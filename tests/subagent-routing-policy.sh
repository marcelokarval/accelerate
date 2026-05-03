#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'subagent-routing-policy failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

model="core/delegation/subagent-model.md"
templates="core/runtime-packets/templates.md"

require_match 'Orchestrator Routing Flow' "$model"
require_match 'classify the task surface' "$model"
require_match 'classify the task phase' "$model"
require_match 'classify the dominant risk' "$model"
require_match 'Role Family Routing Matrix' "$model"
require_match 'architecture / design reviewer' "$model"
require_match 'QA / regression reviewer' "$model"
require_match 'security / anti-abuse reviewer' "$model"
require_match 'selected role family' "$templates"
require_match 'required skills / profiles' "$templates"
require_match 'cleanup expectation after return' "$templates"

printf 'subagent routing policy passed\n'
