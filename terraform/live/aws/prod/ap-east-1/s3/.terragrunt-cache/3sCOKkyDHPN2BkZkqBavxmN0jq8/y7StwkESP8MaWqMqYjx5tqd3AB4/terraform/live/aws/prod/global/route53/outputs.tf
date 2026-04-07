output "hosted_zone_id" {
  description = "ID of the public Route 53 hosted zone."
  value       = aws_route53_zone.this.zone_id
}

output "hosted_zone_name_servers" {
  description = "Assigned Route 53 nameservers for the hosted zone. Use these for delegation."
  value       = aws_route53_zone.this.name_servers
}

output "www_record_fqdn" {
  description = "Fully qualified www record name for the service."
  value       = local.www_record_name
}

output "apex_domain_name" {
  description = "Apex domain name for the hosted zone."
  value       = var.domain_name
}
