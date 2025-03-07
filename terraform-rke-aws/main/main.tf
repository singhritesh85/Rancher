module "rke_cluster" {
  source = "../module"

########################################### To create VPC ##################################################

  vpc_cidr = var.vpc_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  igw_name = var.igw_name
  natgateway_name = var.natgateway_name
  vpc_name = var.vpc_name
 
  env = var.env[0]

###########################To Launch EC2###################################

  image_id = var.image_id["us-east-2"]
  instance_type = var.instance_type[2]
  kms_key_id = var.kms_key_id
  disk_size  = var.disk_size

}

