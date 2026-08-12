#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

CODEX_SKILLS_DIR="$stage_root/skills" "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null
mirror_output="$(CODEX_SKILLS_DIR="$stage_root/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
printf '%s\n' "$mirror_output"
grep -Fxq 'Accelerate runtime mirror: expected=207 verified=207' <<<"$mirror_output"

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$stage_root/skills/accelerate/SKILL.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" \
  "$stage_root/skills/accelerate/references/codex-collaboration-role-policy.json"
cmp -s "$ROOT/global-runtime/accelerate/evals/evals.json" \
  "$stage_root/skills/accelerate/evals/evals.json"

echo "staged global skill mirror passed"
