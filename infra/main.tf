locals {
  subscription_id      = "xxx" # DXP-DX Engineering
  tenant_id            = "xxxxx" # DXP-DX Engineering
  local_admin_user     = "localadmin"
  local_admin_password = "zzzzzz"
  agent_vn_subnet      = [""]
  dns_server           = "168.63.129.16" # Azure default DNS server.
  agent_vm_size        = "Standard_B2s"

  agent_disk_tier = "Standard_LRS"
  agent_disk_size = 256
  default_tags = {
    terraform = "True"
  }
  env                        = "infra"
  short_location             = "sea"
  infra_vnet_address_space   = ["172.16.1.0/26"]
  agent_subnet_address_space = ["172.16.1.0/27"]
  vpn_subnet_prefixes        = ["172.16.1.32/27"]
  client_vpn_subnet_prefixes = ["172.16.1.64/26"]
  #2private_aks_dns_zone_name        = "privatelink.southeastasia.azmk8s.io"
  aks_service_principal_id = "xxxxxx"
  vpn_public_cert_data     = <<EOF
xxxxxxxxxx
xxxxxxxxx
xxxxxxxxx
xxxxxxxxxxxx
EOF
}

data "azurerm_resource_group" "infra" {
  name = "kubeflowdevops-infra-sea-rg"
}
# VNET section
resource "azurerm_virtual_network" "infra" {
  name                = "kubeflowdevops-infra-${local.short_location}-vnet"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name
  address_space       = local.infra_vnet_address_space
  dns_servers         = [local.dns_server]
  tags                = local.default_tags
}
resource "azurerm_subnet" "agent-subnet" {
  name                 = "infra-agent-subnet"
  resource_group_name  = data.azurerm_resource_group.infra.name
  address_prefixes     = local.agent_subnet_address_space
  virtual_network_name = azurerm_virtual_network.infra.name
  lifecycle {
    ignore_changes = [delegation, enforce_private_link_endpoint_network_policies]
  }
}

resource "azurerm_availability_set" "infra-primary" {
  name                         = "kubeflowdevops-infra-${local.short_location}-avail"
  location                     = data.azurerm_resource_group.infra.location
  resource_group_name          = data.azurerm_resource_group.infra.name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 2
  tags                         = local.default_tags
}

module "agent01-vm" {
  source              = "../modules/linux-virtual-machine"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name

  subnet_id = azurerm_subnet.agent-subnet.id

  name                = "kubeflowdevops-infra-${local.short_location}-ops-agent01-vm"
  admin_username      = local.local_admin_user
  admin_password      = local.local_admin_password
  availability_set_id = azurerm_availability_set.infra-primary.id
  vm_size             = local.agent_vm_size
  tags                = local.default_tags
  depends_on          = [azurerm_virtual_network.infra, azurerm_availability_set.infra-primary]
}
module "agent02-vm" {
  source              = "../modules/linux-virtual-machine"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name

  subnet_id = azurerm_subnet.agent-subnet.id

  name                = "kubeflowdevops-infra-${local.short_location}-ops-agent02-vm"
  admin_username      = local.local_admin_user
  admin_password      = local.local_admin_password
  availability_set_id = azurerm_availability_set.infra-primary.id
  vm_size             = local.agent_vm_size
  tags                = local.default_tags
  depends_on          = [azurerm_virtual_network.infra, azurerm_availability_set.infra-primary]
}
resource "azurerm_subnet" "gw-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = local.vpn_subnet_prefixes
  service_endpoints = [
    "Microsoft.Storage"
  ]
}

resource "azurerm_public_ip" "virtual-vpn" {
  name                = "${local.env}-virtual-vpn-${local.short_location}-ip"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "point-to-site" {
  name                = "${local.env}-virtual-vpn-${local.short_location}-gw"
  location            = data.azurerm_resource_group.infra.location
  resource_group_name = data.azurerm_resource_group.infra.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.virtual-vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gw-subnet.id
  }

  vpn_client_configuration {
    address_space = local.client_vpn_subnet_prefixes

    root_certificate {
      name = "DigiCert-Federated-ID-Root-CA"

      public_cert_data = local.vpn_public_cert_data
    }
  }
}

resource "azurerm_container_registry" "kubeflowdevops" {
  name                = "kubeflowdevopsprivate"
  resource_group_name = data.azurerm_resource_group.infra.name
  location            = data.azurerm_resource_group.infra.location
  sku                 = "Basic"
  admin_enabled       = true
}

