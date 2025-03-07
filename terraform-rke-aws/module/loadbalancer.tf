#########################################################
### Network LoadBalancer as rke ClusterLoadBalancer
#########################################################

/*resource "aws_lb" "network_loadbalancer" {
  name               = "network-loadbalancer-rke"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private_subnet.*.id

  tags = {
    Environment = var.env
  }

}

resource "aws_lb_listener" "rke_server_port_6443" {
  load_balancer_arn = aws_lb.network_loadbalancer.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rke_server_6443_tg.arn
  }
}

resource "aws_lb_target_group" "rke_server_6443_tg" {
  name     = "network-loadbalancer-rke-TG"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id
}*/

#########################################################
### Security Group for Network LoadBalancer
#########################################################

resource "aws_security_group" "nlb_sg" {
 name        = "Network-LoadBalancer-SG-${var.env}"
 description = "Security Group for Service Network LoadBalancer"
 vpc_id      = aws_vpc.test_vpc.id

ingress {
   description = "Publicly open Port 80"
   from_port   = 80
   to_port     = 80
   protocol    = "TCP"
   cidr_blocks = ["0.0.0.0/0"] 
 }

ingress {
   description = "Publicly open Port 443"
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

#########################################################
### Network LoadBalancer as rke ServiceLoadBalancer
#########################################################

resource "aws_lb" "service_loadbalancer" {
  name               = "service-loadbalancer-rke"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public_subnet.*.id
  security_groups    = [aws_security_group.nlb_sg.id] 
  tags = {
    Environment = var.env
  }

}

resource "aws_lb_target_group" "rke_agent_443_tg" {
  name     = "service-lb-tg-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_target_group" "rke_agent_80_tg" {
  name     = "service-lb-tg-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_listener" "networklb_listener_port_443" {
  load_balancer_arn = aws_lb.service_loadbalancer.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rke_agent_443_tg.arn
  }
}

resource "aws_lb_listener" "networklb_listener_port_80" {
  load_balancer_arn = aws_lb.service_loadbalancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rke_agent_80_tg.arn
  }
}
