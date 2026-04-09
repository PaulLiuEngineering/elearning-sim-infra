include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/alb-internal-acm"
}

dependency "dns_zone" {
  config_path = "../../global/route53-zone"

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
    public_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region          = "ap-east-1"
  name_prefix         = "lumio-learning-qa-hk"
  domain_name         = "qa-internal.lumio-learning.com"
  hosted_zone_id      = dependency.dns_zone.outputs.hosted_zone_id
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnet_ids          = dependency.vpc.outputs.public_subnet_ids
  allowed_cidr_blocks = ["71.251.203.226/32"]
  tags = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "alb"
  }
}
