output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.this.arn
}

output "task_role_name" {
  description = "Name of the ECS task role for application containers."
  value       = aws_iam_role.task.name
}

output "task_role_arn" {
  description = "ARN of the ECS task role for application containers."
  value       = aws_iam_role.task.arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role."
  value       = aws_iam_role.execution.name
}

output "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = aws_iam_role.execution.arn
}

output "log_group_name" {
  description = "Name of the ECS CloudWatch log group."
  value       = aws_cloudwatch_log_group.ecs.name
}

output "log_group_arn" {
  description = "ARN of the ECS CloudWatch log group."
  value       = aws_cloudwatch_log_group.ecs.arn
}

output "service_arn" {
  description = "ARN of the ECS service, or null when service creation is disabled."
  value       = try(aws_ecs_service.this[0].id, null)
}

output "service_name" {
  description = "Name of the ECS service, or null when service creation is disabled."
  value       = try(aws_ecs_service.this[0].name, null)
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Family name of the ECS task definition."
  value       = aws_ecs_task_definition.this.family
}

output "security_group_id" {
  description = "Security group ID attached to the ECS service."
  value       = aws_security_group.ecs_service.id
}
