# AWS Bootstrap

This directory is documentation only. The AWS bootstrap resources are manual
prerequisites and are not managed by Terraform in this repository.

## Required Resources

### Terraform Backend

- S3 bucket name: `elearning-sim-terraform-state`
- Region: `us-east-1`
- Versioning: enabled
- Server-side encryption: `AES256`
- Public access block: fully enabled

### Terraform Locking

- DynamoDB table name: `elearning-sim-terraform-locks`
- Region: `us-east-1`
- Billing mode: `PAY_PER_REQUEST`
- Partition key: `LockID` (`String`)

### GitHub Actions OIDC

- OIDC provider URL: `https://token.actions.githubusercontent.com`
- Client ID / audience: `sts.amazonaws.com`

### GitHub Actions IAM Role

- Role name: `elearning-sim-terraform-oidc-github`
- Trusted provider: `token.actions.githubusercontent.com`
- Allowed subjects:
  - `repo:PaulLiuEngineering/elearning-sim-infra:ref:refs/heads/main`
  - `repo:PaulLiuEngineering/elearning-sim-infra:ref:refs/heads/feature`
  - `repo:PaulLiuEngineering/elearning-sim-infra:pull_request`

## Notes

- `terraform/live/root.hcl` assumes the backend bucket and lock table above
  already exist.
- GitHub Actions assumes the OIDC provider and IAM role above already exist.
- If any of these names change, update `terraform/live/root.hcl`,
  `stack-metadata.json`, and the workflow/role wiring to match.
