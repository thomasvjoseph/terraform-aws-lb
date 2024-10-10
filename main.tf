resource "aws_lb" "load_balancer" {
  for_each                    = var.lb_resources
  name                        = each.value.lb_name
  internal                    = false
  load_balancer_type          = each.value.load_balancer_type
  ip_address_type             = "ipv4"
  security_groups             = each.value.lb_security_group
  subnets                     = var.subnets
  enable_deletion_protection  = false

  tags  = {
    "Name"                    = each.value.name 
    "Env"                     = each.value.env
    "Terraform"               = "true"
  }
}

resource "aws_lb_target_group" "target_group" {
  for_each                    = var.lb_resources
  name                        = each.value.tg_name
  target_type                 = each.value.lb_target_type
  port                        = each.value.tg_port_number
  protocol                    = "HTTP"
  vpc_id                      = var.vpc_id
  ip_address_type             = "ipv4"

  health_check {
    path                      = "/"
    healthy_threshold         = 5
    unhealthy_threshold       = 2
    timeout                   = 5
    interval                  = 30
    protocol                  = "HTTP"
    matcher                   = "200-399"
  }

  tags  = {
    "Name"                    = each.value.name
    "Env"                     = each.value.env
    "Terraform"               = "true"
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = {
    for k, v in var.lb_resources : k => v if v.use_for == "EC2" && length(v.lb_target_id) > 0
  }
  target_group_arn = aws_lb_target_group.target_group[each.key].arn
  target_id        = element(each.value.lb_target_id, 0)  # Get the first element from the list , 
  #target ID only for EC2. For ECS Fargate no target id , lb_target_id  = []   # No target ID needed for ECS Fargate
  port             = each.value.tg_port_number
}

resource "aws_lb_listener" "http" {
  for_each                    = var.lb_resources
  load_balancer_arn           = aws_lb.load_balancer[each.key].arn
  port                        = each.value.lb_port_number
  protocol                    = "HTTP"
  default_action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.target_group[each.key].arn
  }

  tags  = {
    "Name"                    = each.value.name
    "Env"                     = each.value.env
    "Terraform"               = "true"
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  for_each                    = var.lb_resources
  listener_arn                = aws_lb_listener.http[each.key].arn
  priority                    = 100
  action {
    type                      = "forward"
    target_group_arn          = aws_lb_target_group.target_group[each.key].arn
  }
  condition {
    path_pattern {
      values                  = ["/*"]
    }
  }

  tags  = {
    "Name"                    = each.value.name
    "Env"                     = each.value.env
    "Terraform"               = "true"
  }
}