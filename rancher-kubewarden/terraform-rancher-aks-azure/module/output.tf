output "aks_id" {
  description = "Azure Kubernetes Service (AKS) Cluster ID"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_name" {
  description = "Azure Kubernetes Service (AKS) Cluster name"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.azure_sa.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.azure_sa.name
}

output "storage_account_container_name" {
  description = "The name of the storage account container"
  value       = azurerm_storage_container.azure_sa_container.name
}

output "storage_account_container_id" {
  description = "The id of the storage account container"
  value       = azurerm_storage_container.azure_sa_container.id
}
