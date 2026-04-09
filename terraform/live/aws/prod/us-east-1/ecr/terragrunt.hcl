include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/ecr-repository"
}

inputs = {
  aws_region           = "us-east-1"
  repository_name      = "elearning-sim-us-ecr"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "us-east-1"
    stack       = "ecr"
  }
}
