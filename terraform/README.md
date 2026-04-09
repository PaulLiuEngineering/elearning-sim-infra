# Terraform Layout

This repository is structured to support multiple cloud providers and multiple
environments over time, with live AWS infrastructure currently spanning
`prod` and `qa` stacks.

## Layout

- `bootstrap/`: manual backend and CI/OIDC prerequisites
- `modules/`: reusable Terraform modules
- `live/`: provider and environment specific Terragrunt stacks only

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
- additional AWS regions beyond `us-east-1` and `ap-east-1`
- additional cloud providers such as Aliyun
