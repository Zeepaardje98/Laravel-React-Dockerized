#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$ROOT/bootstrap"

terraform init -input=false
terraform apply -input=false -auto-approve

# capture outputs
export TF_VAR_spaces_access_id=$(terraform output -raw spaces_access_id)
export TF_VAR_spaces_secret_key=$(terraform output -raw spaces_secret_key)

# pass to stack2 via TF_VAR (recommended)
cd "$ROOT/main"

terraform init -input=false
terraform apply -auto-approve

# cleanup sensitive env
unset TF_VAR_spaces_access_id TF_VAR_spaces_secret_key

cd "$ROOT/bootstrap"

terraform destroy -auto-approve