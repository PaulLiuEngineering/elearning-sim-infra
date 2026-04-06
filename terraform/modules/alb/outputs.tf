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

output "https_listener_arn" {
  description = "ARN of the HTTPS listener on the production ALB."
  value       = aws_lb_listener.https.arn
}

output "target_group_arn" {
  description = "ARN of the placeholder target group for future ECS attachment."
  value       = aws_lb_target_group.placeholder.arn
}
