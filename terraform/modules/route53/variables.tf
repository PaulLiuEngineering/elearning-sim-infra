variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "hosted_zone_id" {
  description = "Existing public Route 53 hosted zone ID."
  type        = string
}

variable "domain_name" {
  description = "Apex domain name for the alias record."
  type        = string
}

variable "www_domain_name" {
  description = "WWW domain name for the alias record."
  type        = string
}

variable "alias_name" {
  description = "DNS name of the alias target."
  type        = string
}

variable "alias_zone_id" {
  description = "Hosted zone ID of the alias target."
  type        = string
}

variable "evaluate_target_health" {
  description = "Whether Route 53 should evaluate health of the alias target."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags available to the root provider default_tags block."
  type        = map(string)
  default     = {}
}
