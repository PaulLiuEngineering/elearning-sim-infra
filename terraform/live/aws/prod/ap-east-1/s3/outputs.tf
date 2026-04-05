output "bucket_arn" {
  description = "ARN of the production S3 bucket."
  value       = module.s3.bucket_arn
}

output "bucket_name" {
  description = "Name of the production S3 bucket."
  value       = module.s3.bucket_name
}

output "bucket_region" {
  description = "Region of the production S3 bucket."
  value       = var.aws_region
}
