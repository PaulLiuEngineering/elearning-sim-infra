# Bootstrap

`bootstrap/` documents infrastructure that must exist before `terraform/live`
can use the shared backend and CI role.

These resources are intentionally not managed by Terraform in this repository.
They are created and maintained manually.

Current AWS bootstrap requirements:

- S3 bucket `elearning-sim-terraform-state` in `us-east-1`
- DynamoDB table `elearning-sim-terraform-locks` in `us-east-1`
- IAM OIDC provider `token.actions.githubusercontent.com`
- IAM role `elearning-sim-terraform-oidc-github`

See [aws/README.md](/Users/paul/elearning-sim-infra/terraform/bootstrap/aws/README.md) for the expected configuration.
