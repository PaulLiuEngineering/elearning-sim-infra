terraform {
  backend "s3" {
    bucket       = "elearning-sim-terraform-state"
    key          = "aws/prod/global/route53/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
