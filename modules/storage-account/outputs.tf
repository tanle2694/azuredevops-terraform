output "storage_account_name" {
  description = "The name of the storage account created for the function app"
  value       = azurerm_storage_account.funcsta.name
}

output "storage_account_connection_string" {
  description = "Connection string to the storage account created for the function app"
  value       = azurerm_storage_account.funcsta.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary access key to the storage account created for the function app"
  value       = azurerm_storage_account.funcsta.primary_access_key
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint to the storage account created for the function app"
  value       = azurerm_storage_account.funcsta.primary_blob_endpoint
  sensitive   = true
}