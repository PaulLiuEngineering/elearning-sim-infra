variable "aws_region" {
  description = "AWS region for the root module provider."
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether existing image tags can be overwritten."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable vulnerability scanning on image push."
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "Optional lifecycle policy JSON. When null, the default lifecycle policy can be used."
  type        = string
  default     = null
}

variable "enable_default_lifecycle_policy" {
  description = "Whether to attach the built-in default lifecycle policy when lifecycle_policy is null."
  type        = bool
  default     = true
}

variable "lifecycle_tag_prefixes" {
  description = "Tag prefixes retained by the default lifecycle policy."
  type        = list(string)
  default     = ["v", "release", "prod"]
}

variable "tagged_image_retention_count" {
  description = "How many tagged images to retain in the default lifecycle policy."
  type        = number
  default     = 30
}

variable "untagged_image_expiration_days" {
  description = "How many days to retain untagged images in the default lifecycle policy."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags applied to the ECR repository."
  type        = map(string)
  default     = {}
}
