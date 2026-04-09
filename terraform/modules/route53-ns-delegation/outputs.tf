output "record_fqdn" {
  description = "FQDN of the NS delegation record."
  value       = aws_route53_record.subdomain_delegation.fqdn
}
