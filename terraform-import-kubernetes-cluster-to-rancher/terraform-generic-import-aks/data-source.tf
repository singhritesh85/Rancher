# Azure Kubernetes cluster
data "azurerm_kubernetes_cluster" "cluster_aks" {
  name                 = var.azure_aks_cluster
  resource_group_name  = var.azure_resource_group
}

# Rancher settings
data "rancher2_setting" "server_version" {
    name = "server-version"
}

data "rancher2_setting" "install_uuid" {
    name = "install-uuid"
}

data "rancher2_setting" "server_url" {
    name = "server-url"
}
