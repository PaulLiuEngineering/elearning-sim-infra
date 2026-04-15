output "service_id" {
  description = "ID of the ECS service."
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition."
  value       = module.task_definition.task_definition_arn
}

output "task_definition_family" {
  description = "Family name of the ECS task definition."
  value       = module.task_definition.task_definition_family
}

output "log_group_name" {
  description = "Name of the ECS CloudWatch log group."
  value       = module.task_definition.log_group_name
}

output "log_group_arn" {
  description = "ARN of the ECS CloudWatch log group."
  value       = module.task_definition.log_group_arn
}
