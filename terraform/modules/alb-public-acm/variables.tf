variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "domain_name" {
  description = "Apex domain name served by the ALB."
  type        = string
}

variable "www_domain_name" {
  description = "WWW domain name served by the ALB."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for certificate validation."
  type        = string
}

variable "attach_secondary_certificate" {
  description = "Attach the secondary ACM certificate to the HTTPS listener. When true, requesting the certificate is implied."
  type        = bool
  default     = false
}

variable "request_secondary_certificate" {
  description = "Request a secondary ACM certificate and expose its validation records without attaching it to the HTTPS listener."
  type        = bool
  default     = false
}

variable "secondary_domain_name" {
  description = "Primary domain name for the secondary ACM certificate."
  type        = string
  default     = null
}

variable "secondary_www_domain_name" {
  description = "Secondary WWW domain name for the optional ACM certificate."
  type        = string
  default     = null
}

variable "secondary_create_route53_validation_records" {
  description = "Whether the secondary ACM certificate should create Route 53 validation records."
  type        = bool
  default     = false
}

variable "secondary_wait_for_validation" {
  description = "Whether the secondary ACM certificate should wait for validation."
  type        = bool
  default     = false
}

variable "alb_name" {
  description = "Name of the ALB and its security group."
  type        = string
}

variable "security_group_description" {
  description = "Description applied to the ALB security group."
  type        = string
}

variable "target_group_name" {
  description = "Name of the placeholder target group."
  type        = string
}

variable "target_group_tag_name" {
  description = "Name tag applied to the placeholder target group."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the internet-facing ALB."
  type        = list(string)
}

variable "placeholder_target_group_port" {
  description = "Port for the placeholder target group."
  type        = number
  default     = 80
}

variable "fixed_response_message_body" {
  description = "Fixed HTTPS response served until a target is attached."
  type        = string
  default     = "Service is coming soon."
}

variable "tags" {
  description = "Tags applied to the ALB resources."
  type        = map(string)
  default     = {}
}
