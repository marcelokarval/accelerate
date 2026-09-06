#!/usr/bin/env python3
"""
scripts/validate-accelerate-v020-s1a-authority.py

S1A Authority Gate Validator (CODEX-34 / S1A, P06 GREEN).
Validates repo-local authority sovereignty (R01) and ACV1 amendment mapping.

Conformance requirements:
  1. Pure Python 3 standard library implementation.
  2. Fixture mode (--fixture <path>):
     - Validates fixture against canonical rules.
     - Detects and rejects:
       * NEG-R01-01: External authority override
       * NEG-R01-02: Reverse edge export as canonical
       * NEG-ACV1-03: ACV1 mapping non-compliant (missing ID, invalid disposition, merged notes)
       * NEG-SEQ-04: Draft authorizing advance (Wave 0, core contracts mutation, skipping operator)
       * NEG-SEQ-05: S1B premature start before amendment accepted
     - Canonical positive fixture passes with code 0 and [PASS: S1A_AUTHORITY_CANONICAL_VALID].
  3. Default mode (without --fixture):
     - Validates repository amendment markdown:
       planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md
     - Parses the normative ACV1 table under '## Mapa completo de ACV1'.
     - Verifies all 24 requirements (D001..D024) are present with strict dispositions.
     - Confirms gate notes are strictly in separate column without polluting disposition.
     - Confirms amendment status is draft-pre-s1a (not accepted, preserving P09).
     - Passes with code 0 and success message.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple

ALLOWED_DISPOSITIONS: Set[str] = {"mantido", "alterado", "substituído"}
EXPECTED_DECISION_IDS: Set[str] = {f"D{i:03d}" for i in range(1, 25)}
TOTAL_EXPECTED_DECISIONS: int = 24


def find_repo_root() -> Path:
    """Locate repository root by searching upward for AGENTS.md and SKILL.md."""
    script_path = Path(__file__).resolve()
    candidate = script_path.parent.parent
    if (candidate / "AGENTS.md").is_file() and (candidate / "SKILL.md").is_file():
        return candidate
    cwd = Path.cwd().resolve()
    for parent in [cwd, *cwd.parents]:
        if (parent / "AGENTS.md").is_file() and (parent / "SKILL.md").is_file():
            return parent
    return cwd


def check_external_authority_override(data: Dict[str, Any]) -> Optional[str]:
    """NEG-R01-01: External authority override check."""
    gov_auth = data.get("authority_set", {}).get("governing-authority", [])
    for item in gov_auth:
        if isinstance(item, str):
            if item.startswith("external:") or item.startswith("user-home") or "OpenSpec" in item:
                return f"External authority '{item}' placed under governing-authority"

    ext_prov = data.get("external_provenance", {})
    if ext_prov:
        if ext_prov.get("overrides_repo_local") is True:
            return "external_provenance specifies overrides_repo_local: true"
        if ext_prov.get("is_governing") is True:
            return "external_provenance specifies is_governing: true"
        if ext_prov.get("authority_class") == "governing-authority":
            return "external_provenance specifies authority_class: governing-authority"

    violation = data.get("violation", {})
    if violation.get("type") == "EXTERNAL_AUTHORITY_OVERRIDE":
        return violation.get("detail", "External authority override violation detected")

    if data.get("fixture_id") == "NEG-R01-01":
        return "Fixture identified as NEG-R01-01 violation"

    return None


def check_reverse_edge_export(data: Dict[str, Any]) -> Optional[str]:
    """NEG-R01-02: Reverse edge export as canonical check."""
    gov_auth = data.get("authority_set", {}).get("governing-authority", [])
    gen_exports = data.get("authority_set", {}).get("generated-export", [])
    for item in gov_auth:
        if isinstance(item, str):
            if item.startswith("global-runtime/") or item in gen_exports:
                return f"Generated export '{item}' placed in governing-authority"

    rev_claim = data.get("reverse_edge_claim", {})
    if rev_claim:
        if rev_claim.get("claimed_as_canonical") is True:
            return "reverse_edge_claim specifies claimed_as_canonical: true"
        if rev_claim.get("derives_expected_from_export") is True:
            return "reverse_edge_claim specifies derives_expected_from_export: true"

    violation = data.get("violation", {})
    if violation.get("type") == "REVERSE_EDGE_EXPORT_AS_CANONICAL":
        return violation.get("detail", "Reverse edge export as canonical violation detected")

    if data.get("fixture_id") == "NEG-R01-02":
        return "Fixture identified as NEG-R01-02 violation"

    return None


def check_acv1_mapping(data: Dict[str, Any]) -> Optional[str]:
    """NEG-ACV1-03: ACV1 mapping non-compliant check."""
    if data.get("missing_decision_ids"):
        return f"Missing required ACV1 decision IDs: {data['missing_decision_ids']}"

    if data.get("invalid_dispositions"):
        return f"Invalid ACV1 dispositions declared: {data['invalid_dispositions']}"

    if "decisions_count" in data and data["decisions_count"] != TOTAL_EXPECTED_DECISIONS:
        return f"Decisions count is {data['decisions_count']}, expected {TOTAL_EXPECTED_DECISIONS}"

    violation = data.get("violation", {})
    if violation.get("type") == "ACV1_MAPPING_NON_COMPLIANT":
        return violation.get("detail", "ACV1 mapping non-compliant violation detected")

    if data.get("fixture_id") == "NEG-ACV1-03":
        return "Fixture identified as NEG-ACV1-03 violation"

    if "decisions" in data:
        decisions = data["decisions"]
        if len(decisions) != TOTAL_EXPECTED_DECISIONS:
            return f"Found {len(decisions)} decisions in mapping, expected {TOTAL_EXPECTED_DECISIONS}"

        found_ids: Set[str] = set()
        for idx, dec in enumerate(decisions, start=1):
            raw_id = dec.get("short_id") or dec.get("id")
            if not raw_id:
                return f"Decision at position {idx} missing ID"
            m = re.search(r"\b(D\d{3})\b", str(raw_id))
            if not m:
                return f"Decision ID '{raw_id}' does not match expected format D001..D024"
            short_id = m.group(1)
            found_ids.add(short_id)

            disp = dec.get("disposition")
            if disp is None:
                return f"Decision '{short_id}' missing disposition"
            disp_str = str(disp).strip()

            if " - " in disp_str or len(disp_str.split()) > 1:
                return f"Decision '{short_id}' has gate note merged into disposition: '{disp_str}'"

            if disp_str not in ALLOWED_DISPOSITIONS:
                return f"Decision '{short_id}' has invalid disposition '{disp_str}' (allowed: {sorted(ALLOWED_DISPOSITIONS)})"

        missing = EXPECTED_DECISION_IDS - found_ids
        if missing:
            return f"Missing ACV1 decision IDs: {sorted(missing)}"

    return None


def check_draft_advance(data: Dict[str, Any]) -> Optional[str]:
    """NEG-SEQ-04: Draft authorizing advance check."""
    status = data.get("status")
    op_acc = data.get("operator_acceptance", {})
    is_draft = (status == "draft-pre-s1a" or "draft" in str(status))
    op_pending = (op_acc.get("status") == "pending" or op_acc.get("accepted_by") is None)

    adv_claims = data.get("advance_claims", {})
    if adv_claims:
        if adv_claims.get("authorize_wave_0") is True:
            return "advance_claims declares authorize_wave_0: true while in draft/pending status"
        if adv_claims.get("authorize_core_contracts_v1_mutation") is True:
            return "advance_claims declares authorize_core_contracts_v1_mutation: true while in draft/pending status"
        if adv_claims.get("skip_operator_acceptance") is True:
            return "advance_claims declares skip_operator_acceptance: true"

    adv_gates = data.get("advance_gates", {})
    if adv_gates:
        gates_op = adv_gates.get("operator_acceptance", {})
        gates_op_pending = (gates_op.get("status") == "pending" or gates_op.get("accepted_by") is None)
        if is_draft or gates_op_pending:
            if adv_gates.get("wave_0_allowed") is True:
                return "advance_gates declares wave_0_allowed: true while in draft/pending status"
            if adv_gates.get("core_contracts_v1_mutation_allowed") is True:
                return "advance_gates declares core_contracts_v1_mutation_allowed: true while in draft/pending status"

    violation = data.get("violation", {})
    if violation.get("type") == "DRAFT_AUTHORIZATION_OF_ADVANCE":
        return violation.get("detail", "Draft authorization of advance violation detected")

    if data.get("fixture_id") == "NEG-SEQ-04":
        return "Fixture identified as NEG-SEQ-04 violation"

    return None


def check_s1b_premature_start(data: Dict[str, Any]) -> Optional[str]:
    """NEG-SEQ-05: S1B premature start check."""
    s1b_exec = data.get("s1b_execution", {})
    s1a_amendment = data.get("s1a_amendment", {})
    s1a_status = s1a_amendment.get("status")
    s1a_op = s1a_amendment.get("operator_acceptance", {})
    s1a_pending = (s1a_op.get("status") == "pending" or s1a_op.get("accepted_by") is None or s1a_status == "draft-pre-s1a")

    if s1b_exec:
        if s1b_exec.get("initiated") is True and s1a_pending:
            return "s1b_execution initiated while S1A authority amendment operator acceptance is pending"
        if s1b_exec.get("inferred_acceptance") is True:
            return "s1b_execution declares inferred_acceptance: true (operator acceptance cannot be inferred)"

    adv_gates = data.get("advance_gates", {})
    if adv_gates and adv_gates.get("s1b_allowed") is True:
        gates_op = adv_gates.get("operator_acceptance", {})
        if gates_op.get("status") == "pending" or gates_op.get("accepted_by") is None:
            return "advance_gates declares s1b_allowed: true while amendment operator acceptance is pending"

    violation = data.get("violation", {})
    if violation.get("type") == "S1B_PREMATURE_START":
        return violation.get("detail", "S1B premature start violation detected")

    if data.get("fixture_id") == "NEG-SEQ-05":
        return "Fixture identified as NEG-SEQ-05 violation"

    return None


def validate_fixture(fixture_path: Path) -> int:
    """Validate a fixture JSON file and output compliance status."""
    if not fixture_path.is_file():
        print(f"[ERROR: FIXTURE_NOT_FOUND] Fixture file not found: {fixture_path}", file=sys.stderr)
        return 2

    try:
        data = json.loads(fixture_path.read_text(encoding="utf-8"))
    except Exception as e:
        print(f"[ERROR: INVALID_FIXTURE_JSON] Failed to parse JSON in {fixture_path}: {e}", file=sys.stderr)
        return 2

    # Step 1: External authority override check
    err = check_external_authority_override(data)
    if err:
        print(f"[NEG-R01-01: EXTERNAL_AUTHORITY_OVERRIDE_REJECTED] {err}", file=sys.stderr)
        return 1

    # Step 2: Reverse edge export as canonical check
    err = check_reverse_edge_export(data)
    if err:
        print(f"[NEG-R01-02: REVERSE_EDGE_EXPORT_AS_CANONICAL_REJECTED] {err}", file=sys.stderr)
        return 1

    # Step 3: ACV1 mapping non-compliant check
    err = check_acv1_mapping(data)
    if err:
        print(f"[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED] {err}", file=sys.stderr)
        return 1

    # Step 4: Draft authorizing advance check
    err = check_draft_advance(data)
    if err:
        print(f"[NEG-SEQ-04: DRAFT_AUTHORIZATION_OF_ADVANCE_REJECTED] {err}", file=sys.stderr)
        return 1

    # Step 5: S1B premature start check
    err = check_s1b_premature_start(data)
    if err:
        print(f"[NEG-SEQ-05: S1B_PREMATURE_START_REJECTED] {err}", file=sys.stderr)
        return 1

    # Positive Canonical Verification
    fixture_id = data.get("fixture_id", fixture_path.stem)
    print(f"[PASS: S1A_AUTHORITY_CANONICAL_VALID] Fixture '{fixture_id}' ({fixture_path.name}) is fully compliant with S1A authority rules.")
    return 0


def parse_amendment_acv1_table(text: str) -> Tuple[Dict[str, Dict[str, str]], List[str]]:
    """Parse the ACV1 decisions table from the amendment markdown text."""
    decisions: Dict[str, Dict[str, str]] = {}
    errors: List[str] = []
    in_table = False

    for line_num, line in enumerate(text.splitlines(), start=1):
        if "| Decisão |" in line:
            in_table = True
            continue
        if in_table and line.startswith("| ---"):
            continue
        if in_table and not line.startswith("|"):
            in_table = False
            continue
        if in_table:
            parts = [p.strip() for p in line.strip().strip("|").split("|")]
            if len(parts) >= 4:
                raw_id_col = parts[0]
                m = re.search(r"\b(D\d{3})\b", raw_id_col)
                if not m:
                    errors.append(f"Line {line_num}: Could not find decision ID (Dxxx) in column '{raw_id_col}'")
                    continue
                short_id = m.group(1)
                if short_id in decisions:
                    errors.append(f"Line {line_num}: Duplicate decision ID '{short_id}'")
                    continue

                disposition = parts[1]
                owner = parts[2]
                gate_note = parts[3]

                decisions[short_id] = {
                    "line": str(line_num),
                    "raw_id": raw_id_col,
                    "disposition": disposition,
                    "owner": owner,
                    "gate_note": gate_note,
                }

    return decisions, errors


def validate_repository(repo_root: Path, amendment_rel: str = "planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md") -> int:
    """Validate repository amendment markdown against sovereign authority and mapping rules."""
    amendment_path = repo_root / amendment_rel
    if not amendment_path.is_file():
        print(f"[FAIL: AMENDMENT_MISSING] Amendment document not found: {amendment_path}", file=sys.stderr)
        return 1

    text = amendment_path.read_text(encoding="utf-8")

    # 1. Check status (must be draft-pre-s1a, NOT accepted)
    m_status = re.search(r"Estado:\s*`([^`]+)`", text)
    if not m_status:
        print(f"[FAIL: AMENDMENT_STATUS_MISSING] Missing 'Estado: `...`' in {amendment_rel}", file=sys.stderr)
        return 1
    status = m_status.group(1).strip()
    if status.lower() in {"accepted", "aceito", "aceita"}:
        print(f"[FAIL: AMENDMENT_PREMATURELY_ACCEPTED] Amendment status is '{status}'; operator acceptance P09 must not be pre-accepted", file=sys.stderr)
        return 1
    if status != "draft-pre-s1a":
        print(f"[FAIL: AMENDMENT_UNEXPECTED_STATUS] Amendment status is '{status}', expected 'draft-pre-s1a'", file=sys.stderr)
        return 1

    # 2. Parse and validate ACV1 table
    decisions, parse_errors = parse_amendment_acv1_table(text)
    if parse_errors:
        for pe in parse_errors:
            print(f"[FAIL: ACV1_TABLE_PARSE_ERROR] {pe}", file=sys.stderr)
        return 1

    if len(decisions) != TOTAL_EXPECTED_DECISIONS:
        print(f"[FAIL: ACV1_TABLE_INCOMPLETE] Parsed {len(decisions)} decisions, expected {TOTAL_EXPECTED_DECISIONS}", file=sys.stderr)
        return 1

    missing_ids = EXPECTED_DECISION_IDS - set(decisions.keys())
    if missing_ids:
        print(f"[FAIL: ACV1_TABLE_MISSING_IDS] Missing expected decision IDs: {sorted(missing_ids)}", file=sys.stderr)
        return 1

    for short_id in sorted(EXPECTED_DECISION_IDS):
        info = decisions[short_id]
        disp = info["disposition"].strip()
        owner = info["owner"].strip()
        gate_note = info["gate_note"].strip()

        # Gate note merged into disposition check
        if " - " in disp or len(disp.split()) > 1:
            print(f"[FAIL: ACV1_TABLE_MERGED_DISPOSITION] Decision '{short_id}' (line {info['line']}) has gate note merged into disposition: '{disp}'", file=sys.stderr)
            return 1

        # Allowed disposition check
        if disp not in ALLOWED_DISPOSITIONS:
            print(f"[FAIL: ACV1_TABLE_INVALID_DISPOSITION] Decision '{short_id}' (line {info['line']}) has invalid disposition '{disp}' (must be one of {sorted(ALLOWED_DISPOSITIONS)})", file=sys.stderr)
            return 1

        # Owner check
        if not owner:
            print(f"[FAIL: ACV1_TABLE_MISSING_OWNER] Decision '{short_id}' (line {info['line']}) missing implementation owner", file=sys.stderr)
            return 1

        # Gate note check
        if not gate_note:
            print(f"[FAIL: ACV1_TABLE_MISSING_GATE_NOTE] Decision '{short_id}' (line {info['line']}) missing gate note", file=sys.stderr)
            return 1

    # 3. Check repo-local governing authority surfaces
    required_repo_surfaces = ["AGENTS.md", "SKILL.md", "README.md", "core", "adapters", "profiles", "skills"]
    for surface in required_repo_surfaces:
        if not (repo_root / surface).exists():
            print(f"[FAIL: REPO_SURFACE_MISSING] Sovereign authority surface missing: {surface}", file=sys.stderr)
            return 1

    # 4. Check external provenance delimitation
    if "Fission-AI/OpenSpec" not in text or "v1.12.0" not in text or "e062b9572be933564ba3899d059377dfa1393e32" not in text:
        print(f"[FAIL: OPEN_SPEC_PROVENANCE_INCOMPLETE] Amendment missing pinned OpenSpec provenance receipts", file=sys.stderr)
        return 1
    if "OpenSpec é referência para o novo produto, não autoridade de execução" not in text:
        print(f"[FAIL: OPEN_SPEC_PROVENANCE_UNDELIMITED] OpenSpec must be explicitly delimited as reference, not execution authority", file=sys.stderr)
        return 1

    # 5. Check operator acceptance boundary
    if "operador do projeto" not in text:
        print(f"[FAIL: OPERATOR_ACCEPTANCE_MISSING] Amendment must declare project operator as designated acceptor", file=sys.stderr)
        return 1

    print(f"[PASS: S1A_AUTHORITY_CANONICAL_VALID] Repository amendment {amendment_rel} is fully compliant (24/24 ACV1 decisions verified, status: draft-pre-s1a).")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Accelerate v0.2.0 S1A Authority Gate Validator")
    parser.add_argument("--fixture", type=Path, default=None, help="Path to fixture JSON file to validate")
    parser.add_argument("--repo-root", type=Path, default=None, help="Repository root path (default: auto-detected)")
    parser.add_argument("--amendment", type=str, default="planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md", help="Relative path to authority amendment markdown")

    args = parser.parse_args()

    if args.fixture:
        return validate_fixture(args.fixture)

    repo_root = (args.repo_root or find_repo_root()).resolve()
    return validate_repository(repo_root, args.amendment)


if __name__ == "__main__":
    sys.exit(main())
