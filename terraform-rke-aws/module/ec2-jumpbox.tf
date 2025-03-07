resource "time_sleep" "wait_for_rke_agent" {
  create_duration = "90s"
  depends_on = [aws_autoscaling_group.rke_agent_asg]
}

resource "aws_instance" "rke_jumpbox" {
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
  user_data = file("user_data_jumpbox.sh")
  iam_instance_profile = "AmazonS3FullAccess"

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
    Name="rke-jumbox-${var.env}"
    Environment = var.env
  }
  
  depends_on = [time_sleep.wait_for_rke_agent]

}

resource "time_sleep" "wait_for_rke_jumpbox" {
  create_duration = "240s"
  depends_on = [aws_instance.rke_jumpbox]
}
