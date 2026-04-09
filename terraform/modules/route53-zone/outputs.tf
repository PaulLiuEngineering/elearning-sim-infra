output "hosted_zone_id" {
  description = "ID of the public Route 53 hosted zone."
  value       = aws_route53_zone.this.zone_id
}

output "hosted_zone_name_servers" {
  description = "Assigned Route 53 nameservers for the hosted zone."
  value       = aws_route53_zone.this.name_servers
}
