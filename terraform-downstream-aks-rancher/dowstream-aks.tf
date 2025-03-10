resource "rancher2_cloud_credential" "azure_cloud_credentials" {
  name = "azure-cred"
  azure_credential_config {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
  }
}

resource "rancher2_cluster" "downstream_aks_rancher" {
  name = "mederma"   #"downstream-aks-rancher"
  description = "Downstarem Rancher AKS Cluster created using Terraform"
  aks_config_v2 {
    imported = false
    cloud_credential_id = rancher2_cloud_credential.azure_cloud_credentials.id
    resource_group = var.resource_group
    node_resource_group = var.node_resource_group
    outbound_type = "loadBalancer"
    resource_location = var.resource_location[0]
    dns_prefix = var.dns_prefix
    kubernetes_version = var.kubernetes_version[7]
    network_plugin = var.network_plugin
    virtual_network_resource_group = var.resource_group
    network_dns_service_ip = var.network_dns_service_ip
    network_service_cidr = var.network_service_cidr
    node_pools {
      availability_zones = ["1", "2", "3"]
      name = "pool1"
      mode = "System"
      count = 1
      os_disk_type = var.os_disk_type
      orchestrator_version = var.orchestrator_version[7]
      os_disk_size_gb = var.os_disk_size_gb
      vm_size = var.vm_size
      max_pods = var.max_pods
    }
    node_pools {
      availability_zones = ["1", "2", "3"]
      name = "pool2"
      count = 1
      mode = "User"
      os_disk_type = var.os_disk_type
      orchestrator_version = var.orchestrator_version[7]
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
