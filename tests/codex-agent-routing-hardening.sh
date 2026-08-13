#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pass_count=0
red_count=0

run_case() {
  local case_id="$1"
  local description="$2"
  shift 2
  local output status
  output="$("$@" 2>&1)"
  status=$?
  if [ "$status" -eq 0 ]; then
    printf 'PASS %s - %s\n' "$case_id" "$description"
    pass_count=$((pass_count + 1))
  else
    printf 'RED  %s - %s\n' "$case_id" "$description" >&2
    if [ -n "$output" ]; then
      printf '     %s\n' "$(printf '%s' "$output" | tr '\n' ' ' | cut -c1-500)" >&2
    fi
    red_count=$((red_count + 1))
  fi
}

case_router_001() {
  local router="skills/governance/skill-catalog-router"
  [ -f "$router/SKILL.md" ] || { printf 'missing repo-owned %s/SKILL.md\n' "$router"; return 1; }
  [ -f "$router/references/index.tsv" ] || { printf 'missing router index\n'; return 1; }
  [ -f "$router/scripts/build_index.py" ] || { printf 'missing router index builder\n'; return 1; }
  if rg -F 'skill-catalog-h55' "$router" >/dev/null; then
    printf 'router still names the frozen historical catalog\n'
    return 1
  fi
  python3 "$router/scripts/build_index.py" --repo-root "$ROOT" --check
}

case_spawn_002() {
  local topology="adapters/runtime/codex/logical-agent-topology.toml"
  local policy="adapters/runtime/codex-collaboration/role-policy.json"
  local catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
  local index="skills/governance/skill-catalog-router/references/index.tsv"

  python3 - "$catalog" "$index" <<'PY' || return 1
import sys
import tomllib
from pathlib import Path

catalog = tomllib.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
index_ids = {
    line.split("\t", 1)[0]
    for line in Path(sys.argv[2]).read_text(encoding="utf-8").splitlines()
    if line
}
sources = {source["id"]: source for source in catalog["sources"]}
managed_ids = {
    skill_id
    for group in catalog["groups"]
    if sources[group["source"]]["classification"] == "managed-global"
    for skill_id in group["skill_ids"]
}
if managed_ids != index_ids:
    raise SystemExit(
        "managed-global manifest/index parity differs: "
        f"missing={sorted(managed_ids - index_ids)} extra={sorted(index_ids - managed_ids)}"
    )
PY

  local specialist_count=0
  local agent write_scope packet_file
  while IFS=$'\t' read -r agent write_scope; do
    packet_file="$tmp_dir/$agent.packet"
    python3 scripts/render-codex-spawn-packet.py \
      "$topology" \
      --catalog "$catalog" \
      --policy "$policy" \
      --route scoped \
      --agent "$agent" \
      --task-id "CODEX-3-T2-$agent" \
      --objective 'Prove exact assignment skill routes for every specialist' \
      --scope 'repo-owned Codex specialist routing contract' \
      --write-scope "$write_scope" \
      --evidence 'bash tests/codex-agent-routing-hardening.sh' \
      --validation-owner accelerate-root \
      --context 'CODEX-3 accepted SDD and current worktree' \
      >"$packet_file" || return 1
    python3 - "$packet_file" "$topology" "$policy" "$agent" <<'PY' || return 1
import hashlib
import json
import re
import sys
import tomllib
from pathlib import Path

packet_path, topology_path, policy_path = map(Path, sys.argv[1:4])
agent_name = sys.argv[4]
packet = packet_path.read_text(encoding="utf-8")
topology = tomllib.loads(topology_path.read_text(encoding="utf-8"))
policy = json.loads(policy_path.read_text(encoding="utf-8"))
agent = next(item for item in topology["agents"] if item["name"] == agent_name)
profile = policy["profiles"][agent["collaboration_profile"]]
expected = set(agent["required_skills"]) | set(profile["skill_allowlist"])
records = {}
pattern = re.compile(
    r"skill=(?P<skill>[a-z0-9][a-z0-9:-]*);\s*"
    r"path=(?P<path>/[^;\n]+/SKILL\.md);\s*"
    r"sha256=(?P<sha>[0-9a-f]{64})(?:;|$)"
)
for match in pattern.finditer(packet):
    records[match.group("skill")] = (Path(match.group("path")), match.group("sha"))
if set(records) != expected:
    raise SystemExit(f"assignment route records differ: expected={sorted(expected)} actual={sorted(records)}")
for skill_id, (path, expected_hash) in records.items():
    if not path.is_absolute() or not path.is_file():
        raise SystemExit(f"assignment route for {skill_id} is not an existing absolute file: {path}")
    if path.is_symlink():
        raise SystemExit(f"assignment route for {skill_id} is a symlink rather than a deployed regular file: {path}")
    actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual_hash != expected_hash:
        raise SystemExit(f"assignment route hash mismatch for {skill_id}: {actual_hash} != {expected_hash}")
PY
    specialist_count=$((specialist_count + 1))
  done < <(python3 - "$topology" "$policy" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

topology = tomllib.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
policy = json.loads(Path(sys.argv[2]).read_text(encoding="utf-8"))
for agent in topology["agents"]:
    if agent["kind"] != "specialist":
        continue
    mode = policy["profiles"][agent["collaboration_profile"]]["write_mode"]
    write_scope = "read-only" if mode == "read-only" else "bounded specialist fixture"
    print(f"{agent['name']}\t{write_scope}")
PY
  )
  [ "$specialist_count" -eq 7 ] || {
    printf 'expected 7 rendered specialists, got %s\n' "$specialist_count"
    return 1
  }
}

