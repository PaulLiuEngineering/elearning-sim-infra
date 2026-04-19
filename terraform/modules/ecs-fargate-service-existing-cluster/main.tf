module "task_definition" {
  source = "../ecs-fargate-task-definition"

  aws_region             = var.aws_region
  task_family            = var.task_family
  container_name         = var.container_name
  container_image        = var.container_image
  container_command      = var.container_command
  container_environment  = var.container_environment
  secret_parameter_names = var.secret_parameter_names
  ssm_parameter_prefix   = var.ssm_parameter_prefix
  ssm_parameter_region   = var.ssm_parameter_region
  execution_role_arn     = var.execution_role_arn
  task_role_arn          = var.task_role_arn
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory
  log_retention_in_days  = var.log_retention_in_days
  tags                   = var.tags
}

resource "aws_ecs_service" "this" {
  name                   = var.service_name
  cluster                = var.cluster_arn
  task_definition        = module.task_definition.task_definition_arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true
  wait_for_steady_state  = false

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = var.security_group_ids
    subnets          = var.subnet_ids
  }

  tags = merge(var.tags, {
    Name = var.service_name
  })
}
