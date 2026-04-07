output "cluster_name" {
  description = "Name of the ECS cluster for application deployments."
  value       = module.ecs.cluster_name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster for application deployments."
  value       = module.ecs.cluster_arn
}

output "task_role_name" {
  description = "Name of the ECS task role for application containers."
  value       = module.ecs.task_role_name
}

output "task_role_arn" {
  description = "ARN of the ECS task role for application containers."
  value       = module.ecs.task_role_arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role."
  value       = module.ecs.execution_role_name
}

output "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = module.ecs.execution_role_arn
}

output "log_group_name" {
  description = "CloudWatch log group name for application task logs."
  value       = module.ecs.log_group_name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN for application task logs."
  value       = module.ecs.log_group_arn
}

output "security_group_id" {
  description = "Security group ID that application tasks should use."
  value       = module.ecs.security_group_id
}

output "service_arn" {
  description = "ARN of the ECS service, or null until the application pipeline creates it."
  value       = module.ecs.service_arn
}
