#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT

CODEX_SKILLS_DIR="$stage_root/skills" bash "$ROOT/scripts/sync-skills-to-global.sh" >/dev/null

cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$stage_root/skills/accelerate/SKILL.md"
cmp -s "$ROOT/references/codex-collaboration-routing.md" "$stage_root/skills/accelerate/references/codex-collaboration-routing.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" "$stage_root/skills/accelerate/references/codex-collaboration-role-policy.json"
rg -n 'references/codex-collaboration-routing.md' "$stage_root/skills/accelerate/SKILL.md" >/dev/null
rg -n 'references/codex-collaboration-role-policy.json' "$stage_root/skills/accelerate/SKILL.md" >/dev/null
rg -n 'never use a wildcard' "$stage_root/skills/accelerate/references/codex-collaboration-routing.md" >/dev/null

printf 'runtime sync codex collaboration passed\n'
