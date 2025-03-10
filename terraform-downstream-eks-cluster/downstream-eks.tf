resource "rancher2_cloud_credential" "aws_cloud_credential" {
  name = "aws-cred"
  description = "Aws Cloud credentials"
  amazonec2_credential_config {
    access_key = var.ec2_access_key
    secret_key = var.ec2_secret_key
  }
}

# Rancher cluster
resource "rancher2_cluster" "downstream_eks_cluster" {
  name = "downstream-rancher-eks-cluster"
  description = "Downstarem Rancher EKS Cluster created using Terraform"
  eks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.aws_cloud_credential.id
    region = var.ec2_region[1]
    kubernetes_version = var.k8version[1]
#    logging_types = ["audit", "api"]
    node_groups {
      name = "downstream-nodegroup1"
      instance_type = var.instance_type[2]
      desired_size = var.desired_nodes
      max_size = var.max_nodes
      min_size = var.min_nodes
    }
    private_access = true
    public_access = true
  }
}

# Kubeconfig file
resource "local_file" "kubeconfig_eks" {
  filename = "${path.module}/.kube/config"
  content = rancher2_cluster.downstream_eks_cluster.kube_config
  file_permission = "0600"

}
