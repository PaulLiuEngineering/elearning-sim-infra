include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/vpc"
}

inputs = {
  aws_region                 = "ap-east-1"
  name_prefix                = "lumio-learning-hk-prod"
  cidr_block                 = "172.33.0.0/16"
  public_availability_zones  = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
  public_subnet_cidrs        = ["172.33.0.0/20", "172.33.16.0/20", "172.33.32.0/20"]
  private_availability_zones = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
  private_subnet_cidrs       = ["172.33.48.0/20", "172.33.64.0/20", "172.33.80.0/20"]
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "vpc"
  }
}
