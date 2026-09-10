#!/usr/bin/env python3
"""Deterministic, repo-local S1A authority and ACV1 conformance validator."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple


ALLOWED_DISPOSITIONS: Set[str] = {"mantido", "alterado", "substituído"}
EXPECTED_DECISION_IDS: Tuple[str, ...] = tuple(f"D{i:03d}" for i in range(1, 25))
EXPECTED_DECISION_SET = set(EXPECTED_DECISION_IDS)
TOTAL_EXPECTED_DECISIONS = len(EXPECTED_DECISION_IDS)
CLASS_NAMES = (
    "governing-authority", "decision-artifact", "backend-authority",
    "supporting-reference", "generated-export", "forbidden-authority",
)
RULE_IDS = (
    "RULE-01-REPO-LOCAL-FIRST", "RULE-02-NO-REVERSE-EDGE",
    "RULE-03-SUPPORTING-CANNOT-OVERRIDE", "RULE-04-BACKEND-STATE-BOUNDED",
    "RULE-05-FORBIDDEN-STRICT-REJECTION",
)
OWNER_WAVE = {
    "D001": ("Wave 0", "Wave 0"), "D002": ("Wave 1", "Wave 1"),
    "D003": ("Wave 1", "Wave 1"), "D004": ("Wave 1", "Wave 1"),
    "D005": ("Wave 0", "Wave 0"), "D006": ("Wave 0 e posteriores", "Wave 0"),
    "D007": ("Wave 3", "Wave 3"), "D008": ("Wave 2", "Wave 2"),
    "D009": ("Wave 3", "Wave 3"), "D010": ("Wave 3", "Wave 3"),
    "D011": ("Wave 3", "Wave 3"), "D012": ("Wave 3", "Wave 3"),
    "D013": ("Wave 3", "Wave 3"), "D014": ("Wave 3", "Wave 3"),
    "D015": ("Wave 5", "Wave 5"), "D016": ("Wave 5", "Wave 5"),
    "D017": ("Wave 5", "Wave 5"), "D018": ("Wave 1 após Wave 0", "Wave 1"),
    "D019": ("Wave 4", "Wave 4"), "D020": ("Wave 3", "Wave 3"),
    "D021": ("Wave 5", "Wave 5"), "D022": ("Wave 3/5", "Wave 3"),
    "D023": ("Wave 4", "Wave 4"), "D024": ("Wave 5", "Wave 5"),
}
MARKDOWN_ROWS = {
    "D001": ("D001 autoridade repo-first", "S1A guarda a precedência: fixture rejeita fonte externa/export como autoridade."),
    "D002": ("D002 classes/modos fechados", "mapa declara sem mudança de vocabulário."),
    "D003": ("D003 schemas estritos", "nenhum schema paralelo é criado."),
    "D004": ("D004 validador Draft 2020-12", "escolha concreta segue pendente; S1A não introduz dependência."),
    "D005": ("D005 catálogo + manifesto em paridade", "S1A tem denominator próprio sem editar os 45 IDs."),
    "D006": ("D006 cobertura P0/threshold", "critérios não são relaxados."),
    "D007": ("D007 histórico de rollback append-only", "S1A tem rollback apenas por commit isolado."),
    "D008": ("D008 gates adaptativos monotônicos", "nenhum gate é dispensado por texto."),
    "D009": ("D009 evidência tipada", "planejamento separa prova planejada de observada."),
    "D010": ("D010 invalidação transitiva", "revisão/material change torna proof planejada stale."),
    "D011": ("D011 pós-merge condicionado", "não aplicável a docs pré-S1A sem merge claim."),
    "D012": ("D012 workers tardios", "não aplicável; não há worker de execução."),
    "D013": ("D013 cleanup tipado", "não aplicável; não cria recurso gerenciado."),
    "D014": ("D014 loop de incidente", "não aplicável; não corrige incidente."),
    "D015": ("D015 export repo -> runtime", "export/runtime é exclusão explícita."),
    "D016": ("D016 migração dry-run-first", "não há migração nem dual-write."),
    "D017": ("D017 validação final forense", "S1A prevê revisão, não fechamento."),
    "D018": ("D018 pacote canônico `core/contracts/v1/`", "fixture recusa pacote concorrente/antecipado."),
    "D019": ("D019 mapeamento de labels legado", "nenhuma label é tratada como enum canônico."),
    "D020": ("D020 evento material pós-close", "não aplicável; não existe fechamento."),
    "D021": ("D021 cutover somente Wave 5", "shadow/runtime são exclusões explícitas."),
    "D022": ("D022 fechamento lógico preparado", "não aplicável; sem lifecycle local novo."),
    "D023": ("D023 ferramenta forense é da Wave 4", "revisores apenas usam provas futuras."),
    "D024": ("D024 export/rollback com intent/anchor", "não aplicável; sem export, host ou rollback operacional."),
}
ALLOWED_ROOT_FILES = {"AGENTS.md", "SKILL.md", "README.md"}
ALLOWED_ROOT_DIRECTORIES = {
    "core", "adapters", "profiles", "onboarding", "planning", "skills", "references",
}
NEGATIVE_CONTRACTS = {
    "accelerate-contract-v1-neg-r01-01-external-authority-override": "NEG-R01-01",
    "accelerate-contract-v1-neg-r01-02-generated-export-as-canonical": "NEG-R01-02",
    "accelerate-contract-v1-neg-acv1-03-invalid-disposition-or-missing-id": "NEG-ACV1-03",
    "accelerate-contract-v1-neg-seq-04-draft-authorizing-advance": "NEG-SEQ-04",
    "accelerate-contract-v1-neg-seq-05-s1b-started-before-amendment-accepted": "NEG-SEQ-05",
}


def find_repo_root() -> Path:
    """Locate a repository root without trusting an export or home directory."""
    script_root = Path(__file__).resolve().parent.parent
    if (script_root / "AGENTS.md").is_file() and (script_root / "SKILL.md").is_file():
        return script_root
    cwd = Path.cwd().resolve()
    for parent in [cwd, *cwd.parents]:
        if (parent / "AGENTS.md").is_file() and (parent / "SKILL.md").is_file():
            return parent
    return cwd


class DuplicateJsonKeyError(Exception):
    """Raised only by the JSON object-pairs hook for repeated object keys."""


def duplicate_key_object(pairs: List[Tuple[str, Any]]) -> Dict[str, Any]:
    result: Dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise DuplicateJsonKeyError(key)
        result[key] = value
    return result


def fixture_structure_error(data: Any) -> Optional[str]:
    if not isinstance(data, dict):
        return "fixture root must be a JSON object"
    meaningful = {"authority_set", "classes", "precedence_order", "decisions", "status",
                  "operator_acceptance", "advance_gates", "advance_claims", "s1b_execution",
                  "s1a_amendment"}
    if not meaningful.intersection(data):
        return "fixture has no recognized S1A contract content"
    if "authority_set" in data:
        authority_set = data["authority_set"]
        if not isinstance(authority_set, dict):
            return "authority_set must be an object"
        if tuple(authority_set.keys()) != CLASS_NAMES:
            return "authority_set must contain exactly the six canonical authority classes in order"
        if not all(isinstance(value, list) and all(isinstance(item, str) for item in value) for value in authority_set.values()):
            return "each authority_set class must be a list of strings"
    for field in ("external_provenance", "reverse_edge_claim"):
        if field in data and not isinstance(data[field], dict):
            return f"{field} must be an object"
    provenance = data.get("external_provenance")
    if isinstance(provenance, dict):
        for field in ("overrides_repo_local", "is_governing"):
            if field in provenance and not isinstance(provenance[field], bool):
                return f"external_provenance.{field} must be a boolean"
        if "authority_class" in provenance and (
            not isinstance(provenance["authority_class"], str)
            or provenance["authority_class"] not in CLASS_NAMES
        ):
            return "external_provenance.authority_class must be a canonical authority class"
    reverse_edge_claim = data.get("reverse_edge_claim")
    if isinstance(reverse_edge_claim, dict):
        for field in ("claimed_as_canonical", "derives_expected_from_export"):
            if field in reverse_edge_claim and not isinstance(reverse_edge_claim[field], bool):
                return f"reverse_edge_claim.{field} must be a boolean"
    for field in (
        "operator_acceptance", "advance_gates", "advance_claims", "s1b_execution",
        "s1a_amendment",
    ):
        if field in data and not isinstance(data[field], dict):
            return f"{field} must be an object"
    execution = data.get("s1b_execution")
    if isinstance(execution, dict):
        for field in ("initiated", "inferred_acceptance"):
            if field in execution and not isinstance(execution[field], bool):
                return f"s1b_execution.{field} must be a boolean"
    amendment = data.get("s1a_amendment")
    if isinstance(amendment, dict) and "operator_acceptance" in amendment:
        if not isinstance(amendment["operator_acceptance"], dict):
            return "s1a_amendment.operator_acceptance must be an object"
    gates = data.get("advance_gates")
    if isinstance(gates, dict):
        if "operator_acceptance" in gates and not isinstance(gates["operator_acceptance"], dict):
            return "advance_gates.operator_acceptance must be an object"
        for field in (
            "wave_0_allowed", "core_contracts_v1_mutation_allowed", "s1b_allowed",
        ):
            if field in gates and not isinstance(gates[field], bool):
                return f"advance_gates.{field} must be a boolean"
    claims = data.get("advance_claims")
    if isinstance(claims, dict):
        for field in (
            "authorize_wave_0", "authorize_core_contracts_v1_mutation",
            "skip_operator_acceptance",
        ):
            if field in claims and not isinstance(claims[field], bool):
                return f"advance_claims.{field} must be a boolean"
    return None


def valid_governing_path(value: str) -> bool:
    if not value or value.startswith(("/", "~")) or value in {".", ".."}:
        return False
    if value.startswith(".") or "\\" in value or ":" in value:
        return False
    parts = value.split("/")
    if any(part in {"", ".", ".."} for part in parts[:-1]) or ".." in parts:
        return False
    root = parts[0]
    if root in ALLOWED_ROOT_FILES:
        return len(parts) == 1
    return root in ALLOWED_ROOT_DIRECTORIES


def check_external_authority_override(data: Dict[str, Any]) -> Optional[str]:
    provenance = data.get("external_provenance")
    if isinstance(provenance, dict) and (
        provenance.get("overrides_repo_local") is True
        or provenance.get("is_governing") is True
        or provenance.get("authority_class") == "governing-authority"
    ):
        return "external provenance claims governing or overriding authority"
    return None


def check_reverse_edge_export(data: Dict[str, Any]) -> Optional[str]:
    claim = data.get("reverse_edge_claim")
    if isinstance(claim, dict) and (
        claim.get("claimed_as_canonical") is True or claim.get("derives_expected_from_export") is True
    ):
        return "reverse edge claim treats a generated export as canonical"
    return None


def check_governing_paths(data: Dict[str, Any]) -> Optional[str]:
    authority_set = data.get("authority_set")
    if not isinstance(authority_set, dict):
        return None
    for path in authority_set.get("governing-authority", []):
        if not valid_governing_path(path):
            return f"governing authority path is not a repo-local allowed root: {path!r}"
    return None


def decision_short_id(decision: Any) -> Optional[str]:
    if not isinstance(decision, dict):
        return None
    short_id = decision.get("short_id")
    if not isinstance(short_id, str) or short_id not in EXPECTED_DECISION_SET:
        return None
    return short_id


def generic_mapping_error(data: Dict[str, Any]) -> Optional[str]:
    if "decisions" not in data:
        return None
    decisions = data["decisions"]
    if not isinstance(decisions, list):
        return "decisions must be a list"
    if len(decisions) != TOTAL_EXPECTED_DECISIONS:
        return f"found {len(decisions)} decisions, expected {TOTAL_EXPECTED_DECISIONS}"
    found: List[str] = []
    for index, decision in enumerate(decisions, start=1):
        short_id = decision_short_id(decision)
        if short_id is None:
            return f"decision at position {index} has an invalid short_id"
        disposition = decision.get("disposition")
        if not isinstance(disposition, str) or disposition.strip() != disposition:
            return f"decision {short_id} has an invalid disposition representation"
        if " - " in disposition or len(disposition.split()) != 1 or disposition not in ALLOWED_DISPOSITIONS:
            return f"decision {short_id} has invalid disposition {disposition!r}"
        found.append(short_id)
    if len(set(found)) != len(found):
        return "mapping contains duplicate decision IDs"
    if set(found) != EXPECTED_DECISION_SET:
        return f"mapping IDs do not equal D001..D024 (missing {sorted(EXPECTED_DECISION_SET - set(found))})"
    return None


def authority_model_error(data: Dict[str, Any]) -> Optional[str]:
    is_model = data.get("contract_name") == "accelerate-contract-v1-authority-classes-precedence" or (
        "classes" in data and "precedence_order" in data
    )
    if not is_model:
        return None
    classes = data.get("classes")
    if not isinstance(classes, dict) or tuple(classes.keys()) != CLASS_NAMES:
        return "classes must contain exactly the six canonical class keys in order"
    if data.get("precedence_order") != list(CLASS_NAMES):
        return "precedence_order must be the canonical six-class order"
    for rank, name in enumerate(CLASS_NAMES, start=1):
        entry = classes[name]
        if not isinstance(entry, dict) or entry.get("rank") != rank:
            return f"class {name} must have rank {rank}"
        if entry.get("may_decide_runtime") is not (rank <= 3):
            return f"class {name} has an invalid may_decide_runtime value"
    rules = data.get("enforcement_rules")
    if not isinstance(rules, list) or [rule.get("id") if isinstance(rule, dict) else None for rule in rules] != list(RULE_IDS):
        return "enforcement_rules must contain the exact canonical rule IDs in order"
    return None


def canonical_mapping_error(data: Dict[str, Any]) -> Optional[str]:
    if not is_canonical_mapping(data):
        return None
    if data.get("allowed_dispositions") != ["mantido", "alterado", "substituído"]:
        return "allowed_dispositions is not canonical"
    if data.get("allowed_waves") != [f"Wave {number}" for number in range(6)]:
        return "allowed_waves is not canonical"
    decisions = data.get("decisions")
    if not isinstance(decisions, list) or len(decisions) != TOTAL_EXPECTED_DECISIONS:
        return "canonical mapping must contain exactly 24 decisions"
    for expected_id, decision in zip(EXPECTED_DECISION_IDS, decisions):
        if not isinstance(decision, dict) or decision.get("short_id") != expected_id:
            return f"canonical mapping decision order must contain {expected_id}"
        if decision.get("id") != f"ACV1-{expected_id}":
            return f"decision {expected_id} has conflicting id and short_id"
        if decision.get("disposition") != "mantido":
            return f"decision {expected_id} disposition must remain mantido"
        if (decision.get("implementation_owner"), decision.get("wave")) != OWNER_WAVE[expected_id]:
            return f"decision {expected_id} has an invalid owner/wave pair"
    return None


def is_canonical_mapping(data: Dict[str, Any]) -> bool:
    """Recognize the full mapping by its normative shape, not its metadata."""
    if data.get("contract_name") == "accelerate-contract-v1-acv1-expected-mapping":
        return True
    decisions = data.get("decisions")
    if not isinstance(decisions, list):
        return False
    if "allowed_dispositions" in data or "allowed_waves" in data:
        return True
    short_ids = [decision.get("short_id") for decision in decisions if isinstance(decision, dict)]
    return (
        len(decisions) == TOTAL_EXPECTED_DECISIONS
        and len(short_ids) == TOTAL_EXPECTED_DECISIONS
        and tuple(short_ids) == EXPECTED_DECISION_IDS
        and set(short_ids) == EXPECTED_DECISION_SET
    )


def acceptance_record(
    value: Any, *, pending_requires_null: bool = True,
) -> Optional[Tuple[str, Optional[str]]]:
    if not isinstance(value, dict):
        return None
    status = value.get("status")
    accepted_by = value.get("accepted_by")
    if not isinstance(status, str):
        return ("invalid", None)
    normalized = status.strip().lower()
    if normalized not in {"pending", "accepted"}:
        return ("invalid", None)
    if normalized == "pending":
        if pending_requires_null and accepted_by is not None:
            return ("invalid", None)
        if not pending_requires_null and isinstance(accepted_by, str) and accepted_by.strip():
            return ("invalid", None)
    if normalized == "accepted" and (not isinstance(accepted_by, str) or not accepted_by.strip()):
        return ("invalid", None)
    return (normalized, accepted_by.strip() if isinstance(accepted_by, str) else None)


def amendment_acceptance_error(data: Dict[str, Any]) -> Optional[str]:
    """Validate a present S1A amendment independently of S1B execution."""
    if "s1a_amendment" not in data:
        return None
    amendment = data["s1a_amendment"]
    assert isinstance(amendment, dict)
    status = amendment.get("status")
    if not isinstance(status, str) or status.strip().lower() not in {
        "draft", "draft-pre-s1a", "accepted",
    }:
        return "S1A amendment status must normalize to draft, draft-pre-s1a, or accepted"
    record = (
        acceptance_record(
            amendment.get("operator_acceptance"), pending_requires_null=False,
        )
        if "operator_acceptance" in amendment
        else None
    )
    if record == ("invalid", None):
        return "S1A amendment operator acceptance must be pending without a nonempty accepted_by or accepted with a nonempty accepted_by"
    normalized_status = status.strip().lower()
    if normalized_status == "accepted" and (record is None or record[0] != "accepted"):
        return "accepted S1A amendment requires accepted operator evidence"
    if normalized_status in {"draft", "draft-pre-s1a"} and record is not None and record[0] == "accepted":
        return "draft S1A amendment cannot carry accepted operator evidence"
    return None


def sequence_error(data: Dict[str, Any]) -> Optional[str]:
    has_status = "status" in data
    status = data.get("status")
    normalized_status = status.strip().lower() if isinstance(status, str) else ""
    if has_status and normalized_status not in {"draft", "draft-pre-s1a", "accepted"}:
        return "explicit status must normalize to draft, draft-pre-s1a, or accepted"
    root_record = acceptance_record(data.get("operator_acceptance")) if "operator_acceptance" in data else None
    gates = data.get("advance_gates")
    gate_record = acceptance_record(gates.get("operator_acceptance")) if isinstance(gates, dict) and "operator_acceptance" in gates else None
    if root_record == ("invalid", None) or gate_record == ("invalid", None):
        return "operator acceptance must be pending with accepted_by null or accepted with a nonempty accepted_by"
    if root_record is not None and gate_record is not None and root_record != gate_record:
        return "operator acceptance records disagree"
    is_draft = normalized_status in {"draft", "draft-pre-s1a"}
    if normalized_status == "accepted" and not any(record is not None and record[0] == "accepted" for record in (root_record, gate_record)):
        return "accepted status requires effective accepted operator evidence"
    if is_draft and any(record is not None and record[0] == "accepted" for record in (root_record, gate_record)):
        return "draft status cannot be overridden by accepted operator evidence"
    claims = data.get("advance_claims")
    if isinstance(claims, dict) and claims.get("skip_operator_acceptance") is True:
        return "advance_claims.skip_operator_acceptance is an unauthorized bypass"
    claims_true = isinstance(claims, dict) and any(claims.get(name) is True for name in (
        "authorize_wave_0", "authorize_core_contracts_v1_mutation",
    ))
    gates_true = isinstance(gates, dict) and any(gates.get(name) is True for name in (
        "wave_0_allowed", "core_contracts_v1_mutation_allowed", "s1b_allowed",
    ))
    if claims_true or gates_true:
        if normalized_status != "accepted":
            return "advance authorization requires accepted status"
        if not any(record is not None and record[0] == "accepted" for record in (root_record, gate_record)):
            return "advance authorization requires effective accepted operator evidence"
    return None


def s1b_error(data: Dict[str, Any]) -> Optional[str]:
    execution = data.get("s1b_execution")
    if not isinstance(execution, dict):
        return None
    if execution.get("inferred_acceptance") is True:
        return "S1B operator acceptance cannot be inferred"
    if execution.get("initiated") is True:
        amendment = data.get("s1a_amendment")
        amendment = amendment if isinstance(amendment, dict) else {}
        record = acceptance_record(
            amendment.get("operator_acceptance"), pending_requires_null=False,
        )
        status = amendment.get("status")
        if (
            not isinstance(status, str)
            or status.strip().lower() != "accepted"
            or record is None
            or record[0] != "accepted"
        ):
            return "S1B was initiated before the S1A amendment was accepted"
    return None


def negative_marker(data: Dict[str, Any], kind: str, default: str) -> str:
    """Keep legacy markers only for their semantic contract kinds, never metadata."""
    contract_name = data.get("contract_name")
    return default if isinstance(contract_name, str) and NEGATIVE_CONTRACTS.get(contract_name) == kind else ""


def validate_fixture(fixture_path: Path) -> int:
    if not fixture_path.is_file():
        print(f"[ERROR: FIXTURE_NOT_FOUND] Fixture file not found: {fixture_path}", file=sys.stderr)
        return 2
    try:
        data = json.loads(fixture_path.read_text(encoding="utf-8"), object_pairs_hook=duplicate_key_object)
    except DuplicateJsonKeyError as error:
        print(f"[ERROR: DUPLICATE_JSON_KEY] Duplicate JSON object key: {error}", file=sys.stderr)
        return 2
    except (OSError, json.JSONDecodeError) as error:
        print(f"[ERROR: INVALID_FIXTURE_JSON] Failed to parse JSON in {fixture_path}: {error}", file=sys.stderr)
        return 2

    structure = fixture_structure_error(data)
    if structure:
        print(f"[ERROR: INVALID_FIXTURE_STRUCTURE] {structure}", file=sys.stderr)
        return 2

    for check, kind, legacy, marker in (
        (check_external_authority_override, "NEG-R01-01", "[NEG-R01-01: EXTERNAL_AUTHORITY_OVERRIDE_REJECTED]", "[ERROR: AUTHORITY_PATH_INVALID]"),
        (check_reverse_edge_export, "NEG-R01-02", "[NEG-R01-02: REVERSE_EDGE_EXPORT_AS_CANONICAL_REJECTED]", "[ERROR: AUTHORITY_PATH_INVALID]"),
        (check_governing_paths, "", "", "[ERROR: AUTHORITY_PATH_INVALID]"),
    ):
        error = check(data)
        if error:
            print(f"{negative_marker(data, kind, legacy) or marker} {error}", file=sys.stderr)
            return 1

    error = authority_model_error(data)
    if error:
        print(f"[ERROR: AUTHORITY_MODEL_INVALID] {error}", file=sys.stderr)
        return 1
    error = canonical_mapping_error(data)
    if error:
        print(f"[ERROR: ACV1_MAPPING_INVALID] {error}", file=sys.stderr)
        legacy_error = generic_mapping_error(data)
        if legacy_error:
            print(f"[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED] {legacy_error}", file=sys.stderr)
        return 1
    error = generic_mapping_error(data)
    if error:
        print(f"[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED] {error}", file=sys.stderr)
        return 1
    error = amendment_acceptance_error(data)
    if error:
        print(f"[ERROR: SEQUENCE_GATE_INVALID] {error}", file=sys.stderr)
        return 1
    error = sequence_error(data)
    if error:
        print(f"{negative_marker(data, 'NEG-SEQ-04', '[NEG-SEQ-04: DRAFT_AUTHORIZATION_OF_ADVANCE_REJECTED]') or '[ERROR: SEQUENCE_GATE_INVALID]'} {error}", file=sys.stderr)
        return 1
    error = s1b_error(data)
    if error:
        print(f"{negative_marker(data, 'NEG-SEQ-05', '[NEG-SEQ-05: S1B_PREMATURE_START_REJECTED]') or '[ERROR: SEQUENCE_GATE_INVALID]'} {error}", file=sys.stderr)
        return 1

    label = data.get("fixture_id", fixture_path.stem)
    print(f"[PASS: S1A_AUTHORITY_CANONICAL_VALID] Fixture '{label}' ({fixture_path.name}) is fully compliant with S1A authority rules.")
    return 0


def parse_amendment_acv1_table(text: str) -> Tuple[Optional[List[Dict[str, str]]], Optional[str]]:
    lines = text.splitlines()
    headings = [index for index, line in enumerate(lines) if line == "## Mapa completo de ACV1"]
    if len(headings) != 1:
        return None, "expected exactly one '## Mapa completo de ACV1' section"
    start = headings[0] + 1
    end = next((index for index in range(start, len(lines)) if lines[index].startswith("## ")), len(lines))
    header = "| Decisão | Disposição v0.2.0 | Dono de implementação | Condição/verificação de S1A |"
    try:
        header_index = next(index for index in range(start, end) if lines[index] == header)
    except StopIteration:
        return None, "missing exact four-column ACV1 table header"
    if header_index + 1 >= end or lines[header_index + 1] != "| --- | --- | --- | --- |":
        return None, "missing exact ACV1 table separator"
    rows: List[Dict[str, str]] = []
    for line_number in range(header_index + 2, end):
        line = lines[line_number]
        if not line.strip():
            break
        if not line.startswith("|"):
            return None, f"unexpected content at table line {line_number + 1}"
        parts = [part.strip() for part in line.strip().strip("|").split("|")]
        if len(parts) != 4:
            return None, f"table line {line_number + 1} does not have exactly four columns"
        match = re.fullmatch(r"(D\d{3})\s+.+", parts[0])
        if not match:
            return None, f"table line {line_number + 1} has invalid decision ID"
        rows.append({"short_id": match.group(1), "label": parts[0], "disposition": parts[1], "owner": parts[2], "gate_note": parts[3]})
    if len(rows) != TOTAL_EXPECTED_DECISIONS:
        return None, f"table has {len(rows)} rows, expected {TOTAL_EXPECTED_DECISIONS}"
    for expected_id, row in zip(EXPECTED_DECISION_IDS, rows):
        if row["short_id"] != expected_id:
            return None, f"table decision order must contain {expected_id}"
        if row["disposition"] != "mantido":
            return None, f"table decision {expected_id} disposition must be mantido"
        if row["owner"] != OWNER_WAVE[expected_id][0]:
            return None, f"table decision {expected_id} owner does not match canonical wave ownership"
        expected_label, expected_gate_note = MARKDOWN_ROWS[expected_id]
        if row["label"] != expected_label:
            return None, f"table decision {expected_id} label does not match the frozen contract"
        if row["gate_note"] != expected_gate_note:
            return None, f"table decision {expected_id} S1A condition does not match the frozen contract"
    return rows, None


def parse_amendment_status(text: str) -> Tuple[Optional[str], Optional[str]]:
    """Read the single status declaration only from its normative H2 section."""
    lines = text.splitlines()
    headings = [index for index, line in enumerate(lines) if line == "## Estado, propósito e limite"]
    if len(headings) != 1:
        return None, "expected exactly one '## Estado, propósito e limite' section"
    start = headings[0] + 1
    end = next((index for index in range(start, len(lines)) if lines[index].startswith("## ")), len(lines))
    matches = [re.fullmatch(r"Estado: `([^`]+)`(?:\..*)?", line) for line in lines[start:end]]
    values = [match.group(1).strip() for match in matches if match]
    if len(values) != 1:
        return None, "expected exactly one anchored 'Estado: `...`' declaration in the status section"
    return values[0], None


def validate_repository(repo_root: Path, amendment_rel: str) -> int:
    amendment_path = Path(amendment_rel)
    if not amendment_path.is_absolute():
        amendment_path = repo_root / amendment_path
    if not amendment_path.is_file():
        print(f"[FAIL: AMENDMENT_MISSING] Amendment document not found: {amendment_path}", file=sys.stderr)
        return 1
    try:
        text = amendment_path.read_text(encoding="utf-8")
    except OSError as error:
        print(f"[FAIL: AMENDMENT_MISSING] Unable to read amendment: {error}", file=sys.stderr)
        return 1
    _, table_error = parse_amendment_acv1_table(text)
    if table_error:
        print(f"[ERROR: MARKDOWN_CONTRACT_INVALID] {table_error}", file=sys.stderr)
        return 1
    status, status_error = parse_amendment_status(text)
    if status_error:
        print(f"[ERROR: MARKDOWN_CONTRACT_INVALID] {status_error}", file=sys.stderr)
        return 1
    assert status is not None
    if status.lower() in {"accepted", "aceito", "aceita"}:
        print(f"[FAIL: AMENDMENT_PREMATURELY_ACCEPTED] Amendment status is '{status}'", file=sys.stderr)
        return 1
    if status != "draft-pre-s1a":
        print(f"[FAIL: AMENDMENT_UNEXPECTED_STATUS] Amendment status is '{status}', expected 'draft-pre-s1a'", file=sys.stderr)
        return 1
    for surface in ("AGENTS.md", "SKILL.md", "README.md", "core", "adapters", "profiles", "skills"):
        if not (repo_root / surface).exists():
            print(f"[FAIL: REPO_SURFACE_MISSING] Sovereign authority surface missing: {surface}", file=sys.stderr)
            return 1
    if not all(value in text for value in ("Fission-AI/OpenSpec", "v1.12.0", "e062b9572be933564ba3899d059377dfa1393e32")):
        print("[FAIL: OPEN_SPEC_PROVENANCE_INCOMPLETE] Amendment missing pinned OpenSpec provenance receipts", file=sys.stderr)
        return 1
    if "OpenSpec é referência para o novo produto, não autoridade de execução" not in text:
        print("[FAIL: OPEN_SPEC_PROVENANCE_UNDELIMITED] OpenSpec must be delimited as reference", file=sys.stderr)
        return 1
    if "operador do projeto" not in text:
        print("[FAIL: OPERATOR_ACCEPTANCE_MISSING] Amendment must declare project operator", file=sys.stderr)
        return 1
    print(f"[PASS: S1A_AUTHORITY_CANONICAL_VALID] Repository amendment {amendment_rel} is fully compliant (24/24 ACV1 decisions verified, status: draft-pre-s1a).")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Accelerate v0.2.0 S1A Authority Gate Validator")
    parser.add_argument("--fixture", type=Path, default=None, help="Path to fixture JSON file to validate")
    parser.add_argument("--repo-root", type=Path, default=None, help="Repository root path (default: auto-detected)")
    parser.add_argument("--amendment", type=str, default="planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md", help="Relative or absolute authority amendment markdown path")
    args = parser.parse_args()
    if args.fixture:
        return validate_fixture(args.fixture)
    return validate_repository((args.repo_root or find_repo_root()).resolve(), args.amendment)


if __name__ == "__main__":
    sys.exit(main())
