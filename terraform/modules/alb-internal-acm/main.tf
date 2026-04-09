data "aws_ssm_parameter" "allowed_cidr_blocks" {
  for_each = toset(var.allowed_cidr_block_ssm_parameter_names)

  name            = each.value
  with_decryption = false
}

locals {
  effective_allowed_cidr_blocks = length(var.allowed_cidr_block_ssm_parameter_names) > 0 ? sort(distinct(compact([for parameter in data.aws_ssm_parameter.allowed_cidr_blocks : trimspace(parameter.value)]))) : var.allowed_cidr_blocks
}

module "acm" {
  source = "../acm"

  domain_name               = var.domain_name
  subject_alternative_names = []
  hosted_zone_id            = var.hosted_zone_id
}

module "alb" {
  source = "../alb-internal-facing"

  name_prefix         = var.name_prefix
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  allowed_cidr_blocks = local.effective_allowed_cidr_blocks
  certificate_arn     = module.acm.certificate_arn
  tags                = var.tags
}
