terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "6.0.0"
    }
  }
}

provider "rancher2" {
  api_url    = var.api_url 
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
}

provider "azurerm" {
  client_id = var.azure_client_id
  client_secret = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id = var.azure_tenant_id

  features {}
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.host
  username = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.username
  password = data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.password
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster_aks.kube_config.0.cluster_ca_certificate)
}
