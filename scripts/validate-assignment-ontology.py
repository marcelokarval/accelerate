#!/usr/bin/env python3
"""Fail-closed static validation for assignment ontology receipts."""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator


REPO = Path(__file__).resolve().parents[1]
SCHEMA_PATH = REPO / "assets/schemas/assignment-ontology.schema.json"
SURFACE_PROOF_LANES = {
    "backend": {"backend-qa", "contract-proof", "runtime-proof"},
    "frontend": {"frontend-qa", "browser-truth"},
    "integrations": {"contract-proof", "runtime-proof", "seam-proof"},
    "data": {"backend-qa", "contract-proof", "runtime-proof"},
    "runtime": {"runtime-proof", "browser-truth"},
    "governance": {"contract-proof", "forensic-closure"},
}


def fail(message: str) -> None:
    raise ValueError(message)


def reject_duplicate_keys(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            fail(f"duplicate key: {key}")
        result[key] = value
    return result


def load_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=reject_duplicate_keys)
    except (OSError, json.JSONDecodeError) as error:
        fail(f"cannot read JSON {path}: {error}")
    if not isinstance(value, dict):
        fail(f"JSON document must be an object: {path}")
    return value


def validate(receipt: dict[str, Any], schema: dict[str, Any]) -> None:
    errors = sorted(Draft202012Validator(schema).iter_errors(receipt), key=lambda error: list(error.path))
    if errors:
        fail(f"schema violation: {errors[0].message}")
    target = receipt["target"]
    if len(target["surfaces"]) > 1 and not target["seam_proof"]:
        fail("multi-surface target requires seam_proof")
    lanes = set(receipt["proof_lanes"])
    for surface in target["surfaces"]:
        if not lanes & SURFACE_PROOF_LANES[surface]:
            fail(f"surface {surface} requires an applicable proof_lane")
    authority = receipt["authority_role"]
    role = receipt["work_role"]
    review = receipt["review"]
    review_fields_present = any(review[field] is not None for field in ("candidate", "candidate_binding", "spec_binding", "target", "coverage", "isolation_reference"))
    allowed_role_pairs = {
        "executor": {"implementation", "research", "integration"},
        "verifier": {"verification"},
        "reviewer": {"review"},
        "root": {"orchestration"},
    }
    if role not in allowed_role_pairs[authority]:
        fail("authority_role and work_role combination is invalid")
    if authority == "verifier":
        if receipt["verification_mode"] not in {"standard", "adversarial"}:
            fail("verifier requires standard or adversarial verification_mode")
    elif receipt["verification_mode"] != "not-applicable":
        fail("only verifier may declare a verification_mode")
    allowed_modes = {
        "executor": {"none", "self-review", "self-forensic"},
        "verifier": {"none"},
        "reviewer": {"independent-adversarial", "runtime-adversarial", "contract-adversarial"},
        "root": {"none", "review-of-review", "closure-forensic"},
    }
    if receipt["review_mode"] not in allowed_modes[authority]:
        fail("review_mode and authority_role combination is invalid")
    allowed_writes = {
        "executor": {"read-only", "bounded-write"},
        "verifier": {"read-only", "test-only"},
        "reviewer": {"read-only"},
        "root": {"root-only"},
    }
    if receipt["write_mode"] not in allowed_writes[authority]:
        fail("write_mode and authority_role combination is invalid")
    if authority != "root" and (receipt["closure_authority"] or receipt["approval_authority"]):
        fail("only root may have approval or closure authority")
    if receipt["verification_mode"] == "adversarial" or "adversarial" in receipt["review_mode"]:
        if not receipt["proof"]["negative_evidence"]:
            fail("adversarial verification or review requires negative_evidence")
    if authority == "verifier":
        if receipt["closure_authority"] or receipt["approval_authority"]:
            fail("verifier cannot have closure or approval authority")
        if review_fields_present or review["independent"]:
            fail("verifier cannot satisfy review or independence")
    elif authority == "reviewer":
        if not all(review[field] is not None for field in ("candidate", "candidate_binding", "spec_binding", "target", "coverage")):
            fail("reviewer requires candidate, exact candidate/spec bindings, target, and coverage")
        if not review["independent"]:
            fail("reviewer requires independent review")
        if target != review["target"]:
            fail("reviewer target must exactly equal receipt target")
        covered = set(review["coverage"]["surfaces"])
        missing = set(review["target"]["surfaces"]) - covered
        if missing:
            fail("reviewer coverage does not cover target surfaces")
        if review["coverage"]["domain_path"] != review["target"]["domain_path"]:
            fail("reviewer coverage does not cover target domain_path")
        if len(review["coverage"]["surfaces"]) > 1 and not review["coverage"]["seam_proof"]:
            fail("multi-surface reviewer coverage requires seam_proof")
        source = review["candidate"]["runtime_instance"]
        instance = receipt["runtime_instance"]
        if review["candidate"]["assignment_id"] == receipt["assignment_id"]:
            fail("independent review requires distinct candidate assignment_id")
        if source["agent_id"] == instance["agent_id"] or source["call_id"] == instance["call_id"]:
            fail("independent review requires distinct runtime agent_id and call_id")
        if not review["isolation_reference"]:
            fail("independent review requires isolation_reference")
    elif review_fields_present or review["independent"]:
        fail("non-reviewer assignments require null review fields and independent=false")


def main() -> int:
    paths = [Path(argument) for argument in sys.argv[1:]]
    if not paths:
        fail("usage: validate-assignment-ontology.py RECEIPT.json [RECEIPT.json ...]")
    schema = load_json(SCHEMA_PATH)
    for path in paths:
        validate(load_json(path), schema)
    print(f"PASS: assignment ontology receipts validated ({len(paths)} receipt(s))")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ValueError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
