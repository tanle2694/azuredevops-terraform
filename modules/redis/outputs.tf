output "id" {
  value       = azurerm_redis_cache.redis.id
  description = "Redis instance id"
}

output "name" {
  value       = azurerm_redis_cache.redis.name
  description = "Redis instance name"
}

output "hostname" {
  value       = azurerm_redis_cache.redis.hostname
  description = "Redis instance hostname"
}

output "ssl_port" {
  value       = azurerm_redis_cache.redis.ssl_port
  description = "Redis instance SSL port"
}

output "port" {
  value       = azurerm_redis_cache.redis.port
  description = "Redis instance port"
}

output "primary_access_key" {
  sensitive   = true
  value       = azurerm_redis_cache.redis.primary_access_key
  description = "Redis primary access key"
}

output "secondary_access_key" {
  sensitive   = true
  value       = azurerm_redis_cache.redis.secondary_access_key
  description = "Redis secondary access key"
}

output "private_static_ip_address" {
  value       = azurerm_redis_cache.redis.private_static_ip_address
  description = "Redis private static IP address"
}

output "sku_name" {
  value       = azurerm_redis_cache.redis.sku_name
  description = "Redis SKU name"
}

output "family" {
  value       = azurerm_redis_cache.redis.family
  description = "Redis family"
}

output "capacity" {
  value       = azurerm_redis_cache.redis.capacity
  description = "Redis capacity"
}

output "redis_configuration" {
  value       = azurerm_redis_cache.redis.redis_configuration
  sensitive   = true
  description = "Redis configuration"
}

output "primary_connection_string" {
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
  description = "The primary connection string of the Redis Instance."
}

output "secondary_connection_string" {
  value       = azurerm_redis_cache.redis.secondary_connection_string
  sensitive   = true
  description = "The secondary connection string of the Redis Instance."
}
