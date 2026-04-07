include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/live/aws/prod/ap-east-1/rds"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    private_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "ecs" {
  config_path = "../ecs"

  mock_outputs = {
    security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  private_subnet_ids        = dependency.network.outputs.private_subnet_ids
  allowed_security_group_id = dependency.ecs.outputs.security_group_id
}
