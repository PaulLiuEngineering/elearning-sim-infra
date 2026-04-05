terraform {
  backend "s3" {
    bucket       = "elearning-sim-terraform-state"
    key          = "aws/prod/ap-east-1/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
