locals {
  aws_provider_version    = "~> 5.0"
  random_provider_version = "~> 3.0"
  terraform_version       = ">= 1.5.0"
}

remote_state {
  backend = "s3"

  config = {
    bucket         = "elearning-sim-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "elearning-sim-terraform-locks"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "${local.terraform_version}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.aws_provider_version}"
    }
    random = {
      source  = "hashicorp/random"
      version = "${local.random_provider_version}"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}
EOF
}
