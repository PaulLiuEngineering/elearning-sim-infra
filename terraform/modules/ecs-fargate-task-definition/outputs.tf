output "log_group_name" {
  description = "Name of the ECS CloudWatch log group."
  value       = aws_cloudwatch_log_group.ecs.name
}

output "log_group_arn" {
  description = "ARN of the ECS CloudWatch log group."
  value       = aws_cloudwatch_log_group.ecs.arn
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Family name of the ECS task definition."
  value       = aws_ecs_task_definition.this.family
}
