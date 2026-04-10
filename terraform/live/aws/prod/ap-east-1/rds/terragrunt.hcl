include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/rds-postgres-ssm"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "ecs" {
  config_path = "../ecs"

  mock_outputs = {
    security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "bastion" {
  config_path = "../bastion-rds"

  mock_outputs = {
    security_group_id = "sg-00000000000000002"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region                     = "ap-east-1"
  name_prefix                    = "lumio-learning-hk-prod"
  vpc_id                         = dependency.vpc.outputs.vpc_id
  subnet_ids                     = dependency.vpc.outputs.private_subnet_ids
  allowed_security_group_id      = dependency.ecs.outputs.security_group_id
  allowed_security_group_ids     = [dependency.bastion.outputs.security_group_id]
  db_name                        = "elearningsim"
  username                       = "elearning_sim_db_admin"
  engine_version                 = "17.8"
  instance_class                 = "db.t4g.micro"
  backup_retention_period        = 7
  backup_window                  = "18:00-19:00"
  deletion_protection            = true
  db_address_ssm_parameter_name  = "/lumio-learning/hk/prod/DB_ADDRESS"
  db_username_ssm_parameter_name = "/lumio-learning/hk/prod/DB_USERNAME"
  db_password_ssm_parameter_name = "/lumio-learning/hk/prod/DB_PASSWORD"
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "rds"
  }
}
