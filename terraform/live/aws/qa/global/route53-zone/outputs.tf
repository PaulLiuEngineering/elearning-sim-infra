output "hosted_zone_id" {
  description = "ID of the QA public Route 53 hosted zone."
  value       = module.this.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Assigned nameservers for the QA hosted zone."
  value       = module.this.hosted_zone_name_servers
}
