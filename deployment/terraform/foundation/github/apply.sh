#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

# Paths
# Shared backend.hcl lives two levels up at deployment/terraform/backend.hcl
SHARED_BACKEND_HCL="${ROOT_DIR}/../../backend.hcl"

# State key for this stack (unique per deployment)
STATE_KEY="foundation/github/terraform.tfstate"

# AWS credentials file for DigitalOcean Spaces backend
AWS_CREDENTIALS_FILE="${ROOT_DIR}/../../.aws/credentials"
AWS_PROFILE="digitalocean-spaces"

# Check if AWS credentials exist for DigitalOcean Spaces
aws_credentials_exist() {
  echo "[INFO] Checking if AWS credentials exist with DigitalOcean Spaces profile."
  
  if [[ -f "${AWS_CREDENTIALS_FILE}" ]]; then
    # Check if [digitalocean-spaces] profile exists
    if grep -q "\[${AWS_PROFILE}\]" "${AWS_CREDENTIALS_FILE}"; then
      echo "[SUCCESS] Found AWS credentials file with DigitalOcean Spaces profile."
      return 0
    else
      echo "[WARNING] AWS credentials file found, but does not have DigitalOcean Spaces profile."
    fi
  else
    echo "[WARNING] AWS credentials file not found: ${AWS_CREDENTIALS_FILE}"
  fi

  return 1
}

if aws_credentials_exist; then
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

# Terraform plan
echo "[INFO] Terraform plan"
PLAN_FILE_LOCAL=".tfplan.local"
terraform plan -out "${PLAN_FILE_LOCAL}" >/dev/null

# Terraform show
echo "[INFO] Terraform showing plan preview."
terraform show "${PLAN_FILE_LOCAL}" || true

# Terraform apply (asks for permission)
read -r -p "Proceed with apply using this plan? [y/N] " CONFIRM
case "${CONFIRM}" in
  y|Y|yes|YES)
    terraform apply "${PLAN_FILE_LOCAL}"
    ;;
  *)
    echo "[INFO] Aborting by user choice."
    exit 0
    ;;
esac

