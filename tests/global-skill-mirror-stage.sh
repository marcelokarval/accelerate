#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

CODEX_SKILLS_DIR="$stage_root/skills" HERMES_SKILLS_DIR="$stage_root/hermes-skills" \
  "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null
mirror_output="$(CODEX_SKILLS_DIR="$stage_root/skills" HERMES_SKILLS_DIR="$stage_root/hermes-skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
printf '%s\n' "$mirror_output"
grep -Eq '^Accelerate runtime mirror: expected=[0-9]+ verified=[0-9]+$' <<<"$mirror_output"
expected="$(sed -n 's/^Accelerate runtime mirror: expected=\([0-9][0-9]*\) verified=.*/\1/p' <<<"$mirror_output")"
verified="$(sed -n 's/^Accelerate runtime mirror: expected=[0-9][0-9]* verified=\([0-9][0-9]*\)$/\1/p' <<<"$mirror_output")"
[[ "$expected" == "$verified" ]]

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$stage_root/skills/accelerate/SKILL.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" \
  "$stage_root/skills/accelerate/references/codex-collaboration-role-policy.json"
cmp -s "$ROOT/global-runtime/accelerate/evals/evals.json" \
  "$stage_root/skills/accelerate/evals/evals.json"
cmp -s "$ROOT/core/runtime-packets/delegation-dispatch-receipt.schema.json" \
  "$stage_root/skills/accelerate/assets/delegation-dispatch-receipt.schema.json"
cmp -s "$ROOT/scripts/validate-delegation-dispatch-receipt.py" \
  "$stage_root/skills/accelerate/scripts/validate-delegation-dispatch-receipt.py"

echo "staged global skill mirror passed"
