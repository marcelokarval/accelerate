#!/usr/bin/env python3
"""Render exact U5/U6 projections from their repository-owned machine policy."""
from __future__ import annotations
import json
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
POLICY_PATH = REPO / "adapters/runtime/other-runtime-adapters.policy.json"

def load(path: Path = POLICY_PATH) -> dict: return json.loads(path.read_text(encoding="utf-8"))
def ylist(values: list[str]) -> str: return "[" + ", ".join(values) + "]"
def manifest(name: str, item: dict) -> str:
    proof_paths = [f"adapters/runtime/{name}/delegation-contract.md", "tests/test_other_runtime_adapters.py"]
    if name == "opencode":
        proof_paths += ["scripts/inspect-opencode-host.py", "tests/test_opencode_host_inspector.py"]
    proof = ylist(proof_paths)
    observation = item.get("host_observation", {})
    host_fields = "" if name != "opencode" else f"""observed_opencode_package: {observation['opencode_package_version']}
opencode_cli_readback: {observation['opencode_cli_readback']}
observed_omo_slim_package: {observation['omo_slim_package_version']}
omo_slim_loader_observation: {observation['omo_slim_loader']}
accelerate_loader_status: {observation['accelerate_loader']}
asds_execution_consumer_status: {observation['asds_execution_consumer']}
inspector_command: python3 scripts/inspect-opencode-host.py --help
"""
    return f"""schema_version: 1
name: {name}
type: {item['type']}
status: experimental
runtime_status: {item['runtime_status']}
proof_class: {item['proof_class']}
authority_boundary: {item['authority_boundary']}
allowed_current_tools: {ylist(item['current_tools'])}
candidate_native_tools: {ylist([] if name == 'openclaw' else item['candidate_tools'])}
allowed_roles: {ylist(item['allowed_roles'])}
suppressed_roles: {ylist(item['forbidden_roles'])}
allowed_efforts: {ylist(item['allowed_efforts'])}
suppressed_capabilities: {ylist(item['suppressed_capabilities'])}
nesting: {item['nesting']}
{host_fields}validation_command: python3 scripts/validate-other-runtime-adapters.py
proof_artifacts: {proof}
privacy_notes: {item['privacy_notes']}
"""
def contract(name: str, item: dict) -> str:
    policy = {key: item[key] for key in ("runtime_status", "proof_class", "current_tools", "candidate_tools", "allowed_roles", "forbidden_roles", "allowed_efforts", "forbidden_efforts", "nesting", "max_assignment_depth", "max_concurrent_children", "named_model_allowlist", "named_tool_allowlist", "named_skill_allowlist", "named_mcp_allowlist", "timeout_required", "cleanup_currently_allowed", "root_only_synthesis", "effective_model_receipt_required", "callability_proven", "loader_proven")}
    policy["installer"] = {"allowed": False, "requires_dry_run": True, "requires_readback": True, "requires_rollback": True}
    observation = item.get("host_observation", {})
    host_section = "\n" if name != "opencode" else f"""
## Bounded host observation

- OpenCode package manifest: `{observation['opencode_package_version']}`; fresh `opencode --version` readback: `{observation['opencode_cli_readback']}`.
- OMO-Slim package: `{observation['omo_slim_package_version']}`; bounded load observation: `{observation['omo_slim_loader']}`. This is not durable loader authority.
- Accelerate loader: `{observation['accelerate_loader']}`. The source plugin is not an installation or runtime readback.
- ASDS execution-consumer host: `{observation['asds_execution_consumer']}`. OMO task lifecycle does not prove host-owned leases, read-only coordinator enforcement, durable brokers, snapshots, or verifier receipts.
- `scripts/inspect-opencode-host.py` reads only injected package/configuration files and emits a redacted declaration receipt. It intentionally does not read logs or auth and cannot promote runtime status.

The next stage is a separately reviewed source-governed loader with preview, explicit apply authorization, readback and rollback. It is not implemented by this projection or inspector.
"""
    return f"""# {name.title()} Runtime Projection (Generated)

This file is generated from `adapters/runtime/other-runtime-adapters.policy.json`.
It is a `{item['runtime_status']}` / `{item['proof_class']}` projection, never a loader, provider call, or host-config authority.

- observed source: {item['observed_version']}
- candidate disposition: {item['candidate_note']}
- privacy boundary: {item['privacy_notes']}
{host_section}<!-- accelerate-runtime-policy {json.dumps(policy, sort_keys=True)} -->
"""
