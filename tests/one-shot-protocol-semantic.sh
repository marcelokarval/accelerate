#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'one-shot-protocol-semantic failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

protocol="core/review/one-shot-side-by-side-protocol.md"
ledger="planning/execution/one-shot-task-ledger-template.md"

require_match 'executive plan' "$protocol"
require_match 'task ledger' "$protocol"
require_match 'one-shot execution' "$protocol"
require_match 'side-by-side' "$protocol"
require_match 'requested vs implemented' "$protocol"
require_match 'auto-correction' "$protocol"
require_match 'reproof' "$protocol"
require_match 'final forensic' "$protocol"
require_match 'closure blocker' "$protocol"

require_match 'Requested Outcome' "$ledger"
require_match 'Implemented Evidence' "$ledger"
require_match 'Side-By-Side Judgment' "$ledger"
require_match 'Defects Found' "$ledger"
require_match 'Correction Owner' "$ledger"
require_match 'Reproof Evidence' "$ledger"
require_match 'Closure Status' "$ledger"

printf 'one-shot protocol semantic anchors passed\n'
