variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "ap-east-1"
}

variable "bucket_name" {
  description = "Name of the production S3 bucket in Hong Kong."
  type        = string
  default     = "elearning-sim-hk-prod"
}

variable "attach_https_only_bucket_policy" {
  description = "Attach an example bucket policy that denies non-TLS requests."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "s3"
  }
}
