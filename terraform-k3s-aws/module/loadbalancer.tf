#########################################################
### Application LoadBalancer as k3s ClusterLoadBalancer
#########################################################

resource "aws_lb" "network_loadbalancer" {
  name               = "network-loadbalancer-k3s"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private_subnet.*.id

  tags = {
    Environment = var.env
  }

}

resource "aws_lb_listener" "k3s_server_port_6443" {
  load_balancer_arn = aws_lb.network_loadbalancer.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_server_6443_tg.arn
  }
}

resource "aws_lb_target_group" "k3s_server_6443_tg" {
  name     = "network-loadbalancer-k3s-TG"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id
}

