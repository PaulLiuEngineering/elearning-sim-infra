variable "aws_region" {
  description = "AWS region used by this stack. Route 53 hosted zones are global."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Root domain name for the public hosted zone."
  type        = string
  default     = "lumio-learning.com"
}

variable "create_www_alias_record" {
  description = "Create the future www alias record to an ALB when target details are available."
  type        = bool
  default     = false
}

variable "www_alias_name" {
  description = "Fully qualified DNS name for the ALB target of the www alias record."
  type        = string
  default     = null
}

variable "www_alias_zone_id" {
  description = "Hosted zone ID of the ALB target for the www alias record."
  type        = string
  default     = null
}

variable "create_apex_redirect_records" {
  description = "Create placeholder apex redirect records when redirect infrastructure is available."
  type        = bool
  default     = false
}

variable "apex_redirect_target" {
  description = "Future redirect destination for the apex domain."
  type        = string
  default     = "www.lumio-learning.com"
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53"
  }
}
