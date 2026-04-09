variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix for the QA VPC stack."
  type        = string
  default     = "lumio-learning-qa-hk"
}

variable "cidr_block" {
  description = "CIDR block for the QA VPC."
  type        = string
  default     = "172.32.0.0/16"
}

variable "public_availability_zones" {
  description = "Availability zones for the public subnets."
  type        = list(string)
  default     = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["172.32.0.0/20", "172.32.16.0/20", "172.32.32.0/20"]
}

variable "private_availability_zones" {
  description = "Availability zones for the private subnets."
  type        = list(string)
  default     = ["ap-east-1a", "ap-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["172.32.48.0/20", "172.32.64.0/20"]
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "vpc"
  }
}
