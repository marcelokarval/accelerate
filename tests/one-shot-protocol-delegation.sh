#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'one-shot-protocol-delegation failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

model="core/delegation/subagent-model.md"

require_match 'correction/reproof status' "$model"
require_match 'delegated correction' "$model"
require_match 'master owns integration' "$model"
require_match 'final forensic closure' "$model"
require_match 'review-of-review' "$model"
require_match 'self-review' "$model"
require_match 'self-forensic review' "$model"

printf 'one-shot protocol delegation contract passed\n'
