"""Comprehensive persistent test suite for OmniRouter capability battery contracts, validator, and renderer."""

from __future__ import annotations

import copy
import hashlib
import json
import os
import sys
from pathlib import Path
import pytest
import jsonschema

REPO_ROOT = Path(__file__).resolve().parents[1]
SKILL_SCRIPTS = REPO_ROOT / "skills/operations/omnirouter-operations/scripts"
sys.path.insert(0, str(SKILL_SCRIPTS))

import validate_capability_battery as validator
import render_capability_report as renderer

MANIFEST_SCHEMA_PATH = REPO_ROOT / "skills/operations/omnirouter-operations/assets/capability-battery-manifest.schema.json"
RECEIPT_SCHEMA_PATH = REPO_ROOT / "skills/operations/omnirouter-operations/assets/capability-battery-validation-receipt.schema.json"


def full_valid_manifest_v2() -> dict:
    return {
        "schema_version": "2.0",
        "battery_id": "omniroute-battery-001",
        "catalog_snapshot_id": "snap-2026-09-05-v1",
        "provider": "openrouter",
        "route": "direct:anthropic",
        "harness": "codex",
        "controls": {
            "temperature": 0,
            "max_tokens": 2048,
            "isolation": True,
            "seed": "fixed-seed-42",
        },
        "planned_slots": [
            {
                "slot_id": "slot-01",
                "capability": "code-generation",
                "rubric_version": "v2.0-rubric",
                "input_sha256": "a" * 64,
                "requested_model": "anthropic/claude-sonnet-4.6",
            },
            {
                "slot_id": "slot-02",
                "capability": "tool-protocol",
                "rubric_version": "v2.0-rubric",
                "input_sha256": "b" * 64,
                "requested_model": "anthropic/claude-sonnet-4.6",
            },
        ],
        "evidence": [
            {
                "slot_id": "slot-01",
                "attempt": 1,
                "status": "pass",
                "requested_model": "anthropic/claude-sonnet-4.6",
                "effective_model": "anthropic/claude-sonnet-4.6",
                "http_status": 200,
                "response_sha256": "c" * 64,
                "artifact_locator": "run/slot-01/attempt-1.json",
                "semantic_verdict": "valid JSON and accurate types",
            },
            {
                "slot_id": "slot-02",
                "attempt": 1,
                "status": "transport_fail",
                "requested_model": "anthropic/claude-sonnet-4.6",
                "http_status": 503,
                "reason": "gateway upstream timeout 503",
            },
            {
                "slot_id": "slot-02",
                "attempt": 2,
                "status": "pass",
                "requested_model": "anthropic/claude-sonnet-4.6",
                "effective_model": "anthropic/claude-sonnet-4.6",
                "http_status": 200,
                "response_sha256": "d" * 64,
                "artifact_locator": "run/slot-02/attempt-2.json",
                "semantic_verdict": "recovered cleanly on retry 2",
            },
        ],
    }


# Test 1: Full valid manifest
def test_full_valid_manifest():
    manifest = full_valid_manifest_v2()
    counts = validator.validate_manifest(manifest)
    assert counts["planned_slot_count"] == 2
    assert counts["evidence_count"] == 3


# Test 2: Empty snapshot
def test_reject_empty_snapshot():
    manifest = full_valid_manifest_v2()
    manifest["catalog_snapshot_id"] = ""
    with pytest.raises(ValueError, match=r"(?i)catalog_snapshot_id"):
        validator.validate_manifest(manifest)


# Test 3: Empty controls
def test_reject_empty_controls():
    manifest = full_valid_manifest_v2()
    manifest["controls"] = {}
    with pytest.raises(ValueError, match=r"(?i)controls"):
        validator.validate_manifest(manifest)


# Test 4: Requested model changed in retry
def test_reject_retry_changing_requested_model():
    manifest = full_valid_manifest_v2()
    # Change requested_model on retry 2 of slot-02
    manifest["evidence"][2]["requested_model"] = "openai/gpt-5.6-terra"
    with pytest.raises(ValueError, match=r"(?i)retry changing requested_model"):
        validator.validate_manifest(manifest)


# Test 5: Requested model mismatch with planned slot
def test_reject_slot_model_mismatch():
    manifest = full_valid_manifest_v2()
    manifest["evidence"][0]["requested_model"] = "deepseek/deepseek-chat"
    with pytest.raises(ValueError, match=r"(?i)does not match planned slot"):
        validator.validate_manifest(manifest)


# Test 6: Pass with HTTP 500 or 400
def test_reject_pass_with_http_error():
    manifest = full_valid_manifest_v2()
    manifest["evidence"][0]["status"] = "pass"
    manifest["evidence"][0]["http_status"] = 500
    with pytest.raises(ValueError, match=r"(?i)requires successful HTTP 2xx"):
        validator.validate_manifest(manifest)

    manifest["evidence"][0]["http_status"] = 400
    with pytest.raises(ValueError, match=r"(?i)requires successful HTTP 2xx"):
        validator.validate_manifest(manifest)


