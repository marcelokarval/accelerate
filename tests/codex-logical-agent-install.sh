#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
topology="adapters/runtime/codex/logical-agent-topology.toml"
catalog="adapters/runtime/codex/skill-catalog-manifest.toml"
home="$(mktemp -d)"
outside="$(mktemp -d)"
trap 'rm -rf "$home" "$outside"' EXIT

snapshot_home() {
  local output="$1"
  python3 - "$home" "$output" <<'PY'
import hashlib
import json
import os
import stat
import sys
from pathlib import Path

home = Path(sys.argv[1])
state = []
for path in sorted(home.rglob("*")):
    relative = path.relative_to(home)
    if relative == Path(".codex-runtime-mutation.lock"):
        continue
    metadata = path.lstat()
    entry = {"path": str(relative), "mode": stat.S_IMODE(metadata.st_mode)}
    if stat.S_ISREG(metadata.st_mode):
        entry["kind"] = "file"
        entry["sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
    elif stat.S_ISDIR(metadata.st_mode):
        entry["kind"] = "directory"
    elif stat.S_ISLNK(metadata.st_mode):
        entry["kind"] = "symlink"
        entry["target"] = os.readlink(path)
    else:
        entry["kind"] = "other"
    state.append(entry)
Path(sys.argv[2]).write_text(json.dumps(state, sort_keys=True, separators=(",", ":")) + "\n")
PY
}

mkdir "$home/missing-base"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home/missing-base" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: missing global base was accepted\n' >&2
  exit 1
fi

printf '# pre-existing permissive config mode\n' >"$home/config.toml"
chmod 0664 "$home/config.toml"
(umask 000; python3 scripts/install-codex-skill-catalog.py "$catalog" --codex-home "$home" >/dev/null)
sed -i '1i model = "wrong-model"\nmodel_reasoning_effort = "xhigh"\n' "$home/config.toml"
printf '\n[mcp_servers.fixture]\ncommand = "fixture"\n' >> "$home/config.toml"
printf '# legacy additive root profile\n' > "$home/orchestrator.config.toml"
(umask 000; python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null)
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
import hashlib
import sys
import stat
import tomllib
from pathlib import Path

config = tomllib.loads(Path(sys.argv[1]).read_text())
if config.get("mcp_servers", {}).get("fixture", {}).get("command") != "fixture":
    raise SystemExit("codex logical agent install failed: unmanaged MCP config was not preserved")
home = Path(sys.argv[1]).resolve().parent
private_files = [
    home / "config.toml",
    home / "on-demand.config.toml",
    home / "superpowers-on-demand.config.toml",
    home / "skill-catalog-install-receipt.json",
    home / "logical-agent-install-receipt.json",
]
private_files.extend(home / f"{agent}.config.toml" for agent in (
    "python-backend", "nextjs-frontend", "research", "reviewer", "qa",
    "data-db", "integrations-ops",
))
for path in private_files:
    mode = stat.S_IMODE(path.stat().st_mode)
    if mode != 0o600:
        raise SystemExit(f"codex logical agent install failed: {path.name} mode is {mode:04o}, expected 0600")
receipt = json.loads(Path(sys.argv[2]).read_text())
if receipt.get("schema_version") != 2 or receipt.get("install_identity") != "codex-logical-agent-profiles":
    raise SystemExit("codex logical agent install failed: logical receipt is not exact schema v2")
installed = {entry.get("agent"): entry for entry in receipt.get("installed", [])}
expected_agents = {
    "orchestrator", "python-backend", "nextjs-frontend", "research",
    "reviewer", "qa", "data-db", "integrations-ops",
}
if set(installed) != expected_agents:
    raise SystemExit("codex logical agent install failed: logical receipt profile set is incomplete")
for agent, entry in installed.items():
    target = home / ("config.toml" if agent == "orchestrator" else f"{agent}.config.toml")
    expected_provenance = "logical-orchestrator-defaults" if agent == "orchestrator" else "logical-agent-render"
    if Path(entry.get("target", "")) != target or entry.get("provenance") != expected_provenance:
        raise SystemExit(f"codex logical agent install failed: invalid ownership record for {agent}")
    if entry.get("sha256") != hashlib.sha256(target.read_bytes()).hexdigest():
        raise SystemExit(f"codex logical agent install failed: stale receipt digest for {agent}")
retired = receipt.get("retired_profiles", [])
if len(retired) != 1 or retired[0].get("agent") != "orchestrator":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile migration missing from receipt")
backup = Path(retired[0].get("backup", ""))
if not backup.is_file() or backup.read_text() != "# legacy additive root profile\n":
    raise SystemExit("codex logical agent install failed: legacy orchestrator profile backup is unavailable")
if stat.S_IMODE(backup.stat().st_mode) != 0o600:
    raise SystemExit("codex logical agent install failed: history backup is not private mode 0600")
PY

# G10-F2: logical receipt authority must also have a single filesystem
# identity; a second hardlink is rejected before no-op or reconciliation.
ln "$home/logical-agent-install-receipt.json" "$outside/logical-receipt-hardlink-peer.json"
snapshot_home "$outside/g10-f2-logical-before.json"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$home" >"$outside/g10-f2-logical.out" 2>&1; then
  printf 'codex logical agent install failed: hardlinked logical receipt was accepted\n' >&2
  exit 1
fi
snapshot_home "$outside/g10-f2-logical-after.json"
cmp -s "$outside/g10-f2-logical-before.json" "$outside/g10-f2-logical-after.json" || {
  printf 'codex logical agent install failed: hardlinked logical receipt rejection mutated state\n' >&2
  exit 1
}
unlink "$outside/logical-receipt-hardlink-peer.json"

# G8-F1: a structurally plausible receipt must not authorize a no-op when its
# rollback history escapes CODEX_HOME/backups.
cp "$home/logical-agent-install-receipt.json" "$outside/original-logical-receipt.json"
mkdir "$outside/escaped-logical-backups"
chmod 0700 "$outside/escaped-logical-backups"
python3 - "$home/logical-agent-install-receipt.json" "$outside/escaped-logical-backups" <<'PY'
import json
import shutil
import sys
from pathlib import Path

path = Path(sys.argv[1])
outside = Path(sys.argv[2]).resolve()
receipt = json.loads(path.read_text())
for collection in (receipt["installed"], receipt["retired_profiles"]):
    for entry in collection:
        if entry.get("backup") is None:
            continue
        source = Path(entry["backup"])
        target = outside / source.name
        shutil.copy2(source, target)
        entry["backup"] = str(target)
receipt["rollback_directory"] = str(outside)
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
snapshot_home "$outside/g8-f1-before.json"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$home" >"$outside/g8-f1.out" 2>&1; then
  printf 'codex logical agent install failed: outside rollback receipt was accepted\n' >&2
  exit 1
fi
snapshot_home "$outside/g8-f1-after.json"
cmp -s "$outside/g8-f1-before.json" "$outside/g8-f1-after.json" || {
  printf 'codex logical agent install failed: outside rollback receipt rejection mutated governed state\n' >&2
  exit 1
}
cp "$outside/original-logical-receipt.json" "$home/logical-agent-install-receipt.json"

# G9-F1: every history backup is target-bound and private. Each hostile variant
# starts from the same valid standalone install and must fail without mutation.
cp -a "$home" "$outside/g9-pristine-home"
restore_g9_home() {
  rm -rf -- "$home"
  cp -a "$outside/g9-pristine-home" "$home"
}
for scenario in rename swap wrong-suffix mode0666 hardlink symlink missing outside rollback-identity; do
  restore_g9_home
  python3 - "$home/logical-agent-install-receipt.json" "$scenario" "$outside" <<'PY'
import json
import os
import sys
from pathlib import Path

path = Path(sys.argv[1])
scenario = sys.argv[2]
outside = Path(sys.argv[3])
receipt = json.loads(path.read_text())
entries = [
    entry
    for collection in (receipt["installed"], receipt["retired_profiles"])
    for entry in collection
    if entry.get("backup") is not None
]
first = entries[0]
source = Path(first["backup"])
if scenario == "rename":
    mutated = source.with_name("renamed-logical-backup.bin")
    source.rename(mutated)
    first["backup"] = str(mutated)
elif scenario == "swap":
    first["backup"], entries[1]["backup"] = entries[1]["backup"], first["backup"]
elif scenario == "wrong-suffix":
    mutated = source.with_name(source.name + ".bak")
    source.rename(mutated)
    first["backup"] = str(mutated)
elif scenario == "mode0666":
    os.chmod(source, 0o666)
elif scenario == "hardlink":
    os.link(source, outside / "g9-hardlink-peer")
elif scenario == "symlink":
    payload = source.with_name(".g9-symlink-payload")
    source.rename(payload)
    source.symlink_to(payload.name)
elif scenario == "missing":
    source.unlink()
elif scenario == "outside":
    outside_directory = outside / "g9-outside-backup"
    outside_directory.mkdir(mode=0o700, exist_ok=True)
    mutated = outside_directory / source.name
    source.rename(mutated)
    first["backup"] = str(mutated)
elif scenario == "rollback-identity":
    alternate = path.parent / "backups" / "logical-agents-alternate"
    alternate.mkdir(mode=0o700)
    receipt["rollback_directory"] = str(alternate)
else:
    raise SystemExit(f"unknown G9 scenario: {scenario}")
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
  snapshot_home "$outside/g9-$scenario-before.json"
  if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
    --codex-home "$home" >"$outside/g9-$scenario.out" 2>&1; then
    printf 'codex logical agent install failed: %s backup adversarial was accepted\n' "$scenario" >&2
    exit 1
  fi
  snapshot_home "$outside/g9-$scenario-after.json"
  cmp -s "$outside/g9-$scenario-before.json" "$outside/g9-$scenario-after.json" || {
    printf 'codex logical agent install failed: %s backup rejection mutated governed state\n' "$scenario" >&2
    exit 1
  }
  if python3 scripts/install-codex-skill-catalog.py "$catalog" \
    --codex-home "$home" --logical-topology "$topology" \
    >"$outside/g9-catalog-$scenario.out" 2>&1; then
    printf 'codex logical agent install failed: catalog consumer accepted %s logical backup adversarial\n' "$scenario" >&2
    exit 1
  fi
  snapshot_home "$outside/g9-catalog-$scenario-after.json"
  cmp -s "$outside/g9-$scenario-before.json" "$outside/g9-catalog-$scenario-after.json" || {
    printf 'codex logical agent install failed: catalog %s backup rejection mutated governed state\n' "$scenario" >&2
    exit 1
  }
  rm -f -- "$outside/g9-hardlink-peer"
  rm -rf -- "$outside/g9-outside-backup"
done
restore_g9_home
snapshot_home "$outside/g9-valid-before.json"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
snapshot_home "$outside/g9-valid-after.json"
cmp -s "$outside/g9-valid-before.json" "$outside/g9-valid-after.json" || {
  printf 'codex logical agent install failed: valid standalone history was not idempotent\n' >&2
  exit 1
}

# Combined sync receipts intentionally have no standalone backup history. That
# exact null-history v2 shape must remain a byte-idempotent valid state.
python3 - "$home/logical-agent-install-receipt.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
receipt = json.loads(path.read_text())
for entry in receipt["installed"]:
    entry["backup"] = None
receipt["retired_profiles"] = []
receipt["rollback_directory"] = None
path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
PY
snapshot_home "$outside/g9-null-before.json"
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null
snapshot_home "$outside/g9-null-after.json"
cmp -s "$outside/g9-null-before.json" "$outside/g9-null-after.json" || {
  printf 'codex logical agent install failed: valid null-history sync receipt was not idempotent\n' >&2
  exit 1
}
restore_g9_home

# G8-F2: an invalid receipt target must fail before stale profile healing,
# backup creation, or any other governed mutation.
cp "$home/logical-agent-install-receipt.json" "$outside/receipt-target-restore.json"
cp "$home/python-backend.config.toml" "$outside/profile-restore.toml"
rm "$home/logical-agent-install-receipt.json"
mkdir "$home/logical-agent-install-receipt.json"
printf '\n# stale before invalid receipt target\n' >>"$home/python-backend.config.toml"
snapshot_home "$outside/g8-f2-before.json"
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" \
  --codex-home "$home" >"$outside/g8-f2.out" 2>&1; then
  printf 'codex logical agent install failed: directory receipt target was accepted\n' >&2
  exit 1
fi
snapshot_home "$outside/g8-f2-after.json"
cmp -s "$outside/g8-f2-before.json" "$outside/g8-f2-after.json" || {
  printf 'codex logical agent install failed: invalid receipt target caused partial mutation\n' >&2
  exit 1
}
rmdir "$home/logical-agent-install-receipt.json"
cp "$outside/receipt-target-restore.json" "$home/logical-agent-install-receipt.json"
cp "$outside/profile-restore.toml" "$home/python-backend.config.toml"

python3 - "$home/config.toml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
body = path.read_text()
injection = '  { path = "/home/marcelo-karval/.codex/skills/nextjs-app-router-patterns/SKILL.md", enabled = true },\n'
path.write_text(body.replace("config = [\n", "config = [\n" + injection, 1))
PY
stale_output="$home/stale-catalog-check.out"
if python3 scripts/check-codex-logical-agent-install.py "$topology" "$catalog" \
  --codex-home "$home" --agent python-backend >"$stale_output" 2>&1; then
  printf 'codex logical agent install failed: checker accepted stale global catalog\n' >&2
  exit 1
fi
if rg -F 'Traceback' "$stale_output" >/dev/null; then
  printf 'codex logical agent install failed: checker leaked a traceback for expected drift\n' >&2
  exit 1
fi
rg -F 'Codex skill catalog install check failed' "$stale_output" >/dev/null || {
  printf 'codex logical agent install failed: checker omitted the governed catalog diagnostic\n' >&2
  exit 1
}
if python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null 2>&1; then
  printf 'codex logical agent install failed: re-enabled specialist base skill was accepted\n' >&2
  exit 1
fi
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' >/dev/null 2>&1; then
  printf 'codex logical agent install failed: launcher accepted re-enabled specialist base skill\n' >&2
  exit 1
fi
python3 scripts/install-codex-skill-catalog.py "$catalog" --codex-home "$home" >/dev/null
python3 scripts/install-codex-logical-agents.py "$topology" "$catalog" --codex-home "$home" >/dev/null

scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' | rg -F "codex -p python-backend" >/dev/null
printf '\n# stale\n' >> "$home/python-backend.config.toml"
if scripts/codex-logical-agent.sh --codex-home "$home" --dry-run python-backend debug prompt-input '' >/dev/null 2>&1; then
  printf 'codex logical agent install failed: stale profile was accepted\n' >&2
  exit 1
fi
printf 'codex logical agent install passed\n'
