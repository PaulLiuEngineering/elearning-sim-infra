variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for the internal ALB resources."
  type        = string
}

variable "domain_name" {
  description = "Domain name served by the internal ALB."
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone ID used for ACM validation."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the internal ALB."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the ALB listeners."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_block_ssm_parameter_names" {
  description = "Optional SSM parameter names whose values are used as the ALB allowlist."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the ALB resources."
  type        = map(string)
  default     = {}
}
