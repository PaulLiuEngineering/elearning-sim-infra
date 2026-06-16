include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/vpc"
}

inputs = {
  aws_region                 = "ap-east-1"
  name_prefix                = "nexa-learning-qa-hk"
  cidr_block                 = "172.32.0.0/16"
  public_availability_zones  = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
  public_subnet_cidrs        = ["172.32.0.0/20", "172.32.16.0/20", "172.32.32.0/20"]
  private_availability_zones = ["ap-east-1a", "ap-east-1b"]
  private_subnet_cidrs       = ["172.32.48.0/20", "172.32.64.0/20"]
  tags = {
    cloud       = "aws"
    environment = "qa"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "vpc"
  }
}
