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

CODEX_SKILLS_DIR="$STAGE_ROOT/codex" \
HERMES_SKILLS_DIR="$STAGE_ROOT/hermes" \
  "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

SOURCE="$ROOT/global-runtime/accelerate/SKILL.md"
TARGET="$STAGE_ROOT/codex/accelerate/SKILL.md"
cmp -s "$SOURCE" "$TARGET"
cmp -s "$ROOT/references/runtime-packet-templates.md" \
  "$STAGE_ROOT/codex/accelerate/references/runtime-packet-templates.md"
cmp -s "$ROOT/global-runtime/accelerate/evals/direct-fast-path-routing.json" \
  "$STAGE_ROOT/codex/accelerate/evals/direct-fast-path-routing.json"

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
  "$STAGE_ROOT/codex/accelerate/references/runtime-packet-templates.md"

CAPABILITY_SOURCE="$ROOT/docs/codex-skill-seeds/skills/hermes-core-change-governance"
for runtime_root in "$STAGE_ROOT/codex" "$STAGE_ROOT/hermes"; do
  while IFS= read -r source_file; do
    relative_path="${source_file#${CAPABILITY_SOURCE}/}"
    cmp -s "$source_file" "$runtime_root/hermes-core-change-governance/$relative_path"
  done < <(find "$CAPABILITY_SOURCE" -type f | sort)
done

printf 'runtime sync direct fast path passed\n'
