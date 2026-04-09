include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/route53-ns-delegation"
}

dependency "parent_zone" {
  config_path = "../route53"

  mock_outputs = {
    hosted_zone_id = "Z0000000000000000"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "qa_zone" {
  config_path = "../../../qa/global/route53-zone"

  mock_outputs = {
    hosted_zone_name_servers = [
      "ns-000.awsdns-00.com",
      "ns-000.awsdns-00.net",
      "ns-000.awsdns-00.org",
      "ns-000.awsdns-00.co.uk",
    ]
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region            = "us-east-1"
  parent_hosted_zone_id = dependency.parent_zone.outputs.hosted_zone_id
  subdomain_name        = "qa-internal.lumio-learning.com"
  name_servers          = dependency.qa_zone.outputs.hosted_zone_name_servers
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53-qa-internal-delegation"
  }
}
