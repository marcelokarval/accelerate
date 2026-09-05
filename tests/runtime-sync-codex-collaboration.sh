#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
materialize=(bash "$ROOT/tests/helpers/stage-runtime-mirror-fixture.sh")
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT
printf 'accelerate-test-root-v1\n' > "$stage_root/.accelerate-test-root"
mkdir -p "$stage_root/.codex/skills" "$stage_root/.agents/skills"

"${materialize[@]}" --test-root "$stage_root" \
  --codex-root "$stage_root/.codex/skills" --hermes-root "$stage_root/.agents/skills"
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
empty_home="$stage_root/empty-home"
mkdir "$empty_home"
check="$(HOME="$empty_home" CODEX_SKILLS_DIR="$stage_root/.codex/skills" HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
mirror_line="$(grep '^Accelerate runtime mirror: expected=[1-9][0-9]* verified=[1-9][0-9]*$' <<<"$check")"
[[ "$mirror_line" =~ expected=([1-9][0-9]*)\ verified=([1-9][0-9]*)$ ]]
[[ "${BASH_REMATCH[1]}" == "${BASH_REMATCH[2]}" ]]
must_fail() { if "$@" >/dev/null 2>&1; then echo "expected failure: $*" >&2; exit 1; fi; }
must_fail env HOME="$empty_home" bash "$ROOT/scripts/check-global-skill-mirror.sh"
must_fail env CODEX_SKILLS_DIR="$stage_root/.codex/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh"
must_fail env CODEX_SKILLS_DIR='' HERMES_SKILLS_DIR='' bash "$ROOT/scripts/check-global-skill-mirror.sh"
must_fail env CODEX_SKILLS_DIR='' HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh"
ln -s /tmp "$stage_root/symlink-root"
must_fail "${materialize[@]}" --test-root "$stage_root" --codex-root "$stage_root/symlink-root" --hermes-root "$stage_root/.agents/skills"
ln -s .codex "$stage_root/contained-symlink-root"
must_fail "${materialize[@]}" --test-root "$stage_root" --codex-root "$stage_root/contained-symlink-root/skills" --hermes-root "$stage_root/.agents/skills"
rm "$stage_root/.codex/skills/accelerate/references/codex-collaboration-routing.md"
must_fail env CODEX_SKILLS_DIR="$stage_root/.codex/skills" HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh"
"${materialize[@]}" --test-root "$stage_root" --codex-root "$stage_root/.codex/skills" --hermes-root "$stage_root/.agents/skills"
printf drift >> "$stage_root/.codex/skills/accelerate/references/codex-collaboration-routing.md"
must_fail env CODEX_SKILLS_DIR="$stage_root/.codex/skills" HERMES_SKILLS_DIR="$stage_root/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh"
printf 'runtime sync codex collaboration passed\n'
