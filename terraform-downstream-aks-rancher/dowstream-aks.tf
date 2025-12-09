resource "rancher2_cloud_credential" "azure_cloud_credentials" {
  name = "azure-cred"
  azure_credential_config {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
  }
}

# Create Resource Group
###resource "azurerm_resource_group" "aks_rg" {
###  name     = var.node_resource_group
###  location = var.resource_location[0]
###}

# Create VNet for Downstream AKS
###resource "azurerm_virtual_network" "aks_vnet" {
###  name                = var.vnet_name      ###"${var.prefix}-vnet"
###  resource_group_name = azurerm_resource_group.aks_rg.name
###  location            = azurerm_resource_group.aks_rg.location
###  address_space       = var.vnet_address_space
###}

# Create Subnet for VNet of Downstream AKS
###resource "azurerm_subnet" "aks_subnet" {
###  name                 = var.subnet_name         ###"${var.prefix}-subnet"
###  resource_group_name  = azurerm_resource_group.aks_rg.name
###  service_endpoints    = ["Microsoft.ContainerRegistry"]
###  virtual_network_name = azurerm_virtual_network.aks_vnet.name
###  address_prefixes     = var.subnet_address_prefixes
###  depends_on = [azurerm_virtual_network.aks_vnet]
###}

resource "rancher2_cluster" "downstream_aks_rancher" {
  name = "mederma6" ###"downstream-aks-rancher"
  description = "Downstarem Rancher AKS Cluster created using Terraform"
  aks_config_v2 {
    imported = false
    cloud_credential_id = rancher2_cloud_credential.azure_cloud_credentials.id
    resource_group = var.resource_group               ###azurerm_resource_group.aks_rg.name
    node_resource_group = var.node_resource_group     ###azurerm_resource_group.aks_rg.name
    outbound_type = "loadBalancer"
    resource_location = var.resource_location[0]      ###azurerm_resource_group.aks_rg.location
    dns_prefix = var.dns_prefix
    kubernetes_version = var.kubernetes_version[11]
###    private_cluster = true
    network_plugin = var.network_plugin
    virtual_network_resource_group = var.resource_group
###    virtual_network = azurerm_virtual_network.aks_vnet.name
###    subnet = azurerm_subnet.aks_subnet.name
    network_dns_service_ip = var.network_dns_service_ip
    network_service_cidr = var.network_service_cidr
###    network_docker_bridge_cidr = var.network_docker_bridge_cidr
    node_pools {
#      availability_zones = ["1", "2", "3"]
      name = "pool1"
      mode = "System"
      count = 1
      os_disk_type = var.os_disk_type
      orchestrator_version = var.orchestrator_version[11]
      os_disk_size_gb = var.os_disk_size_gb
      vm_size = var.vm_size
      max_pods = var.max_pods
    }
    node_pools {
#      availability_zones = ["1", "2", "3"]
      name = "pool2"
      count = 1
      mode = "User"
      os_disk_type = var.os_disk_type
      orchestrator_version = var.orchestrator_version[11]
      os_disk_size_gb = var.os_disk_size_gb
      vm_size = var.vm_size
      max_pods = var.max_pods
      max_surge = "25%"
    }
  }
}

resource "local_file" "kubeconfig_aks" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.downstream_aks_rancher.kube_config
  file_permission = "0600"
}
