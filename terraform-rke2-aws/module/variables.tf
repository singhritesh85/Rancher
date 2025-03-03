############################################################# variables for VPC ########################################################

variable "vpc_cidr"{

}

variable "private_subnet_cidr"{

}

variable "public_subnet_cidr"{

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

}

variable "natgateway_name" {

}

variable "vpc_name" {

}

variable "env" {

}

##################################### Variables for RKE2 Server and Agent #######################################

variable "image_id" {

}

variable "instance_type" {

}

variable "disk_size" {

}

variable "kms_key_id" {

}


