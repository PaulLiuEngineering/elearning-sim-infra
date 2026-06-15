#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="/Users/paulliu/elearning-sim-infra/terraform/live/aws"
AUTO_CONFIRM=false
STATE_DIR="$ROOT_DIR/.destroy-qa-prod-state"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

run() {
  log "$*"
  "$@"
}

step_done() {
  local step_name="$1"
  [[ -f "$STATE_DIR/$step_name.done" ]]
}

mark_step_done() {
  local step_name="$1"
  mkdir -p "$STATE_DIR"
  : > "$STATE_DIR/$step_name.done"
}

run_step() {
  local step_name="$1"
  shift

  if step_done "$step_name"; then
    log "Skipping completed step: $step_name"
    return
  fi

  "$@"
  mark_step_done "$step_name"
}

is_missing_resource_error() {
  local output="$1"

  [[ "$output" == *"DBInstanceNotFound"* ]] || \
  [[ "$output" == *"RepositoryNotFoundException"* ]] || \
  [[ "$output" == *"NoSuchBucket"* ]] || \
  [[ "$output" == *"cannot find remote state"* ]] || \
  [[ "$output" == *"Backend initialization required"* ]] || \
  [[ "$output" == *"does not exist"* && "$output" == *"terraform.tfstate"* ]]
}

destroy_stack() {
  local stack_dir="$1"
  local output
  local status

  if [[ ! -f "$stack_dir/terragrunt.hcl" ]]; then
    log "Skipping missing stack directory: $stack_dir"
    return
  fi

  log "bash -lc cd '$stack_dir' && terragrunt destroy -auto-approve"
  set +e
  output="$(bash -lc "cd '$stack_dir' && terragrunt destroy -auto-approve" 2>&1)"
  status=$?
  set -e
  printf '%s\n' "$output"

  if [[ $status -eq 0 ]]; then
    return
  fi

  if is_missing_resource_error "$output"; then
    log "Stack already absent or state missing, skipping: $stack_dir"
    return
  fi

  return $status
}

disable_rds_deletion_protection() {
  local db_identifier="$1"
  local output
  local status

  log "aws rds modify-db-instance --region ap-east-1 --db-instance-identifier $db_identifier --no-deletion-protection --apply-immediately"
  set +e
  output="$(aws rds modify-db-instance \
    --region ap-east-1 \
    --db-instance-identifier "$db_identifier" \
    --no-deletion-protection \
    --apply-immediately 2>&1)"
  status=$?
  set -e
  printf '%s\n' "$output"

  if [[ $status -ne 0 ]]; then
    if is_missing_resource_error "$output"; then
      log "RDS instance already absent, skipping: $db_identifier"
      return
    fi
    return $status
  fi

  run aws rds wait db-instance-available \
    --region ap-east-1 \
    --db-instance-identifier "$db_identifier"
}

delete_ecr_images() {
  local region="$1"
  local repository="$2"
  local tagged_image_ids
  local untagged_image_ids
  local output
  local status

  set +e
  output="$(aws ecr list-images \
    --region "$region" \
    --repository-name "$repository" \
    --query 'imageIds[?imageTag!=null]' \
    --output json 2>&1)"
  status=$?
  set -e

  if [[ $status -ne 0 ]]; then
    if is_missing_resource_error "$output"; then
      log "ECR repository already absent, skipping: $repository ($region)"
      return
    fi
    printf '%s\n' "$output"
    return $status
  fi

  tagged_image_ids="$output"

  if [[ "$tagged_image_ids" != "[]" ]]; then
    run aws ecr batch-delete-image \
      --region "$region" \
      --repository-name "$repository" \
      --image-ids "$tagged_image_ids"
  fi

  while true; do
    set +e
    output="$(aws ecr list-images \
      --region "$region" \
      --repository-name "$repository" \
      --filter tagStatus=UNTAGGED \
      --query 'imageIds[*]' \
      --output json 2>&1)"
    status=$?
    set -e

    if [[ $status -ne 0 ]]; then
      if is_missing_resource_error "$output"; then
        log "ECR repository already absent, skipping: $repository ($region)"
        return
      fi
      printf '%s\n' "$output"
      return $status
    fi

    untagged_image_ids="$output"

    if [[ "$untagged_image_ids" == "[]" ]]; then
      break
    fi

    run aws ecr batch-delete-image \
      --region "$region" \
      --repository-name "$repository" \
      --image-ids "$untagged_image_ids"
  done

  log "ECR repository empty: $repository ($region)"
}

delete_s3_version_batch() {
  local bucket="$1"
  local query="$2"
  local payload
  local status

  set +e
  payload="$(aws s3api list-object-versions \
    --bucket "$bucket" \
    --query "$query" \
    --output json 2>&1)"
  status=$?
  set -e

  if [[ $status -ne 0 ]]; then
    if is_missing_resource_error "$payload"; then
      return 1
    fi
    printf '%s\n' "$payload"
    return $status
  fi

  if [[ "$payload" == '{"Objects":[]}' || "$payload" == '{"Objects":null}' ]]; then
    return 1
  fi

  run aws s3api delete-objects --bucket "$bucket" --delete "$payload"
}

