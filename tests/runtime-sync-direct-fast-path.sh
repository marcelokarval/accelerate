#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAGE_ROOT="$(mktemp -d)"
cleanup() {
  local status=$?
  rm -rf "$STAGE_ROOT"
  exit "$status"
}
trap cleanup EXIT

CODEX_SKILLS_DIR="$STAGE_ROOT/skills" "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

SOURCE="$ROOT/global-runtime/accelerate/SKILL.md"
TARGET="$STAGE_ROOT/skills/accelerate/SKILL.md"
cmp -s "$SOURCE" "$TARGET"
cmp -s "$ROOT/references/runtime-packet-templates.md" \
  "$STAGE_ROOT/skills/accelerate/references/runtime-packet-templates.md"
cmp -s "$ROOT/global-runtime/accelerate/evals/direct-fast-path-routing.json" \
  "$STAGE_ROOT/skills/accelerate/evals/direct-fast-path-routing.json"

for expected in \
  "## Reasoning Effort Contract" \
  "## Fable Method Composition" \
  "## Wave-Gated Execution" \
  "## Execution Routes" \
  "zero physical or" \
  "virtual subagents" \
  'Escalate out of `direct-fast-path`'; do
  grep -Fq -- "$expected" "$TARGET"
done

grep -Fq -- "## 14. Direct Fast Path Packet" \
  "$STAGE_ROOT/skills/accelerate/references/runtime-packet-templates.md"

printf 'runtime sync direct fast path passed\n'
