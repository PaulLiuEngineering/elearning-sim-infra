include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/ec2-bastion"
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
  aws_region  = "ap-east-1"
  name_prefix = "lumio-learning-hk-prod"
  vpc_id      = dependency.vpc.outputs.vpc_id
  subnet_id   = dependency.vpc.outputs.public_subnet_ids[0]
  key_name    = "rds-bastion-host-prod"
  ami_id      = "ami-08944d7bb6589fc80"
  allowed_cidr_block_ssm_parameter_names = [
    "/lumio-learning/hk/prod/alb-allowlist/paulliu",
  ]
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "bastion"
  }
}
