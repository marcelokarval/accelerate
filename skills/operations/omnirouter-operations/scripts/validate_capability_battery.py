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
MAX_MANIFEST_BYTES = 2 * 1024 * 1024
MAX_PLANNED_SLOTS = 1000
MAX_EVIDENCE_ROWS = 10000
MAX_ATTEMPT = 101
MAX_CONTROL_PROPERTIES = 32
_SCHEMA_CACHE: dict[str, Any] | None = None

STATUSES = {"pass", "semantic_fail", "transport_fail", "protocol_fail", "not_run", "inconclusive"}
ID_RE = re.compile(r"^[A-Za-z0-9._-]{1,160}$")
MODEL_ID_RE = re.compile(r"^[A-Za-z0-9._/:@-]{1,160}$")
SHA_RE = re.compile(r"^[a-f0-9]{64}$")
SAFE_TEXT_RE = re.compile(r"^[^\r\n\t\x00-\x1f\x7f-\x9f]{1,240}$")
FORBIDDEN_KEY_PARTS = {
    "raw", "authorization", "cookie", "token", "secret", "apikey", "password",
    "header", "headers", "body", "prompt", "response", "credential", "credentials",
}
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


def read_manifest_bytes(path: Path) -> bytes:
    """Read one bounded, regular, non-symlink manifest and return those bytes."""
    try:
        fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0))
        try:
            stat = os.fstat(fd)
            if not stat.st_mode & 0o170000 == 0o100000:
                raise ValueError("manifest must be a regular file")
            if stat.st_size > MAX_MANIFEST_BYTES:
                raise ValueError("manifest exceeds maximum byte limit")
            with os.fdopen(fd, "rb") as handle:
                fd = -1
                raw = handle.read()
        finally:
            if fd >= 0:
                os.close(fd)
    except ValueError:
        raise
    except OSError as exc:
        raise ValueError("cannot read manifest input") from exc
    if len(raw) > MAX_MANIFEST_BYTES:
        raise ValueError("manifest exceeds maximum byte limit")
    return raw


def parse_json_bytes(raw: bytes) -> dict[str, Any]:
    try:
        value = json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ValueError("manifest is not valid UTF-8 JSON") from exc
    if not isinstance(value, dict):
        raise ValueError("manifest must be a JSON object")
    return value


def _key_parts(key: str) -> set[str]:
    normalized = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", key)
    return {part for part in re.split(r"[^A-Za-z0-9]+", normalized.lower()) if part}


def _forbidden_key(key: str) -> bool:
    parts = _key_parts(key)
    return bool(parts & FORBIDDEN_KEY_PARTS) or {"api", "key"} <= parts or {
        "private", "key"
    } <= parts or {"access", "key"} <= parts or {"client", "secret"} <= parts


