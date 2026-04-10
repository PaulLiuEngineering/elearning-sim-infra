output "instance_id" {
  description = "ID of the bastion EC2 instance."
  value       = aws_instance.this.id
}

output "public_dns" {
  description = "Public DNS name of the bastion EC2 instance."
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "Public IP of the bastion EC2 instance."
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "Security group ID attached to the bastion EC2 instance."
  value       = aws_security_group.bastion.id
}
