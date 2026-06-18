resource "aws_lb" "load_balancer" {
  for_each                   = var.lb_resources
  name                       = each.value.lb_name
  internal                   = each.value.internal
  load_balancer_type         = each.value.load_balancer_type
  ip_address_type            = "ipv4"
  security_groups            = each.value.lb_security_group
  subnets                    = each.value.subnets
  enable_deletion_protection = each.value.enable_deletion_protection

  tags = each.value.tags
}

resource "aws_lb_target_group" "target_group" {
  for_each        = var.lb_resources
  name            = each.value.tg_name
  target_type     = each.value.lb_target_type
  port            = each.value.tg_port_number
  protocol        = "HTTP"
  vpc_id          = var.vpc_id
  ip_address_type = "ipv4"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200-399"
  }

  tags = each.value.tags
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = {
    for pair in flatten([
      for k, v in var.lb_resources : [
        for target_id in v.lb_target_id : {
          lb_key    = k
          target_id = target_id
        }
      ] if v.use_for == "EC2"
    ]) : "${pair.lb_key}-${pair.target_id}" => pair
  }
  target_group_arn = aws_lb_target_group.target_group[each.value.lb_key].arn
  target_id        = each.value.target_id
  port             = var.lb_resources[each.value.lb_key].tg_port_number
}

resource "aws_lb_listener" "http" {
  for_each          = var.lb_resources
  load_balancer_arn = aws_lb.load_balancer[each.key].arn
  port              = each.value.lb_port_number
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }

  tags = each.value.tags
}

resource "aws_lb_listener_rule" "listener_rule" {
  for_each     = var.lb_resources
  listener_arn = aws_lb_listener.http[each.key].arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = each.value.tags
}