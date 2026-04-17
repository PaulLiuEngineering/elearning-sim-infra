include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/sqs"
}

inputs = {
  aws_region                   = "ap-east-1"
  queue_name                   = "assessment-llm-evaluation-prod"
  visibility_timeout_seconds   = 30
  message_retention_seconds    = 345600
  receive_wait_time_seconds    = 0
  queue_url_ssm_parameter_name = "/lumio-learning/hk/prod/ASSESSMENT_LLM_EVALUATION_SQS_QUEUE_URL"
  redrive_policy = {
    max_receive_count = 5
  }
  sqs_managed_sse_enabled = true
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "sqs-llm-eval"
    service     = "assessment-llm-evaluation"
  }
}
