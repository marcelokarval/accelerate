from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
VALIDATOR = REPO / "scripts/validate-hermes-delegate-task.py"
FIXTURES = REPO / "tests/fixtures/hermes-delegate-task"


def validate(name: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(VALIDATOR), str(FIXTURES / name)],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )


def test_static_contract_receipt_is_accepted_with_adapter_derived_sync_projection():
    result = validate("valid-sync-fallback.json")
    assert result.returncode == 0, result.stderr
    assert "PASS" in result.stdout


def test_hermes_adapter_rejects_heterogeneous_batch_missing_resolution_lineage_nested_and_lock_claims():
    expected = {
        "heterogeneous-batch.json": "homogeneous agent_role",
        "missing-effective-receipt.json": None,
        "missing-postgres-lineage.json": None,
        "nested-without-root-grant.json": "root grant",
        "native-root-write-lock-claim.json": "native root-write-lock",
    }
    for fixture, message in expected.items():
        result = validate(fixture)
        assert result.returncode != 0, fixture
        if message:
            assert message in result.stderr


def test_sync_first_canary_requires_effective_sync_ack_reconciliation_and_live_postgres_proof():
    expected = {
        "sync-first-async.json": "sync-first canary requires effective sync mode",
        "sync-first-missing-ack.json": None,
        "sync-first-static-lineage.json": None,
    }
    for fixture, message in expected.items():
        result = validate(fixture)
        assert result.returncode != 0, fixture
        if message:
            assert message in result.stderr


def test_receipt_rejects_ambiguous_lifecycle_invalid_lineage_and_unproven_effective_routing():
    expected = {
        "delivery-unknown.json": "ambiguous execution or delivery state blocks closure",
        "duplicate-child-lineage.json": None,
        "missing-native-routing-evidence.json": None,
        "boolean-depth.json": "assignment depth is invalid",
        "native-enum-contradiction.json": "native execution_state",
        "invalid-policy-ref.json": "policy ref path/hash",
    }
    for fixture, message in expected.items():
        result = validate(fixture)
        assert result.returncode != 0, fixture
        if message:
            assert message in result.stderr


def test_adapter_manifest_and_generated_fragment_describe_staged_projection_and_rollback():
    manifest = json.loads((REPO / "adapters/runtime/hermes/hermes-delegate-task.manifest.json").read_text())
    assert manifest["policy_cap"] == 3
    assert manifest["execution"]["async_after"] == "adapter_reconciliation_and_live_postgres_proof"
    assert manifest["root_write_lock"]["native"] == "unsupported"
    assert (REPO / "adapters/runtime/hermes/hermes-delegate-task-bootstrap.fragment.md").is_file()
    assert (REPO / "scripts/stage-hermes-delegate-task-adapter.py").is_file()
    result = subprocess.run(
        [sys.executable, "scripts/render-hermes-delegate-task-bootstrap.py", "--check"],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )
    assert result.returncode == 0, result.stderr


def test_staged_projection_is_blocked_with_a_nonzero_exit_code():
    result = subprocess.run(
        [sys.executable, "scripts/stage-hermes-delegate-task-adapter.py", "--dry-run"],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
    )
    assert result.returncode == 3
    assert "BLOCKED_PENDING_RUNTIME_TRUTH" in result.stdout
    assert "sync-result-projection" in result.stdout


def test_live_postgres_preflight_blocks_without_governed_runtime_evidence_or_dsn_echo():
    result = subprocess.run(
        [sys.executable, "scripts/verify-hermes-delegate-task-live.py", str(FIXTURES / "valid-sync-fallback.json")],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
        env={},
    )
    assert result.returncode == 3
    assert "BLOCKED" in result.stdout
    assert "postgresql://" not in result.stdout + result.stderr


def test_live_postgres_preflight_without_arguments_is_an_explicit_block_not_usage_success():
    result = subprocess.run(
        [sys.executable, "scripts/verify-hermes-delegate-task-live.py"],
        cwd=REPO,
        text=True,
        capture_output=True,
        check=False,
        env={},
    )
    assert result.returncode == 3
    assert "BLOCKED" in result.stdout
