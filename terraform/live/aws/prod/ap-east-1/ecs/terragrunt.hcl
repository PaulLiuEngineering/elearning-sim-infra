include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/ecs-fargate-service"
}

dependencies {
  paths = ["../sqs-llm-eval"]
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    target_group_arn = "arn:aws:elasticloadbalancing:ap-east-1:000000000000:targetgroup/mock/0000000000000000"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000000000000"
    vpc_cidr_block    = "10.0.0.0/16"
    public_subnet_ids = ["subnet-00000000000000001", "subnet-00000000000000002"]
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

dependency "s3" {
  config_path = "../s3"

  mock_outputs = {
    bucket_arn = "arn:aws:s3:::elearning-sim-hk-prod"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "sqs_llm_eval" {
  config_path = "../sqs-llm-eval"

  mock_outputs = {
    queue_arn = "arn:aws:sqs:ap-east-1:000000000000:assessment-llm-evaluation-prod"
  }
  mock_outputs_merge_strategy_with_state  = "shallow"
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  aws_region            = "ap-east-1"
  name_prefix           = "lumio-learning-hk-prod"
  vpc_id                = dependency.vpc.outputs.vpc_id
  subnet_ids            = dependency.vpc.outputs.public_subnet_ids
  ingress_cidr_blocks   = [dependency.vpc.outputs.vpc_cidr_block]
  target_group_arn      = dependency.alb.outputs.target_group_arn
  container_image       = "${dependency.ecr.outputs.repository_url}:latest"
  app_bucket_arn        = dependency.s3.outputs.bucket_arn
  sqs_queue_arns        = [dependency.sqs_llm_eval.outputs.queue_arn]
  task_family           = "lumio-learning-hk-prod"
  service_name          = "lumio-learning-hk-prod-service"
  create_service        = true
  container_name        = "app"
  container_environment = {}
  secret_parameter_names = [
    "ASSESSMENT_CONTENT_S3_BUCKET_ARN",
    "ASSESSMENT_LLM_EVALUATION_SQS_QUEUE_URL",
    "ASSESSMENT_EXPLAIN_ENABLED",
    "AWS_REGION",
    "AWS_ROLE_ARN",
    "DATABASE_DRIVER",
    "DB_POOL_MAX",
    "ELEVENLABS_DEFAULT_VOICE_ID",
    "ELEVENLABS_DIALECT_VOICE_MAP",
    "ELEVENLABS_STT_MODEL",
    "ELEVENLABS_TTS_MODEL",
    "ELEVENLABS_TTS_OUTPUT_FORMAT",
    "LLM_PROVIDER",
    "LOG_LEVEL",
    "NANOGPT_IMAGE_MODEL",
    "NANOGPT_IMAGE_TIMEOUT_MS",
    "NANOGPT_MODEL",
    "NANOGPT_TIMEOUT_MS",
    "NEXT_PUBLIC_ASSESSMENT_EXPLAIN_ENABLED",
    "NEXT_PUBLIC_ASSESSMENT_REUSE_CURRENT_QUESTION",
    "NEXT_PUBLIC_WORKOS_REDIRECT_URI",
    "APP_BASE_URL",
    "WORKOS_DEFAULT_ORGANIZATION_ID",
    "WORKOS_REDIRECT_URI",
    "DATABASE_URL",
    "ELEVENLABS_API_KEY",
    "WORKOS_API_KEY",
    "WORKOS_CLIENT_ID",
    "WORKOS_COOKIE_PASSWORD",
    "NANOGPT_API_KEY",
  ]
  ssm_parameter_prefix              = "/lumio-learning/hk/prod"
  ssm_parameter_region              = "ap-east-1"
  container_port                    = 3000
  task_cpu                          = 512
  task_memory                       = 1024
  desired_count                     = 4
  autoscaling_min_capacity          = 4
  autoscaling_max_capacity          = 8
  assign_public_ip                  = true
  health_check_grace_period_seconds = 60
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "ecs"
  }
}
