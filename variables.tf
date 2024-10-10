variable "lb_resources" {
  description = "Load Balancer resources definition"
  type = map(object({
    lb_name             = string
    lb_security_group   = list(string)
    lb_target_type      = string
    tg_name             = string
    tg_port_number      = number
    lb_port_number      = number
    lb_target_id        = list(string)
    load_balancer_type  = string
    name                = string
    env                 = string
    use_for             = string  # "EC2" or "ECS"
  }))
}

variable "vpc_id" {
  description = "value of the id of the vpc"
}


variable "subnets" {
  description = "value of the id of the subnets"
  type = list(string)
}