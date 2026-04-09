locals {
  secondary_certificate_requested = var.request_secondary_certificate || var.attach_secondary_certificate
}

module "acm" {
  source = "../acm"

  domain_name               = var.domain_name
  subject_alternative_names = [var.www_domain_name]
  hosted_zone_id            = var.hosted_zone_id
}

module "secondary_acm" {
  count  = local.secondary_certificate_requested ? 1 : 0
  source = "../acm"

  domain_name                       = var.secondary_domain_name
  subject_alternative_names         = [var.secondary_www_domain_name]
  create_route53_validation_records = var.secondary_create_route53_validation_records
  wait_for_validation               = var.secondary_wait_for_validation
}

module "alb" {
  source = "../alb"

  alb_name                      = var.alb_name
  security_group_description    = var.security_group_description
  target_group_name             = var.target_group_name
  target_group_tag_name         = var.target_group_tag_name
  vpc_id                        = var.vpc_id
  subnet_ids                    = var.subnet_ids
  placeholder_target_group_port = var.placeholder_target_group_port
  fixed_response_message_body   = var.fixed_response_message_body
  certificate_arn               = module.acm.certificate_arn
  tags                          = var.tags
}

resource "aws_lb_listener_certificate" "secondary" {
  count = var.attach_secondary_certificate ? 1 : 0

  listener_arn    = module.alb.https_listener_arn
  certificate_arn = module.secondary_acm[0].requested_certificate_arn
}
