#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'codex logical agent topology failed: %s\n' "$1" >&2
  exit 1
}

topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
policy="adapters/runtime/codex-collaboration/role-policy.json"
validator="scripts/validate-codex-logical-agent-topology.py"
renderer="scripts/render-codex-logical-agent.py"
assignment="scripts/render-codex-spawn-packet.py"

for path in "$topology" "$catalog" "$policy" "$validator" "$renderer" "$assignment"; do
  [ -f "$path" ] || fail "missing $path"
done

python3 "$validator" "$topology" "$catalog" "$policy"
python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path

topology = tomllib.loads(Path(sys.argv[1]).read_text())
research = next(agent for agent in topology["agents"] if agent["name"] == "research")
if research["role_family"] != "research" or research["collaboration_profile"] != "librarian":
    raise SystemExit("logical research must use the research/librarian binding")
PY

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

for agent in python-backend nextjs-frontend research reviewer qa; do
  output="$tmp_dir/${agent}.config.toml"
  python3 "$renderer" "$topology" "$catalog" --agent "$agent" --output "$output"
  [ -s "$output" ] || fail "empty profile for $agent"
  rg -F "# Generated from the governed logical-agent topology." "$output" >/dev/null || fail "missing provenance for $agent"
  ! rg -F '*' "$output" >/dev/null || fail "wildcard in $agent profile"
done

if python3 "$renderer" "$topology" "$catalog" --agent orchestrator --output "$tmp_dir/orchestrator.config.toml" >/dev/null 2>&1; then
  fail 'renderer accepted orchestrator as an additive profile'
fi
rg -F 'python-pro/SKILL.md", enabled = true' "$tmp_dir/python-backend.config.toml" >/dev/null || fail 'python profile missing'
! rg -F 'nextjs-app-router-patterns/SKILL.md' "$tmp_dir/python-backend.config.toml" >/dev/null || fail 'python profile leaked frontend skill'
rg -F 'nextjs-app-router-patterns/SKILL.md", enabled = true' "$tmp_dir/nextjs-frontend.config.toml" >/dev/null || fail 'frontend profile missing'
! rg -F 'python-pro/SKILL.md' "$tmp_dir/nextjs-frontend.config.toml" >/dev/null || fail 'frontend profile leaked python skill'

packet="$(python3 "$assignment" "$topology" --policy "$policy" --route scoped --agent python-backend --task-id CODEX-1 --objective 'Add one bounded backend change' --scope 'src/service.py' --write-scope 'src/service.py tests/test_service.py' --evidence 'pytest tests/test_service.py' --validation-owner root --context 'Use the active issue and current worktree.')"
printf '%s\n' "$packet" | rg -F 'Spawn Packet' >/dev/null || fail 'spawn packet missing heading'
[ "$(printf '%s\n' "$packet" | wc -l)" -le 10 ] || fail 'spawn packet exceeds ten lines'
printf '%s\n' "$packet" | rg -F 'Root only: issue topology, external writes, integration, review-of-review, closure.' >/dev/null || fail 'root boundary missing'
printf '%s\n' "$packet" | rg -F 'not injected into native spawn' >/dev/null || fail 'logical profile boundary missing'
printf '%s\n' "$packet" | rg -F 'interruption is not rollback' >/dev/null || fail 'interruption boundary missing'

invalid="$tmp_dir/invalid.toml"
cp "$topology" "$invalid"
sed -i '/name = "qa"/,+10d' "$invalid"
if python3 "$validator" "$invalid" "$catalog" "$policy" >/dev/null 2>&1; then
  fail 'validator accepted missing required logical agent'
fi

printf 'codex logical agent topology passed\n'
