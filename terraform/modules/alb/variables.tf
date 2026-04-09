variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB and its security group."
  type        = string
  default     = "lumio-learning-prod-alb"
}

variable "target_group_name" {
  description = "Name of the placeholder target group."
  type        = string
  default     = "lumio-learning-prod-tg"
}

variable "target_group_tag_name" {
  description = "Name tag applied to the placeholder target group."
  type        = string
  default     = "lumio-learning-prod-placeholder-tg"
}

variable "security_group_description" {
  description = "Description applied to the ALB security group."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the internet-facing ALB."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for an ALB."
  }
}

variable "placeholder_target_group_port" {
  description = "Port for the placeholder target group."
  type        = number
  default     = 80
}

variable "fixed_response_message_body" {
  description = "Fixed HTTPS response served until an ECS target is attached."
  type        = string
  default     = "Lumio Learning is coming soon."
}

variable "certificate_arn" {
  description = "ACM certificate ARN used by the HTTPS listener."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ALB resources."
  type        = map(string)
  default     = {}
}
