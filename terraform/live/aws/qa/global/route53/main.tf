module "qa_internal" {
  source = "../../../../../modules/route53"

  hosted_zone_id  = var.hosted_zone_id
  domain_name     = var.domain_name
  www_domain_name = var.www_domain_name
  alias_name      = var.alias_name
  alias_zone_id   = var.alias_zone_id
}
