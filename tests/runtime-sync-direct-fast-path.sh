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

CODEX_HOME_ROOT="$STAGE_ROOT/runtime/.codex"
SKILLS_TARGET="$CODEX_HOME_ROOT/skills"
BACKUP_ROOT="$STAGE_ROOT/backups/direct-fast-path"
RECEIPT_FILE="$BACKUP_ROOT/sync-receipt.json"
mkdir -p "$SKILLS_TARGET"

CODEX_HOME="$CODEX_HOME_ROOT" CODEX_SKILLS_DIR="$SKILLS_TARGET" \
  CODEX_SKILLS_BACKUP_DIR="$BACKUP_ROOT" CODEX_SKILLS_RECEIPT_FILE="$RECEIPT_FILE" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$STAGE_ROOT" \
  "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

SOURCE="$ROOT/global-runtime/accelerate/SKILL.md"
TARGET="$SKILLS_TARGET/accelerate/SKILL.md"
cmp -s "$SOURCE" "$TARGET"
cmp -s "$ROOT/references/runtime-packet-templates.md" \
  "$SKILLS_TARGET/accelerate/references/runtime-packet-templates.md"
cmp -s "$ROOT/global-runtime/accelerate/evals/direct-fast-path-routing.json" \
  "$SKILLS_TARGET/accelerate/evals/direct-fast-path-routing.json"
test -f "$RECEIPT_FILE"

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
  "$SKILLS_TARGET/accelerate/references/runtime-packet-templates.md"

printf 'runtime sync direct fast path passed\n'
