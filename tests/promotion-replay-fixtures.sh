#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'promotion-replay-fixtures failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

fixtures=(
  planning/promotion/replay-fixtures/architecture-reviewer.md
  planning/promotion/replay-fixtures/qa-regression-reviewer.md
  planning/promotion/replay-fixtures/security-reviewer.md
  planning/promotion/replay-fixtures/backend-worker.md
  planning/promotion/replay-fixtures/frontend-worker.md
  planning/promotion/replay-fixtures/governance-auditor.md
  planning/promotion/replay-fixtures/bounded-proof-auditor.md
)

for fixture in "${fixtures[@]}"; do
  [ -f "$fixture" ] || fail "missing fixture: $fixture"
  require_match 'template path:' "$fixture"
  require_match 'base contract reference: `agents/base-agent-contract.md`' "$fixture"
  require_match 'promotion readiness packet reference: `planning/promotion/template-promotion-readiness-packet.md`' "$fixture"
  require_match 'selected role family:' "$fixture"
  require_match 'compatible capability family:' "$fixture"
  require_match 'assignment received:' "$fixture"
  require_match 'return contract expected:' "$fixture"
  require_match 'prohibited authority checked:' "$fixture"
  require_match 'residual risk required: yes' "$fixture"
  require_match 'cleanup expectation checked: complete' "$fixture"
  require_match 'root review-of-review required: yes' "$fixture"
  require_match 'promotion state: .*template-only until runtime binding and replay evidence exist|promotion state: proof-replay only for this fixture; template-only until runtime binding and replay evidence exist' "$fixture"
  if rg -n 'final closure[^\n]*(allowed|owned by agent)|`Done`[^\n]*(allowed|owned by agent)' "$fixture" >/dev/null; then
    fail "fixture claims forbidden closure authority: $fixture"
  fi
done

require_match 'replay-fixtures/' planning/promotion/README.md
require_match 'empirically-replayed' planning/promotion/README.md
require_match 'bounded-proof-auditor' planning/promotion/README.md
require_match 'positive fixture expected result: `accept-for-root-review`' planning/promotion/replay-fixtures/bounded-proof-auditor.md
require_match 'negative fixture expected result: `block-and-demote`' planning/promotion/replay-fixtures/bounded-proof-auditor.md
require_match 'autonomous runtime availability' agents/promotion/bounded-proof-auditor-replay.md
require_match 'agent-factory-replay-2026-05-08.md' agents/promotion/bounded-proof-auditor-replay.md

printf 'promotion replay fixtures passed\n'
