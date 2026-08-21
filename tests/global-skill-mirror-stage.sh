#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tool=(python3 "$ROOT/scripts/sync-accelerate-governed-drift.py")
stage_root="$(mktemp -d)"
trap 'rm -rf "$stage_root"' EXIT
printf 'accelerate-test-root-v1\n' > "$stage_root/.accelerate-test-root"
mkdir -p "$stage_root/.codex" "$stage_root/.agents"

# The installed mirror is read-only input for this disposable fixture. The
# production broad exporter stays fail-closed.
installed="${HOME}/.codex/skills"
[[ -d "$installed/accelerate" ]]
cp -a "$installed" "$stage_root/.codex/skills"
cp -a "$installed" "$stage_root/.agents/skills"

snapshot_other() {
  find "$1/accelerate" -type f \
    ! -path '*/references/subagent-model.md' \
    ! -path '*/assets/delegation-dispatch-receipt.schema.json' \
    ! -path '*/scripts/validate-delegation-dispatch-receipt.py' \
    -printf '%P|%i|%m|%u|%g|%s\n' | LC_ALL=C sort
}
run() { "${tool[@]}" --mirror "$1" --test-root "$stage_root" "${@:2}"; }
must_fail() { if "$@" >/dev/null 2>&1; then echo "expected failure: $*" >&2; exit 1; fi; }

find "$stage_root" ! -name wrapper.before ! -name wrapper.after -printf '%P|%i\n' | LC_ALL=C sort > "$stage_root/wrapper.before"
must_fail env CODEX_SKILLS_DIR="$stage_root/legacy" HERMES_SKILLS_DIR="$stage_root/legacy-hermes" bash "$ROOT/scripts/sync-skills-to-global.sh"
find "$stage_root" ! -name wrapper.before ! -name wrapper.after -printf '%P|%i\n' | LC_ALL=C sort > "$stage_root/wrapper.after"
cmp -s "$stage_root/wrapper.before" "$stage_root/wrapper.after"

for mirror in codex agents; do
  target="$stage_root/.${mirror}/skills/accelerate"
  snapshot_other "$stage_root/.${mirror}/skills" > "$stage_root/$mirror.other.before"
  printf drift >> "$target/references/subagent-model.md"
  printf drift >> "$target/assets/delegation-dispatch-receipt.schema.json"
  printf drift >> "$target/scripts/validate-delegation-dispatch-receipt.py"
  run "$mirror" --apply >/dev/null
  cmp -s "$ROOT/references/subagent-model.md" "$target/references/subagent-model.md"
  cmp -s "$ROOT/core/runtime-packets/delegation-dispatch-receipt.schema.json" "$target/assets/delegation-dispatch-receipt.schema.json"
  cmp -s "$ROOT/scripts/validate-delegation-dispatch-receipt.py" "$target/scripts/validate-delegation-dispatch-receipt.py"
  snapshot_other "$stage_root/.${mirror}/skills" > "$stage_root/$mirror.other.after"
  cmp -s "$stage_root/$mirror.other.before" "$stage_root/$mirror.other.after"
  mirror_output="$(CODEX_SKILLS_DIR="$stage_root/.${mirror}/skills" HERMES_SKILLS_DIR="$stage_root/.${mirror}/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
  printf '%s\n' "$mirror_output"
  grep -q '^Accelerate runtime mirror: expected=211 verified=211$' <<<"$mirror_output"
done

echo "staged global skill mirror passed"
