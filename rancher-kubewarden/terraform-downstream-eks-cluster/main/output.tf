output "eks_details" {
  description = "Details of the K8S-Management-Node and EKS Cluster Created"
  value       = "${module.eks_cluster}"
}
