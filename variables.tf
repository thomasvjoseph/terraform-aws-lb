variable "lb_resources" {
  description = "Load Balancer resources definition"
  type = map(object({
    lb_name                    = string
    lb_security_group          = list(string)
    lb_target_type             = string
    internal                   = bool
    subnets                    = list(string)
    tg_name                    = string
    tg_port_number             = number
    lb_port_number             = number
    lb_target_id               = list(string)
    load_balancer_type         = string
    enable_deletion_protection = bool
    tags                       = map(string)
    use_for                    = string # "EC2" or "ECS"
  }))
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}