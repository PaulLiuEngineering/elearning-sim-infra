locals {
  default_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the most recent tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release", "prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Expire untagged images after 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  image_tag_mutability = "MUTABLE"
}

module "ecr" {
  source = "../../../../../modules/ecr"

  repository_name      = var.repository_name
  image_tag_mutability = local.image_tag_mutability
  scan_on_push         = var.scan_on_push
  lifecycle_policy     = var.lifecycle_policy != null ? var.lifecycle_policy : local.default_lifecycle_policy
  tags                 = var.tags
}
