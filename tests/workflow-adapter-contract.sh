#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'workflow-adapter-contract failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "${path}" ] || fail "missing required file: ${path}"
}

require_file "adapters/workflow/adapter-contract.md"
require_file "adapters/workflow/capability-schema-v2.md"
require_file "core/control-plane/manifest-truth-gate.md"
require_file "adapters/workflow/local/README.md"
require_file "adapters/workflow/local/capabilities.yaml"
require_file "onboarding/local-workspace/read-workflow-capabilities.sh"
require_file "onboarding/local-workspace/select-workflow-capability.sh"

python3 - "${ROOT}" <<'PY'
from pathlib import Path
import re
import subprocess
import sys

root = Path(sys.argv[1])

CAPABILITIES = [
    "read_lookup",
    "create_update",
    "review_artifact_attachment",
    "rehydration",
    "write_recovery",
    "closure_comment",
    "status_transition",
    "production_merge_land_gate",
]
LEGACY = [
    "identity",
    "work_item_create",
    "work_item_lookup",
    "work_item_update",
    "lifecycle_transition",
    "topology",
    "review_attachment",
    "closure_attachment",
    "metadata_rehydration",
    "failure_recovery",
    "external_api",
]
CAPABILITY_VALUES = {"native", "linked", "substitute", "planned", "blocked", "none"}
PROVEN_VALUES = {"native", "linked", "substitute"}
REMOTE_WRITE_CAPABILITIES = {
    "create_update",
    "review_artifact_attachment",
    "closure_comment",
    "status_transition",
    "production_merge_land_gate",
}


