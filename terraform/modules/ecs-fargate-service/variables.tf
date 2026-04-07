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
}

variable "target_group_arn" {
  description = "Target group ARN used by the ECS service."
  type        = string
}

variable "app_bucket_arn" {
  description = "ARN of the application S3 bucket the ECS task role can access."
  type        = string
}

variable "create_service" {
  description = "Whether to create the ECS service."
  type        = bool
  default     = false
}

variable "task_definition_arn" {
  description = "Task definition ARN to run when create_service is true."
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name referenced by the service load balancer block."
  type        = string
}

variable "container_port" {
  description = "Container port referenced by the service load balancer block."
  type        = number
}

variable "desired_count" {
  description = "Desired ECS service task count."
  type        = number
  default     = 1
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
