terraform {
  backend "s3" {
    bucket       = "elearning-sim-terraform-state"
    key          = "aws/prod/us-east-1/ecr/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
