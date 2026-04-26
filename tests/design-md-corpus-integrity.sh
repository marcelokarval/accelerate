#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'design-md-corpus-integrity failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "$path" ] || fail "missing required file: $path"
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n -- "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

require_file "references/design-md/README.md"
require_file "references/design-md/index.md"
require_file "core/review/design-md-corpus.md"
require_file "skills/design-system/design-md-corpus-patterns/SKILL.md"

entry_count=0

for entry_dir in references/design-md/*/; do
  slug="$(basename "$entry_dir")"
  entry_count=$((entry_count + 1))
  require_file "references/design-md/$slug/DESIGN.md"
  require_file "references/design-md/$slug/metadata.md"
  require_match '^# ' "references/design-md/$slug/DESIGN.md"
  require_match 'Visual Theme|Color Palette|Typography|Component|Layout|Agent Prompt' "references/design-md/$slug/DESIGN.md"
  require_match 'source-url:' "references/design-md/$slug/metadata.md"
  require_match 'fetched-at:' "references/design-md/$slug/metadata.md"
  require_match 'not-official:' "references/design-md/$slug/metadata.md"
  require_match "$slug" "references/design-md/index.md"
done

[ "$entry_count" -ge 69 ] || fail "expected at least 69 DESIGN.md entries, found $entry_count"
require_match 'Total entries: `69`' "references/design-md/index.md"

require_match 'design-md-corpus-patterns' "skills/_registry/manifest.md"
require_match 'DESIGN.md corpus' "README.md"
require_match 'DESIGN.md corpus' "core/review/html-design-system-extraction.md"
require_match 'DESIGN.md corpus' "core/review/design-system-contract-application.md"

printf 'design-md corpus integrity passed\n'
