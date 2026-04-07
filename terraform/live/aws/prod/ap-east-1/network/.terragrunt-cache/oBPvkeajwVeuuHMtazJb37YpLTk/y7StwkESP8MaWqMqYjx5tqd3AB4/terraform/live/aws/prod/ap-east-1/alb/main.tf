moved {
  from = aws_acm_certificate.this
  to   = module.acm.aws_acm_certificate.this
}

moved {
  from = aws_route53_record.certificate_validation
  to   = module.acm.aws_route53_record.certificate_validation
}

moved {
  from = aws_acm_certificate_validation.this
  to   = module.acm.aws_acm_certificate_validation.this[0]
}

moved {
  from = aws_security_group.alb
  to   = module.alb.aws_security_group.alb
}

moved {
  from = aws_lb.this
  to   = module.alb.aws_lb.this
}

moved {
  from = aws_lb_target_group.placeholder
  to   = module.alb.aws_lb_target_group.placeholder
}

moved {
  from = aws_lb_listener.http
  to   = module.alb.aws_lb_listener.http
}

moved {
  from = aws_lb_listener.https
  to   = module.alb.aws_lb_listener.https
}

moved {
  from = aws_route53_record.apex
  to   = module.route53.aws_route53_record.apex
}

moved {
  from = aws_route53_record.www
  to   = module.route53.aws_route53_record.www
}

module "acm" {
  source = "../../../../../modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = [var.www_domain_name]
  hosted_zone_id            = var.hosted_zone_id
}

module "acm_cn" {
  source = "../../../../../modules/acm"

  domain_name                       = var.cn_domain_name
  subject_alternative_names         = [var.cn_www_domain_name]
  create_route53_validation_records = false
  wait_for_validation               = false
}

module "alb" {
  source = "../../../../../modules/alb"

  vpc_id                        = var.vpc_id
  subnet_ids                    = var.subnet_ids
  placeholder_target_group_port = var.placeholder_target_group_port
  fixed_response_message_body   = var.fixed_response_message_body
  certificate_arn               = module.acm.certificate_arn
  tags                          = var.tags
}

resource "aws_lb_listener_certificate" "cn" {
  count = var.attach_cn_certificate ? 1 : 0

  listener_arn    = module.alb.https_listener_arn
  certificate_arn = module.acm_cn.requested_certificate_arn
}

module "route53" {
  source = "../../../../../modules/route53"

  hosted_zone_id  = var.hosted_zone_id
  domain_name     = var.domain_name
  www_domain_name = var.www_domain_name
  alias_name      = module.alb.alb_dns_name
  alias_zone_id   = module.alb.alb_zone_id
}
