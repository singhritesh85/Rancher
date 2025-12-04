############################# Variables to create AKS Cluster ###############################

variable "prefix" {
  type = string
  description = "Provide the Prefix Name" 
}

variable "location" {
  type = list
  description = "Provide the Location for Azure Resource to be created"
}

variable "kubernetes_version" {
  type = list
  description = "Provide the Kubernetes Version"
}

variable "ssh_public_key" {
  type = string
  description = "Provide the file name which keep the ssh public key"
}

variable "action_group_shortname" {
  type = string
  description = "Provide the short name for Azure Action Group"
}

variable "email_address" {
  type = string
  description = "Provide the Group Email Address on which Notification should be send"
}

variable "env" {
  type = list
  description = "Provide the Environment for AKS Cluster"
}
