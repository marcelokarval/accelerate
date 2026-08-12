#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT

mkdir "$home/missing-base"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home/missing-base" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: missing global base was accepted\n' >&2
  exit 1
fi

python3 scripts/render-codex-skill-profile.py "$catalog" --mode global --output "$home/config.toml"
sed -i '1i model = "wrong-model"\nmodel_reasoning_effort = "xhigh"\n' "$home/config.toml"
printf '\n[mcp_servers.fixture]\ncommand = "fixture"\n' >> "$home/config.toml"
printf '# legacy additive root profile\n' > "$home/orchestrator.config.toml"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
test -f "$home/logical-agent-install-receipt.json"
for agent in python-backend nextjs-frontend research reviewer qa; do
  python3 scripts/check-codex-logical-agent-install.py "$topology" "$catalog" --codex-home "$home" --agent "$agent" >/dev/null
done
scripts/codex-logical-agent.sh --codex-home "$home" --dry-run orchestrator debug prompt-input '' | rg -F "codex debug prompt-input" >/dev/null
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run orchestrator debug prompt-input '' | rg -F -- '-p orchestrator' >/dev/null; then
  printf 'codex logical agent install failed: orchestrator launcher used a profile\n' >&2
  exit 1
fi
! test -e "$home/orchestrator.config.toml" || { printf 'codex logical agent install failed: orchestrator profile still exists\n' >&2; exit 1; }
rg -F 'model = "gpt-5.6-sol"' "$home/config.toml" >/dev/null || { printf 'codex logical agent install failed: default orchestrator model missing\n' >&2; exit 1; }
rg -F 'model_reasoning_effort = "medium"' "$home/config.toml" >/dev/null || { printf 'codex logical agent install failed: default orchestrator effort missing\n' >&2; exit 1; }

python3 - "$home/config.toml" "$home/logical-agent-install-receipt.json" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

config = tomllib.loads(Path(sys.argv[1]).read_text())
if config.get("mcp_servers", {}).get("fixture", {}).get("command") != "fixture":
    raise SystemExit("codex logical agent install failed: unmanaged MCP config was not preserved")
receipt = json.loads(Path(sys.argv[2]).read_text())
retired = receipt.get("retired_profiles", [])
if len(retired) != 1 or retired[0].get("agent") != "orchestrator":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile migration missing from receipt")
backup = Path(retired[0].get("backup", ""))
if not backup.is_file() or backup.read_text() != "# legacy additive root profile\n":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile backup is unavailable")
PY

python3 - "$home/config.toml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
body = path.read_text()
injection = '  { path = "/home/marcelo-karval/.codex/skills/nextjs-app-router-patterns/SKILL.md", enabled = true },\n'
path.write_text(body.replace("]\n", injection + "]\n"))
PY
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: re-enabled specialist base skill was accepted\n' >&2
  exit 1
fi
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' >/dev/null 2>&1; then
  printf 'codex logical agent install failed: launcher accepted re-enabled specialist base skill\n' >&2
  exit 1
fi
python3 scripts/render-codex-skill-profile.py "$catalog" --mode global --output "$home/config.toml"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null

scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' | rg -F "codex -p python-backend" >/dev/null
printf '\n# stale\n' >> "$home/python-backend.config.toml"
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' >/dev/null 2>&1; then
  printf 'codex logical agent install failed: stale profile was accepted\n' >&2
  exit 1
fi
printf 'codex logical agent install passed\n'
