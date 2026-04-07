output "private_route_table_id" {
  description = "Route table ID shared by the private subnets."
  value       = aws_route_table.private.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = aws_subnet.private[*].id
}
