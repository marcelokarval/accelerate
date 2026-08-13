#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'codex logical agent topology failed: %s\n' "$1" >&2
  exit 1
}

run_case() {
  local case_id="$1"
  shift
  "$@"
  printf 'PASS %s\n' "$case_id"
}

topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
policy="adapters/runtime/codex-collaboration/role-policy.json"
validator="scripts/validate-codex-logical-agent-topology.py"
renderer="scripts/render-codex-logical-agent.py"
assignment="scripts/render-codex-spawn-packet.py"
omo_sdd="planning/architecture/2026-08-13-omo-slim-agent-provenance-sdd.md"

check_omo_mapping() {
  python3 - "$topology" "$omo_sdd" <<'PY'
import sys
import tomllib
from pathlib import Path

expected = {
    "orchestrator": ("orchestrator", ["council"], "adapted-absorbed"),
    "python-backend": ("fixer", [], "adapted-specialized"),
    "nextjs-frontend": ("fixer", ["designer"], "adapted-partial"),
    "research": ("librarian", ["explorer"], "adapted-composite"),
    "reviewer": ("oracle", ["council"], "adapted-composite"),
    "qa": ("observer", ["oracle"], "adapted-partial"),
    "data-db": ("fixer", [], "adapted-specialized"),
    "integrations-ops": ("fixer", [], "adapted-specialized"),
}
topology = tomllib.loads(Path(sys.argv[1]).read_text())
sdd = Path(sys.argv[2]).read_text()
actual = {
    agent["name"]: (
        agent["omo_slim_primary_role"],
        agent["omo_slim_secondary_roles"],
        agent["omo_slim_equivalence"],
    )
    for agent in topology["agents"]
}
if actual != expected:
    raise SystemExit(f"OMO-Slim mapping mismatch: {actual!r}")
for name, (primary, secondary, equivalence) in expected.items():
    secondary_cell = ", ".join(f"`{role}`" for role in secondary) if secondary else "none"
    row = f"| `{name}` | `{primary}` | {secondary_cell} | `{equivalence}` |"
    if row not in sdd:
        raise SystemExit(f"OMO-Slim SDD mapping mismatch: {row}")
for agent in topology["agents"]:
    note = agent.get("omo_slim_adaptation")
    if not isinstance(note, str) or len(note.split()) < 5:
        raise SystemExit(f"missing substantive OMO-Slim adaptation for {agent.get('name')}")
PY
}

check_omo_role_set() {
  python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path

expected = ["orchestrator", "oracle", "librarian", "explorer", "designer", "fixer", "observer", "council"]
topology = tomllib.loads(Path(sys.argv[1]).read_text())
if topology["omo_slim_builtin_roles"] != expected:
    raise SystemExit("OMO-Slim built-in role denominator is not exact")
if topology.get("omo_slim_provenance") != "adapted-influence-not-runtime-authority":
    raise SystemExit("OMO-Slim provenance boundary is missing")
PY
}

check_omo_negative_fixtures() {
  local fixture_dir missing unknown duplicate
  fixture_dir="$(mktemp -d)"
  missing="$fixture_dir/missing.toml"
  unknown="$fixture_dir/unknown.toml"
  duplicate="$fixture_dir/duplicate.toml"
  cp "$topology" "$missing"
  cp "$topology" "$unknown"
  cp "$topology" "$duplicate"
  sed -i '/omo_slim_primary_role = "fixer"/d' "$missing"
  sed -i '0,/omo_slim_primary_role = "fixer"/s//omo_slim_primary_role = "unknown-donor"/' "$unknown"
  sed -i 's/"observer", "council"/"observer", "council", "council"/' "$duplicate"
  if python3 "$validator" "$missing" "$catalog" "$policy" >/dev/null 2>&1; then
    fail 'validator accepted missing OMO-Slim provenance'
  fi
  if python3 "$validator" "$unknown" "$catalog" "$policy" >/dev/null 2>&1; then
    fail 'validator accepted unknown OMO-Slim role'
  fi
  if python3 "$validator" "$duplicate" "$catalog" "$policy" >/dev/null 2>&1; then
    fail 'validator accepted a duplicated OMO-Slim built-in role'
  fi
  rm -rf "$fixture_dir"
}

