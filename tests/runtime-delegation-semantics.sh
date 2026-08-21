#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

validator=(python3 scripts/validate-runtime-delegation-semantics.py)
fixtures="tests/fixtures/runtime-delegation-semantics"

"${validator[@]}" "$fixtures/valid-run.json"

declare -A expected=(
  [unknown-telemetry-is-zero.json]='runtime telemetry value'
  [effective-cap-exceeds-policy.json]='capacity order'
  [unsupported-enforcement.json]='unsupported enforcement'
  [invalid-state-transition.json]='invalid state transition'
)

for fixture in "${!expected[@]}"; do
  output="$("${validator[@]}" "$fixtures/$fixture" 2>&1 || true)"
  if [[ "$output" != *"${expected[$fixture]}"* ]]; then
    printf 'negative fixture did not fail for expected reason: %s\n%s\n' "$fixture" "$output" >&2
    exit 1
  fi
  if [[ "$output" != *'FAIL:'* ]]; then
    printf 'negative semantic fixture unexpectedly passed: %s\n' "$fixture" >&2
    exit 1
  fi
done

printf 'PASS: runtime delegation semantic fixtures\n'
