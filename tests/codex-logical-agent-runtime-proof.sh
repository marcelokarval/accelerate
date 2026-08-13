#!/usr/bin/env bash
set -euo pipefail

# Opt-in because it executes the installed Codex binary and one minimal model
# turn per logical context. Static profile rendering uses a disposable
# CODEX_HOME; effective startup proof reads the post-restart installed home
# with ephemeral, read-only turns so host-injected skills remain observable.
if [ "${CODEX_RUNTIME_PROOF:-0}" != "1" ]; then
  echo "codex logical agent runtime proof skipped (set CODEX_RUNTIME_PROOF=1)"
  exit 0
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
command -v codex >/dev/null || { echo "codex binary unavailable" >&2; exit 1; }

temporary="$(mktemp -d "${ROOT}/.tmp/codex-logical-agent-runtime.XXXXXX")"
trap 'rm -rf "$temporary"' EXIT
topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
catalog_skills_dir="$(python3 - "$catalog" <<'PY'
import sys
import tomllib
from pathlib import Path
document = tomllib.loads(Path(sys.argv[1]).read_text())
print(next(item["base_path"] for item in document["sources"] if item["id"] == "r0"))
PY
)"

ln -s "$catalog_skills_dir" "$temporary/skills"
python3 scripts/install-codex-skill-catalog.py "$catalog" --codex-home "$temporary" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$temporary" >/dev/null
python3 - "$temporary/config.toml" "$temporary/orchestrator.config.toml" <<'PY'
import sys
import tomllib
from pathlib import Path

config = tomllib.loads(Path(sys.argv[1]).read_text())
if config.get("model") != "gpt-5.6-sol" or config.get("model_reasoning_effort") != "medium":
    raise SystemExit("root orchestrator defaults were not installed")
if Path(sys.argv[2]).exists():
    raise SystemExit("root orchestrator was installed as an additive profile")
PY
live_home="${CODEX_RUNTIME_HOME:-${CODEX_HOME:-${HOME}/.codex}}"
test -f "$live_home/config.toml" || { echo "installed Codex runtime config is unavailable" >&2; exit 1; }
CODEX_HOME="$live_home" bash scripts/check-global-skill-mirror.sh >/dev/null
while IFS= read -r agent; do
  if [ "$agent" = "orchestrator" ]; then
    CODEX_HOME="$live_home" codex debug prompt-input '' >"$temporary/$agent.json"
  else
    CODEX_HOME="$live_home" codex -p "$agent" debug prompt-input '' >"$temporary/$agent.json"
  fi
done < <(python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path
for agent in tomllib.loads(Path(sys.argv[1]).read_text())["agents"]:
    print(agent["name"])
PY
)

while IFS= read -r agent; do
  runtime_args=()
  if [ "$agent" != "orchestrator" ]; then
    runtime_args=(-p "$agent")
  fi
  CODEX_HOME="$live_home" codex "${runtime_args[@]}" exec \
    --ephemeral --json -s read-only -C "$ROOT" \
    'Do not call tools or read files. Reply with exactly: CODEX_RUNTIME_READY' \
    >"$temporary/$agent.runtime.jsonl"
  python3 - "$agent" "$temporary/$agent.runtime.jsonl" <<'PY'
import json
import sys
from pathlib import Path

agent = sys.argv[1]
items = [json.loads(line) for line in Path(sys.argv[2]).read_text().splitlines() if line.strip()]
messages = [
    item.get("item", {}).get("text")
    for item in items
    if item.get("type") == "item.completed" and item.get("item", {}).get("type") == "agent_message"
]
errors = [
    item.get("item", {}).get("message", "")
    for item in items
    if item.get("type") == "item.completed" and item.get("item", {}).get("type") == "error"
]
if messages != ["CODEX_RUNTIME_READY"]:
    raise SystemExit(f"{agent} did not return the exact runtime readiness token: {messages}")
if any("Skill descriptions were shortened" in message for message in errors):
    raise SystemExit(f"{agent} exceeded the skills context budget")
if errors:
    raise SystemExit(f"{agent} emitted runtime errors: {errors}")
PY
done < <(python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path
for agent in tomllib.loads(Path(sys.argv[1]).read_text())["agents"]:
    print(agent["name"])
PY
)

python3 - "$topology" "$catalog" "$temporary" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

def skills(path: str) -> set[str]:
    for message in json.loads(Path(path).read_text()):
        for content in message.get("content", []):
            text = content.get("text", "")
            if text.startswith("<skills_instructions>"):
                return {
                    line[2:].partition(":")[0]
                    for line in text.splitlines()
                    if line.startswith("- ") and ": " in line
                }
    raise SystemExit(f"skills instruction block missing from {path}")

topology = tomllib.loads(Path(sys.argv[1]).read_text())
catalog = tomllib.loads(Path(sys.argv[2]).read_text())
temporary = Path(sys.argv[3])
groups = {group["id"]: group for group in catalog["groups"]}
root_visible = set(groups["root-core"]["skill_ids"])
for group in catalog["groups"]:
    if group["classification"] == "host-injected" and group["enabled_by_default"]:
        prefix = group.get("identifier_prefix", "")
        root_visible |= {f"{prefix}{skill_id}" for skill_id in group["skill_ids"]}
for agent in topology["agents"]:
    name = agent["name"]
    visible = skills(temporary / f"{name}.json")
    expected = set(root_visible)
    if agent["kind"] == "specialist":
        group = groups[agent["catalog_group"]]
        prefix = group.get("identifier_prefix", "")
        expected |= {f"{prefix}{skill_id}" for skill_id in group["skill_ids"]}
    if visible != expected:
        raise SystemExit(
            f"{name} effective inventory drifted: "
            f"missing={sorted(expected - visible)} extra={sorted(visible - expected)}"
        )
PY

echo "codex logical agent runtime proof passed"
