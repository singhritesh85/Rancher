output "aks_id" {
  description = "Azure Kubernetes Service (AKS) Cluster ID"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_name" {
  description = "Azure Kubernetes Service (AKS) Cluster name"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}
