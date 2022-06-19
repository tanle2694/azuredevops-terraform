resource "azurerm_resource_group" "main" {
    name     = "${var.project_short_name}-${var.env}-${var.short_location}-${var.resource_group_name}"
    location = var.location
    tags     = local.default_tags
  
}

data "azurerm_resource_group" "dev" {
    name = "kubeflowdevops-dev-sea-rg"
}

data "azurerm_private_dns_zone" "private-dns-zone" {
    name                = var.private_aks_dns_zone_name
    resource_group_name = data.azurerm_resource_group.dev.name
}

module "main-private-aks" {
    source = "../../modules/private-aks"
    subscription_id          = var.subscription_id
    resource_group_name      = azurerm_resource_group.main.name
    node_resource_group      = "${var.project_short_name}-${var.env}-aks-node-${var.short_location}-rg"
    location                 = var.location
    private_dns_zone_id      = data.azurerm_private_dns_zone.private-dns-zone.id
    service_principal_id     = var.service_principal_client_id
    service_principal_secret = var.service_principal_client_secret
    cluster_subnet_id        = azurerm_subnet.aks-subnet.id
    kubernetes_version       = var.kubernetes_version
    cluster_name             = "${var.project_short_name}-${var.env}-${var.short_location}-aks"
    cluster_dns_prefix       = "${var.project_short_name}-${var.env}-${var.short_location}-aks-dns"
    node_pool_default        = var.node_pool_default
    node_pool_additionals    = var.node_pool_additionals
    tags                     = local.default_tags

}