#############################Provide Parameters for VPC####################################

region = "us-east-2"

vpc_cidr = "172.20.0.0/16"
private_subnet_cidr = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
public_subnet_cidr = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
igw_name = "test-IGW-RKE2"
natgateway_name = "RKE2-NatGateway"
vpc_name = "test-vpc-rke2"
env = ["dev", "stage", "prod"]

#############################Provide Parameters for Rancher Cloud Credentials ######################################

rancher_url = "https://rancher.singhritesh85.com"
rancher_token = "token-XXXXX:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
ec2_access_key = "XXXXXXXXXXXXXXXXXXXX"
ec2_secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

#############################Provide Parameters for RKE2 Machine Config EC2 ########################################

image_id = {
  "us-east-1" = "ami-0a1179631ec8933d7"
  "us-east-2" = "ami-024adb4f8af4c9df2"    #"ami-0cb91c7de36eed2cb"       #"ami-0ef0a3b4303b17ec5"
  "us-west-1" = "ami-0e0ece251c1638797"
  "us-west-2" = "ami-086f060214da77a16"
}
instance_type = ["t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge"]
zone = "a"
kms_key_id = "arn:aws:kms:us-east-2:02XXXXXXXXX6:key/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
volume_type = ["gp2", "gp3", "io1", "io2"]
open_port = ["80/tcp","443/tcp","6443/tcp","9345/tcp","2379/tcp","2380/tcp","8472/udp","4789/udp","9796/tcp","10256/tcp","10250/tcp","10251/tcp","10252/tcp"]
encrypt_ebs_volume = true
root_volume_size = 16
device_name = "/dev/sda1"

public_private_ec2_ip = false

kubernetes_version = "v1.30.5+rke2r1"
