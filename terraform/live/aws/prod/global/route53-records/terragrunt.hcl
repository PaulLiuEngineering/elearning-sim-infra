include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/route53"
}

dependency "dns_zone" {
  config_path = "../route53"

  mock_outputs = {
    hosted_zone_id = "Z0000000000000000"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "alb" {
  config_path = "../../ap-east-1/alb"

  mock_outputs = {
    alb_dns_name = "lumio-learning-prod-alb-000000.ap-east-1.elb.amazonaws.com"
    alb_zone_id  = "Z0000000000000"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region      = "us-east-1"
  domain_name     = "lumio-learning.com"
  www_domain_name = "www.lumio-learning.com"
  hosted_zone_id  = dependency.dns_zone.outputs.hosted_zone_id
  alias_name      = dependency.alb.outputs.alb_dns_name
  alias_zone_id   = dependency.alb.outputs.alb_zone_id
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53-records"
  }
}
