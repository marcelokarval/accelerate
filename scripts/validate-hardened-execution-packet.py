#!/usr/bin/env python3
"""Validate an Accelerate hardened execution packet without external packages."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


REPO = Path(__file__).resolve().parents[1]
SCHEMA_PATH = REPO / "core/contracts/hardened-execution-packet.schema.json"
SECRET_KEY = re.compile(r"(?:api[_-]?key|authorization|credential|password|secret|token)", re.I)
SECRET_VALUE = re.compile(
    r"(?:Bearer\s+[A-Za-z0-9._-]{16,}|sk-[A-Za-z0-9_-]{16,}|"
    r"gh[pousr]_[A-Za-z0-9_]{16,}|AIza[0-9A-Za-z_-]{20,}|"
    r"-----BEGIN [A-Z ]*PRIVATE KEY-----)"
)


def _resolve(schema: dict[str, Any], root: dict[str, Any]) -> dict[str, Any]:
    reference = schema.get("$ref")
    if not reference:
        return schema
    if not reference.startswith("#/"):
        raise ValueError(f"unsupported schema reference: {reference}")
    resolved: Any = root
    for part in reference[2:].split("/"):
        resolved = resolved[part]
    return resolved


def _type_matches(value: Any, expected: str) -> bool:
    return {
        "object": isinstance(value, dict),
        "array": isinstance(value, list),
        "string": isinstance(value, str),
    }.get(expected, True)


def _validate_schema(
    value: Any,
    schema: dict[str, Any],
    root: dict[str, Any],
    path: str,
) -> list[str]:
    schema = _resolve(schema, root)
    errors: list[str] = []
    expected_type = schema.get("type")
    if expected_type and not _type_matches(value, expected_type):
        return [f"{path or '$'}: expected {expected_type}"]
    if "const" in schema and value != schema["const"]:
        errors.append(f"{path or '$'}: value does not match contract")
    if "enum" in schema and value not in schema["enum"]:
        errors.append(f"{path or '$'}: value is not allowed")
    if isinstance(value, str) and len(value) < schema.get("minLength", 0):
        errors.append(f"{path or '$'}: value must not be empty")
    if isinstance(value, list):
        if len(value) < schema.get("minItems", 0):
            errors.append(f"{path or '$'}: list must not be empty")
        item_schema = schema.get("items")
        if item_schema:
            for index, item in enumerate(value):
                errors.extend(_validate_schema(item, item_schema, root, f"{path}[{index}]"))
    if isinstance(value, dict):
        properties = schema.get("properties", {})
        for required in schema.get("required", []):
            if required not in value:
                child = f"{path}.{required}" if path else required
                errors.append(f"{child}: required field is missing")
        if schema.get("additionalProperties") is False:
            for key in value.keys() - properties.keys():
                child = f"{path}.{key}" if path else key
                errors.append(f"{child}: unknown field")
        for key in value.keys() & properties.keys():
            child = f"{path}.{key}" if path else key
            errors.extend(_validate_schema(value[key], properties[key], root, child))
    return errors


def _scan_secrets(value: Any, path: str = "") -> list[str]:
    errors: list[str] = []
    if isinstance(value, dict):
        for key, child in value.items():
            child_path = f"{path}.{key}" if path else key
            if SECRET_KEY.fullmatch(key):
                errors.append(f"{child_path}: secret-bearing field is forbidden")
            errors.extend(_scan_secrets(child, child_path))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            errors.extend(_scan_secrets(child, f"{path}[{index}]"))
    elif isinstance(value, str) and SECRET_VALUE.search(value):
        errors.append(f"{path or '$'}: secret-like value is forbidden")
    return errors


def validate_packet(payload: Any, schema_path: Path = SCHEMA_PATH) -> list[str]:
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    errors = _validate_schema(payload, schema, schema, "")
    errors.extend(_scan_secrets(payload))
    if isinstance(payload, dict):
        if payload.get("classification") != "non-trivial":
            errors.append("classification: hardened packets require non-trivial work")
        if payload.get("execution_route") == "orchestrated":
            delegation = payload.get("delegation_decision")
            tasks = delegation.get("tasks", []) if isinstance(delegation, dict) else []
            if len(tasks) < 2:
                errors.append(
                    "delegation_decision.tasks: orchestrated route requires at least two tasks"
                )
    return sorted(set(errors))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("packet", type=Path)
    parser.add_argument("--schema", type=Path, default=SCHEMA_PATH)
    args = parser.parse_args()
    try:
        payload = json.loads(args.packet.read_text(encoding="utf-8"))
        errors = validate_packet(payload, args.schema)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL: unable to validate packet: {type(error).__name__}")
        return 2
    if errors:
        for error in errors:
            print(f"FAIL: {error}")
        return 1
    print("PASS: hardened execution packet is valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
