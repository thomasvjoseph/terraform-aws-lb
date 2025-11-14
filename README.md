# AWS Load Balancer Terraform Module

This Terraform module creates and manages AWS Application Load Balancers (ALB), target groups, listeners, and listener rules. It supports configurations for both EC2 instances and ECS services as targets.

Features

	•	Creates AWS Load Balancers (ALB)
	•	Configures Target Groups and Listener Rules
	•	Supports both EC2 and ECS (Fargate) target types
	•	Configurable through variables for flexible deployments


## Usage/Examples

```hcl
    module "alb" {
  source  = "thomasvjoseph/lb/aws"
  version = "x.y.z"

  vpc_id  = "vpc-12345678"
  subnets = ["subnet-abcdef12", "subnet-abcdef34"]

  lb_resources = {
    "example" = {
      lb_name            = "example-lb"
      lb_security_group  = ["sg-0123456789abcdef0"]
      lb_target_type     = "instance"  # Options: instance, ip
      internal           = false
      tg_name            = "example-tg"
      tg_port_number     = 80
      lb_port_number     = 80
      lb_target_id       = ["i-0123456789abcdef0"]  # For EC2 targets, list of instance IDs
      load_balancer_type = "application"
      enable_deletion_protection = false
      tags = {
        Name = "example-lb"
        Environment = "dev"
      }
      use_for = "EC2"
    },
    "ecs-example" = {
      lb_name            = "ecs-example-lb"
      lb_security_group  = ["sg-0123456789abcdef1"]
      lb_target_type     = "ip"  # Use "ip" for ECS Fargate
      internal           = false
      tg_name            = "ecs-example-tg"
      tg_port_number     = 8080
      lb_port_number     = 8080
      lb_target_id       = []  # For ECS targets, leave this empty
      load_balancer_type = "application"
      enable_deletion_protection = false
      tags = {
        Name = "ecs-example-lb"
        Environment = "prod"
      }
      use_for = "ECS"
    }
  }
}
```


## Input Variables

| Name            | Description                          | Type     | Default | Required |
|-----------------|--------------------------------------|----------|---------|----------|
| `lb_resources`  | Load Balancer resources definition   | `map`    | n/a     | yes      |
| `vpc_id`        | The ID of the VPC                    | `string` | n/a     | yes      |
| `subnets`       | List of subnet IDs                   | `string` | n/a     | yes      |


## lb_resources object structure

The lb_resources variable is a map of objects with the following fields:

| Name            | Description                          | Type     | Default | Required |
|-----------------|--------------------------------------|----------|---------|----------|
| `lb_name`	|The name of the Load Balancer |	`string`|	yes|
| `lb_security_group|`	List of security group IDs for the Load Balancer |	`list(string)` |	yes |
| `lb_target_type`|	Type of target (instance for EC2, ip for ECS Fargate)|	`string`|	yes|
| `internal`|	Whether the Load Balancer is internal or internet-facing|	`bool`	| yes |
| `tg_name`|	Name of the Target Group|	`string`|	yes|
| `tg_port_number`|	Port number for the Target Group|	`number`	|yes|
| `lb_port_number`|	Port number for the Load Balancer listener|	`number`	|yes|
| `lb_target_id`|	List of target IDs (required for EC2, leave empty for ECS) |	`list(string)`| no |
| `load_balancer_type`|	Type of Load Balancer (application)|	`string`|	yes|
| `enable_deletion_protection`|	Whether to enable deletion protection|	`bool`	| yes |
| `tags`|	Tags to apply to all resources |	`map(string)` |	yes |
| `use_for`|	Indicates whether to use for EC2 or ECS|	`string`|	yes|

## Health Check Settings
The module configures health checks with the following default parameters:

    Path: /

    Healthy Threshold: 5

    Unhealthy Threshold: 2

    Timeout: 5 seconds

    Interval: 30 seconds

    Protocol: HTTP

    Matcher: 200-399 status codes

## Target Group Attachment Behavior

The module automatically handles target group attachments based on the use_for parameter:

    EC2 Targets: The aws_lb_target_group_attachment resource is created with the specified EC2 instance IDs from lb_target_id

    ECS Targets: No target group attachment is created as ECS services automatically register targets with the target group

## Outputs


| Name              | Description                          |
|-------------------|--------------------------------------|
| `alb_dns_name`    | The DNS name of the Load Balancer    |
| `alb_arn`         | The ARN of the Load Balancer         |
| `target_group_arn`| The ARN of the Target Group          |

## Important Notes
ECS Fargate: When using ECS Fargate, set lb_target_type to "ip" and lb_target_id to an empty list []

EC2 Instances: When using EC2, set lb_target_type to "instance" and provide instance IDs in lb_target_id

Security Groups: Ensure your security groups allow traffic on the specified ports

Subnets: Provide subnets in at least two different Availability Zones for high availability

## Requirements

| Name              | Version    |
|-------------------|------------|
| `Terraform`       | >= 0.12    |
| `AWS`             | >= 3.0     |


## License

This module is licensed under the MIT License.

## Author: 

thomas joseph
- [linkedin](https://www.linkedin.com/in/thomasvjoseph/)
- [medium](https://medium.com/@thomasvjoseph)