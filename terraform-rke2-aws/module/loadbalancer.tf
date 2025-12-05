################################################################################################
### Internal Network LoadBalancer as rke2 ClusterLoadBalancer for fixed registration address ###
################################################################################################

resource "aws_security_group" "sg_rke2_internal_nlb" {
 name        = "rke2-internal-nlb-sg-${var.env}"
 description = "Security Group for Internal NLB"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Internal NLB"
   from_port   = 9345
   to_port     = 9345
   protocol    = "TCP"
   cidr_blocks = ["10.10.0.0/16"]
}

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "sg_rke2_external_nlb" {
 name        = "rke2-external-nlb-sg-${var.env}"
 description = "Security Group for External NLB"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "External NLB"
   from_port   = 6443
   to_port     = 6443
   protocol    = "TCP"
   cidr_blocks = ["10.10.0.0/16"]
}

ingress {
   description = "Port 80"
   from_port   = 80
   to_port     = 80
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
}

ingress {
   description = "Port 443"
   from_port   = 443
   to_port     = 443
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"]
}

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_lb" "internal_network_loadbalancer" {
  name               = "nlb-rke2-internal"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private_subnet.*.id
  security_groups    = [aws_security_group.sg_rke2_internal_nlb.id]

  tags = {
    Environment = var.env
  }

}

resource "aws_lb_listener" "internal_rke2_server_port_9345" {
  load_balancer_arn = aws_lb.internal_network_loadbalancer.arn
  port              = "9345"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_rke2_server_9345_tg.arn
  }
}

resource "aws_lb_target_group" "internal_rke2_server_9345_tg" {
  name     = "internal-nlb-rke2-TG"
  port     = 9345
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id
}

##################################################################################################
### External Network LoadBalancer as rke2 ClusterLoadBalancer to route External user's request ###
##################################################################################################

resource "aws_lb" "external_network_loadbalancer" {
  name               = "nlb-rke2-external"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public_subnet.*.id
  security_groups    = [aws_security_group.sg_rke2_external_nlb.id]

  tags = {
    Environment = var.env
  }

}

resource "aws_lb_listener" "external_rke2_server_port_6443" {
  load_balancer_arn = aws_lb.external_network_loadbalancer.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_rke2_server_6443_tg.arn
  }
}

resource "aws_lb_listener" "external_rke2_server_port_80" {
  load_balancer_arn = aws_lb.external_network_loadbalancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_rke2_server_6443_tg.arn
  }
}

resource "aws_lb_listener" "external_rke2_server_port_443" {
  load_balancer_arn = aws_lb.external_network_loadbalancer.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_rke2_server_6443_tg.arn
  }
}

resource "aws_lb_target_group" "external_rke2_server_6443_tg" {
  name     = "external-nlb-rke2-TG"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id
}
