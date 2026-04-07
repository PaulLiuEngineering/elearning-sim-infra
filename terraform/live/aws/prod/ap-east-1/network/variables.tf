variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix for the network stack."
  type        = string
  default     = "lumio-learning-hk-prod"
}

variable "vpc_id" {
  description = "Existing VPC ID for the private subnets."
  type        = string
  default     = "vpc-0aff03d7739209bef"
}

variable "availability_zones" {
  description = "Availability zones used by the new private subnets."
  type        = list(string)
  default     = ["ap-east-1a", "ap-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["172.31.48.0/20", "172.31.64.0/20"]
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "network"
  }
}
