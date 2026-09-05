#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
materialize=(bash "$ROOT/tests/helpers/stage-runtime-mirror-fixture.sh")
STAGE_ROOT="$(mktemp -d)"
trap 'rm -rf "$STAGE_ROOT"' EXIT
printf 'accelerate-test-root-v1\n' > "$STAGE_ROOT/.accelerate-test-root"
mkdir -p "$STAGE_ROOT/.codex/skills" "$STAGE_ROOT/.agents/skills"

"${materialize[@]}" --test-root "$STAGE_ROOT" \
  --codex-root "$STAGE_ROOT/.codex/skills" --hermes-root "$STAGE_ROOT/.agents/skills"
for mirror in codex agents; do
  target="$STAGE_ROOT/.${mirror}/skills/accelerate"
  printf drift >> "$target/references/subagent-model.md"
  printf drift >> "$target/assets/delegation-dispatch-receipt.schema.json"
  printf drift >> "$target/scripts/validate-delegation-dispatch-receipt.py"
  python3 "$ROOT/scripts/sync-accelerate-governed-drift.py" --mirror "$mirror" --test-root "$STAGE_ROOT" --apply >/dev/null
done

TARGET="$STAGE_ROOT/.codex/skills/accelerate/SKILL.md"
cmp -s "$ROOT/global-runtime/accelerate/SKILL.md" "$TARGET"
cmp -s "$ROOT/references/runtime-packet-templates.md" "$STAGE_ROOT/.codex/skills/accelerate/references/runtime-packet-templates.md"
cmp -s "$ROOT/global-runtime/accelerate/evals/direct-fast-path-routing.json" "$STAGE_ROOT/.codex/skills/accelerate/evals/direct-fast-path-routing.json"
for expected in "## Reasoning Effort Contract" "## Fable Method Composition" "## Wave-Gated Execution" "## Execution Routes" "zero physical or" "virtual subagents" 'Escalate out of `direct-fast-path`'; do grep -Fq -- "$expected" "$TARGET"; done
grep -Fq -- "## 14. Direct Fast Path Packet" "$STAGE_ROOT/.codex/skills/accelerate/references/runtime-packet-templates.md"

CAPABILITY_SOURCE="$ROOT/docs/codex-skill-seeds/skills/hermes-core-change-governance"
for runtime_root in "$STAGE_ROOT/.codex/skills" "$STAGE_ROOT/.agents/skills"; do
  while IFS= read -r source_file; do cmp -s "$source_file" "$runtime_root/hermes-core-change-governance/${source_file#${CAPABILITY_SOURCE}/}"; done < <(find "$CAPABILITY_SOURCE" -type f | sort)
done
check="$(CODEX_SKILLS_DIR="$STAGE_ROOT/.codex/skills" HERMES_SKILLS_DIR="$STAGE_ROOT/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
mirror_line="$(grep '^Accelerate runtime mirror: expected=[1-9][0-9]* verified=[1-9][0-9]*$' <<<"$check")"
[[ "$mirror_line" =~ expected=([1-9][0-9]*)\ verified=([1-9][0-9]*)$ ]]
[[ "${BASH_REMATCH[1]}" == "${BASH_REMATCH[2]}" ]]
printf 'runtime sync direct fast path passed\n'
