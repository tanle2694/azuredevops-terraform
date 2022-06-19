resource "azurerm_kubernetes_cluster" "main" {

  name = var.cluster_name

  location = var.location

  resource_group_name = var.resource_group_name

  node_resource_group = var.node_resource_group

  kubernetes_version = var.kubernetes_version

  dns_prefix = var.cluster_dns_prefix

  private_cluster_enabled = true
  private_dns_zone_id     = var.private_dns_zone_id
  service_principal {
    client_id     = var.service_principal_id
    client_secret = var.service_principal_secret
  }

  azure_policy_enabled              = true
  #role_based_access_control_enabled = true

  default_node_pool {
    name                = "default"
    vm_size             = lookup(var.node_pool_default, "vm_size", "Standard_DS1_v2")
    enable_auto_scaling = true
    node_count          = lookup(var.node_pool_default, "node_min_count", 1)
    min_count           = lookup(var.node_pool_default, "node_min_count", 1)
    max_count           = lookup(var.node_pool_default, "node_max_count", 8)
    #node_taints         = lookup(var.node_pool_default, "node_taints", null)
    max_pods       = lookup(var.node_pool_default, "max_pods", null)
    vnet_subnet_id = var.cluster_subnet_id
    upgrade_settings {
      max_surge = "33%"
    }
  }

  network_profile {
    network_plugin     = var.cluster_network_plugin
    dns_service_ip     = var.cluster_dns_service_ip
    docker_bridge_cidr = var.cluster_docker_bridge_cidr
    service_cidr       = var.cluster_service_cidr
    pod_cidr           = var.cluster_pod_cidr

    load_balancer_sku = "standard"
  
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [default_node_pool.0.node_count, windows_profile]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.node_pool_additionals

  # The name of the node pool.
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = lookup(each.value, "vm_size", "Standard_F16s_v2")
  enable_auto_scaling   = true
  node_count            = lookup(each.value, "node_min_count", 1)
  min_count             = lookup(each.value, "node_min_count", 1)
  max_count             = lookup(each.value, "node_max_count", 8)
  node_taints           = lookup(each.value, "node_taints", null)
  max_pods              = lookup(each.value, "max_pods", null)
  vnet_subnet_id        = var.cluster_subnet_id

  lifecycle {
    ignore_changes = [node_count]
  }
  tags = var.tags
}
