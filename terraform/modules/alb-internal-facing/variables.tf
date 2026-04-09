variable "name_prefix" {
  description = "Resource name prefix used for the ALB, security group, and target group."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the internal-facing ALB."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for an ALB."
  }
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the ALB listeners."
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidr_blocks) >= 1
    error_message = "At least one allowed CIDR block is required."
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
  default     = "Lumio Learning QA is coming soon."
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
