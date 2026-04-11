variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "task_family" {
  description = "Family name for the ECS task definition."
  type        = string
}

variable "container_name" {
  description = "Container name for the ECS task definition."
  type        = string
}

variable "container_image" {
  description = "Full container image reference for the task."
  type        = string
}

variable "container_command" {
  description = "Optional command override for the ECS container."
  type        = list(string)
  default     = []
}

variable "container_environment" {
  description = "Static environment variables injected into the task container."
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

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role."
  type        = string
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

variable "log_group_name" {
  description = "Optional CloudWatch log group name. Defaults to /ecs/<task_family>."
  type        = string
  default     = null
}

variable "log_retention_in_days" {
  description = "Retention period for the ECS CloudWatch log group."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to the ECS task resources."
  type        = map(string)
  default     = {}
}
