
```markdown

# AWS Load Balancer Terraform Module

This Terraform module creates and manages AWS Application Load Balancers (ALB), target groups, listeners, and listener rules. It supports configurations for both EC2 instances and ECS services as targets.

Features

	•	Creates AWS Load Balancers (ALB)
	•	Configures Target Groups and Listener Rules
	•	Supports both EC2 and ECS (Fargate) target types
	•	Configurable through variables for flexible deployments

## Usage

```hcl
module "alb" {
  source  = "your-username/alb/aws"  # Replace with your module's path on the Terraform Registry
  version = "x.y.z"

  vpc_id  = "vpc-12345678"
  subnets = ["subnet-abcdef12", "subnet-abcdef34"]

  lb_resources = {
    "example" = {
      lb_name            = "example-lb"
      lb_security_group  = ["sg-0123456789abcdef0"]
      lb_target_type     = "instance"  # Options: instance, ip
      tg_name            = "example-tg"
      tg_port_number     = 80
      lb_port_number     = 80
      lb_target_id       = ["i-0123456789abcdef0"]  # For EC2 targets, list of instance IDs
      load_balancer_type = "application"
      name               = "example-lb"
      env                = "prod"
      use_for            = "EC2"  # or ECS
    },
    "ecs-example" = {
      lb_name            = "ecs-example-lb"
      lb_security_group  = ["sg-0123456789abcdef1"]
      lb_target_type     = "ip"
      tg_name            = "ecs-example-tg"
      tg_port_number     = 8080
      lb_port_number     = 8080
      lb_target_id       = []  # For ECS targets, leave this empty
      load_balancer_type = "application"
      name               = "ecs-example-lb"
      env                = "dev"
      use_for            = "ECS"
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

	•	lb_name: The name of the Load Balancer.
	•	lb_security_group: List of security group IDs for the Load Balancer.
	•	lb_target_type: Type of target (e.g., instance, ip).
	•	tg_name: Name of the Target Group.
	•	tg_port_number: Port number for the Target Group.
	•	lb_port_number: Port number for the Load Balancer.
	•	lb_target_id: List of target IDs (required for EC2, leave empty for ECS).
	•	load_balancer_type: Type of Load Balancer (e.g., application).
	•	name: Name tag for resources.
	•	env: Environment tag (e.g., dev, prod).
	•	use_for: Indicates whether to use for EC2 or ECS.

## Target Group Attachment

The module uses the aws_lb_target_group_attachment resource for EC2 targets only. When using ECS (Fargate), the target group attachment does not require a target_id. The logic in the module handles this automatically, ensuring that:

	•	EC2 Targets: The target group attachment is created with the specified EC2 instance ID.
	•	ECS Targets: The target group attachment is not created as ECS services automatically register targets.

## Outputs


| Name              | Description                          |
|-------------------|--------------------------------------|
| `alb_dns_name`    | The DNS name of the Load Balancer    |
| `alb_arn`         | The ARN of the Load Balancer         |
| `target_group_arn`| The ARN of the Target Group          |


## Requirements

| Name              | Version    |
|-------------------|------------|
| `Terraform`       | >= 0.12    |
| `AWS`             | >= 3.0     |


## License

This module is licensed under the MIT License.

## Author: 

thomas joseph
