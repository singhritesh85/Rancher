output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eksdemo.endpoint
}
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eksdemo.name
}
output "karpenter_node_spun_iam_role_arn" {
  description = "IAM Role ARN for Karpenter to spin-up nodes"
  value       = aws_iam_role.karpenter_node_iam_role.arn
}
output "k8s_managemnt_node_instance_id" {
  description = "The ID of the K8S Managemnt Node EC2 instance."
  value       = aws_instance.k8s_management_node.id
}
