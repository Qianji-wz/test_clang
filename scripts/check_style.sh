#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/check_style.sh [--staged]

Options:
  --staged   Only check staged C/C++ files.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

check_staged=false
if [[ "${1:-}" == "--staged" ]]; then
  check_staged=true
elif [[ -n "${1:-}" ]]; then
  echo "Unknown argument: $1"
  usage
  exit 1
fi

if ! command -v clang-format >/dev/null 2>&1; then
  echo "[ERROR] clang-format not found"
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "[ERROR] git not found"
  exit 1
fi

tmp_files="$(mktemp)"
trap 'rm -f "$tmp_files"' EXIT

if [[ "$check_staged" == "true" ]]; then
  git diff --cached --name-only --diff-filter=ACMR \
    | grep -E '\.(c|cc|cpp|cxx|h|hh|hpp|hxx)$' >"$tmp_files" || true
else
  git ls-files \
    | grep -E '\.(c|cc|cpp|cxx|h|hh|hpp|hxx)$' >"$tmp_files" || true
fi

if [[ ! -s "$tmp_files" ]]; then
  echo "[INFO] No C/C++ files to check"
  exit 0
fi

echo "[INFO] Running clang-format check"
format_failed=0
while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  if ! diff -u "$file" <(clang-format "$file") >/dev/null; then
    echo "[FORMAT] $file"
    format_failed=1
  fi
done <"$tmp_files"

if [[ "$format_failed" -ne 0 ]]; then
  echo "[ERROR] clang-format check failed. Run: clang-format -i <file>"
  exit 1
fi

if command -v clang-tidy >/dev/null 2>&1; then
  if [[ -f "compile_commands.json" ]]; then
    echo "[INFO] Running clang-tidy check"
    while IFS= read -r file; do
      [[ -f "$file" ]] || continue
      clang-tidy --quiet "$file"
    done <"$tmp_files"
  else
    echo "[WARN] compile_commands.json not found, skip clang-tidy"
  fi
else
  echo "[WARN] clang-tidy not found, skip clang-tidy"
fi

echo "[OK] All checks passed"