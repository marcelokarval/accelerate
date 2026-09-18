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

LOCAL_WORKSPACE_REFERENCE="$STAGE_ROOT/.codex/skills/accelerate/references/local-workspace-entry-gate.md"
LOCAL_WORKSPACE_RESOLVER="$STAGE_ROOT/.codex/skills/accelerate/scripts/resolve-local-workspace-tool.py"
LOCAL_WORKSPACE_TRUST="$STAGE_ROOT/.codex/skills/accelerate/assets/local-workspace-source-trust.json"
test -f "$LOCAL_WORKSPACE_RESOLVER"
test -f "$LOCAL_WORKSPACE_TRUST"
trust_backup="$STAGE_ROOT/local-workspace-source-trust.original.json"
cp "$LOCAL_WORKSPACE_TRUST" "$trust_backup"
root_commit="$(git -C "$ROOT" rev-parse HEAD)"
root_origin="$(git -C "$ROOT" remote get-url origin)"
python3 - "$LOCAL_WORKSPACE_TRUST" "$ROOT" "$root_commit" "$root_origin" <<'PY'
import json, sys
from pathlib import Path
manifest, source, commit, origin = sys.argv[1:]
Path(manifest).write_text(
    json.dumps(
        {
            "schema_version": 1,
            "trusted_sources": [
                {
                    "path": source,
                    "commit": commit,
                    "origin": origin,
                }
            ],
        },
        indent=2,
    ) + "\n",
    encoding="utf-8",
)
PY
grep -Fq -- 'resolve-local-workspace-tool.py' "$LOCAL_WORKSPACE_REFERENCE"
if grep -Fq -- '../onboarding/local-workspace/' "$LOCAL_WORKSPACE_REFERENCE"; then
  printf 'runtime reference still derives source-only onboarding paths from the installed skill\n' >&2
  exit 1
fi
resolved_tool="$(python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$ROOT" emit-v2.sh)"
test "$resolved_tool" = "$ROOT/onboarding/local-workspace/emit-v2.sh"
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$ROOT" unsupported.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver accepted an unsupported tool\n' >&2
  exit 1
fi
fake_source="$STAGE_ROOT/fake-accelerate"
mkdir -p "$fake_source/global-runtime/accelerate" "$fake_source/onboarding/local-workspace"
git -C "$fake_source" init -q
git -C "$fake_source" config user.name test
git -C "$fake_source" config user.email test@example.invalid
git -C "$fake_source" remote add origin https://github.com/marcelokarval/accelerate.git
printf '# fake\n' > "$fake_source/AGENTS.md"
printf '%s\n' '---' 'name: accelerate' '---' > "$fake_source/SKILL.md"
cp "$ROOT/global-runtime/accelerate/SKILL.md" "$fake_source/global-runtime/accelerate/SKILL.md"
printf '#!/usr/bin/env bash\nexit 0\n' > "$fake_source/onboarding/local-workspace/emit-v2.sh"
chmod 755 "$fake_source/onboarding/local-workspace/emit-v2.sh"
git -C "$fake_source" add .
git -C "$fake_source" commit -qm fixture
empty_home="$STAGE_ROOT/empty-home"
mkdir -p "$empty_home"
resolved_from_hostile_cwd="$(cd "$fake_source" && HOME="$empty_home" python3 "$LOCAL_WORKSPACE_RESOLVER" emit-v2.sh)"
if [[ "$resolved_from_hostile_cwd" != "$ROOT/onboarding/local-workspace/emit-v2.sh" ]]; then
  printf 'local-workspace resolver trusted an enclosing repository over the manifest-pinned source\n' >&2
  exit 1
fi
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a forged canonical origin through --source-root\n' >&2
  exit 1
fi
if ACCELERATE_SOURCE_ROOT="$fake_source" python3 "$LOCAL_WORKSPACE_RESOLVER" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a forged canonical origin through environment configuration\n' >&2
  exit 1
fi
fake_commit="$(git -C "$fake_source" rev-parse HEAD)"
python3 - "$LOCAL_WORKSPACE_TRUST" "$fake_source" "$fake_commit" <<'PY'
import json
import sys
from pathlib import Path

manifest, source, commit = sys.argv[1:]
Path(manifest).write_text(
    json.dumps(
        {
            "schema_version": 1,
            "trusted_sources": [
                {
                    "path": source,
                    "commit": commit,
                    "origin": "https://github.com/marcelokarval/accelerate.git",
                }
            ],
        },
        indent=2,
    )
    + "\n",
    encoding="utf-8",
)
PY
expected_fake_tool="$fake_source/onboarding/local-workspace/emit-v2.sh"
resolved_fake_tool="$(python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh)"
if [[ "$resolved_fake_tool" != "$expected_fake_tool" ]]; then
  printf 'local-workspace resolver did not honor a manifest-pinned source root\n' >&2
  exit 1
fi
mv "$fake_source/AGENTS.md" "$fake_source/AGENTS.real"
ln -s AGENTS.real "$fake_source/AGENTS.md"
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a symlinked identity file\n' >&2
  exit 1
fi
rm "$fake_source/AGENTS.md"
mv "$fake_source/AGENTS.real" "$fake_source/AGENTS.md"
chmod 777 "$fake_source/onboarding/local-workspace/emit-v2.sh"
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a working tool mode that differs from pinned HEAD\n' >&2
  exit 1
fi
chmod 755 "$fake_source/onboarding/local-workspace/emit-v2.sh"
mv "$fake_source/onboarding" "$fake_source/real-onboarding"
ln -s real-onboarding "$fake_source/onboarding"
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a tool with a symlinked path component\n' >&2
  exit 1
fi
rm "$fake_source/onboarding"
mv "$fake_source/real-onboarding" "$fake_source/onboarding"
printf '# unreviewed drift\n' >> "$fake_source/onboarding/local-workspace/emit-v2.sh"
if python3 "$LOCAL_WORKSPACE_RESOLVER" --source-root "$fake_source" emit-v2.sh >/dev/null 2>&1; then
  printf 'local-workspace resolver trusted a source tool that differs from pinned HEAD\n' >&2
  exit 1
fi
mv "$trust_backup" "$LOCAL_WORKSPACE_TRUST"

CAPABILITY_SOURCE="$ROOT/docs/codex-skill-seeds/skills/hermes-core-change-governance"
for runtime_root in "$STAGE_ROOT/.codex/skills" "$STAGE_ROOT/.agents/skills"; do
  while IFS= read -r source_file; do cmp -s "$source_file" "$runtime_root/hermes-core-change-governance/${source_file#${CAPABILITY_SOURCE}/}"; done < <(find "$CAPABILITY_SOURCE" -type f | sort)
done
check="$(CODEX_SKILLS_DIR="$STAGE_ROOT/.codex/skills" HERMES_SKILLS_DIR="$STAGE_ROOT/.agents/skills" bash "$ROOT/scripts/check-global-skill-mirror.sh")"
mirror_line="$(grep '^Accelerate runtime mirror: expected=[1-9][0-9]* verified=[1-9][0-9]*$' <<<"$check")"
[[ "$mirror_line" =~ expected=([1-9][0-9]*)\ verified=([1-9][0-9]*)$ ]]
[[ "${BASH_REMATCH[1]}" == "${BASH_REMATCH[2]}" ]]
printf 'runtime sync direct fast path passed\n'