def fail(message: str) -> None:
    print(f"workflow-adapter-contract failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def parse(path: Path) -> dict[str, str]:
    values = {}
    for line in path.read_text().splitlines():
        match = re.match(r"^([a-zA-Z0-9_]+):\s*(.*)$", line)
        if match:
            key = match.group(1)
            if key in values:
                fail(f"{path.relative_to(root)} has duplicate key: {key}")
            values[key] = match.group(2).strip()
    return values

registry_text = (root / "adapters/workflow/remote-write-registry.yaml").read_text()
registry_commands = set(re.findall(r"(?m)^\s*command:\s*(\S+)\s*$", registry_text))

for manifest in (root / "adapters/workflow").glob("*/capabilities.yaml"):
    values = parse(manifest)
    adapter = values.get("adapter") or manifest.parent.name
    if values.get("schema_version") != "2":
        fail(f"{adapter} must use schema_version 2")
    if adapter != manifest.parent.name:
        fail(f"adapter key {adapter} does not match directory {manifest.parent.name}")
    if values.get("status") not in {"implemented", "planned", "blocked"}:
        fail(f"{adapter} has invalid status {values.get('status')}")
    if values.get("runtime_truth") not in {"local", "remote", "hybrid", "none"}:
        fail(f"{adapter} has invalid runtime_truth {values.get('runtime_truth')}")
    if not values.get("substitute_evidence"):
        fail(f"{adapter} missing substitute_evidence")

    for key in LEGACY:
        if key not in values:
            fail(f"{adapter} missing legacy compatibility key {key}")
        if values[key] not in CAPABILITY_VALUES:
            fail(f"{adapter}.{key} invalid value {values[key]}")

    for capability in CAPABILITIES:
        status = values.get(capability)
        command = values.get(f"{capability}_command")
        proof = values.get(f"{capability}_proof")
        if status not in CAPABILITY_VALUES:
            fail(f"{adapter}.{capability} invalid or missing status {status}")
        if command is None or proof is None:
            fail(f"{adapter}.{capability} missing command/proof fields")
        if status in PROVEN_VALUES:
            if command in {"", "none"}:
                fail(f"{adapter}.{capability} is {status} but lacks command")
            if proof in {"", "none", "planned", "blocked"}:
                fail(f"{adapter}.{capability} is {status} but lacks honest proof")
            if not (root / command).is_file():
                fail(f"{adapter}.{capability} command missing: {command}")
        if status in {"planned", "blocked", "none"} and proof.startswith("planning/evidence/dated-proof-appendix/"):
            fail(f"{adapter}.{capability} is {status} but claims live proof")
        if values.get("runtime_truth") == "remote" and status == "native" and capability in REMOTE_WRITE_CAPABILITIES:
            if command not in registry_commands:
                fail(f"{adapter}.{capability} native remote write command not in registry: {command}")

    if adapter == "local":
        if values.get("runtime_truth") != "local" or values.get("external_api") != "none":
            fail("local adapter must be local runtime truth with no external_api")
        for capability in CAPABILITIES:
            if values[capability] != "substitute":
                fail(f"local.{capability} must be substitute")

    if adapter == "linear":
        for path in [
            "adapters/workflow/linear/operational-contract.md",
            "onboarding/local-workspace/probe-linear-adapter.sh",
            "onboarding/local-workspace/read-linear-adapter.sh",
            "onboarding/local-workspace/attach-linear-artifact.sh",
            "onboarding/local-workspace/read-linear-mcp-adapter.sh",
            "onboarding/local-workspace/create-linear-mcp-issue.sh",
            "onboarding/local-workspace/attach-linear-mcp-artifact.sh",
            "onboarding/local-workspace/write-linear-mcp-recovery.sh",
        ]:
            if not (root / path).is_file():
                fail(f"linear missing required helper {path}")
        if values.get("status") == "implemented":
            fail("linear must not be implemented until structured MCP writes are bound here")

    if adapter == "github-pr":
        for path in [
            "onboarding/local-workspace/probe-github-pr-adapter.sh",
            "onboarding/local-workspace/read-github-pr-adapter.sh",
            "onboarding/local-workspace/attach-github-pr-artifact.sh",
            "onboarding/local-workspace/create-github-pr-adapter.sh",
            "onboarding/local-workspace/comment-github-pr-closure.sh",
            "onboarding/local-workspace/validate-closure-comment-artifact.sh",
            "onboarding/local-workspace/rehydrate-github-pr-adapter.sh",
            "onboarding/local-workspace/validate-github-pr-recovery.sh",
            "onboarding/local-workspace/write-github-pr-recovery.sh",
            "onboarding/local-workspace/check-ship-readiness.sh",
            "onboarding/local-workspace/check-production-readiness.sh",
            "onboarding/local-workspace/land-github-pr.sh",
        ]:
            if not (root / path).is_file():
                fail(f"github-pr missing required helper {path}")
        if values.get("create_update") == "native":
            proof = values.get("create_update_proof", "")
            if not proof.startswith("planning/evidence/dated-proof-appendix/") or not (root / proof).is_file():
                fail("github-pr create cannot be native without durable live create proof")
        if values.get("production_merge_land_gate") == "native":
            proof = values.get("production_merge_land_gate_proof", "")
            if not proof.startswith("planning/evidence/dated-proof-appendix/") or not (root / proof).is_file():
                fail("github-pr land cannot be native without durable live land proof")

# Capability reader/select smoke checks.
read = subprocess.run([str(root / "onboarding/local-workspace/read-workflow-capabilities.sh"), "github-pr"], cwd=root, text=True, stdout=subprocess.PIPE, check=True)
if '"closure_comment"' not in read.stdout:
    fail("capability read summary omitted closure_comment")
select = subprocess.run([str(root / "onboarding/local-workspace/select-workflow-capability.sh"), "github-pr", "read_lookup"], cwd=root, text=True, stdout=subprocess.PIPE, check=True)
if '"available": true' not in select.stdout:
    fail("capability select did not mark github-pr read_lookup available")
blocked = subprocess.run([str(root / "onboarding/local-workspace/select-workflow-capability.sh"), "github-issues", "production_merge_land_gate"], cwd=root, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
if blocked.returncode == 0:
    fail("capability select did not fail closed for none capability")

print("workflow adapter contract tests passed")
PY
