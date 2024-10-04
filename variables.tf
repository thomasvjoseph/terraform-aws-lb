variable "lb_name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "lb_security_group" {
  description = "Security groups for the load balancer"
  type        = list(string)
}

variable "tg_name" {
  description = "Target group name"
  type        = string
}

variable "tg_port_number" {
  description = "Port number for the target group"
  type        = number
}

variable "lb_port_number" {
  description = "Port number for the load balancer"
  type        = number
}

variable "lb_target_id" {
  description = "List of target IDs (instance IDs for EC2, IP addresses for Fargate)"
  type        = list(string)
}

variable "load_balancer_type" {
  description = "Load balancer type (application or network)"
  type        = string
}

variable "name" {
  description = "Resource name for tagging"
  type        = string
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "use_for" {
  description = "Defines whether the LB is used for EC2 or Fargate (EC2 or Fargate)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the resources will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnets where the load balancer will be deployed"
  type        = list(string)
}

# Health Check Optional Variables
variable "health_check_path" {
  description = "The destination for the health check requests"
  type        = string
  default     = "/"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful health checks required before considering the target healthy"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed health checks required before considering the target unhealthy"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "The time, in seconds, to wait for a response from the target before considering it unhealthy"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "The approximate interval, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_protocol" {
  description = "The protocol used when performing the health check"
  type        = string
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "The HTTP status code to match"
  type        = string
  default     = "200-399"
}