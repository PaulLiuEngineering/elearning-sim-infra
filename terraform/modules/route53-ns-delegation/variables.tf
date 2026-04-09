variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "parent_hosted_zone_id" {
  description = "Hosted zone ID of the parent domain where the NS delegation record is created."
  type        = string
}

variable "subdomain_name" {
  description = "Fully qualified subdomain name to delegate from the parent hosted zone."
  type        = string
}

variable "name_servers" {
  description = "Authoritative nameservers for the delegated child hosted zone."
  type        = list(string)
}

variable "ttl" {
  description = "TTL in seconds for the NS delegation record."
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags available to the root provider default_tags block."
  type        = map(string)
  default     = {}
}