case_alias_003() {
  local profiles_file="$tmp_dir/catalog-profiles.txt"
  python3 scripts/render-codex-skill-profile.py \
    adapters/runtime/codex/skill-catalog-manifest.toml \
    --mode profile --list-profiles >"$profiles_file"
  python3 - "$profiles_file" <<'PY'
import sys
from pathlib import Path

actual = {line.strip() for line in Path(sys.argv[1]).read_text().splitlines() if line.strip()}
expected = {"on-demand", "superpowers-on-demand"}
if actual != expected:
    raise SystemExit(f"raw catalog profiles remain launchable: expected={sorted(expected)} actual={sorted(actual)}")
PY
  [ "$?" -eq 0 ] || return 1

  local fake_home="$tmp_dir/codex-home"
  local raw_alias_catalog="$tmp_dir/raw-alias-catalog.toml"
  python3 - adapters/runtime/codex/skill-catalog-manifest.toml "$raw_alias_catalog" <<'PY'
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text()
for profile in (
    "django-backend", "next-react-frontend", "product-browser-qa",
    "governance-review", "catalog-librarian",
):
    old = (
        f'id = "{profile}"\nsource = "r0"\nclassification = "specialist"\n'
        f'profile = "{profile}"\npublic_profile = false\nenabled_by_default = false\n'
    )
    new = (
        f'id = "{profile}"\nsource = "r0"\nclassification = "on-demand"\n'
        f'profile = "{profile}"\npublic_profile = true\nenabled_by_default = false\n'
        'recovery_route = "skill-catalog-router"\n'
    )
    if old not in text:
        raise SystemExit(f"fixture cannot expose raw catalog alias {profile}")
    text = text.replace(old, new, 1)
Path(sys.argv[2]).write_text(text)
PY
  python3 scripts/install-codex-skill-catalog.py \
    "$raw_alias_catalog" --codex-home "$fake_home" >/dev/null || return 1
  python3 scripts/install-codex-skill-catalog.py \
    adapters/runtime/codex/skill-catalog-manifest.toml \
    --codex-home "$fake_home" >/dev/null || return 1
  local stale
  for stale in django-backend next-react-frontend data-db integrations-ops product-browser-qa governance-review catalog-librarian; do
    [ ! -e "$fake_home/$stale.config.toml" ] || {
      printf 'stale raw alias was not removed: %s\n' "$stale"
      return 1
    }
  done
}

case_routes_004() {
  python3 - adapters/runtime/codex/logical-agent-topology.toml adapters/runtime/codex-collaboration/role-policy.json <<'PY'
import json
import sys
import tomllib
from pathlib import Path

topology = tomllib.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
policy = json.loads(Path(sys.argv[2]).read_text(encoding="utf-8"))
agents = {item["name"]: item for item in topology["agents"]}
expected = {
    "data-db": ("data", "data-db"),
    "integrations-ops": ("integrations-ops", "integrations-ops"),
}
for name, (role, group) in expected.items():
    agent = agents.get(name)
    if not agent:
        raise SystemExit(f"missing logical agent {name}")
    required = {
        "kind": "specialist",
        "role_family": role,
        "catalog_group": group,
        "collaboration_profile": "implementation",
        "model": "gpt-5.6-terra",
        "reasoning_effort": "medium",
        "write_mode": "bounded-write",
        "external_writes": False,
        "closure_authority": False,
    }
    for key, value in required.items():
        if agent.get(key) != value:
            raise SystemExit(f"{name}.{key}: expected={value!r} actual={agent.get(key)!r}")
    if "implementation" not in policy["role_bindings"].get(role, []):
        raise SystemExit(f"implementation profile is not bound to logical role {role}")
PY
}