empty_s3_bucket() {
  local bucket="$1"
  local output
  local status

  log "aws s3 rm s3://$bucket --recursive --region ap-east-1"
  set +e
  output="$(aws s3 rm "s3://$bucket" --recursive --region ap-east-1 2>&1)"
  status=$?
  set -e
  printf '%s\n' "$output"

  if [[ $status -ne 0 ]] && ! is_missing_resource_error "$output"; then
    return $status
  fi

  while delete_s3_version_batch "$bucket" '{Objects: Versions[].{Key: Key, VersionId: VersionId}}'; do
    :
  done

  while delete_s3_version_batch "$bucket" '{Objects: DeleteMarkers[].{Key: Key, VersionId: VersionId}}'; do
    :
  done
}

confirm() {
  if [[ "$AUTO_CONFIRM" == true ]]; then
    return
  fi

  cat <<'EOF'
This script will destroy the QA and PROD AWS stacks managed in this repo.
It will:
  - disable RDS deletion protection
  - destroy Terragrunt stacks in dependency order
  - empty S3 buckets, including versioned objects and delete markers
  - delete all images from ECR repositories

Type DESTROY to continue:
EOF

  local reply
  read -r reply
  if [[ "$reply" != "DESTROY" ]]; then
    echo "Aborted."
    exit 1
  fi
}

usage() {
  cat <<'EOF'
Usage: destroy-qa-prod.sh [--yes]

Options:
  --yes    Skip the confirmation prompt.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes)
      AUTO_CONFIRM=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

require_cmd aws
require_cmd terragrunt
require_cmd bash

confirm

run_step "disable-rds-qa" disable_rds_deletion_protection "lumio-learning-qa-hk-postgres"
run_step "disable-rds-prod" disable_rds_deletion_protection "lumio-learning-hk-prod-postgres"

run_step "destroy-prod-global-route53-records" destroy_stack "$ROOT_DIR/prod/global/route53-records"
run_step "destroy-prod-global-route53-qa-internal-delegation" destroy_stack "$ROOT_DIR/prod/global/route53-qa-internal-delegation"

run_step "destroy-qa-global-route53" destroy_stack "$ROOT_DIR/qa/global/route53"
run_step "destroy-qa-ecs-llm-eval-service" destroy_stack "$ROOT_DIR/qa/ap-east-1/ecs-llm-eval-service"
run_step "destroy-qa-ecs-migrate" destroy_stack "$ROOT_DIR/qa/ap-east-1/ecs-migrate"
run_step "destroy-qa-rds" destroy_stack "$ROOT_DIR/qa/ap-east-1/rds"
run_step "destroy-qa-ecs" destroy_stack "$ROOT_DIR/qa/ap-east-1/ecs"
run_step "destroy-qa-alb" destroy_stack "$ROOT_DIR/qa/ap-east-1/alb"
run_step "destroy-qa-bastion-rds" destroy_stack "$ROOT_DIR/qa/ap-east-1/bastion-rds"
run_step "destroy-qa-sqs-llm-eval" destroy_stack "$ROOT_DIR/qa/ap-east-1/sqs-llm-eval"

run_step "destroy-prod-ecs-llm-eval-service" destroy_stack "$ROOT_DIR/prod/ap-east-1/ecs-llm-eval-service"
run_step "destroy-prod-ecs-migrate" destroy_stack "$ROOT_DIR/prod/ap-east-1/ecs-migrate"
run_step "destroy-prod-rds" destroy_stack "$ROOT_DIR/prod/ap-east-1/rds"
run_step "destroy-prod-ecs" destroy_stack "$ROOT_DIR/prod/ap-east-1/ecs"
run_step "destroy-prod-alb" destroy_stack "$ROOT_DIR/prod/ap-east-1/alb"
run_step "destroy-prod-bastion-rds" destroy_stack "$ROOT_DIR/prod/ap-east-1/bastion-rds"
run_step "destroy-prod-sqs-llm-eval" destroy_stack "$ROOT_DIR/prod/ap-east-1/sqs-llm-eval"

run_step "empty-s3-qa" empty_s3_bucket "elearning-sim-hk-qa"
run_step "empty-s3-prod" empty_s3_bucket "elearning-sim-hk-prod"

run_step "empty-ecr-qa" delete_ecr_images "ap-east-1" "elearning-sim-hk-qa-ecr"
run_step "empty-ecr-prod-ap-east-1" delete_ecr_images "ap-east-1" "elearning-sim-hk-ecr"
run_step "empty-ecr-prod-us-east-1" delete_ecr_images "us-east-1" "elearning-sim-us-ecr"

run_step "destroy-qa-s3" destroy_stack "$ROOT_DIR/qa/ap-east-1/s3"
run_step "destroy-qa-ecr" destroy_stack "$ROOT_DIR/qa/ap-east-1/ecr"
run_step "destroy-qa-vpc" destroy_stack "$ROOT_DIR/qa/ap-east-1/vpc"
run_step "destroy-qa-global-route53-zone" destroy_stack "$ROOT_DIR/qa/global/route53-zone"

run_step "destroy-prod-s3" destroy_stack "$ROOT_DIR/prod/ap-east-1/s3"
run_step "destroy-prod-ecr-ap-east-1" destroy_stack "$ROOT_DIR/prod/ap-east-1/ecr"
run_step "destroy-prod-ecr-us-east-1" destroy_stack "$ROOT_DIR/prod/us-east-1/ecr"
run_step "destroy-prod-vpc" destroy_stack "$ROOT_DIR/prod/ap-east-1/vpc"
run_step "destroy-prod-global-route53" destroy_stack "$ROOT_DIR/prod/global/route53"

log "Destroy sequence completed."
