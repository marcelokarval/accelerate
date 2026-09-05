#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'ci-contract failed: %s\n' "$1" >&2
  exit 1
}

WORKFLOW=".github/workflows/accelerate-tests.yml"
[ -f "${WORKFLOW}" ] || fail "missing GitHub Actions workflow: ${WORKFLOW}"

grep -Fq 'pull_request:' "${WORKFLOW}" || fail "workflow must run on pull_request"
grep -Fq 'push:' "${WORKFLOW}" || fail "workflow must run on push"
grep -Fq 'branches: [main]' "${WORKFLOW}" || fail "workflow must target main branch"
grep -Fq 'bash tests/all.sh' "${WORKFLOW}" || fail "workflow must run canonical full test suite"
grep -Eq 'actions/checkout@v[5-9]' "${WORKFLOW}" || fail "workflow must checkout repository with Node 24-compatible checkout action"
if grep -Fq 'actions/checkout@v4' "${WORKFLOW}"; then
  fail "workflow must not use Node 20-era checkout@v4"
fi
grep -Fq 'ripgrep' "${WORKFLOW}" || fail "workflow must install ripgrep for shell tests"
grep -Eq 'fetch-depth:[[:space:]]*0' "${WORKFLOW}" || fail "workflow must retain full history for immutable governed-drift pin verification"

if grep -Eiq 'TOKEN|SECRET|PASSWORD|API_KEY|LINEAR_API_KEY|GH_TOKEN|GITHUB_TOKEN' "${WORKFLOW}"; then
  fail "workflow must not declare or reference external provider credentials"
fi

printf 'ci contract passed\n'
