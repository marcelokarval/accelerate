#!/usr/bin/env python3
"""Fail-closed validation for the Accelerate review finding contract."""

from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import date
from pathlib import Path
from typing import Any


REQUIRED_STRING_FIELDS = {
    "id",
    "location",
    "category",
    "affected_behavior",
    "failure_scenario",
    "confidence",
    "severity",
    "finding_state",
    "correction",
    "false_positive_disposition",
}
REQUIRED_LIST_FIELDS = {"evidence", "required_proof"}
REQUIRED_OBJECT_FIELDS = {"severity_rationale", "exploitability"}
REQUIRED_FIELDS = REQUIRED_STRING_FIELDS | REQUIRED_LIST_FIELDS | REQUIRED_OBJECT_FIELDS | {"waiver"}
CONFIDENCE = {"low", "medium", "high"}
SEVERITY = {"P0", "P1", "P2", "P3"}
FINDING_STATES = {"candidate", "confirmed", "rejected", "waived"}
CATEGORIES = {
    "correctness",
    "legibility",
    "architecture",
    "security",
    "performance",
    "tests",
    "verification-story",
}
SEVERITY_RATIONALE_FIELDS = {
    "impact",
    "reach",
    "reproducibility",
    "exploitability_basis",
}
EXPLOITABILITY_FIELDS = {"status", "rationale"}
EXPLOITABILITY_STATUSES = {
    "exploitable",
    "conditionally-exploitable",
    "not-exploitable",
    "not-applicable",
}
WAIVER_FIELDS = {"reason", "approver", "expires", "residual_risk"}
FINDING_ID = re.compile(r"^FINDING-[A-Z0-9]+(?:-[A-Z0-9]+)*$")
PATH_LINE = re.compile(r"^(?!/)(?!.*(?:^|/)\.\.(?:/|$))[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*:[1-9][0-9]*$")
KNOWN_LOCATION = re.compile(
    r"^(?:artifact|runtime|provider):[A-Za-z0-9_.-]+(?:[/#][A-Za-z0-9_.:#-]+)+$"
)
PROOF_LOCATOR = re.compile(
    r"^(?:test|artifact|runtime|provider|log|trace|command|url):[A-Za-z0-9_.:/#?&=+-]{8,}$"
)
PLACEHOLDER_WORDS = re.compile(
    r"\b(?:generic|placeholder|unknown|unspecified|tbd|todo|lorem|abcdefg[h-z]*)\b",
    re.IGNORECASE,
)


class ValidationError(ValueError):
    pass


