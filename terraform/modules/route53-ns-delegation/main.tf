resource "aws_route53_record" "subdomain_delegation" {
  zone_id = var.parent_hosted_zone_id
  name    = var.subdomain_name
  type    = "NS"
  ttl     = var.ttl
  records = var.name_servers

  allow_overwrite = true
}
