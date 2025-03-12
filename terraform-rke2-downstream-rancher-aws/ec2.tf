# Security Group

resource "aws_security_group" "rke2" {
 name        = "rke2-security-group-${var.env[0]}"
 description = "Security Group for RKE2"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Remote Login using SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "All nodes in RKE2 cluster needs to communicate to each other on port 6443"
   from_port   = 6443
   to_port     = 6443
   protocol    = "TCP"
   cidr_blocks = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
 }

ingress {
   description = "New nodes join the cluster on port 9345, Port 9345 should be open on RKE2 Servers only"
   from_port   = 9345
   to_port     = 9345
   protocol    = "TCP"
   cidr_blocks = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
 }

ingress {
   description = "All nodes in RKE2 cluster needs to communicate to each other on port 6443"
   from_port   = 6443
   to_port     = 6443
   protocol    = "TCP"
   cidr_blocks = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
 }

ingress {
   description = "establish connection among the RKE2 Servers and Agents"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["172.20.0.0/16"]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}


# Create AmazonEC2 cloud credential
resource "rancher2_cloud_credential" "aws_cloud_cred" {
  name = "aws-cred"
  amazonec2_credential_config {
    access_key = var.ec2_access_key
    secret_key = var.ec2_secret_key
  }
}

# Create amazonec2 machine config v2
resource "rancher2_machine_config_v2" "rke_ec2" {
  generate_name = "rke2-machine-config-ec2"
  amazonec2_config {
    ami =  var.image_id["us-east-2"]
    region = var.region
    security_group = [aws_security_group.rke2.name]
    subnet_id = aws_subnet.public_subnet.0.id
    instance_type = var.instance_type[2]
    vpc_id = "${aws_vpc.test_vpc.id}"
    open_port = var.open_port
    zone = var.zone
    kms_key = var.kms_key_id
    private_address_only = var.public_private_ec2_ip
    userdata = file("user_data.sh")
    volume_type = var.volume_type[0]
    root_size = var.root_volume_size 
    encrypt_ebs_volume = var.encrypt_ebs_volume
    device_name = var.device_name
    monitoring = true
    use_ebs_optimized_instance = true
  }
  depends_on = [rancher2_cloud_credential.aws_cloud_cred]
}