def nonempty_string(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def substantive(value: Any, *, minimum: int = 12, words: int = 2) -> bool:
    if not nonempty_string(value) or len(value.strip()) < minimum:
        return False
    tokens = re.findall(r"[A-Za-z0-9]+", value)
    return (
        len(tokens) >= words
        and len({token.lower() for token in tokens}) >= words
        and not PLACEHOLDER_WORDS.search(value)
    )


def exact_object(value: Any, fields: set[str], label: str, source: Path) -> dict[str, Any]:
    if not isinstance(value, dict) or set(value) != fields:
        raise ValidationError(f"{source}: {label} must contain exactly {sorted(fields)}")
    return value


def validate_severity_rationale(value: Any, source: Path) -> None:
    rationale = exact_object(value, SEVERITY_RATIONALE_FIELDS, "severity_rationale", source)
    required_semantics = {
        "impact": r"impact|integrity|confidential|availability|incorrect|fail|loss|expos|violat|corrupt",
        "reach": r"caller|user|tenant|request|record|service|component|route|population|scope|bounded|\ball\b|single",
        "reproducibility": r"test|reproduc|determin|intermittent|trace|command|case|steps|observed",
        "exploitability_basis": r"actor|hostile|trust|attack|prereq|path|authoriz|no .*required|not applicable",
    }
    for field, pattern in required_semantics.items():
        item = rationale[field]
        if not substantive(item, minimum=28, words=5) or not re.search(pattern, item, re.I):
            raise ValidationError(
                f"{source}: severity_rationale.{field} lacks concrete required semantics"
            )


def validate_exploitability(value: Any, source: Path) -> None:
    exploitability = exact_object(value, EXPLOITABILITY_FIELDS, "exploitability", source)
    if exploitability["status"] not in EXPLOITABILITY_STATUSES:
        raise ValidationError(
            f"{source}: exploitability.status must be one of {sorted(EXPLOITABILITY_STATUSES)}"
        )
    rationale = exploitability["rationale"]
    if (
        not substantive(rationale, minimum=28, words=5)
        or not re.search(r"actor|hostile|trust|attack|prereq|path|authoriz|no .*boundary", rationale, re.I)
    ):
        raise ValidationError(f"{source}: exploitability.rationale must explain the attacker path or absence")


def substantive_proof_locator(value: Any) -> bool:
    if not isinstance(value, str) or not PROOF_LOCATOR.fullmatch(value):
        return False
    _, payload = value.split(":", 1)
    return (
        len(payload) >= 8
        and not PLACEHOLDER_WORDS.search(payload)
        and any(marker in payload for marker in ("/", "::", "#", "://"))
    )


def validate_exploitability_consistency(
    severity_rationale: Any, exploitability: Any, source: Path
) -> None:
    basis = severity_rationale["exploitability_basis"]
    rationale = exploitability["rationale"]
    combined = f"{basis} {rationale}"
    negated_absence_span = re.compile(
        r"\b(?:no|without)\s+(?:a\s+|an\s+|any\s+)?"
        r"(?:(?:hostile|external|authenticated|unauthenticated|tenant|threat)\s+)*"
        r"(?:actor|attacker|attack(?:er)?|attack\s+path|trust(?:[- ]boundary)?|"
        r"exploit(?:ability)?|path)"
        r"(?:\s+(?:path|boundary))?"
        r"(?:\s+(?:or|and)\s+(?:a\s+|an\s+|any\s+)?"
        r"(?:(?:hostile|external|authenticated|unauthenticated|tenant|threat)\s+)*"
        r"(?:actor|attacker|attack(?:er)?|attack\s+path|trust(?:[- ]boundary)?|"
        r"exploit(?:ability)?|path)(?:\s+(?:path|boundary))?)*"
        r"(?:\s+(?:exists?|applies?|is\s+(?:required|present|available|possible)|"
        r"can\s+(?:reach|cross|control|exploit)))?",
        re.I,
    )
    offensive_action = (
        r"(?:attack(?:s|ed|ing)?|control(?:s|led|ling)?|cross(?:es|ed|ing)?|"
        r"select(?:s|ed|ing)?|send(?:s|ing)?|sent|exploit(?:s|ed|ing)?|"
        r"access(?:es|ed|ing)?|reach(?:es|ed|ing)?|bypass(?:es|ed|ing)?|"
        r"read(?:s|ing)?|writ(?:e|es|ing|ten)|modif(?:y|ies|ied|ying)|"
        r"target(?:s|ed|ing)?)"
    )
    sensitive_target = (
        r"(?:trust(?:[- ]boundary)?|authoriz(?:ation|ed)?|ownership|boundary|"
        r"another\s+user|other\s+tenant|records?|target)"
    )
    offensive_sensitive_pattern = re.compile(
        rf"\b{offensive_action}\b.{{0,96}}\b{sensitive_target}\b|"
        rf"\b{sensitive_target}\b.{{0,96}}\b{offensive_action}\b",
        re.I,
    )

    def assertion_remainder(text: str) -> str:
        return negated_absence_span.sub(" ", text)

    def positive_attacker_path(text: str) -> bool:
        remainder = assertion_remainder(text)
        return bool(offensive_sensitive_pattern.search(remainder))

    def contradictory_offense(text: str) -> bool:
        remainder = negated_absence_span.sub(" ", text)
        return bool(offensive_sensitive_pattern.search(remainder))

    basis_absence = negated_absence_span.search(basis)
    rationale_absence = negated_absence_span.search(rationale)
    basis_attacker = positive_attacker_path(basis)
    rationale_attacker = positive_attacker_path(rationale)
    basis_offense = contradictory_offense(basis)
    rationale_offense = contradictory_offense(rationale)
    status = exploitability["status"]
    if status in {"not-applicable", "not-exploitable"}:
        if not basis_absence or not rationale_absence or basis_offense or rationale_offense:
            raise ValidationError(
                f"{source}: {status} exploitability must consistently state why no attacker path applies"
            )
    if status in {"exploitable", "conditionally-exploitable"}:
        if basis_absence or rationale_absence or not basis_attacker or not rationale_attacker:
            raise ValidationError(
                f"{source}: {status} exploitability requires a coherent attacker path"
            )
        if status == "conditionally-exploitable" and not re.search(
            r"prereq|requires?|only when|condition|authenticated|access", combined, re.I
        ):
            raise ValidationError(
                f"{source}: conditionally-exploitable status requires prerequisite semantics"
            )


def validate_finding(value: Any, source: Path, seen_ids: set[str]) -> None:
    if not isinstance(value, dict):
        raise ValidationError(f"{source}: finding must be a JSON object")

    missing = sorted(REQUIRED_FIELDS - set(value))
    if missing:
        raise ValidationError(f"{source}: missing required fields: {', '.join(missing)}")
    unknown = sorted(set(value) - REQUIRED_FIELDS)
    if unknown:
        raise ValidationError(f"{source}: unknown fields: {', '.join(unknown)}")

    for field in sorted(REQUIRED_STRING_FIELDS):
        if not nonempty_string(value[field]):
            raise ValidationError(f"{source}: {field} must be a non-empty string")

    finding_id = value["id"]
    if not FINDING_ID.fullmatch(finding_id):
        raise ValidationError(f"{source}: id must use canonical FINDING-* form")
    if finding_id in seen_ids:
        raise ValidationError(f"{source}: duplicate finding id {finding_id}")
    seen_ids.add(finding_id)

    if not (PATH_LINE.fullmatch(value["location"]) or KNOWN_LOCATION.fullmatch(value["location"])):
        raise ValidationError(f"{source}: location must be path:line or a known artifact/runtime locator")
    if value["category"] not in CATEGORIES:
        raise ValidationError(f"{source}: category must be one of {sorted(CATEGORIES)}")

    for field in (
        "affected_behavior",
        "failure_scenario",
        "correction",
        "false_positive_disposition",
    ):
        if not substantive(value[field]):
            raise ValidationError(f"{source}: {field} must be substantive")

    for field in sorted(REQUIRED_LIST_FIELDS):
        items = value[field]
        if (
            not isinstance(items, list)
            or not items
            or not all(substantive_proof_locator(item) for item in items)
            or len(set(items)) != len(items)
        ):
            raise ValidationError(f"{source}: {field} must be a non-empty list of strings")

    if value["confidence"] not in CONFIDENCE:
        raise ValidationError(f"{source}: confidence must be one of {sorted(CONFIDENCE)}")
    if value["severity"] not in SEVERITY:
        raise ValidationError(f"{source}: severity must be one of {sorted(SEVERITY)}")
    if value["finding_state"] not in FINDING_STATES:
        raise ValidationError(f"{source}: finding_state must be one of {sorted(FINDING_STATES)}")
    disposition = value["false_positive_disposition"].lower()
    confirms = bool(re.search(r"inspected-confirmed|(?<!not )\bconfirmed\b", disposition))
    state_markers = {
        "candidate": r"candidate|unconfirmed|pending (?:evidence|inspection)|needs? (?:evidence|inspection)",
        "confirmed": r"confirmed|reproduced|verified defect",
        "rejected": r"rejected|false positive|not a defect|not confirmed|disproved",
        "waived": r"waived|accepted exception",
    }
    if not re.search(state_markers[value["finding_state"]], disposition):
        raise ValidationError(
            f"{source}: false_positive_disposition contradicts finding_state {value['finding_state']}"
        )
    if value["finding_state"] in {"candidate", "rejected"} and confirms:
        raise ValidationError(
            f"{source}: {value['finding_state']} finding cannot use a confirmed disposition"
        )
    validate_severity_rationale(value["severity_rationale"], source)
    validate_exploitability(value["exploitability"], source)
    validate_exploitability_consistency(
        value["severity_rationale"], value["exploitability"], source
    )

    waiver = value["waiver"]
    if value["finding_state"] == "waived" and waiver is None:
        raise ValidationError(f"{source}: waived finding_state requires a waiver")
    if value["finding_state"] != "waived" and waiver is not None:
        raise ValidationError(f"{source}: waiver is only allowed when finding_state is waived")
    if waiver is not None:
        if not isinstance(waiver, dict):
            raise ValidationError(f"{source}: waiver must be null or an object")
        missing_waiver = sorted(WAIVER_FIELDS - set(waiver))
        if missing_waiver:
            raise ValidationError(
                f"{source}: waiver misses fields: {', '.join(missing_waiver)}"
            )
        unknown_waiver = sorted(set(waiver) - WAIVER_FIELDS)
        if unknown_waiver:
            raise ValidationError(
                f"{source}: waiver has unknown fields: {', '.join(unknown_waiver)}"
            )
        for field in ("reason", "approver", "residual_risk"):
            if not substantive(waiver[field]):
                raise ValidationError(f"{source}: waiver.{field} must be substantive")
        if not nonempty_string(waiver["expires"]):
            raise ValidationError(f"{source}: waiver.expires must be an ISO date")
        try:
            expires = date.fromisoformat(waiver["expires"])
        except ValueError as exc:
            raise ValidationError(
                f"{source}: waiver.expires must be an ISO YYYY-MM-DD date"
            ) from exc
        if expires <= date.today():
            raise ValidationError(f"{source}: waiver.expires must be a future date")


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValidationError(f"{path}: cannot read: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValidationError(f"{path}: invalid JSON: {exc}") from exc


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("findings", nargs="+", type=Path)
    args = parser.parse_args()

    try:
        seen_ids: set[str] = set()
        for path in args.findings:
            payload = load_json(path)
            values = payload if isinstance(payload, list) else [payload]
            if not values:
                raise ValidationError(f"{path}: finding list must not be empty")
            for value in values:
                validate_finding(value, path, seen_ids)
    except ValidationError as exc:
        print(f"review finding validation failed: {exc}", file=sys.stderr)
        return 1

    print(f"review finding validation passed ({len(args.findings)} file(s))")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
