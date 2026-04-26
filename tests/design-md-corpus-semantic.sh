#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'design-md-corpus-semantic failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n -- "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

doc="core/review/design-md-corpus.md"
skill="skills/design-system/design-md-corpus-patterns/SKILL.md"

require_match 'repo-local curated corpus' "$doc"
require_match 'not implementation authority by itself' "$doc"
require_match 'design-system.contract.md' "$doc"
require_match 'design-system.theme.css' "$doc"
require_match '--ds-\*' "$doc"
require_match 'Benchmark Influence Map' "$doc"
require_match 'brand cloning' "$doc"
require_match 'provenance' "$doc"
require_match 'Source Observer' "$doc"

require_match 'Select examples' "$skill"
require_match 'Do not copy brand identity' "$skill"
require_match 'Map influence to tokens' "$skill"
require_match 'design-system.contract.md' "$skill"
require_match 'design-system.theme.css' "$skill"
require_match '--ds-\*' "$skill"

printf 'design-md corpus semantic anchors passed\n'
