# elearning-sim-infra

Terraform infrastructure repository for `elearning-sim`.

Current scope:

- live AWS infrastructure only in `terraform/live/aws/prod/us-east-1/ecr`
- reusable Terraform module for ECR in `terraform/modules/ecr`
- GitHub Actions workflow using OIDC for Terraform plan on PRs to `main` and
  apply on pushes to `main`

The layout is intentionally prepared for future AWS regional expansion and
additional cloud providers such as Aliyun.