variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix for the RDS stack."
  type        = string
  default     = "lumio-learning-hk-prod"
}

variable "vpc_id" {
  description = "Existing VPC ID for the RDS instance."
  type        = string
  default     = "vpc-0aff03d7739209bef"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "allowed_security_group_id" {
  description = "Security group ID allowed to access PostgreSQL."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "elearningsim"
}

variable "username" {
  description = "Master username for the PostgreSQL instance."
  type        = string
  default     = "elearning-sim-db-admin"
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

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "rds"
  }
}
