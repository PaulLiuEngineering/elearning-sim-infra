output "alb_arn" {
  description = "ARN of the production ALB."
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the production ALB."
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the production ALB."
  value       = module.alb.alb_zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the Lumio Learning domains."
  value       = module.acm.requested_certificate_arn
}

output "cn_acm_certificate_arn" {
  description = "ARN of the separate ACM certificate for the .cn domains."
  value       = module.acm_cn.requested_certificate_arn
}

output "cn_certificate_validation_records" {
  description = "DNS validation records to add manually in Aliyun for the .cn certificate."
  value       = module.acm_cn.domain_validation_options
}

output "hosted_zone_id" {
  description = "ID of the existing public Route 53 hosted zone."
  value       = var.hosted_zone_id
}

output "target_group_arn" {
  description = "ARN of the placeholder target group for future ECS attachment."
  value       = module.alb.target_group_arn
}
