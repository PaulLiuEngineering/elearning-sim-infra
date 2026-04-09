# elearning-sim-infra

Terraform infrastructure repository for `elearning-sim`.

Current scope:

- live AWS infrastructure in `terraform/live/aws/*`
- reusable modules for AWS resources in `terraform/modules/*`
- GitHub Actions workflow using OIDC for Terraform plan on PRs to `main` and
  apply on pushes to `main`

The layout is intentionally prepared for future AWS regional expansion and
additional cloud providers such as Aliyun.
