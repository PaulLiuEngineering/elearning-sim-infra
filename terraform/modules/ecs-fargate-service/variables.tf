variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ECS service security group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ECS tasks run."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB security group ID allowed to reach the service."
  type        = string
  default     = null
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to reach the service when not using an ALB security group reference."
  type        = list(string)
  default     = []
}

variable "target_group_arn" {
  description = "Target group ARN used by the ECS service."
  type        = string
}

variable "container_image" {
  description = "Full container image reference for the application."
  type        = string
}

variable "app_bucket_arn" {
  description = "ARN of the application S3 bucket the ECS task role can access."
  type        = string
}

variable "task_family" {
  description = "Task definition family name. Defaults to name_prefix when null."
  type        = string
  default     = null
}

variable "service_name" {
  description = "ECS service name. Defaults to <name_prefix>-service when null."
  type        = string
  default     = null
}

variable "create_service" {
  description = "Whether to create the ECS service."
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Container name referenced by the service load balancer block."
  type        = string
}

variable "container_environment" {
  description = "Static environment variables injected into the application container."
  type        = map(string)
  default     = {}
}

variable "secret_parameter_names" {
  description = "SSM parameter names, relative to ssm_parameter_prefix, injected as ECS secrets."
  type        = list(string)
  default     = []
}

variable "ssm_parameter_prefix" {
  description = "SSM parameter path prefix used to build ECS secret references."
  type        = string
  default     = null
}

variable "ssm_parameter_region" {
  description = "AWS region that stores the SSM parameters. Defaults to the current provider region."
  type        = string
  default     = null
}

variable "container_port" {
  description = "Container port referenced by the service load balancer block."
  type        = number
}

variable "task_cpu" {
  description = "CPU units for the Fargate task definition."
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory in MiB for the Fargate task definition."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired ECS service task count."
  type        = number
  default     = 1
}

variable "assign_public_ip" {
  description = "Whether ECS tasks should receive public IP addresses."
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Retention period for the ECS CloudWatch log group."
  type        = number
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "Grace period for ECS service health checks."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Tags applied to the ECS resources."
  type        = map(string)
  default     = {}
}
