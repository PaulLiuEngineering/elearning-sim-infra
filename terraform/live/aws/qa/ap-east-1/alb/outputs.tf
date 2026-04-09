output "alb_arn" {
  description = "ARN of the QA ALB."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the QA ALB."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the QA ALB."
  value       = module.alb.alb_zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the QA ALB."
  value       = module.acm.requested_certificate_arn
}

output "alb_security_group_id" {
  description = "Security group ID attached to the QA ALB."
  value       = module.alb.alb_security_group_id
}
