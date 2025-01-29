variable "azure_resource_group" {
  description = "Provide the Azure Resource Group name in which AKS Cluster is existed"
  type = string
}

variable "rancher2_access_key" {
  description = "Provide Rancher Access Key (Username)"
  type = string
}

variable "rancher2_secret_key" {
  description = "Provide Rancher Secret Key (Password)"
  type = string
}

variable "api_url" {
  description = "Provider the Rancher URL"
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

variable "azure_tenant_id" {
  description = "Provide Azure Tenant ID"
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
