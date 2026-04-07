variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Name of the production ECR repository."
  type        = string
  default     = "elearning-sim-us-ecr"
}

variable "image_tag_mutability" {
  description = "Whether existing image tags can be overwritten."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable vulnerability scanning on image push."
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "Optional lifecycle policy JSON. Null uses the default policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags for this stack."
  type        = map(string)
  default = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "us-east-1"
    stack       = "ecr"
  }
}
