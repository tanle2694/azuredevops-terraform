variable "resource_group_name" {
  description = "The resource group where the resources should be created."
}

variable "location" {
  default     = "westeurope"
  description = "The azure datacenter location where the resources should be created."
}

variable "storage_account_name" {
  default     = ""
  description = "Storage account name that this function will use."
}

variable "account_replication_type" {
  default     = "LRS"
  description = "The Storage Account replication type. See azurerm_storage_account module for posible values."
}

variable "allow_blob_public_access" {
  default     = false
  description = "Allow or disallow public access to all blobs or containers in the storage account"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}
variable "storage_table_names" {
  description = "The name of the storage table. Must be unique within the storage account the table is located."
  type        = list(string)
}
variable "storage_private_blob_containers" {
  description = "The name of the storage table. Must be unique within the storage account the table is located."
  type        = list(string)
}
variable "storage_public_blob_containers" {
  description = "The name of the storage table. Must be unique within the storage account the table is located."
  type        = list(string)
}
