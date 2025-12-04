# Security Group for Kubernetes Management Node
resource "aws_security_group" "k8s_management" {
  name        = "K8S-Management-Node"
  description = "Security Group for K8S Management Node"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-management-sg"
  }
}

########################################################### Kubernetes Managemnt Node ###############################################################

resource "aws_instance" "k8s_management_node" {
  ami           = var.provide_ami
  instance_type = var.instance_type[0]
  monitoring = true
  vpc_security_group_ids = [aws_security_group.k8s_management.id]  ### var.vpc_security_group_ids       ###[aws_security_group.all_traffic.id]
  subnet_id = aws_subnet.public_subnet[0].id                                 ###aws_subnet.public_subnet[0].id
  root_block_device{
    volume_type="gp2"
    volume_size="20"
    encrypted=true
    kms_key_id = var.kms_key_id
    delete_on_termination=true
  }
  user_data = file("user_data_k8s_management_node.sh")
  iam_instance_profile = "Administrator_Access"  # IAM Role to be attached to EC2

  lifecycle{
    prevent_destroy=false
    ignore_changes=[ ami ]
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  metadata_options { #Enabling IMDSv2
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 2
  }

  tags={
    Name="${var.name}"
    Environment = var.env
  }
}
resource "aws_eip" "k8s_management_node" {
  domain = "vpc"     ###vpc = true
}
resource "aws_eip_association" "eip_association_k8s_management_node" {  ### I will use this EC2 behind the ALB.
  instance_id   = aws_instance.k8s_management_node.id
  allocation_id = aws_eip.k8s_management_node.id
}
