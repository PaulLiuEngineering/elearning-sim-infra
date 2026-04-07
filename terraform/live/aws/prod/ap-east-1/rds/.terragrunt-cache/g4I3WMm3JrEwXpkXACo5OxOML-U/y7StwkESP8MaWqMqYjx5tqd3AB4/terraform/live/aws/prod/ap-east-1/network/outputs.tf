output "private_route_table_id" {
  description = "Route table ID used by the private subnets."
  value       = module.private_subnets.private_route_table_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for internal workloads."
  value       = module.private_subnets.private_subnet_ids
}
