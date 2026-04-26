#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'one-shot-protocol-integrity failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "$path" ] || fail "missing required file: $path"
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

require_file "core/review/one-shot-side-by-side-protocol.md"
require_file "planning/execution/one-shot-task-ledger-template.md"

require_match 'One-Shot Side-By-Side Gate' "core/control-plane/branch-enforcement-matrix.md"
require_match 'One-Shot Side-By-Side Gate' "core/control-plane/gate-ownership-index.md"
require_match 'one-shot-side-by-side-protocol.md' "core/control-plane/gate-ownership-index.md"
require_match 'one-shot-side-by-side-protocol.md' "core/review/architecture.md"
require_match 'one-shot-side-by-side-protocol.md' "core/README.md"
require_match 'one-shot-task-ledger-template.md' "planning/execution/README.md"
require_match 'One-Shot Side-By-Side Review Packet' "core/runtime-packets/templates.md"
require_match 'Final Forensic Reconciliation Packet' "core/runtime-packets/templates.md"

printf 'one-shot protocol integrity passed\n'
