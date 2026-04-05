# Terraform Layout

This repository is structured to support multiple cloud providers and multiple
environments over time, while keeping only `aws/prod/us-east-1/ecr` live for
now.

## Layout

- `modules/`: reusable Terraform modules
- `live/`: provider and environment specific root modules

Current live stack:

- `live/aws/prod/us-east-1/ecr`

## Stack Metadata

Each runnable stack under `live/` should include a `stack-metadata.json` file
for CI/CD metadata that is not part of the Terraform configuration itself.

Use `stack-metadata.example.json` as the template when creating a new live
stack.

Current metadata fields:

- `provider`: cloud provider name such as `aws`
- `region`: deployment region such as `us-east-1`
- `github_environment`: GitHub environment name such as `prod`
- `role_arn`: OIDC role ARN used by GitHub Actions

Planned expansion:

- additional AWS regional stacks such as `eks`, `db`, and `s3`
- additional AWS regions such as `ap-east-1`
- additional cloud providers such as Aliyun
