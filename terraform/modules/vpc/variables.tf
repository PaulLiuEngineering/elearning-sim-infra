variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "name_prefix" {
  description = "Resource name prefix for the VPC and related resources."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the new VPC."
  type        = string
}

variable "public_availability_zones" {
  description = "Availability zones used by the public subnets."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "At least two public subnets are required."
  }
}

variable "private_availability_zones" {
  description = "Availability zones used by the private subnets."
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
  description = "Tags applied to the VPC resources."
  type        = map(string)
  default     = {}
}
