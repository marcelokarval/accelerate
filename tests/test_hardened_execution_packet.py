from __future__ import annotations

import importlib.util
from pathlib import Path

import pytest


VALIDATOR = (
    Path(__file__).resolve().parents[1]
    / "scripts/validate-hardened-execution-packet.py"
)


def load_validator():
    spec = importlib.util.spec_from_file_location("packet_validator", VALIDATOR)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def packet(route: str = "orchestrated") -> dict:
    return {
        "schema_version": 1,
        "classification": "non-trivial",
        "objective": "Implement a bounded behavior change",
        "success_criteria": ["focused tests pass"],
        "authority_set": ["repository policy", "live runtime readback"],
        "scope": {"in": ["src/"], "non_goals": ["credential migration"]},
        "known_facts": ["public API exists"],
        "unresolved_decisions": ["exact internal boundary"],
        "risk_classification": {
            "level": "medium",
            "reasons": ["cross-file behavior"],
        },
        "acceptance_criteria": ["focused tests pass"],
        "proof_plan": ["run focused-test-command"],
        "execution_route": route,
        "model_decision": {
            "model": "auto/best-coding",
            "effort": "medium",
            "reason": "implementation",
        },
        "delegation_decision": {
            "mode": "physical" if route == "orchestrated" else "root",
            "reason": "independent implementation and proof lanes",
            "tasks": [
                {
                    "id": "T1",
                    "owner": "implementation",
                    "depends_on": [],
                    "deliverable": "change",
                },
                {
                    "id": "T2",
                    "owner": "qa",
                    "depends_on": ["T1"],
                    "deliverable": "evidence",
                },
            ],
        },
        "stop_conditions": ["authority conflict", "failed required proof"],
    }


@pytest.mark.parametrize("route", ["scoped", "orchestrated"])
def test_accepts_complete_non_trivial_packet(route):
    assert load_validator().validate_packet(packet(route)) == []


@pytest.mark.parametrize(
    ("classification", "route"),
    [("conversational/no-op", "direct"), ("trivial-bounded", "scoped")],
)
def test_rejects_disproportionate_hardened_packet(classification, route):
    payload = packet(route)
    payload["classification"] = classification
    assert "classification: hardened packets require non-trivial work" in load_validator().validate_packet(payload)


@pytest.mark.parametrize(
    "field",
    [
        "objective",
        "success_criteria",
        "authority_set",
        "scope",
        "known_facts",
        "unresolved_decisions",
        "risk_classification",
        "acceptance_criteria",
        "proof_plan",
        "model_decision",
        "delegation_decision",
        "stop_conditions",
    ],
)
def test_rejects_missing_required_field(field):
    payload = packet()
    del payload[field]
    assert f"{field}: required field is missing" in load_validator().validate_packet(payload)


def test_rejects_orchestrated_packet_without_independent_tasks():
    payload = packet()
    payload["delegation_decision"]["tasks"] = payload["delegation_decision"]["tasks"][:1]
    assert "delegation_decision.tasks: orchestrated route requires at least two tasks" in load_validator().validate_packet(payload)


def test_rejects_unknown_fields_recursively():
    payload = packet()
    payload["scope"]["surprise"] = True
    assert "scope.surprise: unknown field" in load_validator().validate_packet(payload)


def test_secret_rejection_reports_path_not_value():
    payload = packet()
    secret = "Bearer abcdefghijklmnopqrstuvwxyz123456"
    payload["known_facts"] = [secret]
    errors = load_validator().validate_packet(payload)
    assert "known_facts[0]: secret-like value is forbidden" in errors
    assert secret not in "\n".join(errors)