check_omo_agents_view() {
  local global_agents="${CODEX_GLOBAL_AGENTS:-}"
  rg -F '## OMO-Slim Provenance Map' AGENTS.md >/dev/null || fail 'AGENTS.md lacks OMO-Slim provenance map'
  rg -F 'adapters/runtime/codex/logical-agent-topology.toml' AGENTS.md >/dev/null || fail 'AGENTS.md lacks topology authority pointer'
  if [ -n "$global_agents" ]; then
    [ -f "$global_agents" ] || fail "configured global AGENTS.md does not exist: $global_agents"
    rg -F '## OMO-Slim Agent Provenance' "$global_agents" >/dev/null || fail 'global AGENTS.md lacks OMO-Slim provenance map'
  fi
  local row
  while IFS= read -r row; do
    rg -F "$row" AGENTS.md >/dev/null || fail "repo AGENTS.md lacks exact OMO-Slim row: $row"
    if [ -n "$global_agents" ]; then
      rg -F "$row" "$global_agents" >/dev/null || fail "global AGENTS.md lacks exact OMO-Slim row: $row"
    fi
  done <<'ROWS'
| `orchestrator` | `orchestrator` + absorbed `council` | Root orchestrates and closes; bounded independent reviewers supply council behavior. |
| `python-backend` | specialized `fixer` | Bounded Python/Django implementation. |
| `nextjs-frontend` | `fixer` + partial `designer` | Frontend implementation; design behavior requires accepted design authority. |
| `research` | `librarian` + `explorer` | Current-source research plus read-only repository discovery. |
| `reviewer` | `oracle` + bounded `council` | Skeptical review; root retains review-of-review. |
| `qa` | partial `observer` + `oracle` | Visual/media evidence inspection plus skeptical review; broader QA/runtime/browser proof is Codex-native. |
| `data-db` | specialized `fixer` | Bounded database design and SQL implementation. |
| `integrations-ops` | specialized `fixer` | Bounded MCP, integration, cache, payment, and operational implementation. |
ROWS
}

check_omo_renderer_compatibility() {
  local output
  output="$(mktemp)"
  python3 "$renderer" "$topology" "$catalog" --agent python-backend --output "$output"
  rg -F 'python-pro/SKILL.md", enabled = true' "$output" >/dev/null || fail 'OMO-Slim metadata broke profile rendering'
  ! rg -F 'omo_slim_' "$output" >/dev/null || fail 'donor provenance leaked into generated Codex profile'
  rm -f "$output"
}

for path in "$topology" "$catalog" "$policy" "$validator" "$renderer" "$assignment" "$omo_sdd"; do
  [ -f "$path" ] || fail "missing $path"
done

python3 "$validator" "$topology" "$catalog" "$policy"
run_case CASE-OMO-001 check_omo_mapping
run_case CASE-OMO-002 check_omo_role_set
run_case CASE-OMO-003 check_omo_negative_fixtures
run_case CASE-OMO-004 check_omo_agents_view
run_case CASE-OMO-005 check_omo_renderer_compatibility
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

for agent in python-backend nextjs-frontend research reviewer qa data-db integrations-ops; do
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
rg -F 'postgresql/SKILL.md", enabled = true' "$tmp_dir/data-db.config.toml" >/dev/null || fail 'data profile missing'
! rg -F 'stripe-integration/SKILL.md' "$tmp_dir/data-db.config.toml" >/dev/null || fail 'data profile leaked integration skill'
rg -F 'native-mcp/SKILL.md", enabled = true' "$tmp_dir/integrations-ops.config.toml" >/dev/null || fail 'integrations profile missing'
! rg -F 'postgresql/SKILL.md' "$tmp_dir/integrations-ops.config.toml" >/dev/null || fail 'integrations profile leaked data skill'

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
