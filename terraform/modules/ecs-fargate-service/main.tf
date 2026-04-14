data "aws_iam_policy_document" "task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  task_family         = coalesce(var.task_family, var.name_prefix)
  service_name        = coalesce(var.service_name, "${var.name_prefix}-service")
  secret_region       = coalesce(var.ssm_parameter_region, data.aws_region.current.name)
  normalized_ssm_path = var.ssm_parameter_prefix == null ? null : "/${trim(var.ssm_parameter_prefix, "/")}"
  autoscaling_enabled = var.create_service && var.autoscaling_max_capacity != null

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
      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
        }
      }
    },
    length(local.container_environment) > 0 ? { environment = local.container_environment } : {},
    length(local.container_secrets) > 0 ? { secrets = local.container_secrets } : {}
  )
}

data "aws_iam_policy_document" "task_s3_access" {
  statement {
    sid = "AllowBucketListing"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [var.app_bucket_arn]
  }

  statement {
    sid = "AllowObjectReadWrite"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = ["${var.app_bucket_arn}/*"]
  }
}

resource "aws_security_group" "ecs_service" {
  name        = "${var.name_prefix}-ecs"
  description = "Security group for the ${var.name_prefix} ECS service"
  vpc_id      = var.vpc_id

  lifecycle {
    precondition {
      condition     = var.alb_security_group_id != null || length(var.ingress_cidr_blocks) > 0
      error_message = "Set alb_security_group_id or ingress_cidr_blocks for ECS ingress."
    }
  }

  dynamic "ingress" {
    for_each = var.alb_security_group_id != null ? [var.alb_security_group_id] : []

    content {
      description     = "Allow ALB traffic"
      from_port       = var.container_port
      to_port         = var.container_port
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = length(var.ingress_cidr_blocks) > 0 ? [var.ingress_cidr_blocks] : []

    content {
      description = "Allow ECS ingress from configured CIDR blocks"
      from_port   = var.container_port
      to_port     = var.container_port
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs"
  })
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs"
  })
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.task_family}"
  retention_in_days = var.log_retention_in_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-logs"
  })
}

resource "aws_iam_role" "task" {
  name               = "${var.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-task-role"
  })
}

resource "aws_iam_role" "execution" {
  name               = "${var.name_prefix}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-execution-role"
  })
}

resource "aws_iam_role_policy" "task_s3_access" {
  name   = "${var.name_prefix}-task-s3-access"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_s3_access.json
}

resource "aws_iam_role_policy_attachment" "execution_ecs_task" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "execution_ssm_get_parameters" {
  statement {
    sid = "AllowGetParameters"

    actions = [
      "ssm:GetParameters"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "execution_ssm_get_parameters" {
  name   = "${var.name_prefix}-execution-ssm-get-parameters"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.execution_ssm_get_parameters.json
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn
  container_definitions    = jsonencode([local.container_definition])

  lifecycle {
    precondition {
      condition     = length(var.secret_parameter_names) == 0 || var.ssm_parameter_prefix != null
      error_message = "Set ssm_parameter_prefix when secret_parameter_names are configured."
    }
  }

  tags = merge(var.tags, {
    Name = local.task_family
  })
}

resource "aws_ecs_service" "this" {
  count                             = var.create_service ? 1 : 0
  name                              = local.service_name
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  enable_execute_command            = true
  wait_for_steady_state             = false

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.ecs_service.id]
    subnets          = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = merge(var.tags, {
    Name = local.service_name
  })
}

resource "aws_appautoscaling_target" "ecs_service" {
  count = local.autoscaling_enabled ? 1 : 0

  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = coalesce(var.autoscaling_min_capacity, var.desired_count)
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_service_cpu" {
  count = local.autoscaling_enabled ? 1 : 0

  name               = "${local.service_name}-cpu-target"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling_cpu_target_value
  }
}
