"""Evidence-labelled entry observations; no natural-language inference or permissions.

Adapters extract observations using entry-rubric.md. This module validates their
structure and decides routing; it does not authenticate evidence or call ASDS.
"""
from typing import Any

from core.routing import classify, _fields, _text, _texts

MATERIAL_SIGNALS = frozenset({
    "security_behavior", "sensitive_data_effect", "financial_effect",
    "persistent_state_change", "irreversible_effect", "shared_interface_change",
    "dependent_outcomes", "material_decision", "other_material_effect",
})
_FIELDS = frozenset({"intent", "outcome", "scope", "reversibility",
                     "explicit_asds", "workflow_owner", "operations", "signals", "gaps"})


def assess_entry(observation: dict[str, Any]) -> dict[str, Any]:
    """Decide what entry should do next without planning or granting execution.

    A signal requires a source/evidence and concrete consequence. Operation count
    never determines complexity. Routing gaps use inspection or a user question;
    workflow decisions travel to ASDS. Accepted ASDS work bypasses new triage.
    """
    fields = set(observation)
    if fields not in (set(_FIELDS), set(_FIELDS) | {"requested_product"}):
        _fields(observation, _FIELDS, "entry observation")
    for field, allowed in {
        "intent": ("conversation", "engineering"),
        "scope": ("bounded", "broad", "unknown"),
        "reversibility": ("reversible", "irreversible", "unknown"),
        "workflow_owner": (None, "asds"),
    }.items():
        if observation[field] not in allowed:
            raise ValueError(f"invalid {field}")
    _text(observation["outcome"], "outcome")
    requested_product = observation.get("requested_product", "implementation")
    if requested_product not in ("implementation", "planning", "conversation"):
        raise ValueError("invalid requested_product")
    if type(observation["explicit_asds"]) is not bool:
        raise ValueError("explicit_asds must be a boolean")
    _texts(observation["operations"], "operations")
    if not isinstance(observation["signals"], list) or not isinstance(observation["gaps"], list):
        raise ValueError("signals and gaps must be lists")
    for signal in observation["signals"]:
        _fields(signal, frozenset({"kind", "evidence", "consequence"}), "signal")
        if not isinstance(signal["kind"], str) or signal["kind"] not in MATERIAL_SIGNALS:
            raise ValueError("unknown material signal")
        for field in ("evidence", "consequence"):
            _text(signal[field], field)
    for gap in observation["gaps"]:
        _fields(gap, frozenset({"question", "resolver", "source"}), "gap")
        for field in ("question", "source"):
            _text(gap[field], field)
        if gap["resolver"] not in ("inspect", "user", "asds"):
            raise ValueError("gap resolver must be inspect, user or asds")

    if observation["workflow_owner"] == "asds":
        return {"state": "continue", "route": "asds", "next_action": "continue_asds",
                "reasons": ["existing ASDS ownership; changes stay with its coordinator"]}
    if observation["intent"] == "conversation" and not observation["explicit_asds"]:
        return {"state": "ready", "route": "conversation", "next_action": "respond",
                "reasons": ["conversation does not activate engineering"]}

    # These are entry-blocking facts, not decisions that ASDS should elaborate.
    for resolver, action in (("inspect", "inspect"), ("user", "ask")):
        questions = [gap["question"] for gap in observation["gaps"] if gap["resolver"] == resolver]
        if questions:
            return {"state": "needs_context", "route": None, "next_action": action,
                    "reasons": questions}
    if requested_product == "planning":
        return {"state": "ready", "route": "asds", "next_action": "handoff",
                "reasons": ["planning is the requested product; ASDS owns planning only"]}
    kinds = {signal["kind"] for signal in observation["signals"]}
    workflow_gap = any(gap["resolver"] == "asds" for gap in observation["gaps"])
    known_asds = (observation["explicit_asds"] or kinds or workflow_gap
                  or observation["scope"] == "broad"
                  or observation["reversibility"] == "irreversible")
    if (observation["scope"] == "unknown" or observation["reversibility"] == "unknown") and not known_asds:
        raise ValueError("unknown engineering observations require an entry gap; do not assume low risk")
    # Unknown facts never admit direct work above. Once another material signal
    # establishes ASDS, do not misreport unknown scope/reversibility as observed harm.
    decision = classify({
        "engineering": observation["intent"] == "engineering",
        "bounded": observation["scope"] != "broad",
        "reversible": observation["reversibility"] != "irreversible",
        "uncertainty": "material_decision" in kinds or any(gap["resolver"] == "asds" for gap in observation["gaps"]),
        "multi_step": "dependent_outcomes" in kinds,
        "explicit_asds": observation["explicit_asds"],
        "risks": sorted(kinds - {"dependent_outcomes", "material_decision"}),
    })
    return {"state": "ready", "route": decision["route"],
            "next_action": "handoff" if decision["route"] == "asds" else "execute_direct",
            "reasons": decision["reasons"]}
