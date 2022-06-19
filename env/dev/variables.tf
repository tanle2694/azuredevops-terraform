variable "subscription_id" {
    description = "Subscription id for Azure subscription"
    default = "xxxx-xxxx-xxxx"
}

variable "tenant_id" {
    description = "Tenant id for Azure subscription"
    default = "xxx-xxx-xxx"  
}

variable "env" {
    type = string
    default = "dev"  
}

variable "env_short_name" {
    type = string
    default = "dev"  
}

variable "short_location" {
    type = string
    default = "sea"  
}

variable "project_short_name" {
    type = string
    default = "kubeflowdevops"
}

variable "resource_group_name" {
  type    = string
  default = "rg"
}

variable "location" {
  type    = string
  default = "southeastasia"
}

# VNET
variable "vnet_name" {
  type        = string
  description = "The address space that is used by the virtual network"
  default     = "vnet01"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network"
  default     = ["172.22.0.0/17"]
}
# VNET SUBNET AKS subnet section
variable "aks_subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["172.22.0.128/25"]
}
variable "node_pool_default" {

}
variable "node_pool_additionals" {

}
variable "private_aks_dns_zone_name" {}
variable "service_principal_client_id" {
  description = "AKS service principal client id"
}
variable "service_principal_client_secret" {
  description = "AKS service principal client secret"
}
variable "kubernetes_version" {
  description = "AKS version"
  default     = "1.20.9"
}

variable "devops_group_id" {

}
variable "azure_devops_object_id" {

}
variable "service_principal_client_object_id" {}

variable "sa_client_id" {}
variable "sa_client_secret" {}
variable "idp_public_endpoint" {}
