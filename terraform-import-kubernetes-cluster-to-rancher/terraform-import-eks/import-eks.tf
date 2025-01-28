# Rancher cloud credentials for EKS
resource "rancher2_cloud_credential" "credential_amazon" {
  name = "Amazon Credentials"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

# Rancher cluster import
resource "rancher2_cluster" "cluster_amazon_eks" {
  name         = var.aws-eks-cluster
  description  = "Import EKS Cluster to Rancher using Terraform"

  eks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.credential_amazon.id
    name = var.aws-eks-cluster
    region = "${data.aws_region.reg.name}"
    imported = true
  }
}

# Introducing delay of 2 minutes
resource "null_resource" "before" {
  depends_on = [rancher2_cluster.cluster_amazon_eks]
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
  content = rancher2_cluster.cluster_amazon_eks.kube_config
  file_permission = "0600"

  depends_on = [null_resource.delay_2m]
}