case_doctrine_005() {
  python3 - <<'PY'
from pathlib import Path

files = [
    Path("agents/doctrine/capability-matrix.md"),
    Path("agents/doctrine/ontology.md"),
    Path("agents/doctrine/pooling-model.md"),
    Path("agents/doctrine/selection-policy.md"),
    Path("agents/envelopes/skill-envelopes.md"),
]
families = {
    "specification-engineer",
    "code-quality-reviewer",
    "test-engineer",
    "web-performance-auditor",
    "data-database-specialist",
    "integrations-ops-specialist",
}
missing = []
for path in files:
    text = path.read_text(encoding="utf-8")
    for family in sorted(families):
        if f"`{family}`" not in text:
            missing.append(f"{path}:{family}")
if missing:
    raise SystemExit("unreconciled family doctrine: " + ", ".join(missing))
PY
}

case_read_only_006() {
  python3 - adapters/runtime/codex-collaboration/role-policy.json <<'PY'
import json
import sys
from pathlib import Path

policy = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
templates = {
    "specification-review": Path("agents/templates/specification-engineer.md"),
    "test-strategy": Path("agents/templates/test-engineer.md"),
    "governance-audit": Path("agents/templates/governance-auditor.md"),
}
required_phrases = (
    "workspace mutation is forbidden",
    "return packet",
    "separate bounded executor assignment",
)
for profile_name, path in templates.items():
    profile = policy["profiles"][profile_name]
    if profile.get("write_mode") != "read-only":
        raise SystemExit(f"{profile_name} is no longer a read-only review profile")
    text = path.read_text(encoding="utf-8").casefold()
    missing = [phrase for phrase in required_phrases if phrase not in text]
    if missing:
        raise SystemExit(f"{path} leaves read-only artifact delivery ambiguous: missing={missing}")
PY
}

case_packet_limit_007() {
  local topology="$tmp_dir/topology-limit-eight.toml"
  sed 's/^spawn_packet_limit = .*/spawn_packet_limit = 8/' \
    adapters/runtime/codex/logical-agent-topology.toml >"$topology"
  local packet="$tmp_dir/limit-eight.packet"
  python3 scripts/render-codex-spawn-packet.py \
    "$topology" \
    --policy adapters/runtime/codex-collaboration/role-policy.json \
    --route scoped \
    --agent python-backend \
    --task-id CODEX-3-T7 \
    --objective 'Prove the configured packet limit is operational' \
    --scope 'scripts/render-codex-spawn-packet.py' \
    --write-scope 'scripts/render-codex-spawn-packet.py tests/codex-spawn-packet.sh' \
    --evidence 'bash tests/codex-spawn-packet.sh' \
    --validation-owner accelerate-root \
    --context 'CODEX-3 accepted SDD and current worktree' \
    >"$packet" || return 1
  local actual
  actual="$(wc -l <"$packet")"
  [ "$actual" -le 8 ] || {
    printf 'renderer emitted %s lines for configured limit 8\n' "$actual"
    return 1
  }
}

run_case CASE-ROUTER-001 'router is repo-owned and indexes current governed sources' case_router_001
run_case CASE-SPAWN-002 'spawn packet carries existing absolute skill paths and exact SHA256 values' case_spawn_002
run_case CASE-ALIASES-003 'raw catalog aliases are hidden and stale generated aliases are removed' case_alias_003
run_case CASE-ROUTES-004 'data-db and integrations-ops are explicit bounded logical agents' case_routes_004
run_case CASE-DOCTRINE-005 'ontology, pool, selection, compatibility and envelopes share one family set' case_doctrine_005
run_case CASE-READONLY-006 'read-only reviewers return artifacts without ambiguous workspace edits' case_read_only_006
run_case CASE-LIMIT-007 'spawn_packet_limit is consumed as an operational rendering limit' case_packet_limit_007

printf 'codex agent routing hardening: pass=%s red=%s total=7\n' "$pass_count" "$red_count"
[ "$red_count" -eq 0 ]
