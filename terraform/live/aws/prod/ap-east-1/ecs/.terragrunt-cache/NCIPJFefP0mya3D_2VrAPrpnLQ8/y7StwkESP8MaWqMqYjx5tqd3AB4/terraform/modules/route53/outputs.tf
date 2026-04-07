output "apex_record_fqdn" {
  description = "FQDN of the apex alias record."
  value       = aws_route53_record.apex.fqdn
}

output "www_record_fqdn" {
  description = "FQDN of the www alias record."
  value       = aws_route53_record.www.fqdn
}
