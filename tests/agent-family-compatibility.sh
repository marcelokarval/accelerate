#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'agent-family-compatibility failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

matrix="agents/doctrine/capability-matrix.md"
selection="agents/doctrine/selection-policy.md"

require_match 'Role Family Compatibility Map' "$matrix"
for role in architecture backend frontend data integrations-ops qa-regression security governance provider-boundary product-runtime; do
  printf -v role_pattern '[|] `%s` [|]' "$role"
  require_match "$role_pattern" "$matrix"
done

require_match 'role family.*portable routing category' "$matrix"
require_match 'capability family.*concrete promoted or candidate agent family' "$matrix"
require_match 'base agent contract' "$matrix"
require_match 'capability-matrix.md#role-family-compatibility-map' "$selection"
require_match 'cleanup expectation' "$selection"

printf 'agent family compatibility passed\n'
