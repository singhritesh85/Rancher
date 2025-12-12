resource "aws_instance" "rke2_jumpbox" {
  ami           = var.image_id
  instance_type = "t3.micro"
  monitoring = true
  vpc_security_group_ids = [aws_security_group.remote_login.id]      ### var.vpc_security_group_ids       ###[aws_security_group.all_traffic.id]
  subnet_id = aws_subnet.public_subnet[0].id                                 ###aws_subnet.public_subnet[0].id
  root_block_device{
    volume_type="gp2"
    volume_size="10"
    encrypted=true
    kms_key_id = var.kms_key_id
    delete_on_termination=true
  }
  user_data = file("user_data.sh")

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
    Name="rke2-jumbox-${var.env}"
    Environment = var.env
  }

}

