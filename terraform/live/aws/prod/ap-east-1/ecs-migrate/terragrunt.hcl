include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/ecs-fargate-task-definition"
}

dependency "ecs" {
  config_path = "../ecs"

  mock_outputs = {
    execution_role_arn = "arn:aws:iam::000000000000:role/mock-execution"
    task_role_arn      = "arn:aws:iam::000000000000:role/mock-task"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs = {
    repository_url = "000000000000.dkr.ecr.ap-east-1.amazonaws.com/mock"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region            = "ap-east-1"
  task_family           = "lumio-learning-hk-prod-migrate"
  container_name        = "migrate"
  container_image       = "${dependency.ecr.outputs.repository_url}:migrate-latest"
  container_command     = ["npm", "run", "db:migrate"]
  container_environment = {}
  secret_parameter_names = [
    "DATABASE_URL",
  ]
  ssm_parameter_prefix = "/lumio-learning/hk/prod"
  ssm_parameter_region = "ap-east-1"
  execution_role_arn   = dependency.ecs.outputs.execution_role_arn
  task_role_arn        = dependency.ecs.outputs.task_role_arn
  task_cpu             = 512
  task_memory          = 1024
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "ecs-migrate"
  }
}
