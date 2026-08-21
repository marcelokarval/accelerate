#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

CODEX_SKILLS_DIR="$stage_root/skills" HERMES_SKILLS_DIR="$stage_root/hermes-skills" \
  bash "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$stage_root/skills/accelerate/SKILL.md"
cmp -s "$ROOT/references/codex-collaboration-routing.md" "$stage_root/skills/accelerate/references/codex-collaboration-routing.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" "$stage_root/skills/accelerate/references/codex-collaboration-role-policy.json"
rg -n 'references/codex-collaboration-routing.md' "$stage_root/skills/accelerate/SKILL.md" >/dev/null
rg -n 'references/codex-collaboration-role-policy.json' "$stage_root/skills/accelerate/SKILL.md" >/dev/null
rg -n 'never use a wildcard' "$stage_root/skills/accelerate/references/codex-collaboration-routing.md" >/dev/null
cmp -s "$ROOT/core/runtime-packets/delegation-dispatch-receipt.schema.json" \
  "$stage_root/skills/accelerate/assets/delegation-dispatch-receipt.schema.json"
cmp -s "$ROOT/scripts/validate-delegation-dispatch-receipt.py" \
  "$stage_root/skills/accelerate/scripts/validate-delegation-dispatch-receipt.py"

python3 "$stage_root/skills/accelerate/scripts/validate-delegation-dispatch-receipt.py" "$ROOT/tests/fixtures/delegation-dispatch/valid-orchestrated.json" >/dev/null

printf 'runtime sync codex collaboration passed\n'
