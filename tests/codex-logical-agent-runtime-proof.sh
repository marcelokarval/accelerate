#!/usr/bin/env bash
set -euo pipefail

# Opt-in because it executes the installed Codex binary. It never writes to the
# user Codex home: profiles are rendered into a disposable CODEX_HOME.
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
python3 scripts/render-codex-skill-profile.py "$catalog" --mode global --output "$temporary/config.toml"
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
while IFS= read -r agent; do
  if [ "$agent" = "orchestrator" ]; then
    CODEX_HOME="$temporary" codex debug prompt-input '' >"$temporary/$agent.json"
  else
    CODEX_HOME="$temporary" codex -p "$agent" debug prompt-input '' >"$temporary/$agent.json"
  fi
done < <(python3 - "$topology" <<'PY'
import sys
import tomllib
from pathlib import Path
for agent in tomllib.loads(Path(sys.argv[1]).read_text())["agents"]:
    print(agent["name"])
PY
)

python3 - "$topology" "$temporary" <<'PY'
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
temporary = Path(sys.argv[2])
for agent in topology["agents"]:
    name = agent["name"]
    visible = skills(temporary / f"{name}.json")
    missing = set(agent["required_skills"]) - visible
    if missing:
        raise SystemExit(f"{name} is missing declared skills: {sorted(missing)}")

forbidden = {
    "orchestrator": {"django-pro", "nextjs-app-router-patterns"},
    "python-backend": {"nextjs-app-router-patterns"},
    "nextjs-frontend": {"django-pro"},
    "data-db": {"nextjs-app-router-patterns"},
    "integrations-ops": {"django-pro", "nextjs-app-router-patterns"},
    "research": {"django-pro", "nextjs-app-router-patterns"},
    "reviewer": {"django-pro", "nextjs-app-router-patterns"},
    "qa": {"django-pro", "nextjs-app-router-patterns"},
}
for name, denied in forbidden.items():
    leaked = denied & skills(temporary / f"{name}.json")
    if leaked:
        raise SystemExit(f"{name} exposes forbidden specialist skills: {sorted(leaked)}")
PY

echo "codex logical agent runtime proof passed"
