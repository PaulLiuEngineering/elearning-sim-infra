variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "name_prefix" {
  description = "Resource name prefix for the bastion resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the bastion security group."
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where the bastion host is launched."
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name used to access the bastion host."
  type        = string

  validation {
    condition     = trimspace(var.key_name) != ""
    error_message = "Provide a non-empty EC2 key pair name."
  }
}

variable "ami_id" {
  description = "Optional AMI ID for the bastion host. When null, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.nano"
}

variable "root_volume_size" {
  description = "Root volume size for the bastion host in GiB."
  type        = number
  default     = 8
}

variable "allowed_cidr_block_ssm_parameter_names" {
  description = "SSM parameter names whose values are used as the bastion SSH allowlist."
  type        = list(string)

  validation {
    condition     = length(var.allowed_cidr_block_ssm_parameter_names) > 0
    error_message = "Provide at least one SSM parameter name for bastion SSH access."
  }
}

variable "tags" {
  description = "Tags applied to the bastion resources."
  type        = map(string)
  default     = {}
}
