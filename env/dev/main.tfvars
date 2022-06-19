subscription_id = "xxxx"
tenant_id       = "xxxxx"
# az ad sp create-for-rbac --skip-assignment --name kubeflowdevops-aks-sp --years 100
# 100 years expired date for the service principal of the AKS

azure_devops_object_id = "xxxxxxx"

devops_group_id = "xxxxx"

# infra configuration

project_short_name = "kubeflowdevops"
env                = "dev"
env_short_name     = "01"
short_location     = "sea"
location           = "Southeast Asia"
dns_server         = "168.63.129.16" # Azure default DNS server.
# Service principal for AKS
service_principal_client_id        = "xxxxx-yyyyy"
service_principal_client_object_id = "xxxxx-yyyyy"
service_principal_client_secret    = "xxxxx-yyyyy"  
kubernetes_version                 = "1.21.7"                               # see the error with kubeflow https://stackoverflow.com/questions/70420241/issues-when-setting-up-kubeflow-pipeline-on-minikube/70450847
private_aks_dns_zone_name          = "privatelink.southeastasia.azmk8s.io"
# AKS
node_pool_default = {
  vm_size        = "Standard_B4ms"
  node_count     = "1"
  node_min_count = "1"
  node_max_count = "5"
  max_pods       = "50"
}

node_pool_additionals = {
  e2sv3 : {
    vm_size        = "Standard_E2_v3"
    node_count     = "0"
    node_min_count = "0"
    node_max_count = "9"
    max_pods       = "30"
    node_taints    = ["vmsize=e2s_v3:NoSchedule"]
  }
}

# Vnet 
# id of the destination vnet for peering with app service vnet
address_space          = ["10.5.132.0/23"]
aks_subnet_prefixes    = ["10.5.132.0/27"]
dex_user               = "user@kubeflowdevops.com"
dex_password           = "MTIzNDEyMzQK"
dex_ip                 = "1.2.3.4"

sa_client_id     = "xxxxx"
sa_client_secret = "xxxx"
