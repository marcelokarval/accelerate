#!/usr/bin/env python3
"""Inspect bounded OpenCode declarations without starting OpenCode or reading secrets."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import stat
import sys
from pathlib import Path
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit


SCHEMA = "accelerate.opencode-host-inspection/1"
SENSITIVE = re.compile(r"(?i)(authorization|credential|password|secret|token|api[_-]?key)")


class InspectionError(ValueError):
    """Closed inspection failure with a non-sensitive machine code."""

    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


def read_json_file(label: str, path: Path) -> tuple[dict, dict]:
    try:
        metadata = path.lstat()
    except OSError as error:
        raise InspectionError(f"{label}_unavailable") from error
    if stat.S_ISLNK(metadata.st_mode) or not stat.S_ISREG(metadata.st_mode):
        raise InspectionError(f"{label}_not_regular_file")
    try:
        payload = path.read_bytes()
        parsed = json.loads(payload)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as error:
        raise InspectionError(f"{label}_invalid_json") from error
    if not isinstance(parsed, dict):
        raise InspectionError(f"{label}_invalid_shape")
    evidence = {
        "role": label,
        "path": str(path.absolute()),
        "size": len(payload),
        "sha256": hashlib.sha256(payload).hexdigest(),
    }
    return parsed, evidence


def public_label(value: object, label: str) -> str | None:
    if value is None:
        return None
    if not isinstance(value, str) or not value or len(value) > 128 or SENSITIVE.search(value):
        raise InspectionError(f"{label}_invalid")
    return value


def redact_plugin_declaration(value: str) -> str:
    if SENSITIVE.search(value):
        return "[redacted]"
    redacted = value
    try:
        parts = urlsplit(redacted)
        port = f":{parts.port}" if parts.port is not None else ""
    except ValueError:
        return "[redacted-invalid-plugin-declaration]"
    if parts.scheme and parts.netloc:
        hostname = parts.hostname or ""
        userinfo = "[redacted]@" if parts.username is not None or parts.password is not None else ""
        query = urlencode([(key, "[redacted]") for key, _value in parse_qsl(parts.query, keep_blank_values=True)])
        redacted = urlunsplit((parts.scheme, f"{userinfo}{hostname}{port}", parts.path, query, ""))
    return redacted


def plugin_declarations(config: dict) -> tuple[list[str], list[str]]:
    if "plugin" in config and "plugins" in config:
        raise InspectionError("opencode_config_ambiguous_plugin_fields")
    raw = config.get("plugin", config.get("plugins", []))
    if not isinstance(raw, list) or any(not isinstance(value, str) or not value for value in raw):
        raise InspectionError("opencode_config_invalid_plugins")
    return raw, [redact_plugin_declaration(value) for value in raw]


def is_accelerate_declaration(value: str, expected: str | None) -> bool:
    normalized = value.split("?", 1)[0].rstrip("/").lower()
    names = ("/accelerate-plugin.js", "/accelerate.js", "/accelerate-plugin.mjs", "/accelerate.mjs")
    if normalized.endswith(names):
        return True
    return expected is not None and normalized == expected.split("?", 1)[0].rstrip("/").lower()


def inspect(args: argparse.Namespace) -> dict:
    opencode_package, opencode_package_evidence = read_json_file("opencode_package", args.opencode_package)
    opencode_config, opencode_config_evidence = read_json_file("opencode_config", args.opencode_config)
    slim_package, slim_package_evidence = read_json_file("slim_package", args.slim_package)
    slim_config, slim_config_evidence = read_json_file("slim_config", args.slim_config)

    if opencode_package.get("name") != "@opencode/cli":
        raise InspectionError("opencode_package_identity_mismatch")
    if slim_package.get("name") != "oh-my-opencode-slim":
        raise InspectionError("slim_package_identity_mismatch")
    opencode_version = public_label(opencode_package.get("version"), "opencode_package_version")
    slim_version = public_label(slim_package.get("version"), "slim_package_version")
    if opencode_version is None or slim_version is None:
        raise InspectionError("package_version_missing")

    declared_plugins, redacted_plugins = plugin_declarations(opencode_config)
    expected_accelerate = str(args.expected_accelerate_plugin) if args.expected_accelerate_plugin else None
    accelerate_declared = any(is_accelerate_declaration(value, expected_accelerate) for value in declared_plugins)
    slim_declarations = [value for value in declared_plugins if "oh-my-opencode-slim" in value.lower()]
    declared_versions = {
        match.group(1)
        for value in slim_declarations
        if (match := re.search(r"oh-my-opencode-slim@([^/\\?#]+)", value, re.IGNORECASE))
    }
    slim_identity_matches = bool(slim_declarations) and (not declared_versions or declared_versions == {slim_version})

    preset = public_label(slim_config.get("preset"), "slim_preset")
    default_agent = public_label(
        opencode_config.get("default_agent", opencode_config.get("defaultAgent")),
        "opencode_default_agent",
    )
    presets = slim_config.get("presets", {})
    if not isinstance(presets, dict):
        raise InspectionError("slim_config_invalid_presets")
    active = presets.get(preset, {}) if preset is not None else {}
    if not isinstance(active, dict):
        raise InspectionError("slim_config_invalid_active_preset")
    orchestrator = active.get("orchestrator", {})
    if not isinstance(orchestrator, dict):
        raise InspectionError("slim_config_invalid_orchestrator")
    skills = orchestrator.get("skills", [])
    mcps = orchestrator.get("mcps", [])
    if not isinstance(skills, list) or not isinstance(mcps, list):
        raise InspectionError("slim_config_invalid_orchestrator_capabilities")
    disabled = slim_config.get("disabled_agents", [])
    if not isinstance(disabled, list) or any(not isinstance(value, str) for value in disabled):
        raise InspectionError("slim_config_invalid_disabled_agents")

    flags = {
        "filesystem_declarations_observed": True,
        "cli_readback_observed": False,
        "log_evidence_used": False,
        "model_invoked": False,
        "omo_slim_declared": bool(slim_declarations),
        "omo_slim_package_identity_matches": slim_identity_matches,
        "omo_slim_loaded_observed": False,
        "accelerate_loader_declared": accelerate_declared,
        "accelerate_loader_loaded_observed": False,
        "wildcard_skills_declared": "*" in skills,
        "wildcard_mcps_declared": "*" in mcps,
        "designer_declared": "designer" in active and "designer" not in disabled,
        "council_declared": ("council" in active or isinstance(slim_config.get("council"), dict)) and "council" not in disabled,
        "nested_delegation_qualified": False,
        "asds_execution_consumer_host_qualified": False,
    }
    blockers = [
        "fresh_cli_readback_missing",
        "accelerate_loader_runtime_readback_missing",
        "asds_execution_consumer_host_contract_unproven",
    ]
    if not accelerate_declared:
        blockers.append("accelerate_loader_not_declared")
    if not slim_identity_matches:
        blockers.append("omo_slim_identity_unverified")
    if flags["wildcard_skills_declared"] or flags["wildcard_mcps_declared"]:
        blockers.append("wildcard_capability_declaration")
    if flags["designer_declared"] or flags["council_declared"]:
        blockers.append("suppressed_role_declared")

    return {
        "schema_version": SCHEMA,
        "inspection_mode": "read-only",
        "authority": "filesystem declarations only; not CLI, loader, model, log, permission or ASDS runtime authority",
        "runtime_status": "blocked",
        "consumer_disposition": "manual_handoff_required",
        "packages": {
            "opencode": {"name": "@opencode/cli", "version": opencode_version},
            "omo_slim": {"name": "oh-my-opencode-slim", "version": slim_version},
        },
        "configuration": {
            "plugin_declarations": redacted_plugins,
            "default_agent": default_agent,
            "omo_slim_preset": preset,
        },
        "capabilities": flags,
        "blockers": blockers,
        "evidence": [
            opencode_package_evidence,
            opencode_config_evidence,
            slim_package_evidence,
            slim_config_evidence,
        ],
        "next_stage": "source-governed loader with preview, explicit apply authorization, readback and rollback; not implemented by this inspector",
    }


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description=__doc__)
    result.add_argument("--opencode-package", type=Path, required=True)
    result.add_argument("--opencode-config", type=Path, required=True)
    result.add_argument("--slim-package", type=Path, required=True)
    result.add_argument("--slim-config", type=Path, required=True)
    result.add_argument("--expected-accelerate-plugin", type=Path)
    result.add_argument("--pretty", action="store_true")
    return result


def main() -> int:
    args = parser().parse_args()
    try:
        receipt = inspect(args)
    except InspectionError as error:
        print(json.dumps({"schema_version": SCHEMA, "status": "error", "error": {"code": error.code}}, sort_keys=True), file=sys.stderr)
        return 2
    print(json.dumps(receipt, indent=2 if args.pretty else None, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
