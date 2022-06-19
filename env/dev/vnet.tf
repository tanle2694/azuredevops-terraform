module "vnet" {
    source              = "../../modules/vnet"
    vnet_name           = "${var.project_short_name}-${var.env}-${var.vnet_name}"
    resource_group_name = azurerm_resource_group.main.name
    address_space       = var.address_space
    # subnet for app service plan
    tags       = local.default_tags
    depends_on = [azurerm_resource_group.main]    
}

resource "azurerm_subnet" "aks-subnet" {
  name                                          = "${var.env}-aks-subnet"
  resource_group_name                           = azurerm_resource_group.main.name
  address_prefixes                              = var.aks_subnet_prefixes
  virtual_network_name                          = module.vnet.name
  enforce_private_link_service_network_policies = true
  service_endpoints = [
    "Microsoft.Storage"
  ]
  lifecycle {
    ignore_changes = [delegation, enforce_private_link_endpoint_network_policies]
  }
}

# VNET PEERING
data "azurerm_virtual_network" "dev01-vnet" {
  name                = "kubeflowdevops-dev01-vnet01"
  resource_group_name = data.azurerm_resource_group.test01.name
}

resource "azurerm_virtual_network_peering" "dev01-to-dev02" {
  name                      = "dev01-to-dev02"
  resource_group_name       = data.azurerm_resource_group.dev01.name
  virtual_network_name      = data.azurerm_virtual_network.dev01-vnet.name
  remote_virtual_network_id = module.vnet.id
}

resource "azurerm_virtual_network_peering" "dev02-to-dev01" {
  name                      = "dev02-to-dev01"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = module.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.dev01-vnet.id
}
