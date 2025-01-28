variable "azure_resource_group" {
  description = "Provide the Azure Resource Group Name"
  type = string
}

variable "azure_region" {
  type = list
  description = "Provide the Azure Region into which AKS Cluster existed"
}

variable "rancher2_access_key" {
  description = "Provide Rancher Access Key (Username)"
  type = string
}

variable "rancher2_secret_key" {
  description = "Provide Rancher Secret Key (Password)"
  type = string
}

variable "azure_client_id" {
  description = "Provide Client ID for Application in Azure"
  type = string
}

variable "azure_client_secret" {
  description = "Provide Client Secret for Application in Azure"
  type = string
}

variable "azure_subscription_id" {
  description = "Provide Azure Subscription ID"
  type = string
}

variable "azure_aks_cluster" {
  description = "Provide the Azure AKS Cluster Name to be imported"
  type = string
}

variable "delaysec" {
  description = "Provide the Delay in Seconds"
  type = number
}
