from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
VALIDATOR = REPO / "scripts/validate-runtime-delegation-semantics.py"
VALID = REPO / "tests/fixtures/runtime-delegation-semantics/valid-run.json"


def run_validator(*paths: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(VALIDATOR), *(str(path) for path in paths)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )


def test_valid_semantic_run_and_registry_pass():
    result = run_validator(VALID)

    assert result.returncode == 0, result.stderr
    assert "PASS" in result.stdout


def test_completed_run_requires_successful_assignments_fan_in_review_exceptions_and_promotion():
    fixtures = REPO / "tests/fixtures/runtime-delegation-semantics"
    assert run_validator(fixtures / "completed-run.json").returncode == 0
    for name, message in {
        "completed-assignment-not-succeeded.json": "assignment state completed and outcome succeeded",
        "completed-fan-in-incomplete.json": "complete fan_in",
        "completed-review-not-passed.json": "review state passed or not-required",
        "completed-open-exception.json": "open exceptions",
        "completed-promotion-not-verified.json": "verified proof and rollback",
        "exception-state-without-record.json": "exception state requires an open exception record",
        "completed-optional-review-failed.json": "review state passed or not-required",
        "exception-state-resolved-only.json": "exception state requires an open exception record",
    }.items():
        result = run_validator(fixtures / name)
        assert result.returncode != 0, name
        assert message in result.stderr


def test_assignment_tree_requires_existing_acyclic_authorized_bounded_parents():
    fixtures = REPO / "tests/fixtures/runtime-delegation-semantics"
    for name, message in {
        "unknown-dependency.json": "unknown assignment",
        "cyclic-dependency.json": "cyclic dependency graph",
        "unknown-parent.json": "unknown assignment",
        "cyclic-parent.json": "cyclic parent graph",
        "nested-delegation-without-grant.json": "root-authorized parent grant",
        "depth-exceeds-policy.json": "depth exceeds policy",
        "budget-order-invalid.json": "capacity order",
    }.items():
        result = run_validator(fixtures / name)
        assert result.returncode != 0, name
        assert message in result.stderr


def test_schema_is_runtime_neutral_and_has_required_portable_terms():
    schema = (REPO / "core/delegation/runtime-neutral-delegation.schema.json").read_text(
        encoding="utf-8"
    ).lower()

    for term in (
        "run",
        "policy",
        "state",
        "budget",
        "assignments",
        "exception",
        "fan_in",
        "review",
        "root_ownership",
        "promotion",
        "runtime_capacity",
        "policy_cap",
        "effective_cap",
    ):
        assert term in schema
    for forbidden in ("codex", "openhands", "hermes", "opencode", "openclaw", "claude", "gpt-", "deepseek", "gemini", "fork"):
        assert forbidden not in schema


def test_schema_declares_complete_semantic_taxonomy():
    schema = json.loads(
        (REPO / "core/delegation/runtime-neutral-delegation.schema.json").read_text(
            encoding="utf-8"
        )
    )
    states = set(schema["$defs"]["lifecycle_state"]["enum"])
    assert {
        "draft", "hardened", "tasks-ready", "dispatch-required", "dispatched",
        "executing", "fan-in", "independent-review", "root-review-of-review",
        "promotion-pending", "promoted", "completed", "blocked", "exception",
        "rejected", "cancelled", "superseded",
    } <= states
    assignments = schema["$defs"]["assignment"]["properties"]
    assert set(assignments["quality_class"]["enum"]) == {
        "root-orchestration", "research-low", "mechanical-medium",
        "implementation-medium", "review-medium", "high-stakes-review",
    }
    assert set(schema["$defs"]["policy"]["properties"]["enforcement_level"]["enum"]) == {
        "native", "adapter-enforced", "prompt-contract-only", "unsupported",
    }


def test_registry_covers_required_runtimes_with_machine_readable_lifecycle_fields():
    registry = json.loads(
        (REPO / "adapters/runtime/runtime-consumer-registry.json").read_text(encoding="utf-8")
    )
    consumers = {consumer["runtime"]: consumer for consumer in registry["consumers"]}

    assert set(consumers) == {"codex", "openhands", "hermes", "opencode", "openclaw", "claude"}
    for consumer in consumers.values():
        for field in (
            "status",
            "source_authority",
            "projection",
            "loader",
            "native_primitive",
            "adapter",
            "proof",
            "install",
            "rollback",
        ):
            assert consumer[field]
    assert consumers["codex"]["status"] == "legacy-reference"
    assert consumers["codex"]["projection"]["mode"] == "reference-only"
    assert (REPO / consumers["codex"]["projection"]["path"]).is_file()
    assert "runtime-neutral-delegation" in (REPO / consumers["codex"]["projection"]["path"]).read_text()


def test_registry_negative_probes_fail_for_bad_types_paths_and_static_support_claims(tmp_path):
    registry_path = REPO / "adapters/runtime/runtime-consumer-registry.json"
    registry = json.loads(registry_path.read_text(encoding="utf-8"))
    probes = {
        "empty-loader": lambda item: item.update({"loader": ""}),
        "missing-path": lambda item: item["projection"].update({"path": "missing/file"}),
        "static-supported": lambda item: item.update({"status": "supported", "proof": "registry validation only"}),
        "openhands-supported": lambda item: item.update({"status": "supported"}),
    }
    for name, mutate in probes.items():
        candidate = json.loads(json.dumps(registry))
        item = next(entry for entry in candidate["consumers"] if entry["runtime"] == ("openhands" if name == "openhands-supported" else "codex"))
        mutate(item)
        path = tmp_path / f"{name}.json"
        path.write_text(json.dumps(candidate), encoding="utf-8")
        result = subprocess.run(
            [sys.executable, str(VALIDATOR), "--registry", str(path), str(VALID)],
            cwd=REPO, text=True, capture_output=True, check=False,
        )
        assert result.returncode != 0, name
        assert "FAIL" in result.stderr


def test_negative_fixtures_fail_closed_without_treating_unknown_telemetry_as_zero():
    fixtures = REPO / "tests/fixtures/runtime-delegation-semantics"
    for name in (
        "unknown-telemetry-is-zero.json",
        "effective-cap-exceeds-policy.json",
        "unsupported-enforcement.json",
        "invalid-state-transition.json",
    ):
        result = run_validator(fixtures / name)
        assert result.returncode != 0, name
        assert "FAIL" in result.stderr
