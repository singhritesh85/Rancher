#############################
### Security Group
#############################

resource "aws_security_group" "rke2" {
 name        = "rke2-security-group-${var.env}"
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
   cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
 }

ingress {
   description = "New nodes join the cluster on port 9345, Port 9345 should be open on RKE2 Servers only"
   from_port   = 9345
   to_port     = 9345
   protocol    = "TCP"
   cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
 }

ingress {
   description = "establish connection among the RKE2 Servers and Agents"
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
### Security Group RKE2 Agents
#####################################

resource "aws_security_group" "sg_rke2_agents" {
 name        = "rke2-Agents-security-group-${var.env}"
 description = "Security Group for RKE2 Agents"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Remote Login using SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "Open Port 80 for AWS NLB"
   from_port   = 80
   to_port     = 80
   protocol    = "TCP"
   security_groups = [aws_security_group.sg_rke2_external_nlb.id]
 } 

ingress {
   description = "Open port 443 for AWS NLB"
   from_port   = 443
   to_port     = 443
   protocol    = "TCP"
   security_groups = [aws_security_group.sg_rke2_external_nlb.id]
 } 

ingress {
   description = "establish connection among the RKE2 Servers and Agents"
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
### Launch Template for RKE2 Server
#####################################

resource "aws_launch_template" "rke2_server_launchtemplate" {
  name          = "rke2-launchtemplate-server-${var.env}"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = filebase64("user_data.sh")

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      encrypted = true
      kms_key_id = var.kms_key_id     ### Provide the kms_key_id for your AWS Account.
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.rke2.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env        ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      Kubernetes-Cluster = "RKE2"
    }
  }
  
  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env       ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       Kubernetes-Cluster = "RKE2"
    }
  }

}

#####################################
### Launch Template for RKE2 Agent
#####################################

resource "aws_launch_template" "rke2_agent_launchtemplate" {
  name          = "rke2-launchtemplate-agent-${var.env}"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = filebase64("user_data.sh")
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      encrypted = true
      kms_key_id = var.kms_key_id     ### Provide the kms_key_id for your AWS Account.
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.sg_rke2_agents.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env        ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      Kubernetes-Cluster = "RKE2"
    }
  }

  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env       ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       Kubernetes-Cluster = "RKE2"
    }
  }

}

#####################################
### AutoScaling Group for RKE2 Server
#####################################

resource "aws_autoscaling_group" "rke2_server_asg" {
  name                = "asg-rke2-server"
  desired_capacity    = 3
  max_size            = 6
  min_size            = 3
  vpc_zone_identifier = aws_subnet.private_subnet.*.id

  target_group_arns = [
    aws_lb_target_group.external_rke2_server_6443_tg.arn,
    aws_lb_target_group.external_rke2_agent_9345_tg.arn,
#    aws_lb_target_group.external_rke2_server_80_tg.arn,
#    aws_lb_target_group.external_rke2_server_443_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.rke2_server_launchtemplate.id
    version = "$Latest"
  }

}

#####################################
### AutoScaling Group for RKE2 Agent
#####################################

resource "aws_autoscaling_group" "rke2_agent_asg" {
  name                = "asg-rke2-agent"
  desired_capacity    = 3
  max_size            = 6
  min_size            = 3
  vpc_zone_identifier = aws_subnet.private_subnet.*.id

  target_group_arns = [
    aws_lb_target_group.external_rke2_server_80_tg.arn,
    aws_lb_target_group.external_rke2_server_443_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.rke2_agent_launchtemplate.id
    version = "$Latest"
  }
}

############################################################
### AutoScaling Policy for AutoScaling Group of RKE2 Server
############################################################

resource "aws_autoscaling_policy" "rke2_server_scaleup" {
  autoscaling_group_name = aws_autoscaling_group.rke2_server_asg.name
  name                   = "rke2-server-scaleout"
  policy_type            = "StepScaling"
#  cooldown               = 60  # The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start, used for SimpleScaling.
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 90  # The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics.

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = ""   # Without a value, AWS will treat this bound as infinity.
  }

}


resource "aws_autoscaling_policy" "rke2_server_scaledown" {
  autoscaling_group_name = aws_autoscaling_group.rke2_server_asg.name
  name                   = "rke2-server-scalein"
  policy_type            = "StepScaling"
#  cooldown               = 60  # The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start, used for SimpleScaling.
  adjustment_type        = "ChangeInCapacity"
#  estimated_instance_warmup = 90  # The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics.

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = "" # Without a value, AWS will treat this bound as infinity.
    metric_interval_upper_bound = 0  # Without a value, AWS will treat this bound as infinity.
  }

}

###########################################################
### AutoScaling Policy for AutoScaling Group of RKE2 Agent
###########################################################

resource "aws_autoscaling_policy" "rke2_agent_scaleup" {
  autoscaling_group_name = aws_autoscaling_group.rke2_agent_asg.name
  name                   = "rke2-agent-scaleout"
  policy_type            = "StepScaling"
#  cooldown               = 60  # The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start, used for SimpleScaling.
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 90  # The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics.

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = ""   # Without a value, AWS will treat this bound as infinity.
  }

}


resource "aws_autoscaling_policy" "rke2_agent_scaledown" {
  autoscaling_group_name = aws_autoscaling_group.rke2_agent_asg.name
  name                   = "rke2-agent-scalein"
  policy_type            = "StepScaling"
#  cooldown               = 60  # The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start, used for SimpleScaling.
  adjustment_type        = "ChangeInCapacity"
#  estimated_instance_warmup = 90  # The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics.

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_lower_bound = "" # Without a value, AWS will treat this bound as infinity.
    metric_interval_upper_bound = 0  # Without a value, AWS will treat this bound as infinity.
  }

}

##########################################################
### AWS Cloudwatch Alarm for RKE2 Server ASG
##########################################################

resource "aws_cloudwatch_metric_alarm" "rke2_server_cloudwatchalarm_high" {
  alarm_name          = "RKE2-Server-CloudwatchAlarm-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rke2_server_asg.name
  }

  alarm_description = "This metric monitors RKE2 Server autoscaling ec2 scaleup cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rke2_server_scaleup.arn]
}

resource "aws_cloudwatch_metric_alarm" "rke2_server_cloudwatchalarm_low" {
  alarm_name          = "RKE2-Server-CloudwatchAlarm-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rke2_server_asg.name
  }

  alarm_description = "This metric monitors RKE2 Server autoscaling ec2 scaledown cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rke2_server_scaledown.arn]
}

#############################################
### AWS Cloudwatch Alarm for RKE2 Server ASG
#############################################

resource "aws_cloudwatch_metric_alarm" "rke2_agent_cloudwatchalarm_high" {
  alarm_name          = "RKE2-Agent-CloudwatchAlarm-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rke2_agent_asg.name
  }

  alarm_description = "This metric monitors RKE2 Agent autoscaling ec2 scaleup cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rke2_agent_scaleup.arn]
}

resource "aws_cloudwatch_metric_alarm" "rke2_agent_cloudwatchalarm_low" {
  alarm_name          = "RKE2-Agent-CloudwatchAlarm-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.rke2_agent_asg.name
  }

  alarm_description = "This metric monitors RKE2 Agent autoscaling ec2 scaledown cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.rke2_agent_scaledown.arn]
}
