variable "domain_name" {
  description = "Primary domain name for the ACM certificate."
  type        = string
}

variable "subject_alternative_names" {
  description = "Optional subject alternative names for the ACM certificate."
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for DNS validation."
  type        = string
  default     = null
}

variable "create_route53_validation_records" {
  description = "Create Route 53 validation records for the certificate."
  type        = bool
  default     = true
}

variable "wait_for_validation" {
  description = "Wait for ACM validation to complete during apply."
  type        = bool
  default     = true
}
