############################################################# variables for VPC ########################################################

variable "region" {
  type = string
  description = "Provide the AWS Region into which RKE2 Cluster to be created"
}

variable "vpc_cidr"{
description = "Provide the CIDR for VPC"
type = string
#default = "10.10.0.0/16"
}

variable "private_subnet_cidr"{
description = "Provide the cidr for Private Subnet"
type = list
#default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "public_subnet_cidr"{
description = "Provide the cidr of the Public Subnet"
type = list
#default = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24"]
}

data "aws_partition" "amazonwebservices" {
}

data "aws_region" "reg" {
}

data "aws_availability_zones" "azs" {
}

data "aws_caller_identity" "G_Duty" {
}

variable "igw_name" {
description = "Provide the Name of Internet Gateway"
type = string
#default = "test-IGW"
}

variable "natgateway_name" {
description = "Provide the Name of NAT Gateway"
type = string
#default = "rke2-NatGateway"
}

variable "vpc_name" {
description = "Provide the Name of VPC"
type = string
#default = "test-vpc"
}

variable "env" {
  type = list
  description = "Provide the Environment for EKS Cluster and NodeGroup"
}

####################################################### Rancher Amazon Cloud Credentials #######################################################

variable "rancher_url" { 
  description = "provide the Rancher URL"
  type = string
}

variable "rancher_token" { 
  description = "Provide the Rancher Token"
  type = string
}

variable "ec2_access_key" {
description = "Provide the Amazon IAM Access Key ID"
type = string
}

variable "ec2_secret_key" {
description = "Provide the Amazon IAM Secret Key ID"
type = string
}

####################################################### RKE2 Machine Config EC2 ################################################################

variable "image_id" {
description = "Provide the Image ID of EC2 Instance"
type = map
}

#variable "region" {
#description = "Provide the Amazon AWS Region in Instances and other resouces to be launched"
#type = string
#}

variable "instance_type" {
description = "Provide the Instance type of the EC2 Instance to be launched"
type = list
}

variable "zone" {
description = "Provide the Availability Zone into which the EC2 Instances to be launched"
type = string 
}

variable "open_port" {
description = "Provide the Ports to be opened"
type = list
}

variable "kms_key_id" {
description = "Provide the KMS Key ID to encrypt the EBS Volume"
type = string
}

variable "public_private_ec2_ip" {
description = "Select whether to Launch the EC2 Instance with only private IP or not"
type = bool
}

variable "volume_type" {
description = "Provide the Amazon EBS volume type"
type = list
}

variable "encrypt_ebs_volume" {
description = "Whether to encrypt the EBS Volume or not"
type = bool
}

variable "root_volume_size" {
description = "Provide the Root Volume Size in GB"
type = number
}

variable "device_name" {
description = "Provide the AWS EC2 Root Device Name"
type = string
}

#################################################### RKE2 Version ########################################################

variable "kubernetes_version" {
description = "Provide the RKE2 Version for Kubernetes Cluster"
type = string
}
