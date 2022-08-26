




resource "aws_lb_target_group" "edge_contentlb" {
  name        = "edge-contentlb"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.edgecontent.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.edge_contentlb]
}

resource "aws_alb" "edge_contentlb" {
  name               = "edge-contentlb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public-edgecontent.id,
    aws_subnet.public-edgecontent2.id
  ]

  security_groups = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_http.id,
  ]

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_alb_listener" "edge_content" {
  load_balancer_arn = aws_alb.edge_contentlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.edge_contentlb.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.edge_contentlb.dns_name}"
}

