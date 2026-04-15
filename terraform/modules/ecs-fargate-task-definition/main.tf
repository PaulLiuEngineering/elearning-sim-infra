data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  secret_region       = coalesce(var.ssm_parameter_region, data.aws_region.current.name)
  normalized_ssm_path = var.ssm_parameter_prefix == null ? null : "/${trim(var.ssm_parameter_prefix, "/")}"

  container_environment = [
    for name, value in var.container_environment : {
      name  = name
      value = value
    }
  ]

  container_secrets = [
    for name in var.secret_parameter_names : {
      name      = name
      valueFrom = "arn:aws:ssm:${local.secret_region}:${data.aws_caller_identity.current.account_id}:parameter${local.normalized_ssm_path}/${name}"
    }
  ]

  container_definition = merge(
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
        }
      }
    },
    length(var.container_command) > 0 ? { command = var.container_command } : {},
    length(local.container_environment) > 0 ? { environment = local.container_environment } : {},
    length(local.container_secrets) > 0 ? { secrets = local.container_secrets } : {}
  )
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = coalesce(var.log_group_name, "/ecs/${var.task_family}")
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, {
    Name = "${var.task_family}-logs"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = jsonencode([local.container_definition])

  lifecycle {
    precondition {
      condition     = length(var.secret_parameter_names) == 0 || var.ssm_parameter_prefix != null
      error_message = "Set ssm_parameter_prefix when secret_parameter_names are configured."
    }
  }

  tags = merge(var.tags, {
    Name = var.task_family
  })
}
