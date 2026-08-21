#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT

mkdir "$home/missing-base"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home/missing-base" >/dev/null
test -f "$home/missing-base/config.toml"
python3 - "$home/missing-base/logical-agent-install-receipt.json" <<'PY'
import json
import pathlib
import sys

receipt = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert next(item for item in receipt['installed'] if item['agent'] == 'orchestrator')['changed'] is True
PY

printf '%s\n' 'model = "wrong-model"' 'model_reasoning_effort = "xhigh"' '' '[[unrelated_array]] # trailing array-table comment' 'model = "array-nested-model"' 'model_reasoning_effort = "array-nested-effort"' '' '[unrelated] # trailing table comment' 'value = "preserved"' 'model = "nested-model"' '' '[skills]' 'extra = "preserved"' 'config = [{ path = "C:\\Codex\\a\"quoted\"\\SKILL.md", enabled = true }]' > "$home/config.toml"
printf '%s\n' '' '[mcp_servers.fixture]' 'command = "fixture"' >> "$home/config.toml"
printf '# legacy additive root profile\n' > "$home/orchestrator.config.toml"
snapshot="$home/pre-install-snapshot"
mkdir "$snapshot"
cp "$home/config.toml" "$snapshot/config.toml"
cp "$home/orchestrator.config.toml" "$snapshot/orchestrator.config.toml"
for alias in "$home/config.toml" "$home/python-backend.config.toml"; do
  if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --receipt "$alias" >/dev/null 2>&1; then
    echo 'codex logical agent install failed: install receipt alias was accepted' >&2
    exit 1
  fi
done
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
test -f "$home/logical-agent-install-receipt.json"
for agent in python-backend nextjs-frontend research reviewer qa data-db integrations-ops; do
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
if config.get("skills", {}).get("extra") != "preserved" or config.get("unrelated", {}).get("value") != "preserved" or config.get("unrelated", {}).get("model") != "nested-model":
    raise SystemExit("codex logical agent install failed: unrelated TOML was not preserved")
if config.get("unrelated_array", [{}])[0].get("model") != "array-nested-model" or config.get("unrelated_array", [{}])[0].get("model_reasoning_effort") != "array-nested-effort":
    raise SystemExit("codex logical agent install failed: array-table TOML was not preserved")
if config.get("skills", {}).get("config", [])[0] != {"path": 'C:\\Codex\\a"quoted"\\SKILL.md', "enabled": True}:
    raise SystemExit("codex logical agent install failed: unmanaged skill path was not preserved")
receipt = json.loads(Path(sys.argv[2]).read_text())
retired = receipt.get("retired_profiles", [])
if len(retired) != 1 or retired[0].get("agent") != "orchestrator":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile migration missing from receipt")
backup = Path(retired[0].get("backup", ""))
if not backup.is_file() or backup.read_text() != "# legacy additive root profile\n":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile backup is unavailable")
PY

first_receipt="$home/first-install-receipt.json"
cp "$home/logical-agent-install-receipt.json" "$first_receipt"
for alias in "$home/config.toml" "$home/python-backend.config.toml" "$first_receipt"; do
  if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --rollback --receipt "$first_receipt" --rollback-receipt "$alias" >/dev/null 2>&1; then
    echo 'codex logical agent install failed: rollback receipt alias was accepted' >&2
    exit 1
  fi
done
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --rollback --receipt "$home/config.toml" --rollback-receipt "$home/alias-receipt.json" >/dev/null 2>&1; then
  echo 'codex logical agent install failed: install receipt alias was accepted for rollback' >&2
  exit 1
fi
backup_count_before="$(find "$home/backups" -mindepth 1 -maxdepth 1 -type d | wc -l)"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
python3 - "$home/logical-agent-install-receipt.json" <<'PY'
import json
import pathlib
import sys

receipt = json.loads(pathlib.Path(sys.argv[1]).read_text())
assert receipt['changed'] is False
assert receipt['rollback_directory'] is None
PY
[[ "$(find "$home/backups" -mindepth 1 -maxdepth 1 -type d | wc -l)" == "$backup_count_before" ]] || {
  printf 'codex logical agent install failed: no-op created backup\n' >&2
  exit 1
}
rollback_receipt="$home/logical-agent-rollback-receipt.json"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --rollback --receipt "$first_receipt" --rollback-receipt "$rollback_receipt" >/dev/null
cmp -s "$snapshot/config.toml" "$home/config.toml"
cmp -s "$snapshot/orchestrator.config.toml" "$home/orchestrator.config.toml"
for agent in python-backend nextjs-frontend research reviewer qa data-db integrations-ops; do
  [[ ! -e "$home/$agent.config.toml" ]] || {
    printf 'codex logical agent install failed: rollback retained new profile %s\n' "$agent" >&2
    exit 1
  }
done
python3 - "$rollback_receipt" <<'PY'
import json
import pathlib
import sys

assert json.loads(pathlib.Path(sys.argv[1]).read_text())['mode'] == 'rollback'
PY
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null

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
echo '# tampered owned target' >>"$home/config.toml"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --rollback --rollback-receipt "$home/tampered-current-rollback.json" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: rollback accepted tampered current profile\n' >&2
  exit 1
fi
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
backup_path="$(python3 - "$home/logical-agent-install-receipt.json" <<'PY'
import json
import pathlib
import sys

for entry in json.loads(pathlib.Path(sys.argv[1]).read_text())['owned_files']:
    if entry['backup']:
        print(entry['backup'])
        break
else:
    raise SystemExit('no backup available for tamper test')
PY
)"
echo 'tampered backup' >>"$backup_path"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" --rollback --rollback-receipt "$home/tampered-backup-rollback.json" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: rollback accepted tampered backup\n' >&2
  exit 1
fi
printf 'codex logical agent install passed\n'
