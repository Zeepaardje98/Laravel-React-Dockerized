#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP="$ROOT/bootstrap"
MAIN="$ROOT/main"

cd "$BOOTSTRAP"

terraform destroy -auto-approve

cd "$MAIN"

terraform destroy -auto-approve