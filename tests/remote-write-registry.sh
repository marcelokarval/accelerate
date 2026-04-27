#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="${ROOT}/adapters/workflow/remote-write-registry.yaml"

fail() {
  printf 'remote-write-registry failed: %s\n' "$1" >&2
  exit 1
}

[ -f "${ROOT}/core/control-plane/remote-write-registry.md" ] || fail "missing remote write contract"
[ -f "${REGISTRY}" ] || fail "missing remote write registry"

python3 - "${ROOT}" "${REGISTRY}" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
registry = Path(sys.argv[2])
text = registry.read_text()

entries = re.split(r"\n\s*- id:\s*", text)
if len(entries) <= 1:
    raise SystemExit("remote-write-registry failed: no write entries")

registered_commands = set()
for raw in entries[1:]:
    block = "id: " + raw
    values = {}
    for line in block.splitlines():
        match = re.match(r"\s*([a-z_]+):\s*(.*)\s*$", line)
        if match:
            values[match.group(1)] = match.group(2).strip()
    for key in ["id", "command", "provider", "operation", "status", "requires_opt_in", "privacy_gate", "recovery", "live_proof", "structured_write"]:
        if not values.get(key):
            raise SystemExit(f"remote-write-registry failed: missing {key} in {values.get('id', '<unknown>')}")
    command = values["command"]
    registered_commands.add(command)
    if not (root / command).is_file():
        raise SystemExit(f"remote-write-registry failed: command missing: {command}")
    if values["status"] not in {"available", "blocked", "planned"}:
        raise SystemExit(f"remote-write-registry failed: invalid status for {command}")
    if values["privacy_gate"] not in {"required", "none"}:
        raise SystemExit(f"remote-write-registry failed: invalid privacy gate for {command}")
    if values["structured_write"] not in {"yes", "no"}:
        raise SystemExit(f"remote-write-registry failed: invalid structured_write for {command}")
    if values["structured_write"] == "no" and values["status"] == "available":
        raise SystemExit(f"remote-write-registry failed: unstructured write cannot be available: {command}")
    if values["status"] == "available" and values["requires_opt_in"] == "none" and values["privacy_gate"] == "none" and values["live_proof"] == "none":
        raise SystemExit(f"remote-write-registry failed: available write lacks guard/proof: {command}")
    if values["privacy_gate"] == "required" and "artifact" in values["operation"]:
        script = (root / command).read_text()
        if "require-export-approved.sh" not in script:
            raise SystemExit(f"remote-write-registry failed: artifact write lacks privacy gate call: {command}")

known_remote_write_scripts = {
    "onboarding/local-workspace/create-github-pr-adapter.sh",
    "onboarding/local-workspace/attach-github-pr-artifact.sh",
    "onboarding/local-workspace/land-github-pr.sh",
    "onboarding/local-workspace/attach-linear-artifact.sh",
    "onboarding/local-workspace/create-linear-mcp-issue.sh",
    "onboarding/local-workspace/attach-linear-mcp-artifact.sh",
}
missing = sorted(known_remote_write_scripts - registered_commands)
if missing:
    raise SystemExit(f"remote-write-registry failed: unregistered remote write scripts: {', '.join(missing)}")

write_markers = [
    " pr create ",
    " pr comment ",
    " pr merge ",
    "commentCreate",
    "issueCreate",
    "issueUpdate",
    "linear_save_issue",
    "linear_save_comment",
    "curl -X POST",
    "curl -X PATCH",
    "curl -X PUT",
    "curl -X DELETE",
]
for script in (root / "onboarding/local-workspace").glob("*.sh"):
    rel = str(script.relative_to(root))
    if rel.endswith("validate-linear-comment-response.sh") or rel.endswith("validate-linear-issue-response.sh"):
        continue
    body = f" {script.read_text()} "
    if any(marker in body for marker in write_markers) and rel not in registered_commands:
        raise SystemExit(f"remote-write-registry failed: provider write script is not registered: {rel}")
PY

echo "remote write registry tests passed"
