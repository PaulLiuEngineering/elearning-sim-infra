variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "name_prefix" {
  description = "Resource name prefix for the RDS resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "allowed_security_group_id" {
  description = "Security group ID allowed to access PostgreSQL."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "username" {
  description = "Master username for the PostgreSQL instance."
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "17.8"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial storage allocation in GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage autoscaling allocation in GiB."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window in UTC."
  type        = string
  default     = "18:00-19:00"
}

variable "deletion_protection" {
  description = "Enable deletion protection for the database."
  type        = bool
  default     = true
}

variable "db_address_ssm_parameter_name" {
  description = "SSM parameter name that stores the database address."
  type        = string
  default     = null
}

variable "db_username_ssm_parameter_name" {
  description = "SSM parameter name that stores the database username."
  type        = string
  default     = null
}

variable "db_password_ssm_parameter_name" {
  description = "SSM parameter name that stores the database password."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the RDS resources."
  type        = map(string)
  default     = {}
}
