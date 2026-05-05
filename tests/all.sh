#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

while IFS= read -r test_script; do
  case "${test_script}" in
    tests/all.sh) continue ;;
  esac
  bash "${test_script}"
done < <(find tests -maxdepth 1 -type f -name '*.sh' | sort)

echo "all tests passed"
