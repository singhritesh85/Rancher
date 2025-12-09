variable "client_id" {
description = "Provide Client ID from the Application using Azure Entra ID"
type = string
}

variable "client_secret" {
description = "Provide the Client Secret"
type = string
}

variable "subscription_id" {
description = "Provide subscription Id of your Azure Account's Subscriontion"
type = string
}

variable "tenant_id" {
description = "Provide Tenant Id of your Azure Account's Entra ID"
type = string
}

variable "resource_group" {
description = "Provide the Azure Resource Group Name into which the Resource to be create"
type = string
}

variable "node_resource_group" {
description = "Provide the Resource Group Name for AKS Node Group"
type = string
}

variable "resource_location" {
description = "Provide the Azure Location into which the Resource to be create"
type = list
}
 
variable "dns_prefix" {
description = "Provide the dns prefix name"
type = string
}

variable "kubernetes_version" {
description = "Provide the Kubernetes Version to be created"
type = list
}

variable "network_plugin" {
description = "Provide the Network Plugin Name"
type = string
}

variable "network_service_cidr" {
description = "Provide the AKS Network Service CIDR, Kubernetes Service Address Range"
type = string
}

variable "network_dns_service_ip" {
description = "Provide the IP address assigned to the Kubernetes DNS service"
type = string
}

variable "vnet_address_space" {
description = "Provide the CIDR Range for VNet"
type = list
}

variable "subnet_address_prefixes" {
description = "Provide the CIDR Range for Subnet"
type = list
}

variable "network_docker_bridge_cidr" {
description = "Provide the CIDR Range for Docker Bridge"
type = string
}

variable "vnet_name" {
description = "Provide the VNet Name"
type = string
}

variable "subnet_name" {
description = "Provide the subnet name"
type = string
}

variable "os_disk_type" {
description = "Provide the OS Disk Type"
type = string
}

variable "max_pods" {
description = "Provide maximum number of pods can be created per node"
type = number
}

variable "orchestrator_version" {
description = "Provide the orchestrator Version to be created"
type = list
}

variable "os_disk_size_gb" {
description = "Provide the OS Disk Size in GB"
type = number
}

variable "vm_size" {
description = "Provide the VM Size"
type = string
}

variable "api_url" {
  description = "provide the Rancher URL"
  type = string
}

variable "rancher_token" {
  description = "Provide the Rancher Token"
  type = string
}
