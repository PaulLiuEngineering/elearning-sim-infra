variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix for the QA ALB stack."
  type        = string
  default     = "lumio-learning-qa-hk"
}

variable "domain_name" {
  description = "Domain name served by the QA ALB."
  type        = string
  default     = "qa-internal.lumio-learning.com"
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for ACM validation and DNS records."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the internal ALB."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for an ALB."
  }
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the ALB listeners."
  type        = list(string)
  default     = ["71.251.203.226/32"]
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

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "alb"
  }
}
