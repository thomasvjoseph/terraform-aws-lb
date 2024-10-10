output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = { for k, v in aws_lb.load_balancer: k => v.dns_name }
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = { for k, v in aws_lb.load_balancer : k => v.arn }
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = { for k, v in aws_lb_target_group.target_group : k => v.arn }
}