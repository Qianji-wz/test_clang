#!/usr/bin/env bash

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if [[ ! -d .git ]]; then
  echo "[ERROR] .git directory not found"
  exit 1
fi

git config core.hooksPath .githooks

chmod +x .githooks/pre-commit
chmod +x scripts/check_style.sh

echo "[OK] Git hooks installed. core.hooksPath=.githooks"