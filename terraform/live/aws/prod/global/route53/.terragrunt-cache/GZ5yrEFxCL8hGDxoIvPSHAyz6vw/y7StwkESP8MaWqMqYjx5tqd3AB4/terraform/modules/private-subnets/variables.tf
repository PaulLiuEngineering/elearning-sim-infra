variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the private subnets."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for the private subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2
    error_message = "At least two private subnets are required."
  }
}

variable "tags" {
  description = "Tags applied to the private subnet resources."
  type        = map(string)
  default     = {}
}
