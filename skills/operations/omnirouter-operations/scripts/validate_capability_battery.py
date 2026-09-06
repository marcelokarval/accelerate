#!/usr/bin/env python3
"""Offline validator for a constrained, redacted capability-battery manifest v2.0."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import jsonschema

SCHEMA_PATH = Path(__file__).resolve().parent.parent / "assets/capability-battery-manifest.schema.json"
_SCHEMA_CACHE: dict[str, Any] | None = None

STATUSES = {"pass", "semantic_fail", "transport_fail", "protocol_fail", "not_run", "inconclusive"}
ID_RE = re.compile(r"^[A-Za-z0-9._-]{1,160}$")
MODEL_ID_RE = re.compile(r"^[A-Za-z0-9._/:@-]{1,160}$")
SHA_RE = re.compile(r"^[a-f0-9]{64}$")
SAFE_TEXT_RE = re.compile(r"^[^\r\n\t\x00-\x1f\x7f-\x9f]{1,240}$")
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
    if len(value) > 240 or not SAFE_TEXT_RE.fullmatch(value):
        raise ValueError(f"unsafe or oversized {name}")


def migrate_manifest_v1_to_v2(data: dict[str, Any]) -> dict[str, Any]:
    """Safely migrate a valid v1.0 manifest dictionary to v2.0 structure."""
    if data.get("schema_version") not in {"1.0", "2.0"}:
        raise ValueError("unsupported manifest schema version")
    migrated = dict(data)
    migrated["schema_version"] = "2.0"
    return migrated


def get_schema() -> dict[str, Any]:
    global _SCHEMA_CACHE
    if _SCHEMA_CACHE is None:
        _SCHEMA_CACHE = load_json(SCHEMA_PATH)
    return _SCHEMA_CACHE


def validate_manifest(data: dict[str, Any]) -> dict[str, int]:
    """Validate the manifest against structural, schema, and semantic invariants."""
    reject_secrets(data)
    if not isinstance(data, dict):
        raise ValueError("manifest must be a JSON object")

    # Authoritative structural validation via JSON Schema
    schema = get_schema()
    try:
        jsonschema.validate(instance=data, schema=schema)
    except jsonschema.ValidationError as exc:
        field = ".".join(str(p) for p in exc.path) or "manifest"
        msg = exc.message
        if exc.validator == "pattern" and isinstance(exc.instance, str) and ("\n" in exc.instance or "\r" in exc.instance):
            msg = f"{field} must be a non-empty, single-line string: {msg}"
        elif exc.validator in ("maxLength", "maxProperties"):
            msg = f"oversized {field}: {msg}"
        raise ValueError(f"schema validation error at {field}: {msg}") from exc

    slots = data["planned_slots"]
    evidence = data["evidence"]

    slot_defs: dict[str, dict[str, Any]] = {}
    for slot in slots:
        slot_id = slot["slot_id"]
        if slot_id in slot_defs:
            raise ValueError(f"duplicate planned slot: {slot_id}")
        slot_defs[slot_id] = slot

    seen_attempts: set[tuple[str, int]] = set()
    represented_slots: set[str] = set()
    attempts_by_slot: dict[str, list[int]] = {}
    requested_model_by_slot: dict[str, str] = {}

    for index, row in enumerate(evidence):
        slot_id = row["slot_id"]
        if slot_id not in slot_defs:
            raise ValueError(f"evidence references unplanned slot: {slot_id}")

        attempt = row["attempt"]
        if (slot_id, attempt) in seen_attempts:
            raise ValueError(f"duplicate attempt {attempt} for slot {slot_id}")
        seen_attempts.add((slot_id, attempt))
        represented_slots.add(slot_id)
        attempts_by_slot.setdefault(slot_id, []).append(attempt)

        if slot_id not in requested_model_by_slot:
            planned = slot_defs[slot_id]
            if "requested_model" in planned and planned["requested_model"] != row["requested_model"]:
                raise ValueError(
                    f"requested_model {row['requested_model']!r} does not match planned slot {planned['requested_model']!r} for {slot_id}"
                )
            requested_model_by_slot[slot_id] = row["requested_model"]
        elif requested_model_by_slot[slot_id] != row["requested_model"]:
            raise ValueError(
                f"retry changing requested_model is forbidden for slot {slot_id}: "
                f"{requested_model_by_slot[slot_id]!r} -> {row['requested_model']!r}"
            )

        status = row["status"]
        http_status = row.get("http_status")
        response_sha = row.get("response_sha256")

        if status == "pass":
            if http_status is None or not (200 <= http_status < 300):
                raise ValueError(f"status 'pass' requires successful HTTP 2xx transport; received http_status={http_status} for {slot_id}")
            if not response_sha:
                raise ValueError(f"status 'pass' requires non-empty response_sha256 for {slot_id}")

        elif status == "semantic_fail":
            if http_status is None or not (200 <= http_status < 300):
                raise ValueError(f"status 'semantic_fail' requires completed HTTP transport (2xx); received http_status={http_status} for {slot_id}")
            if not response_sha:
                raise ValueError(f"status 'semantic_fail' requires non-empty response_sha256 for {slot_id}")
            if not effective_model:
                raise ValueError(f"status 'semantic_fail' requires non-empty effective_model for {slot_id}")
            if "reason" not in row or not row["reason"]:
                raise ValueError(f"status 'semantic_fail' requires an explanatory reason for {slot_id}")

        elif status == "transport_fail":
            if http_status is not None and (200 <= http_status < 300):
                raise ValueError(f"status 'transport_fail' cannot have 2xx HTTP status: {http_status} for {slot_id}")
            if "reason" not in row or not row["reason"]:
                raise ValueError(f"status 'transport_fail' requires an explanatory reason for {slot_id}")

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
    parser.add_argument("--migrated-out", type=Path, help="path to write migrated v2.0 manifest")
    args = parser.parse_args()
    try:
        manifest_data = load_json(args.manifest)
        if args.migrate_v1:
            if not args.migrated_out:
                raise ValueError("--migrate-v1 requires --migrated-out to be specified")
            if args.migrated_out.is_symlink():
                raise ValueError(f"--migrated-out cannot be a symlink: {args.migrated_out}")
            if args.manifest.resolve() == args.migrated_out.resolve():
                raise ValueError("--migrated-out cannot point to the same file as --manifest")

            migrated_data = migrate_manifest_v1_to_v2(manifest_data)
            # Validate in-memory representation FIRST before touching any file on disk!
            counts = validate_manifest(migrated_data)
            manifest_data = migrated_data
            serialized = json.dumps(manifest_data, indent=2, sort_keys=True) + "\n"

            target_out = args.migrated_out
            target_out.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile("w", dir=target_out.parent, prefix=".migrated-", delete=False, encoding="utf-8") as tmp:
                tmp.write(serialized)
                tmp_path = Path(tmp.name)
            try:
                os.replace(tmp_path, target_out)
            finally:
                if tmp_path.exists():
                    tmp_path.unlink()
            raw = serialized.encode("utf-8")
        else:
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
        with tempfile.NamedTemporaryFile("w", dir=args.receipt_out.parent, prefix=".receipt-", delete=False, encoding="utf-8") as tmp:
            tmp.write(json.dumps(receipt, sort_keys=True, indent=2) + "\n")
            tmp_path = Path(tmp.name)
        try:
            os.replace(tmp_path, args.receipt_out)
        finally:
            if tmp_path.exists():
                tmp_path.unlink()
        print(json.dumps(receipt, sort_keys=True))
    except ValueError as exc:
        print(f"validation failed: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
