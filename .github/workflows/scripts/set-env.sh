#!/bin/bash

# Script to set Terraform environment variables
# This can be used with GitHub Actions or locally

# DigitalOcean Configuration
export TF_VAR_do_token="${DO_TOKEN}"
export TF_VAR_droplet_name="${DO_DROPLET_NAME}"
export TF_VAR_region="${DO_REGION}"
export TF_VAR_ssh_key_name="${DO_SSH_KEY_NAME}"
export TF_VAR_environment="${ENVIRONMENT}"
export TF_VAR_project_name="${PROJECT_NAME}"

# AWS Configuration (for future use)
export TF_VAR_aws_access_key_id="${AWS_ACCESS_KEY_ID}"
export TF_VAR_aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"
export TF_VAR_aws_region="${AWS_REGION}"

# GCP Configuration (for future use)
export TF_VAR_gcp_project_id="${GCP_PROJECT_ID}"
export TF_VAR_gcp_credentials="${GCP_CREDENTIALS}"

echo "Environment variables set for Terraform"
echo "Environment: ${TF_VAR_environment}"
echo "Project: ${TF_VAR_project_name}"
echo "Region: ${TF_VAR_region}"
