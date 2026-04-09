variable "aws_region" {
  description = "AWS region used by this stack. Route 53 hosted zones are global."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Apex domain name for the QA records."
  type        = string
  default     = "qa-internal.lumio-learning.com"
}

variable "www_domain_name" {
  description = "WWW domain name for the QA records."
  type        = string
  default     = "www.qa-internal.lumio-learning.com"
}

variable "alias_name" {
  description = "DNS name of the QA ALB."
  type        = string
}

variable "alias_zone_id" {
  description = "Hosted zone ID of the QA ALB."
  type        = string
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53"
  }
}
