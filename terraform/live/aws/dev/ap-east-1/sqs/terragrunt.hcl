include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/sqs"
}

inputs = {
  aws_region                 = "ap-east-1"
  queue_name                 = "assessment-llm-evaluation-dev"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  redrive_policy = {
    max_receive_count = 5
  }
  sqs_managed_sse_enabled = true
  tags = {
    cloud       = "aws"
    environment = "dev"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "sqs"
    service     = "assessment-llm-evaluation"
  }
}
