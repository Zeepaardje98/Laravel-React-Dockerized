#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

# AWS credentials file for DigitalOcean Spaces backend
AWS_CREDENTIALS_FILE="${ROOT_DIR}/.aws/credentials"
AWS_PROFILE="digitalocean-spaces"

# Check if AWS credentials exist for DigitalOcean Spaces
aws_credentials_exist() {
  echo "[INFO] Checking if AWS credentials exist with DigitalOcean Spaces profile."
  if [[ -f "${AWS_CREDENTIALS_FILE}" ]]; then
    # Check if [digitalocean-spaces] profile exists
    if grep -q "\[${AWS_PROFILE}\]" "${AWS_CREDENTIALS_FILE}"; then
      echo "[SUCCESS] Found AWS credentials file with DigitalOcean Spaces profile."
      return 0
    fi
  fi
  return 1
}

# Terraform init with remote state storage, or local state if remote state is not set up correctly.
BACKEND_FILE="backend.tf"
if aws_credentials_exist; then
  echo "[INFO] Terraform init attempt with remote state (uses backend)"

  # Set AWS profile and credentials file for Terraform S3 backend to use
  export AWS_PROFILE
  export AWS_SHARED_CREDENTIALS_FILE="${AWS_CREDENTIALS_FILE}"

  # Restore the backend.tf file if it is disabled
  if [[ -f ${BACKEND_FILE}.disabled ]]; then mv ${BACKEND_FILE}.disabled ${BACKEND_FILE}; fi

  # Terraform init with remote state storage
  if ! terraform init; then
    echo "[WARNING] Terraform init with remote state failed."

    echo "[INFO] Do you want to continue with local state?"
    read -r -p "Proceed with local state? [y/N] " CONFIRM
    case "${CONFIRM}" in
      y|Y|yes|YES)
        echo "[INFO] Continuing with local state."
       
        # Terraform init with local state, disable backend.tf if present
        if [[ -f ${BACKEND_FILE} ]]; then mv ${BACKEND_FILE} ${BACKEND_FILE}.disabled; fi
        if ! terraform init; then
          echo "[WARNING] Terraform init with local state failed, exiting."
          exit 1
        fi
        ;;
      *)
        echo "[INFO] Aborting by user choice."
        exit 0
        ;;
    esac
  fi
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
    
    # After apply, extract and update digitalocean spaces credentials for remote state bucket
    echo "[INFO] Extracting generated Spaces credentials for remote state bucket."
    ACCESS_KEY=$(terraform output -raw bucket_spaces_access_key 2>/dev/null || echo "")
    SECRET_KEY=$(terraform output -raw bucket_spaces_secret_key 2>/dev/null || echo "")

    if [[ -n "${ACCESS_KEY}" && -n "${SECRET_KEY}" ]]; then
      echo "[INFO] Updating Spaces credentials in AWS credentials file."
      
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
aws_access_key_id = ${ACCESS_KEY}
aws_secret_access_key = ${SECRET_KEY}
EOF

      rm -f "${AWS_CREDENTIALS_FILE}.bak"

      echo "[INFO] Spaces credentials updated for remote backend."
    else
      echo "[WARNING] Could not extract remote state bucket Spaces credentials from Terraform outputs."
    fi
    ;;
  *)
    echo "[INFO] Aborting by user choice."
    # Restore the backend.tf file
    if [[ -f ${BACKEND_FILE}.disabled ]]; then mv ${BACKEND_FILE}.disabled ${BACKEND_FILE}; fi
    exit 0
    ;;
esac