def reject_secrets(value: Any, trail: str = "$") -> None:
    if isinstance(value, dict):
        for key, child in value.items():
            if key != "response_sha256" and _forbidden_key(key):
                raise ValueError(f"forbidden raw or secret-shaped field at {trail}")
            reject_secrets(child, trail)
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
    if data.get("schema_version") != "1.0":
        raise ValueError("migration accepts v1.0 manifests only")
    if not isinstance(data, dict) or not isinstance(data.get("planned_slots"), list) or not isinstance(data.get("evidence"), list):
        raise ValueError("v1 manifest is not migratable")
    requested_by_slot: dict[str, str] = {}
    for row in data["evidence"]:
        if not isinstance(row, dict) or not isinstance(row.get("slot_id"), str) or not isinstance(row.get("requested_model"), str) or not row["requested_model"]:
            raise ValueError("v1 evidence requires requested_model for migration")
        prior = requested_by_slot.setdefault(row["slot_id"], row["requested_model"])
        if prior != row["requested_model"]:
            raise ValueError("v1 migration has inconsistent requested_model")
    migrated = dict(data)
    migrated["schema_version"] = "2.0"
    migrated.setdefault("provider", "legacy")
    migrated.setdefault("route", "legacy")
    migrated.setdefault("harness", "legacy")
    for slot in migrated["planned_slots"]:
        if not isinstance(slot, dict) or slot.get("slot_id") not in requested_by_slot:
            raise ValueError("v1 migration lacks requested_model for planned slot")
        slot["requested_model"] = requested_by_slot[slot["slot_id"]]
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
    if len(data.get("controls", {})) > MAX_CONTROL_PROPERTIES:
        raise ValueError("controls exceeds maximum property limit")

    # Authoritative structural validation via JSON Schema
    schema = get_schema()
    try:
        jsonschema.validate(instance=data, schema=schema)
    except jsonschema.ValidationError as exc:
        field = ".".join(str(p) for p in exc.path) or "manifest"
        if exc.validator in ("maxLength", "maxProperties", "maxItems"):
            msg = f"oversized {field}"
        elif exc.validator == "pattern" and isinstance(exc.instance, str) and ("\n" in exc.instance or "\r" in exc.instance):
            msg = "field must be a non-empty, single-line string"
        else:
            msg = f"validator {exc.validator} rejected the field"
        raise ValueError(f"schema validation error at {field}: {msg}") from exc

    slots = data["planned_slots"]
    evidence = data["evidence"]
    if len(slots) > MAX_PLANNED_SLOTS:
        raise ValueError("planned_slots exceeds maximum slot limit")
    if len(evidence) > MAX_EVIDENCE_ROWS:
        raise ValueError("evidence exceeds maximum row limit")

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
        if attempt > MAX_ATTEMPT:
            raise ValueError(f"attempt exceeds maximum for slot {slot_id}")
        if (slot_id, attempt) in seen_attempts:
            raise ValueError(f"duplicate attempt {attempt} for slot {slot_id}")
        seen_attempts.add((slot_id, attempt))
        represented_slots.add(slot_id)
        attempts_by_slot.setdefault(slot_id, []).append(attempt)

        if slot_id not in requested_model_by_slot:
            planned = slot_defs[slot_id]
            if "requested_model" in planned and planned["requested_model"] != row["requested_model"]:
                raise ValueError(
                    "requested_model does not match planned slot for " + slot_id
                )
            requested_model_by_slot[slot_id] = row["requested_model"]
        elif requested_model_by_slot[slot_id] != row["requested_model"]:
            raise ValueError(
                f"retry changing requested_model is forbidden for slot {slot_id}"
            )

        status = row["status"]
        http_status = row.get("http_status")
        response_sha = row.get("response_sha256")
        effective_model = row.get("effective_model")

        if status == "pass":
            if http_status is None or not (200 <= http_status < 300):
                raise ValueError(f"status 'pass' requires successful HTTP 2xx transport; received http_status={http_status} for {slot_id}")
            if not response_sha or not effective_model or not row.get("semantic_verdict"):
                raise ValueError(f"status 'pass' requires response digest, effective model, and semantic verdict for {slot_id}")
            for field in ("provider", "route", "harness"):
                if not data.get(field):
                    raise ValueError(f"status 'pass' requires manifest {field} binding")

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
        if "max_retries" in slot_defs[slot_id] and max(numbers) > slot_defs[slot_id]["max_retries"] + 1:
            raise ValueError(f"attempt exceeds max_retries for {slot_id}")

    return {"planned_slot_count": len(slots), "evidence_count": len(evidence)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--receipt-out", required=True, type=Path)
    parser.add_argument("--migrate-v1", action="store_true", help="safely migrate v1 manifest to v2.0")
    parser.add_argument("--migrated-out", type=Path, help="path to write migrated v2.0 manifest")
    args = parser.parse_args()
    try:
        raw = read_manifest_bytes(args.manifest)
        manifest_data = parse_json_bytes(raw)
        manifest_bytes = raw
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
            manifest_bytes = serialized.encode("utf-8")

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
        else:
            counts = validate_manifest(manifest_data)

        receipt = {
            "schema_version": manifest_data.get("schema_version", "2.0"),
            "status": "valid",
            "manifest_sha256": hashlib.sha256(manifest_bytes).hexdigest(),
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
