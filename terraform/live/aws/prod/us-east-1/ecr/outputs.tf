output "repository_arn" {
  description = "ARN of the production ECR repository."
  value       = module.ecr.repository_arn
}

output "repository_name" {
  description = "Name of the production ECR repository."
  value       = module.ecr.repository_name
}

output "repository_url" {
  description = "Repository URL for image pushes."
  value       = module.ecr.repository_url
}
