#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'authority-set-gate failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

for path in \
  core/control-plane/authority-set-gate.md \
  SKILL.md \
  global-runtime/accelerate/SKILL.md \
  core/runtime-packets/templates.md \
  references/README.md \
  README.md \
  docs/architecture/accelerate-control-plane.md; do
  [ -f "$path" ] || fail "missing $path"
done

for term in \
  governing-authority \
  supporting-reference \
  decision-artifact \
  backend-authority \
  generated-export \
  forbidden-authority; do
  require_match "$term" core/control-plane/authority-set-gate.md
  require_match "$term" core/runtime-packets/templates.md
done

require_match 'authority set' SKILL.md
require_match 'authority set' global-runtime/accelerate/SKILL.md
require_match 'supporting-reference' references/README.md
require_match 'generated exports are deployment outputs, not doctrine|generated-export; repository remains source of truth' core/control-plane/authority-set-gate.md

if rg -n 'active references' SKILL.md global-runtime/accelerate/SKILL.md core/runtime-packets/templates.md README.md references/README.md docs/architecture/accelerate-control-plane.md >/tmp/accelerate-active-references.out; then
  cat /tmp/accelerate-active-references.out >&2
  fail "unqualified active references terminology remains in governed docs"
fi

printf 'authority set gate passed\n'