# Test 7: Not run with response / http / effective_model
def test_reject_not_run_with_response_or_http():
    manifest = full_valid_manifest_v2()
    manifest["evidence"] = [
        {
            "slot_id": "slot-01",
            "attempt": 1,
            "status": "not_run",
            "requested_model": "anthropic/claude-sonnet-4.6",
            "reason": "rate limit exhausted",
            "http_status": 200,  # Forbidden on not_run
        },
        {
            "slot_id": "slot-02",
            "attempt": 1,
            "status": "not_run",
            "requested_model": "anthropic/claude-sonnet-4.6",
            "reason": "quota stopped",
        },
    ]
    with pytest.raises(ValueError, match=r"(?i)not_run.*http_status"):
        validator.validate_manifest(manifest)

    manifest["evidence"][0].pop("http_status")
    manifest["evidence"][0]["response_sha256"] = "e" * 64
    with pytest.raises(ValueError, match=r"(?i)not_run.*response_sha256"):
        validator.validate_manifest(manifest)


# Test 8: Missing planned slot in evidence
def test_reject_missing_slot_evidence():
    manifest = full_valid_manifest_v2()
    # Remove all slot-02 evidence
    manifest["evidence"] = [manifest["evidence"][0]]
    with pytest.raises(ValueError, match=r"(?i)planned canonical slots lack evidence"):
        validator.validate_manifest(manifest)


# Test 9: Duplicate attempt
def test_reject_duplicate_attempt():
    manifest = full_valid_manifest_v2()
    dup = copy.deepcopy(manifest["evidence"][0])
    manifest["evidence"].append(dup)
    with pytest.raises(ValueError, match=r"(?i)duplicate attempt"):
        validator.validate_manifest(manifest)


# Test 10: Non-contiguous retry (e.g. 1 then 3, missing 2)
def test_reject_non_contiguous_retry():
    manifest = full_valid_manifest_v2()
    manifest["evidence"][2]["attempt"] = 3  # slot-02 has attempt 1 and 3, missing 2
    with pytest.raises(ValueError, match=r"(?i)not contiguous"):
        validator.validate_manifest(manifest)


# Test 11: Raw response / secret / token forbidden keys and values
def test_reject_raw_or_secret_fields():
    manifest = full_valid_manifest_v2()
    manifest["raw_response"] = "forbidden"
    with pytest.raises(ValueError, match=r"(?i)forbidden raw or secret-shaped field"):
        validator.validate_manifest(manifest)

    manifest = full_valid_manifest_v2()
    manifest["controls"]["token"] = "sk-secret1234567890"
    with pytest.raises(ValueError, match=r"(?i)forbidden raw or secret-shaped field"):
        validator.validate_manifest(manifest)


# Test 12: Multiline or oversized text
def test_reject_multiline_or_oversized_text():
    manifest = full_valid_manifest_v2()
    manifest["planned_slots"][0]["capability"] = "code-gen\nsecond-line"
    with pytest.raises(ValueError, match=r"(?i)single-line"):
        validator.validate_manifest(manifest)

    manifest = full_valid_manifest_v2()
    manifest["planned_slots"][0]["capability"] = "x" * 241
    with pytest.raises(ValueError, match=r"(?i)oversized"):
        validator.validate_manifest(manifest)


# Test 13: Schema versus Python validator parity
def test_schema_validator_parity_comprehensive():
    schema = json.loads(MANIFEST_SCHEMA_PATH.read_text(encoding="utf-8"))
    valid = full_valid_manifest_v2()

    # Valid instance passes both
    jsonschema.validate(instance=valid, schema=schema)
    validator.validate_manifest(valid)

    # Empty snapshot rejected by both
    empty_snap = copy.deepcopy(valid)
    empty_snap["catalog_snapshot_id"] = ""
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(instance=empty_snap, schema=schema)
    with pytest.raises(ValueError):
        validator.validate_manifest(empty_snap)

    # Empty controls rejected by both
    empty_ctrl = copy.deepcopy(valid)
    empty_ctrl["controls"] = {}
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(instance=empty_ctrl, schema=schema)
    with pytest.raises(ValueError):
        validator.validate_manifest(empty_ctrl)

    # Multiline rubric rejected by both
    multi_rubric = copy.deepcopy(valid)
    multi_rubric["planned_slots"][0]["rubric_version"] = "v1\nmalicious"
    with pytest.raises(jsonschema.ValidationError):
        jsonschema.validate(instance=multi_rubric, schema=schema)
    with pytest.raises(ValueError):
        validator.validate_manifest(multi_rubric)


