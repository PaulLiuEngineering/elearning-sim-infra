variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the existing ECS cluster."
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service."
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

variable "container_port" {
  description = "Optional container port mapping to include in the ECS task definition."
  type        = number
  default     = null
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

variable "subnet_ids" {
  description = "Subnet IDs where the ECS tasks run."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to the ECS service."
  type        = list(string)
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

variable "tags" {
  description = "Tags applied to the ECS resources."
  type        = map(string)
  default     = {}
}
