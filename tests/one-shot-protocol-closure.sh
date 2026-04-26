#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'one-shot-protocol-closure failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

protocol="core/review/one-shot-side-by-side-protocol.md"
packets="core/runtime-packets/templates.md"

require_match 'No task may be marked closed while an in-scope defect is open' "$protocol"
require_match 'Correction without reproof is not closure' "$protocol"
require_match 'Final closure requires a side-by-side reconciliation' "$protocol"
require_match 'open defects' "$packets"
require_match 'corrections without reproof' "$packets"
require_match 'final closure judgment' "$packets"

printf 'one-shot protocol closure rules passed\n'
