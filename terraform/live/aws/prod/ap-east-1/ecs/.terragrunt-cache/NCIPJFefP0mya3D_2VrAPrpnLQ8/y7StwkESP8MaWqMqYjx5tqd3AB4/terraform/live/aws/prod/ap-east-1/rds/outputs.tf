output "address" {
  description = "DNS address of the PostgreSQL instance."
  value       = module.rds.address
}

output "db_address_parameter_name" {
  description = "SSM parameter name storing the DB address."
  value       = aws_ssm_parameter.db_address.name
}

output "arn" {
  description = "ARN of the PostgreSQL instance."
  value       = module.rds.arn
}

output "endpoint" {
  description = "Connection endpoint of the PostgreSQL instance."
  value       = module.rds.endpoint
}

output "password" {
  description = "Generated master password for the PostgreSQL instance."
  value       = module.rds.password
  sensitive   = true
}

output "db_password_parameter_name" {
  description = "SSM parameter name storing the DB password."
  value       = aws_ssm_parameter.db_password.name
}

output "port" {
  description = "Port exposed by the PostgreSQL instance."
  value       = module.rds.port
}

output "security_group_id" {
  description = "Security group ID attached to the PostgreSQL instance."
  value       = module.rds.security_group_id
}

output "username" {
  description = "Master username for the PostgreSQL instance."
  value       = module.rds.username
}

output "db_username_parameter_name" {
  description = "SSM parameter name storing the DB username."
  value       = aws_ssm_parameter.db_username.name
}
