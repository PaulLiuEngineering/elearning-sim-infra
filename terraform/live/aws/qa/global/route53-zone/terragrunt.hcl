include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/route53-zone"
}

inputs = {
  aws_region  = "us-east-1"
  domain_name = "qa-internal.lumio-learning.com"
  tags = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "global"
    stack       = "route53-zone"
  }
}
