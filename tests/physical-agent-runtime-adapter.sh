#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'physical-agent-runtime-adapter failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

adapter="adapters/runtime/physical-agent/README.md"
capabilities="adapters/runtime/physical-agent/capabilities.yaml"
runtime_readme="adapters/runtime/README.md"

[ -f "$adapter" ] || fail "missing physical agent runtime adapter"
[ -f "$capabilities" ] || fail "missing physical agent capabilities.yaml"

require_match 'not a claim that a promoted runtime catalog already exists' "$adapter"
require_match 'subordinate to Accelerate' "$adapter"
require_match 'discover-capabilities' "$adapter"
require_match 'bind-assignment' "$adapter"
require_match 'start-or-resume' "$adapter"
require_match 'collect-return' "$adapter"
require_match 'classify-return' "$adapter"
require_match 'close-or-retain' "$adapter"
require_match 'fallback-if-unavailable' "$adapter"
require_match 'role-family-compatibility-map' "$adapter"
require_match 'Task Execution Return Packet' "$adapter"
require_match 'Skeptical Review Packet' "$adapter"
require_match 'cleanup result' "$adapter"
require_match 'virtual-subagent-packets' "$adapter"
require_match 'physical-agent-left-idle' "$adapter"
require_match 'physical-agent-fallback-missing' "$adapter"
require_match 'physical-agent/README.md' "$runtime_readme"
require_match 'status: planned' "$capabilities"
require_match 'runtime-adapter-subordinate-to-accelerate' "$capabilities"
require_match 'virtual-subagent-packets' "$capabilities"
require_match 'command: not-implemented-yet' "$capabilities"

printf 'physical agent runtime adapter passed\n'
