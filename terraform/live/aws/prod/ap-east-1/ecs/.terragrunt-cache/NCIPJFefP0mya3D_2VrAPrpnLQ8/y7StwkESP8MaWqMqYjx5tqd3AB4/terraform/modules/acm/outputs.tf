output "certificate_arn" {
  description = "ARN of the ACM certificate after validation."
  value       = var.wait_for_validation ? aws_acm_certificate_validation.this[0].certificate_arn : aws_acm_certificate.this.arn
}

output "requested_certificate_arn" {
  description = "ARN of the requested ACM certificate resource."
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_options" {
  description = "Domain validation records that can be created in an external DNS provider."
  value = [
    for option in aws_acm_certificate.this.domain_validation_options : {
      domain_name           = option.domain_name
      resource_record_name  = option.resource_record_name
      resource_record_type  = option.resource_record_type
      resource_record_value = option.resource_record_value
    }
  ]
}
