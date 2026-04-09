variable "aws_region" {
  description = "AWS region used by this stack. Route 53 hosted zones are global."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the QA hosted zone."
  type        = string
  default     = "qa-internal.lumio-learning.com"
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53-zone"
  }
}
