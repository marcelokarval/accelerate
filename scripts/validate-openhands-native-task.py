#!/usr/bin/env python3
"""Validate the repo-owned OpenHands TaskManager dispatch contract.

This validator intentionally proves configuration safety only. It never reads
credentials, starts OpenHands, or claims a provider binding is callable.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
PARITY = REPO / "adapters/runtime/model-lanes/cross-runtime-agent-parity.toml"
SUBAGENT_MATERIALIZER = REPO / "scripts/install-openhands-subagents.py"


def _load_manifest(path: Path) -> dict:
    with path.open("rb") as stream:
        return tomllib.load(stream)


def _load_subagent_materializer():
    spec = importlib.util.spec_from_file_location(
        "openhands_subagent_installer", SUBAGENT_MATERIALIZER
    )
    if not spec or not spec.loader:
        raise ValueError("OpenHands subagent materializer cannot be loaded")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def validate_contract(path: Path = PARITY) -> dict:
    parity = _load_manifest(path)
    contract = parity["openhands_native_task"]
    registry = parity["openhands_subagent_registry"]
    bindings = parity["openhands_native_bindings"]
    children = registry["agents"]

    if contract["contract"] != "openhands-native-taskmanager-v1":
        raise ValueError("unsupported OpenHands native task contract")
    if contract["runtime_semantics_evidence"] != "session-tool-readback-required":
        raise ValueError("OpenHands runtime semantics evidence is not fail-closed")
    if contract["enforcement"] != "prompt-contract-only":
        raise ValueError("OpenHands child dispatch is not mechanically enforced")
    if contract["root_subscription_state"] != "supported":
        raise ValueError("OpenHands root subscription support must be explicit")
    if contract["child_subscription_state"] != "unsupported":
        raise ValueError("OpenHands child subscription support is not proven")
    if contract["child_binding_state"] != "binding_unavailable":
        raise ValueError("OpenHands children must fail closed without a proven binding")
    if set(bindings) != {"default"}:
        raise ValueError("only the supported OpenHands root may retain an LLM binding")
    if contract["dispatch_after"] != "TASKS_READY":
        raise ValueError("OpenHands dispatch must occur after TASKS_READY")
    if contract["on_required_dispatch_failure"] != "blocked":
        raise ValueError("OpenHands dispatch failure must block")
    if contract["max_parallel_policy_cap"] != 3 or registry["max_parallel_recommendation"] != 3:
        raise ValueError("OpenHands native task cap must be three")
    if contract["child_depth"] != 1 or registry["recursive_delegation"] is not False:
        raise ValueError("OpenHands children must be one-level leaves")
    if contract["child_task_tool"] is not False:
        raise ValueError("OpenHands children must not receive a task tool")
    if set(contract["allowed_root_local_degradation"]) != {
        "explicit_user_opt_out", "collaboration_unavailable", "spawn_failed_operator_authorized",
    }:
        raise ValueError("OpenHands root degradation reasons drift")
    for child in children:
        if child.get("binding_state") != "binding_unavailable":
            raise ValueError(f"OpenHands child binding is not fail-closed: {child['name']}")
        if "model" in child:
            raise ValueError(f"OpenHands child incorrectly claims an effective model: {child['name']}")
        if not child.get("requested_model") or not child.get("requested_reasoning_effort"):
            raise ValueError(f"OpenHands child lacks requested model receipt: {child['name']}")
        if "task" in child["tools"] or "task_tool_set" in child["tools"]:
            raise ValueError(f"OpenHands child can delegate: {child['name']}")
    return contract


def dry_run_materialization(path: Path = PARITY, target_dir: Path | None = None) -> int:
    """Inspect an actual or explicitly supplied target without mutating it."""
    validate_contract(path)
    materializer = _load_subagent_materializer()
    expected = materializer.load_registry(path)
    if expected:
        raise ValueError("binding_unavailable OpenHands children would be materialized")
    if target_dir is None:
        target_dir = Path.home() / ".agents/agents"
    if not target_dir.is_dir():
        raise ValueError(f"OpenHands configured child target is missing: {target_dir}")
    return materializer.reconcile(target_dir, expected, apply=False)


def current_runtime_preflight(
    path: Path = PARITY,
    *,
    target_dir: Path | None = None,
    profiles_dir: Path | None = None,
    runtime_version: str | None = None,
) -> dict:
    """Return a fail-closed current-runtime receipt without provider calls."""
    contract = validate_contract(path)
    parity = _load_manifest(path)
    target_dir = target_dir or Path.home() / ".agents/agents"
    profiles_dir = profiles_dir or Path.home() / ".openhands/agent-profiles"
    observed_version = runtime_version
    if observed_version is None:
        return {"status": "blocked", "reason": "runtime_version_readback_required"}
    if observed_version != contract["runtime_package_version"]:
        return {"status": "blocked", "reason": "runtime_version_mismatch", "observed_version": observed_version}
    drift = dry_run_materialization(path, target_dir)
    if drift:
        return {"status": "blocked", "reason": "child_target_drift", "drift": drift}
    root = profiles_dir / "default.json"
    if not root.is_file() or root.is_symlink():
        return {"status": "blocked", "reason": "root_profile_missing"}
    payload = json.loads(root.read_text(encoding="utf-8"))
    if payload.get("llm_profile_ref") != parity["openhands_native_bindings"]["default"]:
        return {"status": "blocked", "reason": "root_binding_drift"}
    # Agent Profile has no supported deny-list for Agent Canvas built-ins. Even
    # enable_sub_agents=false cannot prove launch_child_conversation is absent.
    return {
        "status": "blocked",
        "reason": "native_task_tool_enforcement_unsupported",
        "enforcement": contract["enforcement"],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, default=PARITY)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--target-dir", type=Path)
    parser.add_argument("--profiles-dir", type=Path)
    parser.add_argument("--runtime-version")
    args = parser.parse_args()
    try:
        validate_contract(args.manifest)
        if args.dry_run:
            receipt = current_runtime_preflight(
                args.manifest,
                target_dir=args.target_dir,
                profiles_dir=args.profiles_dir,
                runtime_version=args.runtime_version,
            )
            print(f"{receipt['status'].upper()}: {receipt['reason']}")
            return 1
    except (KeyError, OSError, ValueError, tomllib.TOMLDecodeError) as error:
        print(f"FAIL: {error}")
        return 2
    print("PASS: OpenHands native task contract is structurally fail-closed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