# Test 14: Renderer rejects forged receipt (manifest SHA mismatch)
def test_renderer_rejects_forged_receipt(tmp_path: Path):
    manifest = full_valid_manifest_v2()
    counts = validator.validate_manifest(manifest)
    digest = hashlib.sha256(json.dumps(manifest).encode()).hexdigest()
    fake_receipt = {
        "schema_version": "2.0",
        "status": "valid",
        "manifest_sha256": "f" * 64,  # Forged mismatch
        "validated_at": "2026-09-06T00:00:00+00:00",
        **counts,
    }
    with pytest.raises(ValueError, match=r"(?i)does not match freshly computed"):
        renderer.validate_receipt(fake_receipt, digest, counts)


# Test 15: Renderer rejects tampered counts in receipt
def test_renderer_rejects_tampered_counts():
    manifest = full_valid_manifest_v2()
    counts = validator.validate_manifest(manifest)
    digest = hashlib.sha256(json.dumps(manifest).encode()).hexdigest()
    tampered_receipt = {
        "schema_version": "2.0",
        "status": "valid",
        "manifest_sha256": digest,
        "validated_at": "2026-09-06T00:00:00+00:00",
        "planned_slot_count": 999,  # Tampered
        "evidence_count": counts["evidence_count"],
    }
    with pytest.raises(ValueError, match=r"(?i)planned_slot_count does not match"):
        renderer.validate_receipt(tampered_receipt, digest, counts)


# Test 16: Markdown escaping in renderer
def test_renderer_markdown_escaping():
    raw_text = "evil | column <script>alert(1)</script> \\ end"
    escaped = renderer.escape_markdown(raw_text)
    assert "\\|" in escaped
    assert "&lt;script&gt;" in escaped
    assert "\\\\" in escaped


# Test 17: Output path traversal and symlink rejection
def test_renderer_rejects_symlink_or_path_traversal(tmp_path: Path):
    symlink_dir = tmp_path / "symlink_dir"
    target_dir = tmp_path / "target_dir"
    target_dir.mkdir()
    symlink_dir.symlink_to(target_dir)

    manifest_file = tmp_path / "manifest.json"
    manifest = full_valid_manifest_v2()
    raw = json.dumps(manifest, indent=2).encode("utf-8")
    manifest_file.write_bytes(raw)
    counts = validator.validate_manifest(manifest)
    digest = hashlib.sha256(raw).hexdigest()

    receipt_file = tmp_path / "receipt.json"
    receipt = {
        "schema_version": "2.0",
        "status": "valid",
        "manifest_sha256": digest,
        "validated_at": "2026-09-06T00:00:00+00:00",
        **counts,
    }
    receipt_file.write_text(json.dumps(receipt))

    # Calling renderer main with symlink out-dir should fail
    old_argv = sys.argv
    try:
        sys.argv = [
            "render_capability_report.py",
            "--manifest", str(manifest_file),
            "--validation-receipt", str(receipt_file),
            "--out-dir", str(symlink_dir),
        ]
        exit_code = renderer.main()
        assert exit_code == 2
    finally:
        sys.argv = old_argv


# Test 18: Ranking / interpretation limits notice and non-computable states
def test_ranking_interpretation_limits_non_computable():
    manifest = full_valid_manifest_v2()
    counts = validator.validate_manifest(manifest)
    digest = hashlib.sha256(json.dumps(manifest).encode()).hexdigest()
    report = renderer.render_report(manifest, digest, "receipt.json", counts)
    assert "Interpretation limits and non-promotion notice" in report
    assert "Não gera rankings arbitrários nem promove automaticamente" in report


# Test 19: Semantic fail requires completed 2xx HTTP response
def test_semantic_fail_requires_completed_http():
    manifest = full_valid_manifest_v2()
    manifest["evidence"][0]["status"] = "semantic_fail"
    manifest["evidence"][0]["http_status"] = 502  # Transport fail masquerading as semantic fail
    with pytest.raises(ValueError, match=r"(?i)semantic_fail.*requires completed HTTP transport"):
        validator.validate_manifest(manifest)


# Test 20: Safe migration from v1.0 to v2.0
def test_safe_v1_to_v2_migration():
    v1_manifest = {
        "schema_version": "1.0",
        "battery_id": "legacy-battery",
        "catalog_snapshot_id": "snap-legacy",
        "controls": {"temp": 0},
        "planned_slots": [
            {
                "slot_id": "s1",
                "capability": "c1",
                "rubric_version": "r1",
                "input_sha256": "0" * 64,
            }
        ],
        "evidence": [
            {
                "slot_id": "s1",
                "attempt": 1,
                "status": "pass",
                "requested_model": "model-1",
                "http_status": 200,
                "response_sha256": "1" * 64,
            }
        ],
    }
    migrated = validator.migrate_manifest_v1_to_v2(v1_manifest)
    assert migrated["schema_version"] == "2.0"
    counts = validator.validate_manifest(migrated)
    assert counts["planned_slot_count"] == 1


