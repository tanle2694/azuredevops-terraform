# Taken from https://registry.terraform.io/modules/InnovationNorway/function-app/azurerm/0.1.3-pre
resource "azurerm_storage_account" "funcsta" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  allow_blob_public_access = var.allow_blob_public_access
  tags                     = var.tags
}
# Taken from https://registry.terraform.io/modules/InnovationNorway/function-app/azurerm/0.1.3-pre
resource "azurerm_storage_table" "sa-table" {
  count                = length(var.storage_table_names)
  name                 = element(var.storage_table_names, count.index)
  storage_account_name = azurerm_storage_account.funcsta.name
}

# Taken from https://registry.terraform.io/modules/InnovationNorway/function-app/azurerm/0.1.3-pre
resource "azurerm_storage_container" "sa-private-blob-container" {
  count                 = length(var.storage_private_blob_containers)
  name                  = element(var.storage_private_blob_containers, count.index)
  storage_account_name  = azurerm_storage_account.funcsta.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "sa-public-blob-container" {
  count                 = length(var.storage_public_blob_containers)
  name                  = element(var.storage_public_blob_containers, count.index)
  storage_account_name  = azurerm_storage_account.funcsta.name
  container_access_type = "blob"
}
