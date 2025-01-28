variable "region" {
  type = string
  description = "Provide the AWS Region into which EKS Cluster existed"
}

variable "rancher2_access_key" {
  description = "Provide Rancher Access Key (Username)"
  type = string
}

variable "rancher2_secret_key" {
  description = "Provide Rancher Secret Key (Password)"
  type = string
}

variable "aws_access_key" {
  description = "Provide AWS ACCESS KEY"
  type = string
}

variable "aws_secret_key" {
  description = "Provide AWS SECRET KEY"
  type = string
}

variable "aws-eks-cluster" {
  description = "Provide the AWS EKS Cluster Name to be imported"
  type = string
}

data "aws_region" "reg" {
 
}

variable "delaysec" {
  description = "Provide the Delay in Seconds"
  type = number
}
