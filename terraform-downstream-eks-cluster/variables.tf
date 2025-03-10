# Node disk size in GB
variable "disksize" {
  description = "Provide the Volume Size in GB"
  type = number
}

# Node type
variable "instance_type" {
  description = "Provide the Instance Type for EKS Nodes"
  type = list
}

# Kubernetes version
variable "k8version" {
  description = "Provide the Kubernetes Version to be created"
  type = list
}

# Number of nodes
variable "desired_nodes" {
  description = "Provide the desired number of nodes to be created in the EKS Cluster"
  type = number
}

# Maximum Number of Nodes
variable "max_nodes" {
  description = "Provide the maximum number of nodes"
  type = number
}

variable "min_nodes" {
  description = "Provide the minimum number of nodes"
  type = number
}

# EC2 Region
variable "ec2_region" {
  description = "Provide the EKS Region into which the Cluster to be created"
  type = list
}

variable "rancher_url" { 
  description = "provide the Rancher URL"
  type = string
}

variable "rancher_token" { 
  description = "Provide the Rancher Token"
  type = string
}

variable "ec2_access_key" { 
  description = "Provide the AWS Access Key"
  type = string
}

variable "ec2_secret_key" { 
  description = "Provide the AWS Secret Key"
  type = string
}
