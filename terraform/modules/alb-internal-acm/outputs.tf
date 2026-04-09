output "alb_arn" {
  description = "ARN of the ALB."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB."
  value       = module.alb.alb_zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate."
  value       = module.acm.requested_certificate_arn
}

output "alb_security_group_id" {
  description = "Security group ID attached to the ALB."
  value       = module.alb.alb_security_group_id
}

output "hosted_zone_id" {
  description = "Hosted zone ID used by the ALB."
  value       = var.hosted_zone_id
}

output "target_group_arn" {
  description = "ARN of the placeholder target group."
  value       = module.alb.target_group_arn
}
