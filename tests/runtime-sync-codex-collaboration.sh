#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT
printf 'accelerate-test-root-v1\n' > "$stage_root/.accelerate-test-root"
mkdir -p "$stage_root/.codex/skills" "$stage_root/.agents/skills"

CODEX_SKILLS_DIR="$stage_root/.codex/skills" HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/sync-skills-to-global.sh" --capabilities-only >/dev/null
cp -a "$HOME/.codex/skills/accelerate" "$stage_root/.codex/skills/accelerate"
cp -a "$HOME/.codex/skills/accelerate" "$stage_root/.agents/skills/accelerate"
for mirror in codex agents; do
  target="$stage_root/.${mirror}/skills/accelerate"
  printf drift >> "$target/references/subagent-model.md"
  printf drift >> "$target/assets/delegation-dispatch-receipt.schema.json"
  printf drift >> "$target/scripts/validate-delegation-dispatch-receipt.py"
  python3 "$ROOT/scripts/sync-accelerate-governed-drift.py" --mirror "$mirror" --test-root "$stage_root" --apply >/dev/null
done

target="$stage_root/.codex/skills/accelerate"
cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$target/SKILL.md"
cmp -s "$ROOT/references/codex-collaboration-routing.md" "$target/references/codex-collaboration-routing.md"
cmp -s "$ROOT/adapters/runtime/codex-collaboration/role-policy.json" "$target/references/codex-collaboration-role-policy.json"
rg -n 'references/codex-collaboration-routing.md' "$target/SKILL.md" >/dev/null
rg -n 'references/codex-collaboration-role-policy.json' "$target/SKILL.md" >/dev/null
rg -n 'never use a wildcard' "$target/references/codex-collaboration-routing.md" >/dev/null
cmp -s "$ROOT/core/runtime-packets/delegation-dispatch-receipt.schema.json" "$target/assets/delegation-dispatch-receipt.schema.json"
cmp -s "$ROOT/scripts/validate-delegation-dispatch-receipt.py" "$target/scripts/validate-delegation-dispatch-receipt.py"
python3 "$target/scripts/validate-delegation-dispatch-receipt.py" "$ROOT/tests/fixtures/delegation-dispatch/valid-orchestrated.json" >/dev/null
check="$(CODEX_SKILLS_DIR="$stage_root/.codex/skills" HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
grep -q '^Accelerate runtime mirror: expected=211 verified=211$' <<<"$check"
printf 'runtime sync codex collaboration passed\n'
