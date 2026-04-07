output "address" {
  description = "DNS address of the PostgreSQL instance."
  value       = aws_db_instance.this.address
}

output "arn" {
  description = "ARN of the PostgreSQL instance."
  value       = aws_db_instance.this.arn
}

output "database_name" {
  description = "Initial database name."
  value       = aws_db_instance.this.db_name
}

output "endpoint" {
  description = "Connection endpoint of the PostgreSQL instance."
  value       = aws_db_instance.this.endpoint
}

output "password" {
  description = "Generated master password."
  value       = random_password.master.result
  sensitive   = true
}

output "port" {
  description = "Port exposed by the PostgreSQL instance."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "Security group ID attached to the PostgreSQL instance."
  value       = aws_security_group.db.id
}

output "username" {
  description = "Master username for the PostgreSQL instance."
  value       = aws_db_instance.this.username
}
