locals {
  dead_letter_queue_name = "${var.queue_name}-dlq"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn
    maxReceiveCount     = var.redrive_policy.max_receive_count
  })
}

resource "aws_sqs_queue" "dead_letter" {
  name                       = local.dead_letter_queue_name
  message_retention_seconds  = var.message_retention_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  tags = var.tags
}

resource "aws_sqs_queue" "this" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  redrive_policy             = local.redrive_policy
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled

  tags = var.tags
}

resource "aws_ssm_parameter" "queue_url" {
  count = var.queue_url_ssm_parameter_name == null ? 0 : 1

  name  = var.queue_url_ssm_parameter_name
  type  = "String"
  value = aws_sqs_queue.this.url
  tags  = var.tags
}
