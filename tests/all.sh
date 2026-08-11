#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_tests=(
  "tests/recursive-self-improvement-contract.sh"
)

for required_test in "${required_tests[@]}"; do
  if [ ! -f "${required_test}" ]; then
    printf 'missing required test: %s\n' "${required_test}" >&2
    exit 1
  fi
done

while IFS= read -r test_script; do
  case "${test_script}" in
    tests/all.sh|tests/direct-fast-path-routing.sh|tests/runtime-sync-direct-fast-path.sh) continue ;;
  esac
  bash "${test_script}"
done < <(find tests -maxdepth 1 -type f -name '*.sh' | sort)

echo "all tests passed"
