output "alb_arn" {
  description = "ARN of the production ALB."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the production ALB."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the production ALB."
  value       = aws_lb.this.zone_id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the Lumio Learning domains."
  value       = aws_acm_certificate.this.arn
}

output "hosted_zone_id" {
  description = "ID of the existing public Route 53 hosted zone."
  value       = var.hosted_zone_id
}

output "target_group_arn" {
  description = "ARN of the placeholder target group for future ECS attachment."
  value       = aws_lb_target_group.placeholder.arn
}
