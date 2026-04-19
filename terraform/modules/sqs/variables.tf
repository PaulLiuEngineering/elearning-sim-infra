variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "queue_name" {
  description = "Name of the SQS queue. The dead-letter queue name is derived from this value."
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout for messages in seconds."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "How long SQS retains messages in seconds."
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Long polling wait time in seconds."
  type        = number
  default     = 0
}

variable "redrive_policy" {
  description = "Dead-letter queue redrive policy configuration."
  type = object({
    max_receive_count = number
  })
  default = {
    max_receive_count = 5
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Enable SQS managed server-side encryption."
  type        = bool
  default     = true
}

variable "queue_url_ssm_parameter_name" {
  description = "SSM parameter name that stores the SQS queue URL."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the SQS queues."
  type        = map(string)
  default     = {}
}
