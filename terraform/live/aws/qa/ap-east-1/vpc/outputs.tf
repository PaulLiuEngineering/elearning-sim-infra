output "vpc_id" {
  description = "ID of the QA VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets in the QA VPC."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets in the QA VPC."
  value       = module.vpc.private_subnet_ids
}

output "public_route_table_id" {
  description = "Route table ID associated with the QA public subnets."
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "Route table ID associated with the QA private subnets."
  value       = module.vpc.private_route_table_id
}
