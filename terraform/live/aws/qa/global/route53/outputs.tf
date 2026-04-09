output "apex_record_fqdn" {
  description = "Fully qualified name of the QA apex alias record."
  value       = module.qa_internal.apex_record_fqdn
}

output "www_record_fqdn" {
  description = "Fully qualified name of the QA www alias record."
  value       = module.qa_internal.www_record_fqdn
}
