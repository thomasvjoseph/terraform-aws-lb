resource "aws_lb" "load_balancer" {
  name                        = var.lb_name
  internal                    = var.scheme
  load_balancer_type          = var.load_balancer_type
  ip_address_type             = "ipv4"
  security_groups             = var.lb_security_group
  subnets                     = var.subnets
  enable_deletion_protection  = var.enable_deletion_protection

  tags  = { 
    "Name"                    = var.name
    "Env"                     = var.env
    "Terraform"               = "true"
  }
}

resource "aws_lb_target_group" "target_group" {
  name                        = var.tg_name
  target_type                 = var.lb_target_type
  port                        = var.tg_port_number
  protocol                    = "HTTP"
  vpc_id                      = var.vpc_id
  ip_address_type             = "ipv4"

  health_check {
    path                      = var.health_check_path
    healthy_threshold         = var.health_check_healthy_threshold
    unhealthy_threshold       = var.health_check_unhealthy_threshold
    timeout                   = var.health_check_timeout
    interval                  = var.health_check_interval
    protocol                  = var.health_check_protocol
    matcher                   = var.health_check_matcher
  }

  tags  = {
    "Name"                    = var.name
    "Env"                     = var.env
    "Terraform"               = "true"
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = length(var.lb_target_id) > 0 && var.use_for == "EC2" ? { for idx, target in var.lb_target_id : idx => target } : {}

  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = each.value
  port             = var.tg_port_number
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.lb_port_number
  protocol          = var.lb_listener_protocol
  default_action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags  = {
    "Name"          = var.name
    "Env"           = var.env
    "Terraform"     = "true"
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  condition {
    path_pattern {
      values         = ["/*"]
    }
  }

  tags  = {
    "Name"          = var.name
    "Env"           = var.env
    "Terraform"     = "true"
  }
}