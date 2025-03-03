#########################################################
### Application LoadBalancer as rke2 ClusterLoadBalancer
#########################################################

resource "aws_lb" "network_loadbalancer" {
  name               = "network-loadbalancer-rke2"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private_subnet.*.id

  tags = {
    Environment = var.env
  }

}

resource "aws_lb_listener" "rke2_server_port_6443" {
  load_balancer_arn = aws_lb.network_loadbalancer.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rke2_server_6443_tg.arn
  }
}

resource "aws_lb_target_group" "rke2_server_6443_tg" {
  name     = "network-loadbalancer-rke2-TG"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id
}