# Test 21: (T1) Renderer prefix/symlink escape (out vs outside)
def test_renderer_out_vs_outside_prefix_escape(tmp_path):
    manifest_file = tmp_path / "manifest.json"
    receipt_file = tmp_path / "receipt.json"
    manifest = full_valid_manifest_v2()
    manifest_file.write_text(json.dumps(manifest))
    counts = validator.validate_manifest(manifest)
    raw = manifest_file.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    receipt = {
        "schema_version": "2.0",
        "status": "valid",
        "manifest_sha256": digest,
        "planned_slot_count": counts["planned_slot_count"],
        "evidence_count": counts["evidence_count"],
        "validated_at": "2026-09-06T00:00:00+00:00",
    }
    receipt_file.write_text(json.dumps(receipt))

    out_dir = tmp_path / "out"
    out_dir.mkdir()
    outside_dir = tmp_path / "outside"
    outside_dir.mkdir()

    symlink_target = out_dir / "capability-battery-report.md"
    escaped_file = outside_dir / "capability-battery-report.md"
    symlink_target.symlink_to(escaped_file)

    old_argv = sys.argv
    try:
        sys.argv = [
            "render_capability_report.py",
            "--manifest", str(manifest_file),
            "--validation-receipt", str(receipt_file),
            "--out-dir", str(out_dir),
        ]
        exit_code = renderer.main()
        assert exit_code == 2, "renderer must exit with code 2 when target escapes out_dir"
        assert not escaped_file.exists(), "escaped file in outside dir must not be written"
    finally:
        sys.argv = old_argv


# Test 22: (T2) Structural parity between Python and JSON Schema
def test_schema_python_comprehensive_matrix():
    schema = json.loads(MANIFEST_SCHEMA_PATH.read_text(encoding="utf-8"))

    # Case 1: planned slot with reasoning_effort, timeout_seconds, max_retries
    m1 = full_valid_manifest_v2()
    m1["planned_slots"][0]["reasoning_effort"] = "high"
    m1["planned_slots"][0]["timeout_seconds"] = 30
    m1["planned_slots"][0]["max_retries"] = 2
    validator.validate_manifest(m1)
    jsonschema.validate(m1, schema)

    # Case 2: provider name with spaces
    m2 = full_valid_manifest_v2()
    m2["provider"] = "OmniRoute Main Provider"
    validator.validate_manifest(m2)
    jsonschema.validate(m2, schema)

    # Case 3: capability with non-ASCII unicode
    m3 = full_valid_manifest_v2()
    m3["planned_slots"][0]["capability"] = "visão computacional e raciocínio multi-etapa"
    jsonschema.validate(m3, schema)
    validator.validate_manifest(m3)

    # Case 4: top-level optional fields and evidence attempt_timestamp
    m4 = full_valid_manifest_v2()
    m4["client_version"] = "2.5.0"
    m4["gateway_version"] = "1.0.0"
    m4["stop_rule"] = "first_pass"
    m4["cost_tracking"] = "tokens_offline"
    m4["final_classification"] = "offline_verified"
    m4["evidence"][0]["attempt_timestamp"] = "2026-09-06T00:00:00Z"
    validator.validate_manifest(m4)
    jsonschema.validate(m4, schema)


# Test 23: (T3) Destructive / in-place migration does not mutate input on invalid manifest
def test_migrate_v1_invalid_does_not_modify_input(tmp_path):
    invalid_v1 = {
        "schema_version": "1.0",
        "battery_id": "legacy-battery",
        "catalog_snapshot_id": "snap-legacy",
        "controls": {"temp": 0},
        "planned_slots": [
            {
                "slot_id": "s1",
                "capability": "c1",
                "rubric_version": "r1",
                "input_sha256": "0" * 64,
            }
        ],
        "evidence": [
            {
                "slot_id": "s1",
                "attempt": 1,
                "status": "invalid_unknown_status",
                "requested_model": "model-1",
            }
        ],
    }
    manifest_path = tmp_path / "manifest_v1.json"
    original_content = json.dumps(invalid_v1, indent=2) + "\n"
    manifest_path.write_text(original_content, encoding="utf-8")
    receipt_path = tmp_path / "receipt.json"

    old_argv = sys.argv
    try:
        sys.argv = [
            "validate_capability_battery.py",
            "--manifest", str(manifest_path),
            "--receipt-out", str(receipt_path),
            "--migrate-v1",
        ]
        exit_code = validator.main()
        assert exit_code == 2
        assert manifest_path.read_text(encoding="utf-8") == original_content
    finally:
        sys.argv = old_argv
