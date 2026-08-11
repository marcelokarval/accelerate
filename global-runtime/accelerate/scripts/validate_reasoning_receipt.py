#!/usr/bin/env python3
"""Validate one Codex-native Accelerate reasoning decision receipt fail-closed."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
POLICY_PATH = ROOT / "assets/reasoning-effort-policy.json"
SCHEMA_PATH = ROOT / "assets/reasoning-decision-receipt.schema.json"
MODE_BASIS = {
    "single": "single-bounded",
    "parallel": "independent-lanes",
    "wave": "ordered-waves",
    "incident": "active-incident",
}
TYPED_REF = re.compile(r"^(?:artifact|cmd|test|runtime|doc|receipt|plane):.+$", re.IGNORECASE)


def load_object(path: Path, label: str) -> dict:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"invalid/missing {label}: {path}: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError(f"{label} root must be an object")
    return data


def validate(receipt: object, policy: dict, schema: dict, *, expected_mode: str, expected_kind: str | None) -> list[str]:
    if not isinstance(receipt, dict):
        return ["receipt root must be an object"]
    required = set(schema.get("required", []))
    allowed = set(schema.get("properties", {}))
    errors: list[str] = []
    missing = sorted(required - set(receipt))
    unsupported = sorted(set(receipt) - allowed)
    if missing:
        errors.append("missing required fields: " + ", ".join(missing))
    if unsupported:
        errors.append("unsupported fields: " + ", ".join(unsupported))
    if errors:
        return errors

    if receipt["receipt_version"] != 1:
        errors.append("receipt_version must be 1")
    if receipt["receipt_kind"] not in {"pre-create", "final-decision"}:
        errors.append("receipt_kind must be pre-create|final-decision")
    elif expected_kind and receipt["receipt_kind"] != expected_kind:
        errors.append(f"receipt_kind mismatch: expected {expected_kind}")
    if receipt["runtime"] != "codex":
        errors.append("runtime must be codex")
    if receipt["execution_mode"] != expected_mode:
        errors.append(f"execution_mode mismatch: expected {expected_mode}")
    if receipt["mode_basis"] != MODE_BASIS.get(expected_mode):
        errors.append(f"mode_basis mismatch for {expected_mode}")

    denominator = receipt["denominator"]
    if (
        not isinstance(denominator, dict)
        or set(denominator) != {"count", "source"}
        or not isinstance(denominator.get("count"), int)
        or isinstance(denominator.get("count"), bool)
        or denominator.get("count", 0) < 1
        or not isinstance(denominator.get("source"), str)
        or not TYPED_REF.match(denominator.get("source", ""))
    ):
        errors.append("denominator must contain positive count and typed source")
    dependencies = receipt["dependencies"]
    if not isinstance(dependencies, list) or any(not isinstance(item, str) or not TYPED_REF.match(item) for item in dependencies):
        errors.append("dependencies must be typed references")

    boundaries = receipt["side_effect_boundaries"]
    if not isinstance(boundaries, dict) or set(boundaries) != {"allowed", "forbidden"}:
        errors.append("side_effect_boundaries must contain allowed and forbidden")
    else:
        allowed_boundaries, forbidden_boundaries = boundaries["allowed"], boundaries["forbidden"]
        if (
            not isinstance(allowed_boundaries, list)
            or not isinstance(forbidden_boundaries, list)
            or any(not isinstance(item, str) or not item for item in [*allowed_boundaries, *forbidden_boundaries])
        ):
            errors.append("side-effect boundaries must be string lists")
        elif set(allowed_boundaries) & set(forbidden_boundaries):
            errors.append("side-effect boundaries overlap")

    if receipt["prompt_hardening"] not in policy["prompt_hardening_modes"]:
        errors.append("invalid prompt_hardening")
    effort = receipt["selected_effort"]
    if effort not in policy["decision_efforts"]:
        errors.append("invalid selected_effort")
    if receipt["basis_code"] not in policy["basis_codes"]:
        errors.append("invalid basis_code")
    if receipt["observable_status"] not in {"not-applicable", "sufficient", "insufficient", "conflicting"}:
        errors.append("invalid observable_status")

    high_policy = policy["high_escalation"]
    triggers = {item["id"] for item in high_policy["triggers"]}
    if effort == "high":
        if receipt["trigger"] not in triggers:
            errors.append("high requires an allowed trigger")
    elif receipt["trigger"] is not None:
        errors.append("non-high trigger must be null")

    evidence = receipt["evidence"]
    if not isinstance(evidence, list) or not evidence or any(not isinstance(item, str) or not TYPED_REF.match(item) for item in evidence):
        errors.append("evidence must contain typed references")
    lower_effort = receipt["lower_effort_insufficiency"]
    if lower_effort not in policy["lower_effort_insufficiency_codes"]:
        errors.append("invalid lower_effort_insufficiency")
    elif effort == "high" and lower_effort in high_policy.get("lower_effort_insufficiency_forbidden", []):
        errors.append("high requires material lower_effort_insufficiency")

    budget = receipt["budget"]
    budget_fields = {"model_calls", "max_tool_calls", "max_correction_loops"}
    budget_valid = (
        isinstance(budget, dict)
        and set(budget) == budget_fields
        and all(
            isinstance(budget.get(field), int)
            and not isinstance(budget.get(field), bool)
            and budget[field] >= 0
            for field in budget_fields
        )
    )
    if not budget_valid:
        errors.append("budget must contain non-negative integer limits")
    elif effort == "high" and budget["model_calls"] < high_policy.get("budget_minimums", {}).get("model_calls", 1):
        errors.append("high requires budget.model_calls >= 1")
    if receipt["stop_condition"] not in policy["stop_condition_codes"]:
        errors.append("invalid stop_condition")
    return errors


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate a Codex Accelerate reasoning receipt.")
    parser.add_argument("receipt", type=Path)
    parser.add_argument("--expected-mode", required=True, choices=sorted(MODE_BASIS))
    parser.add_argument("--expected-kind", choices=["pre-create", "final-decision"])
    parser.add_argument("--format", choices=["json", "text"], default="text")
    args = parser.parse_args(argv)
    try:
        policy = load_object(POLICY_PATH, "policy")
        schema = load_object(SCHEMA_PATH, "receipt schema")
        receipt = load_object(args.receipt.expanduser().resolve(), "receipt")
        errors = validate(
            receipt,
            policy,
            schema,
            expected_mode=args.expected_mode,
            expected_kind=args.expected_kind,
        )
    except ValueError as exc:
        errors = [str(exc)]
    report = {"status": "PASS" if not errors else "FAIL", "runtime": "codex", "errors": errors}
    if args.format == "json":
        print(json.dumps(report, ensure_ascii=False, indent=2))
    else:
        print("Codex reasoning receipt: " + report["status"])
        for error in errors:
            print(f"- {error}")
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
