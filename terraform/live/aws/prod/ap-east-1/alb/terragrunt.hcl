include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/alb-public-acm"
}

dependency "dns_zone" {
  config_path = "../../global/route53"

  mock_outputs = {
    hosted_zone_id = "Z0000000000000000"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000000000000"
    public_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region                    = "ap-east-1"
  domain_name                   = "lumio-learning.com"
  www_domain_name               = "www.lumio-learning.com"
  hosted_zone_id                = dependency.dns_zone.outputs.hosted_zone_id
  request_secondary_certificate = true
  attach_secondary_certificate  = false
  secondary_domain_name         = "lumio-learning.cn"
  secondary_www_domain_name     = "www.lumio-learning.cn"
  alb_name                      = "lumio-learning-prod-alb"
  security_group_description    = "Security group for the Lumio Learning production ALB"
  target_group_name             = "lumio-learning-prod-tg-v2"
  target_group_tag_name         = "lumio-learning-prod-placeholder-tg-v2"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  subnet_ids                    = dependency.vpc.outputs.public_subnet_ids
  placeholder_target_group_port = 80
  fixed_response_message_body   = "Lumio Learning is coming soon."
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "alb"
  }
}
