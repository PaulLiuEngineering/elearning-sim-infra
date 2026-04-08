variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "domain_name" {
  description = "Apex domain name served by the ALB."
  type        = string
  default     = "lumio-learning.com"
}

variable "www_domain_name" {
  description = "WWW domain name served by the ALB."
  type        = string
  default     = "www.lumio-learning.com"
}

variable "hosted_zone_id" {
  description = "Existing public Route 53 hosted zone ID."
  type        = string
  default     = "Z00306403SSX2SQBFGSED"
}

variable "cn_domain_name" {
  description = "Primary .cn domain name for a separate ACM certificate."
  type        = string
  default     = "lumio-learning.cn"
}

variable "cn_www_domain_name" {
  description = "WWW .cn domain name for a separate ACM certificate."
  type        = string
  default     = "www.lumio-learning.cn"
}

variable "attach_cn_certificate" {
  description = "Attach the separately validated .cn certificate to the existing HTTPS listener."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
  default     = "vpc-0aff03d7739209bef"
}

variable "subnet_ids" {
  description = "Subnet IDs for the internet-facing ALB."
  type        = list(string)
  default     = ["subnet-0983719c503d903ac", "subnet-0a2df0c9eaa4e4572", "subnet-08161c6c1dfa9a0c6"]

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

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "alb"
  }
}
