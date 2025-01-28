# Rancher cloud credentials for AKS
resource "rancher2_cloud_credential" "credential_azure" {
  name = "Azure Credentials"
  azure_credential_config {
    client_id = var.azure_client_id
    client_secret = var.azure_client_secret
    subscription_id = var.azure_subscription_id
  }
}

# Rancher cluster import
resource "rancher2_cluster" "cluster_azure_aks" {
  name         = var.azure_aks_cluster
  description  = "Import AKS Cluster to Rancher using Terraform"

  aks_config_v2 {
    name = var.azure_aks_cluster
    cloud_credential_id = rancher2_cloud_credential.credential_azure.id
    resource_group = var.azure_resource_group
    resource_location = var.azure_region[0]
    imported = true
  }
}

# Introducing delay of 2 minutes
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_azure_aks]
}

resource "null_resource" "delay_2m" {
  provisioner "local-exec" {
    command = "sleep ${var.delaysec}"
  }

  triggers = {
    "before" = "null_resource.before.id"
  }
}

# Provide Kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.cluster_azure_aks.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay_2m]
}
