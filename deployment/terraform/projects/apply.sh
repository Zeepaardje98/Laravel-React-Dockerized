#!/usr/bin/env bash
set -euo pipefail

# This script applies Terraform for any project under the projects/ folder.
# Usage: ./apply.sh <project-directory-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -ne 1 ]]; then
  echo "[ERROR] Usage: $0 <project-directory-name>"
  echo "        Example: $0 example-project-1"
  exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="${SCRIPT_DIR}/${PROJECT_NAME}"

if [[ ! -d "${PROJECT_DIR}" ]]; then
  echo "[ERROR] Project directory not found: ${PROJECT_DIR}"
  exit 1
fi

cd "${PROJECT_DIR}"

# Paths
# Helper script for common functions
COMMON_SH="${SCRIPT_DIR}/../scripts/common.sh"

# Shared backend.hcl lives two levels up at deployment/terraform/backend.hcl
SHARED_BACKEND_HCL="${SCRIPT_DIR}/../backend.hcl"

# State key unique per project
STATE_KEY="projects/${PROJECT_NAME}/terraform.tfstate"

# AWS credentials file for DigitalOcean Spaces backend
AWS_CREDENTIALS_FILE="${SCRIPT_DIR}/../.aws/credentials"
AWS_PROFILE="digitalocean-spaces"

# Load common helpers
if [[ -f "${COMMON_SH}" ]]; then
  # shellcheck disable=SC1090
  source "${COMMON_SH}"
else
  echo "[ERROR] Common helper not found: ${COMMON_SH}"
  exit 1
fi

if check_aws_credentials "${AWS_CREDENTIALS_FILE}" "${AWS_PROFILE}"; then
  echo "[INFO] Terraform init attempt with remote state (uses backend)"

  # Validate shared backend file exists
  if [[ ! -f "${SHARED_BACKEND_HCL}" ]]; then
    echo "[ERROR] Backend file not found: ${SHARED_BACKEND_HCL}"
    exit 1
  fi

  # Export Spaces credentials location for Terraform backend
  export AWS_PROFILE
  export AWS_SHARED_CREDENTIALS_FILE="${AWS_CREDENTIALS_FILE}"

  if ! terraform init -backend-config="${SHARED_BACKEND_HCL}" -backend-config="key=${STATE_KEY}"; then
      echo "[WARNING] Terraform init with remote state failed, exiting."
      exit 1
  else
      echo "[INFO] Terraform init with remote state successful."
  fi
fi

terraform_plan_show_apply ".tfplan.local"


