from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
POLICY = REPO / "adapters/runtime/dsh/adapter-policy.json"
VALIDATOR = REPO / "adapters/runtime/dsh/validate-adapter.py"


def test_dsh_policy_maps_accelerate_to_native_tools_and_retains_root_authority():
    policy = json.loads(POLICY.read_text(encoding="utf-8"))
    assert policy["runtime"] == "dsh"
    assert policy["status"] == "supported"
    assert policy["enforcement"] == "prompt-enforced"
    assert policy["root_model_alias"] == "auto/best-coding"
    assert policy["max_concurrent_children"] == 4
    assert policy["tools"] == {
        "reasoning": {"tool": "subagent_reasoning", "model_alias": "auto/best-reasoning"},
        "research": {"tool": "subagent_fast", "model_alias": "auto/best-fast"},
        "implementation": {"tool": "subagent", "model_alias": "auto/best-coding"},
        "independent_lanes": {"tool": "workflow", "model_alias": "auto/best-coding"},
    }
    assert policy["root_retained"] == [
        "hardening",
        "fan-in",
        "integration",
        "review-of-review",
        "closure",
    ]
    assert policy["route_policy"]["conversational/no-op"] == {
        "routes": ["direct"],
        "delegation": "forbidden",
    }
    assert policy["route_policy"]["trivial-bounded"]["delegation"] == "unnecessary-by-default"
    assert policy["native_plugin"]["status"] == "planned"
    assert policy["proof_invalidation"] == "material-mutation"


def test_dsh_adapter_validator_accepts_registered_policy():
    result = subprocess.run(
        [sys.executable, str(VALIDATOR)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )
    assert result.returncode == 0, result.stderr
    assert "PASS" in result.stdout


def test_dsh_adapter_validator_rejects_optimistic_plugin_claim(tmp_path):
    policy = json.loads(POLICY.read_text(encoding="utf-8"))
    policy["native_plugin"]["status"] = "available"
    candidate = tmp_path / "policy.json"
    candidate.write_text(json.dumps(policy), encoding="utf-8")
    result = subprocess.run(
        [sys.executable, str(VALIDATOR), "--policy", str(candidate)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )
    assert result.returncode != 0
    assert "native plugin must remain planned" in result.stderr


def test_dsh_is_consistent_across_runtime_registries():
    bootstrap = json.loads(
        (REPO / "adapters/runtime/cross-runtime-bootstrap-manifest.json").read_text(
            encoding="utf-8"
        )
    )["runtimes"]["dsh"]
    registry = json.loads(
        (REPO / "adapters/runtime/runtime-consumer-registry.json").read_text(
            encoding="utf-8"
        )
    )
    consumer = next(item for item in registry["consumers"] if item["runtime"] == "dsh")
    assert bootstrap == {
        "status": "supported",
        "apply_eligible": True,
        "loader": "code-orchestrated-preset",
        "projection": "adapters/runtime/dsh/code-orchestrated-bootstrap.md",
    }
    assert consumer["status"] == "supported"
    assert consumer["loader"] == "code-orchestrated-preset"
    assert consumer["adapter"] == "adapters/runtime/dsh/"
    assert consumer["projection"]["path"] == "adapters/runtime/dsh/code-orchestrated-bootstrap.md"
