include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//terraform/modules/s3"
}

inputs = {
  aws_region         = "ap-east-1"
  bucket_name        = "elearning-sim-hk-prod"
  versioning_enabled = true
  sse_algorithm      = "AES256"
  tags = {
    cloud       = "aws"
    environment = "prod"
    managed_by  = "terraform"
    region      = "ap-east-1"
    stack       = "s3"
  }
}
