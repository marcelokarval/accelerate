#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT
codex_home="$stage_root/runtime/.codex"
target="$codex_home/skills"
backup="$stage_root/backups/runtime-sync"
receipt="$backup/sync-receipt.json"
mkdir -p "$target"

CODEX_HOME="$codex_home" CODEX_SKILLS_DIR="$target" \
  CODEX_SKILLS_BACKUP_DIR="$backup" CODEX_SKILLS_RECEIPT_FILE="$receipt" \
  CODEX_SKILL_SYNC_ALLOWED_ROOT="$stage_root" \
  bash "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$target/accelerate/SKILL.md"
cmp -s "$ROOT/references/codex-collaboration-routing.md" "$target/accelerate/references/codex-collaboration-routing.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" "$target/accelerate/references/codex-collaboration-role-policy.json"
rg -n 'references/codex-collaboration-routing.md' "$target/accelerate/SKILL.md" >/dev/null
rg -n 'references/codex-collaboration-role-policy.json' "$target/accelerate/SKILL.md" >/dev/null
rg -n 'never use a wildcard' "$target/accelerate/references/codex-collaboration-routing.md" >/dev/null
test -f "$receipt"

printf 'runtime sync codex collaboration passed\n'
