resource "aws_route53_record" "apex" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = var.www_domain_name
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
