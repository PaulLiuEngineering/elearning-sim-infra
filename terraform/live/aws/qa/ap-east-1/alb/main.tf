data "aws_route53_zone" "public" {
  name         = "lumio-learning.com"
  private_zone = false
}

module "acm" {
  source = "../../../../../modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = []
  hosted_zone_id            = data.aws_route53_zone.public.zone_id
}

module "alb" {
  source = "../../../../../modules/alb-internal-facing"

  name_prefix         = var.name_prefix
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  allowed_cidr_blocks = var.allowed_cidr_blocks
  certificate_arn     = module.acm.certificate_arn
  tags                = var.tags
}
