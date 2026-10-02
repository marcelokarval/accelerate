"""Pure routing and handoff validation; neither invocation nor permission grants."""

from copy import deepcopy
from typing import Any


_REQUEST_FIELDS = frozenset({
    "engineering", "bounded", "reversible", "uncertainty", "multi_step",
    "explicit_asds", "risks",
})
_HANDOFF_FIELDS = frozenset({
    "objective", "project", "scope", "constraints", "risks", "references",
    "authorizations",
})


def _fields(value: Any, expected: frozenset[str], label: str) -> None:
    if not isinstance(value, dict) or set(value) != expected:
        raise ValueError(f"{label} must contain exactly: {', '.join(sorted(expected))}")


def _text(value: Any, label: str) -> None:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{label} must be a nonempty string")


def _texts(value: Any, label: str, *, nonempty: bool = False) -> None:
    if not isinstance(value, list) or (nonempty and not value):
        raise ValueError(f"{label} must be a list{' with entries' if nonempty else ''}")
    for item in value:
        _text(item, label)


def classify(request: dict[str, Any]) -> dict[str, Any]:
    """Select an owner from explicit observations without authorizing execution.

    The caller must establish observations from the actual request. This function
    does not assess natural language or infer that ASDS is installed or accepted.
    multi_step denotes dependent outcomes, not read/edit/test operations; risks
    are material effects. See entry-rubric.md and assess_entry for richer inputs.
    """
    _fields(request, _REQUEST_FIELDS, "request")
    for field in _REQUEST_FIELDS - {"risks"}:
        if type(request[field]) is not bool:
            raise ValueError(f"{field} must be a boolean")
    _texts(request["risks"], "risks")
    reasons = []
    if request["explicit_asds"]:
        reasons.append("explicit ASDS selection")
    elif not request["engineering"]:
        return {"classification": "conversation", "route": "conversation",
                "process_owner": "accelerate", "reasons": ["non-engineering request"]}
    if request["engineering"]:
        if not request["bounded"]:
            reasons.append("unbounded scope")
        if not request["reversible"]:
            reasons.append("non-reversible change")
        if request["uncertainty"]:
            reasons.append("unresolved uncertainty")
        if request["multi_step"]:
            reasons.append("multiple dependent steps")
        reasons.extend(request["risks"])
    if reasons:
        return {"classification": "non-trivial", "route": "asds",
                "process_owner": "asds-after-acceptance", "reasons": reasons}
    return {"classification": "trivial", "route": "direct",
            "process_owner": "accelerate", "reasons": ["bounded reversible low-risk work"]}


def validate_handoff(packet: dict[str, Any]) -> dict[str, Any]:
    """Return detached validated context, preserving grants and refusals verbatim.

    Authorization source strings are records, not authenticated permission proof.
    No missing permission, project initialization or execution is implied.
    """
    _fields(packet, _HANDOFF_FIELDS, "handoff")
    for field in ("objective", "project"):
        _text(packet[field], field)
    for field in ("scope", "constraints", "risks", "references"):
        _texts(packet[field], field, nonempty=field == "scope")
    if not isinstance(packet["authorizations"], list):
        raise ValueError("authorizations must be a list")
    for authorization in packet["authorizations"]:
        _fields(authorization, frozenset({"action", "scope", "decision", "source"}),
                "authorization")
        for field in ("action", "scope", "source"):
            _text(authorization[field], field)
        if authorization["decision"] not in ("granted", "denied"):
            raise ValueError("decision must be granted or denied")
    return deepcopy(packet)
