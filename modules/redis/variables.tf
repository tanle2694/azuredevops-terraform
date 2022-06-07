variable "name" {
  description = "The name of the Redis instance. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
  type        = string
  default     = "C"
}


variable "capacity" {
  description = "Redis size: (Basic/Standard: 0,1,2,3,4,5,6) (Premium: 1,2,3,4)  https://docs.microsoft.com/fr-fr/azure/redis-cache/cache-how-to-premium-clustering"
  type        = number
  default     = 0
}

variable "sku_name" {
  description = "Redis Cache Sku name. Can be Basic, Standard or Premium"
  type        = string
  default     = "Basic"
}

variable "enable_non_ssl_port" {
  default = false
}