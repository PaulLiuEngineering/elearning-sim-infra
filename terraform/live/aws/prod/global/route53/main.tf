locals {
  www_record_name = "www.${var.domain_name}"
}

resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = var.tags
}

resource "aws_route53_record" "www_alias" {
  count = var.create_www_alias_record ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = local.www_record_name
  type    = "A"

  alias {
    name                   = var.www_alias_name
    zone_id                = var.www_alias_zone_id
    evaluate_target_health = true
  }

  lifecycle {
    precondition {
      condition     = var.www_alias_name != null && var.www_alias_zone_id != null
      error_message = "www_alias_name and www_alias_zone_id must be set when create_www_alias_record is true."
    }
  }
}

# Placeholder only: apex redirect requires additional infrastructure,
# such as an S3 website redirect bucket plus supporting DNS records.
resource "aws_route53_record" "apex_redirect_placeholder" {
  count = var.create_apex_redirect_records ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 60
  records = ["placeholder redirect target: ${var.apex_redirect_target}"]
}
