#############################
### Security Group
#############################

resource "aws_security_group" "rke" {
 name        = "rke-security-group-${var.env}"
 description = "Security Group for RKE"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Remote Login using SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "All nodes in RKE cluster needs to communicate to each other on port 6443"
   from_port   = 6443
   to_port     = 6443
   protocol    = "TCP"
   cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
 }

ingress {
   description = "New nodes join the cluster on port 9345, Port 9345 should be open on RKE Servers only"
   from_port   = 9345
   to_port     = 9345
   protocol    = "TCP"
   cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
 }

ingress {
   description = "establish connection among the rke Servers and Agents"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["10.10.0.0/16"]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#####################################
### Security Group RKE Agents
#####################################

resource "aws_security_group" "sg_rke_agents" {
 name        = "rke-Agents-security-group-${var.env}"
 description = "Security Group for RKE Agents"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Remote Login using SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "All nodes in RKE cluster needs to communicate to each other on port 6443"
   from_port   = 6443
   to_port     = 6443
   protocol    = "TCP"
   cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
 }

ingress {
   description = "establish connection among the rke Servers and Agents"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["10.10.0.0/16"]
 }

ingress {
   description = "Open Port 80 for NLB"
   from_port   = 80
   to_port     = 80
   protocol    = "TCP"
   security_groups = [aws_security_group.nlb_sg.id]
 }

ingress {
   description = "Open Port 443 for NLB"
   from_port   = 443
   to_port     = 443
   protocol    = "TCP"
   security_groups = [aws_security_group.nlb_sg.id]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

#####################################
### Launch Template for RKE Server
#####################################

resource "aws_launch_template" "rke_server_launchtemplate" {
  name          = "rke-launchtemplate-server-${var.env}"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = filebase64("user_data_server.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.disk_size
      encrypted = true
      kms_key_id = var.kms_key_id     ### Provide the kms_key_id for your AWS Account.
    }
  }

  iam_instance_profile {
    name = "AmazonS3FullAccess"
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.rke.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env        ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      Kubernetes-Cluster = "RKE"
    }
  }
  
  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env       ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       Kubernetes-Cluster = "RKE"
    }
  }

}

#####################################
### Launch Template for RKE Agent
#####################################

resource "aws_launch_template" "rke_agent_launchtemplate" {
  name          = "rke-launchtemplate-agent-${var.env}"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = filebase64("user_data_agent.sh")
  
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.disk_size
      encrypted = true
      kms_key_id = var.kms_key_id     ### Provide the kms_key_id for your AWS Account.
    }
  }

  iam_instance_profile {
    name = "AmazonS3FullAccess"
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.sg_rke_agents.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env        ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      Kubernetes-Cluster = "RKE"
    }
  }

  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env       ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       Kubernetes-Cluster = "RKE"
    }
  }

}

#####################################
### AutoScaling Group for RKE Server
#####################################

resource "time_sleep" "wait_for_vpc_natgateway" {
  create_duration = "10s"
  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_autoscaling_group" "rke_server_asg" {
  name                = "asg-rke-server"
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3
  vpc_zone_identifier = aws_subnet.private_subnet.*.id

  /*target_group_arns = [
    aws_lb_target_group.rke_server_6443_tg.arn
  ]*/

  launch_template {
    id      = aws_launch_template.rke_server_launchtemplate.id
    version = "$Latest"
  }

  depends_on = [time_sleep.wait_for_vpc_natgateway]
}

#####################################
### AutoScaling Group for RKE Agent
#####################################

resource "time_sleep" "wait_for_rke_server" {
  create_duration = "120s"
  depends_on = [aws_autoscaling_group.rke_server_asg]
}

resource "aws_autoscaling_group" "rke_agent_asg" {
  name                = "asg-rke-agent"
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3
  vpc_zone_identifier = aws_subnet.private_subnet.*.id
 
  target_group_arns = [
    aws_lb_target_group.rke_agent_80_tg.arn,
    aws_lb_target_group.rke_agent_443_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.rke_agent_launchtemplate.id
    version = "$Latest"
  }
  
  depends_on = [time_sleep.wait_for_rke_server]
}
