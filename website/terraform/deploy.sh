#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP="$ROOT/bootstrap"
MAIN="$ROOT/main"

cd "$BOOTSTRAP"

terraform init -input=false
terraform apply -input=false -auto-approve

# capture outputs
ADMIN_AK=$(terraform output -raw admin_access_key)
ADMIN_SK=$(terraform output -raw admin_secret_key)

# pass to stack2 via TF_VAR (recommended)
cd "$MAIN"
export TF_VAR_admin_access_key="$ADMIN_AK"
export TF_VAR_admin_secret_key="$ADMIN_SK"

terraform init -input=false
terraform apply -auto-approve

# cleanup sensitive env
unset TF_VAR_admin_access_key TF_VAR_admin_secret_key

cd "$BOOTSTRAP"

terraform destroy -auto-approve