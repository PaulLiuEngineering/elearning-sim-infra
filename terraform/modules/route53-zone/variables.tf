variable "domain_name" {
  description = "Domain name for the public hosted zone."
  type        = string
}

variable "tags" {
  description = "Tags applied to the Route 53 hosted zone."
  type        = map(string)
  default     = {}
}
