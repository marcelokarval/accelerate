#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

required_python_tests=(
  "tests/semantic-implication-python-contract.sh" \
  "tests/test_semantic_implication.py" \
  "tests/test_harness_catalog.py" \
  "tests/test_phase1_entry_currentness.py"
)

for required_test in "${required_python_tests[@]}"; do
  grep -Fq "\"${required_test}\"" tests/all.sh || {
    printf 'semantic implication Python contract failed: missing CI requirement %s\n' "${required_test}" >&2
    exit 1
  }
done

PYTHONDONTWRITEBYTECODE=1 python3 -m pytest -q \
  "${required_python_tests[@]:1}"

printf 'semantic implication Python contract passed\n'
