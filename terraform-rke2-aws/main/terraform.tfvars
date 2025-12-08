###########Provide Parameters for EKS Cluster and NodeGroup########################

region = "us-east-2"

vpc_cidr = "10.10.0.0/16"
private_subnet_cidr = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
public_subnet_cidr = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
igw_name = "test-IGW"
natgateway_name = "RKE2-NatGateway"
vpc_name = "test-vpc"

################# Provide Parameters for RKE2 Server and RKE2 Agent ###################

instance_type = ["t3.micro", "t3.small", "t3.medium"]
disk_size = "30"
image_id = {
  "us-east-1" = "ami-0a1179631ec8933d7"
  "us-east-2" = "ami-025ca978d4c1d9825"     #"ami-0cb91c7de36eed2cb"       #"ami-0ef0a3b4303b17ec5"
  "us-west-1" = "ami-0e0ece251c1638797"
  "us-west-2" = "ami-086f060214da77a16"
}
kms_key_id = "arn:aws:kms:us-east-2:02XXXXXXXXX6:key/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
env = [ "dev", "stage", "prod" ]

