#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'runtime-proof-fixtures failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "${pattern}" "${path}" >/dev/null || fail "missing pattern '${pattern}' in ${path}"
}

runtime_template="adapters/runtime/proof-fixtures/runtime-proof-packet-template.md"
browser_template="adapters/runtime/proof-fixtures/browser-truth-template.md"

[ -f "${runtime_template}" ] || fail "missing runtime proof template"
[ -f "${browser_template}" ] || fail "missing browser truth template"

for marker in \
  "# Runtime Proof Packet" \
  "## Scope" \
  "## Preconditions" \
  "## Evidence" \
  "## Result" \
  "## Closure Lane Mapping" \
  "Backend QA" \
  "Frontend QA" \
  "Browser-Proof" \
  "Persistent E2E"; do
  require_match "${marker}" "${runtime_template}"
done

for marker in \
  "# Browser Truth Packet" \
  "## Scope" \
  "## Runtime Observations" \
  "## Accessibility Observations" \
  "## Design/Product Comparison" \
  "## Closure" \
  "browser truth status" \
  "corrected-state proof status" \
  "residual gaps"; do
  require_match "${marker}" "${browser_template}"
done

require_match "status: available" "adapters/runtime/proof-fixtures/capabilities.yaml"
require_match "validation_command: bash tests/runtime-proof-fixtures.sh" "adapters/runtime/proof-fixtures/capabilities.yaml"

printf 'runtime proof fixtures passed\n'
