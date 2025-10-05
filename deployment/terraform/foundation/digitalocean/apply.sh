#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

# Paths
# Shared backend.hcl lives two levels up at deployment/terraform/backend.hcl
SHARED_BACKEND_HCL="${ROOT_DIR}/../../backend.hcl"

# State key for this stack (unique per deployment)
STATE_KEY="foundation/digitalocean/terraform.tfstate"

# Backend file that can be toggled for local vs remote state
BACKEND_FILE="backend.tf"

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

# Terraform init with remote state storage, or local state if remote state is not set up correctly.
USE_LOCAL_STATE=false
if aws_credentials_exist; then
  echo "[INFO] Terraform init attempt with remote state (uses backend)"

  # Validate shared backend file exists
  if [[ ! -f "${SHARED_BACKEND_HCL}" ]]; then
    echo "[ERROR] Backend file not found: ${SHARED_BACKEND_HCL}"
    exit 1
  fi

  # Set AWS profile and credentials file for Terraform S3 backend to use
  export AWS_PROFILE
  export AWS_SHARED_CREDENTIALS_FILE="${AWS_CREDENTIALS_FILE}"

  # Ensure backend file is present (restore if previously disabled)
  if [[ -f ${BACKEND_FILE}.disabled ]]; then mv "${BACKEND_FILE}.disabled" "${BACKEND_FILE}"; fi

  # Initialize passing shared backend config and a unique key for this stack
  if ! terraform init -backend-config="${SHARED_BACKEND_HCL}" -backend-config="key=${STATE_KEY}"; then
    echo "[WARNING] Terraform init with remote state failed."
    
    read -r -p "Proceed with local state? [y/N] " CONFIRM
    case "${CONFIRM}" in
      y|Y|yes|YES)
        echo "[INFO] Continuing with local state."
        USE_LOCAL_STATE=true
        ;;
      *)
        echo "[INFO] Aborting by user choice."
        exit 0
        ;;
    esac
  else
    echo "[INFO] Terraform init with remote state successful."
  fi
fi

if [[ "${USE_LOCAL_STATE}" == true ]]; then
  # Disable backend so local backend is used
  if [[ -f ${BACKEND_FILE} ]]; then mv "${BACKEND_FILE}" "${BACKEND_FILE}.disabled"; fi

  if ! terraform init -reconfigure; then
    echo "[WARNING] Terraform init with local state failed, exiting."
    exit 1
  fi
  echo "[INFO] Terraform init with local state successful."
fi

# Terraform plan
echo "[INFO] Terraform plan."
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

    # After apply, extract generated Spaces credentials (local + CI) for the state bucket
    echo "[INFO] Extracting generated Spaces credentials for remote state bucket."
    ACCESS_KEY_LOCAL=$(terraform output -raw bucket_spaces_access_key_local 2>/dev/null || echo "")
    SECRET_KEY_LOCAL=$(terraform output -raw bucket_spaces_secret_key_local 2>/dev/null || echo "")

    if [[ -n "${ACCESS_KEY_LOCAL}" && -n "${SECRET_KEY_LOCAL}" ]]; then
      echo "[INFO] Updating local Spaces credentials in AWS credentials file (profile: ${AWS_PROFILE})."
      
      # Create .aws directory if it doesn't exist
      mkdir -p "${ROOT_DIR}/.aws"
      
      # Create or update AWS credentials file
      if [[ -f "${AWS_CREDENTIALS_FILE}" ]]; then
        # Remove existing digitalocean-spaces profile if it exists
        sed -i.bak '/\[digitalocean-spaces\]/,/^\[/ { /\[digitalocean-spaces\]/d; /^\[/!d; }' "${AWS_CREDENTIALS_FILE}"
      else
        touch "${AWS_CREDENTIALS_FILE}"
      fi
      
      # Add DigitalOcean Spaces profile
      cat >> "${AWS_CREDENTIALS_FILE}" << EOF
[digitalocean-spaces]
aws_access_key_id = ${ACCESS_KEY_LOCAL}
aws_secret_access_key = ${SECRET_KEY_LOCAL}
EOF
      rm -f "${AWS_CREDENTIALS_FILE}.bak"
      echo "[INFO] Local Spaces credentials updated for remote backend."
    else
      echo "[WARNING] Could not extract remote state bucket Spaces credentials for local usage from Terraform outputs."
    fi
    ;;
  *)
    echo "[INFO] Aborting by user choice."
    exit 0
    ;;
esac

