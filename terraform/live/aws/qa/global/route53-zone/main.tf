module "this" {
  source = "../../../../../modules/route53-zone"

  domain_name = var.domain_name
  tags        = var.tags
}
