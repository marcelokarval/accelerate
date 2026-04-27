#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="${ROOT}/adapters/workflow/remote-write-registry.yaml"

python3 - "${ROOT}" "${REGISTRY}" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
registry_text = Path(sys.argv[2]).read_text()

def fail(message: str) -> None:
    print(f"manifest-truth-gate failed: {message}", file=sys.stderr)
    raise SystemExit(1)

def parse_yamlish(path: Path) -> dict[str, str]:
    values = {}
    for line in path.read_text().splitlines():
        match = re.match(r"^([a-zA-Z0-9_]+):\s*(.*)$", line)
        if match:
            values[match.group(1)] = match.group(2).strip()
    return values

registry_by_command = {}
for raw in re.split(r"\n\s*- id:\s*", registry_text)[1:]:
    block = "id: " + raw
    values = {}
    for line in block.splitlines():
        match = re.match(r"\s*([a-z_]+):\s*(.*)\s*$", line)
        if match:
            values[match.group(1)] = match.group(2).strip()
    registry_by_command[values.get("command", "")] = values

write_capability_commands = {
    "work_item_create": "create_command",
    "work_item_update": "update_command",
    "review_attachment": "attachment_command",
    "closure_attachment": "attachment_command",
    "lifecycle_transition": "transition_command",
}

for manifest in (root / "adapters/workflow").glob("*/capabilities.yaml"):
    values = parse_yamlish(manifest)
    adapter = values.get("adapter", manifest.parent.name)
    status = values.get("status")
    runtime_truth = values.get("runtime_truth")
    if status not in {"implemented", "planned", "blocked"}:
        fail(f"{adapter} has invalid status {status}")

    if runtime_truth == "remote":
        for capability, command_key in write_capability_commands.items():
            capability_value = values.get(capability)
            if capability_value != "native":
                continue
            command = values.get(command_key)
            if not command:
                fail(f"{adapter}.{capability} is native but lacks {command_key}")
            entry = registry_by_command.get(command)
            if not entry:
                fail(f"{adapter}.{capability} command is not in remote write registry: {command}")
            if entry.get("structured_write") != "yes":
                fail(f"{adapter}.{capability} uses unstructured write command: {command}")
            if status == "implemented" and entry.get("live_proof") == "none":
                fail(f"{adapter}.{capability} implemented without live proof: {command}")

    if runtime_truth == "remote" and status == "implemented":
        essential = ["identity", "work_item_lookup", "review_attachment", "closure_attachment", "metadata_rehydration", "failure_recovery", "external_api"]
        for capability in essential:
            if values.get(capability) in {"planned", "blocked", "none", ""}:
                fail(f"{adapter} implemented while essential capability {capability} is {values.get(capability)}")
        write_essentials = ["work_item_create", "work_item_update", "lifecycle_transition"]
        if all(values.get(capability) in {"planned", "blocked", "none", ""} for capability in write_essentials):
            fail(f"{adapter} implemented without any governed write capability")

    if adapter == "linear":
        for capability in ["work_item_create", "work_item_update", "review_attachment", "closure_attachment", "lifecycle_transition"]:
            if values.get(capability) == "native":
                fail(f"linear must not claim native {capability} while MCP writes are fail-closed")

    if adapter == "github-pr" and status == "implemented":
        required = ["live_read_result", "live_attachment_result", "live_create_result", "live_land_result"]
        missing = [key for key in required if values.get(key) != "passed"]
        if missing:
            fail(f"github-pr implemented missing live proofs: {', '.join(missing)}")

print("manifest truth gate passed")
PY
