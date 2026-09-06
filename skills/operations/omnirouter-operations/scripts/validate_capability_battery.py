#!/usr/bin/env python3
"""Offline validator for a constrained, redacted capability-battery manifest v2.0."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

STATUSES = {"pass", "semantic_fail", "transport_fail", "protocol_fail", "not_run", "inconclusive"}
ID_RE = re.compile(r"^[A-Za-z0-9._-]{1,160}$")
MODEL_ID_RE = re.compile(r"^[A-Za-z0-9._/:@-]{1,160}$")
SHA_RE = re.compile(r"^[a-f0-9]{64}$")
SAFE_TEXT_RE = re.compile(r"^[ A-Za-z0-9._:/@+=,;()\[\]{}|\\-]{1,240}$")
FORBIDDEN_KEY = re.compile(
    r"(?:^|_)(?:raw|authorization|cookie|token|secret|api_key|password|headers?|body|prompt|response)(?:_|$)",
    re.I,
)
SECRET_VALUE = re.compile(
    r"(?:bearer\s+\S+|(?:sk|rk|pk|ghp)_[A-Za-z0-9_-]{12,}|-----BEGIN [A-Z ]+PRIVATE KEY-----|[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,})",
    re.I,
)


def load_json(path: Path) -> dict[str, Any]:
    try:
        with path.open(encoding="utf-8") as handle:
            return json.load(handle)
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read JSON {path}: {exc}") from exc


def reject_secrets(value: Any, trail: str = "$") -> None:
    if isinstance(value, dict):
        for key, child in value.items():
            if key != "response_sha256" and FORBIDDEN_KEY.search(key):
                raise ValueError(f"forbidden raw or secret-shaped field at {trail}.{key}")
            reject_secrets(child, f"{trail}.{key}")
    elif isinstance(value, list):
        for index, child in enumerate(value):
            reject_secrets(child, f"{trail}[{index}]")
    elif isinstance(value, str) and SECRET_VALUE.search(value):
        raise ValueError(f"secret-shaped value at {trail}")


def safe_text(value: Any, name: str) -> None:
    if not isinstance(value, str) or not value or "\n" in value or "\r" in value:
        raise ValueError(f"{name} must be a non-empty, single-line string")
    if not SAFE_TEXT_RE.fullmatch(value):
        raise ValueError(f"unsafe or oversized {name}")


def migrate_manifest_v1_to_v2(data: dict[str, Any]) -> dict[str, Any]:
    """Safely migrate a valid v1.0 manifest dictionary to v2.0 structure."""
    if data.get("schema_version") not in {"1.0", "2.0"}:
        raise ValueError("unsupported manifest schema version")
    migrated = dict(data)
    migrated["schema_version"] = "2.0"
    return migrated


def validate_manifest(data: dict[str, Any]) -> dict[str, int]:
    """Validate the manifest against structural, schema, and semantic invariants."""
    reject_secrets(data)
    if not isinstance(data, dict):
        raise ValueError("manifest must be a JSON object")

    schema_version = data.get("schema_version")
    if schema_version not in {"1.0", "2.0"}:
        raise ValueError(f"unsupported schema_version: {schema_version!r}; expected '2.0' (or '1.0' legacy)")

    required_keys = {"schema_version", "battery_id", "catalog_snapshot_id", "controls", "planned_slots", "evidence"}
    optional_top_keys = {"provider", "route", "harness", "client_version", "gateway_version", "stop_rule", "cost_tracking", "final_classification"}
    if not required_keys <= set(data) or (set(data) - required_keys - optional_top_keys):
        raise ValueError("manifest fields must exactly match the redacted schema")

    if not isinstance(data["battery_id"], str) or not ID_RE.fullmatch(data["battery_id"]):
        raise ValueError(f"invalid battery_id: {data.get('battery_id')!r}")

    safe_text(data["catalog_snapshot_id"], "catalog_snapshot_id")

    # Optional top-level fields validation
    for opt_field in ("provider", "route", "harness"):
        if opt_field in data:
            safe_text(data[opt_field], opt_field)

    # Controls must be a non-empty mapping of scalar safe values
    controls = data.get("controls")
    if not isinstance(controls, dict) or not controls:
        raise ValueError("controls must be a non-empty object")
    for key, value in controls.items():
        if not ID_RE.fullmatch(key):
            raise ValueError(f"invalid control key: {key!r}")
        if isinstance(value, bool) or isinstance(value, int):
            continue
        if isinstance(value, str):
            safe_text(value, f"control {key}")
        else:
            raise ValueError(f"invalid control value type for {key}: must be scalar bool, int, or safe string")

    slots = data.get("planned_slots")
    evidence = data.get("evidence")
    if not isinstance(slots, list) or not slots or not isinstance(evidence, list) or not evidence:
        raise ValueError("planned_slots and evidence must be non-empty lists")

    slot_defs: dict[str, dict[str, Any]] = {}
    for slot in slots:
        if not isinstance(slot, dict):
            raise ValueError("planned slot must be an object")
        slot_required = {"slot_id", "capability", "rubric_version", "input_sha256"}
        slot_optional = {"requested_model", "reasoning_effort", "timeout_seconds", "max_retries"}
        if not slot_required <= set(slot) or (set(slot) - slot_required - slot_optional):
            raise ValueError("invalid planned slot fields")

        slot_id = slot["slot_id"]
        if not isinstance(slot_id, str) or not ID_RE.fullmatch(slot_id):
            raise ValueError(f"invalid slot identifier: {slot_id!r}")
        if slot_id in slot_defs:
            raise ValueError(f"duplicate planned slot: {slot_id}")

        safe_text(slot["capability"], f"slot {slot_id} capability")
        safe_text(slot["rubric_version"], f"slot {slot_id} rubric_version")

        input_sha = slot["input_sha256"]
        if not isinstance(input_sha, str) or not SHA_RE.fullmatch(input_sha):
            raise ValueError(f"invalid input hash for slot {slot_id}")

        if "requested_model" in slot:
            if not isinstance(slot["requested_model"], str) or not MODEL_ID_RE.fullmatch(slot["requested_model"]):
                raise ValueError(f"invalid slot requested_model for slot {slot_id}")

        slot_defs[slot_id] = slot

    seen_attempts: set[tuple[str, int]] = set()
    represented_slots: set[str] = set()
    attempts_by_slot: dict[str, list[int]] = {}
    requested_model_by_slot: dict[str, str] = {}

    permitted_evidence_keys = {
        "slot_id", "attempt", "status", "requested_model", "effective_model",
        "http_status", "artifact_locator", "response_sha256", "semantic_verdict",
        "reason", "attempt_timestamp"
    }

    for index, row in enumerate(evidence):
        if not isinstance(row, dict):
            raise ValueError(f"evidence entry at index {index} must be an object")
        required_evidence = {"slot_id", "attempt", "status", "requested_model"}
        if not required_evidence <= set(row) or (set(row) - permitted_evidence_keys):
            raise ValueError(f"invalid evidence fields at index {index}")

        slot_id = row["slot_id"]
        if slot_id not in slot_defs:
            raise ValueError(f"evidence references unplanned slot: {slot_id}")

        attempt = row["attempt"]
        if not isinstance(attempt, int) or attempt < 1:
            raise ValueError(f"invalid attempt number for {slot_id}: {attempt}")

        if (slot_id, attempt) in seen_attempts:
            raise ValueError(f"duplicate attempt {attempt} for slot {slot_id}")
        seen_attempts.add((slot_id, attempt))
        represented_slots.add(slot_id)
        attempts_by_slot.setdefault(slot_id, []).append(attempt)

        status = row["status"]
        if status not in STATUSES:
            raise ValueError(f"invalid status {status!r} for slot {slot_id}")

        req_model = row["requested_model"]
        if not isinstance(req_model, str) or not MODEL_ID_RE.fullmatch(req_model):
            raise ValueError(f"invalid requested_model {req_model!r} for slot {slot_id}")

        # Slot requested_model consistency across retries:
        if slot_id in requested_model_by_slot:
            if requested_model_by_slot[slot_id] != req_model:
                raise ValueError(
                    f"retry changing requested_model is forbidden for slot {slot_id}: "
                    f"was {requested_model_by_slot[slot_id]!r}, now {req_model!r}"
                )
        else:
            # Check consistency with slot definition if present
            if "requested_model" in slot_defs[slot_id] and slot_defs[slot_id]["requested_model"] != req_model:
                raise ValueError(
                    f"evidence requested_model {req_model!r} does not match planned slot {slot_defs[slot_id]['requested_model']!r}"
                )
            requested_model_by_slot[slot_id] = req_model

        # Safe text checks for optional string fields
        for key in ("effective_model", "artifact_locator", "semantic_verdict", "reason"):
            if key in row:
                safe_text(row[key], f"evidence {slot_id} attempt {attempt} {key}")

        if "response_sha256" in row and (not isinstance(row["response_sha256"], str) or not SHA_RE.fullmatch(row["response_sha256"])):
            raise ValueError(f"invalid response_sha256 for slot {slot_id} attempt {attempt}")

        http_status = row.get("http_status")
        if http_status is not None:
            if not isinstance(http_status, int) or not 100 <= http_status <= 599:
                raise ValueError(f"invalid http_status {http_status} for slot {slot_id} attempt {attempt}")

        # Cross-invariant rules per status:
        if status == "pass":
            if http_status is None or not (200 <= http_status <= 299):
                raise ValueError(
                    f"status 'pass' requires successful HTTP 2xx transport; received http_status={http_status} for {slot_id}"
                )
            if "response_sha256" not in row:
                raise ValueError(f"status 'pass' requires response_sha256 for {slot_id}")

        elif status == "semantic_fail":
            if http_status is None or not (200 <= http_status <= 299):
                raise ValueError(
                    f"status 'semantic_fail' requires completed HTTP transport (2xx); received http_status={http_status} for {slot_id}"
                )
            if "response_sha256" not in row:
                raise ValueError(f"status 'semantic_fail' requires response_sha256 for {slot_id}")

        elif status == "transport_fail":
            if http_status is not None and (200 <= http_status <= 299):
                raise ValueError(
                    f"status 'transport_fail' cannot have successful HTTP 2xx status; received {http_status} for {slot_id}"
                )

        elif status == "protocol_fail":
            if "reason" not in row or not row["reason"]:
                raise ValueError(f"status 'protocol_fail' requires a reason explaining the contract violation for {slot_id}")

        elif status == "not_run":
            if http_status is not None:
                raise ValueError(f"status 'not_run' must not contain http_status for {slot_id}")
            if "response_sha256" in row:
                raise ValueError(f"status 'not_run' must not contain response_sha256 for {slot_id}")
            if "effective_model" in row:
                raise ValueError(f"status 'not_run' must not contain effective_model for {slot_id}")
            if "reason" not in row or not row["reason"]:
                raise ValueError(f"status 'not_run' requires a reason explaining why the slot was skipped for {slot_id}")

        elif status == "inconclusive":
            if "reason" not in row or not row["reason"]:
                raise ValueError(f"status 'inconclusive' requires an explanatory reason for {slot_id}")

    missing_slots = set(slot_defs) - represented_slots
    if missing_slots:
        raise ValueError("planned canonical slots lack evidence: " + ", ".join(sorted(missing_slots)))

    for slot_id, numbers in attempts_by_slot.items():
        if sorted(numbers) != list(range(1, max(numbers) + 1)):
            raise ValueError(f"attempt history is not contiguous for {slot_id}; retries cannot overwrite failures")

    return {"planned_slot_count": len(slots), "evidence_count": len(evidence)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--receipt-out", required=True, type=Path)
    parser.add_argument("--migrate-v1", action="store_true", help="safely migrate v1 manifest to v2.0")
    args = parser.parse_args()
    try:
        manifest_data = load_json(args.manifest)
        if args.migrate_v1:
            manifest_data = migrate_manifest_v1_to_v2(manifest_data)
            args.manifest.write_text(json.dumps(manifest_data, indent=2, sort_keys=True) + "\n", encoding="utf-8")
        counts = validate_manifest(manifest_data)
        raw = args.manifest.read_bytes()
        receipt = {
            "schema_version": manifest_data.get("schema_version", "2.0"),
            "status": "valid",
            "manifest_sha256": hashlib.sha256(raw).hexdigest(),
            "validated_at": datetime.now(timezone.utc).isoformat(),
            **counts,
        }
        args.receipt_out.parent.mkdir(parents=True, exist_ok=True)
        args.receipt_out.write_text(json.dumps(receipt, sort_keys=True, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(receipt, sort_keys=True))
    except ValueError as exc:
        print(f"validation failed: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
