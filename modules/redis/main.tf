resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  enable_non_ssl_port = var.enable_non_ssl_port
  family              = var.family
  sku_name            = var.sku_name
  capacity            = var.capacity
}
