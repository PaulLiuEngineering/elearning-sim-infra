variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix for the ECS stack."
  type        = string
  default     = "lumio-learning-hk-prod"
}

variable "vpc_id" {
  description = "Existing VPC ID for the ECS service."
  type        = string
  default     = "vpc-0aff03d7739209bef"
}

variable "subnet_ids" {
  description = "Public subnet IDs for ECS tasks."
  type        = list(string)
  default     = ["subnet-08161c6c1dfa9a0c6"]
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
  description = "Whether Terraform should create the ECS service or leave service creation to the application deploy pipeline."
  type        = bool
  default     = false
}

variable "task_definition_arn" {
  description = "Task definition ARN to use when create_service is true."
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name exposed by the task definition."
  type        = string
  default     = "app"
}

variable "container_port" {
  description = "Container port exposed by the service."
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "Desired ECS task count."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "ecs"
  }
}
