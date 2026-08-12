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
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
test -f "$home/logical-agent-install-receipt.json"
for agent in orchestrator python-backend nextjs-frontend research reviewer qa; do
  python3 scripts/check-codex-logical-agent-install.py "$topology" "$catalog" --codex-home "$home" --agent "$agent" >/dev/null
done

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

scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' | rg -F "codex -p python-backend" >/dev/null
printf '\n# stale\n' >> "$home/python-backend.config.toml"
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' >/dev/null 2>&1; then
  printf 'codex logical agent install failed: stale profile was accepted\n' >&2
  exit 1
fi
printf 'codex logical agent install passed\n'
