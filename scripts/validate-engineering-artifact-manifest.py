#!/usr/bin/env python3
"""Validate a proportional Engineering Artifact Manifest deterministically."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SDD_MODES = ("micro", "standard", "hierarchical", "critical")
MODE_RANK = {mode: index for index, mode in enumerate(SDD_MODES)}
IMPLEMENTATION_STAGES = {"implementation", "review", "closure"}
COMMON_DISPOSITIONS = {
    "adr",
    "design",
    "test_design",
    "agents",
    "rollout",
    "rollback",
    "observability",
    "agents_docs",
}
DISPOSITION_STATUSES = {
    "separate",
    "consolidated",
    "not-applicable",
    "required",
    "existing",
    "deferred",
}
TEST_DESIGN_DIMENSIONS = {
    "happy",
    "negative",
    "boundary",
    "ownership",
    "concurrency_idempotency",
    "failure_recovery",
    "fixtures",
    "observability",
    "lowest_effective_level",
}
TDD_MODE_BY_CHANGE_KIND = {
    "feature": "red-green-refactor",
    "bug": "failing-repro",
    "refactor": "characterization",
    "docs": "semantic-contract",
    "governance": "semantic-contract",
    "workflow": "semantic-contract",
    "configuration": "semantic-contract",
    "migration": "migration-contract",
    "security": "security-contract",
    "ui": "ui-contract",
    "external-provider": "provider-contract",
    "hybrid": "hybrid",
}
CRITICAL_TRIGGERS = {
    "auth",
    "authentication",
    "authorization",
    "ownership",
    "permissions",
    "billing",
    "financial",
    "sensitive-data",
    "secrets",
    "security-critical",
    "irreversible",
    "pii",
    "destructive",
    "provider-write",
    "irreversible-migration",
    "safety-critical",
    "trust-boundary",
    "external-side-effect",
}
HIERARCHICAL_TRIGGERS = {
    "cross-control-plane",
    "cross-surface",
    "multi-issue",
    "multi-lane",
    "runtime-topology",
    "agent-promotion",
    "cross-domain",
    "architecture-boundary",
    "multi-runtime-migration",
    "independently-deployable-surfaces",
    "cross-owner-contract",
    "multiple-proof-lanes",
}
STANDARD_TRIGGERS = {
    "architecture",
    "workflow-governance",
    "governance",
    "living-docs",
    "migration",
    "security",
    "ui",
    "external-provider",
    "structural-ui",
    "externally-visible-behavior",
    "bug",
    "refactor-risk",
    "new-specialist-capability",
    "durable-decision",
    "concurrency-idempotency",
    "ui-structure",
    "rollback-need",
}
MICRO_TRIGGERS = {"local-known-reversible", "single-surface"}
MUTATION_TRIGGERS = CRITICAL_TRIGGERS | HIERARCHICAL_TRIGGERS | STANDARD_TRIGGERS | MICRO_TRIGGERS

BASELINE_BY_TDD_MODE = {
    "red-green-refactor": {"observed-red"},
    "failing-repro": {"observed-red"},
    "characterization": {"observed-characterization"},
    "semantic-contract": {"observed-red", "observed-contract"},
    "migration-contract": {"observed-contract"},
    "security-contract": {"observed-red", "observed-contract"},
    "ui-contract": {"observed-red", "observed-contract"},
    "provider-contract": {"observed-red", "observed-contract"},
    "hybrid": {"observed-contract"},
}

NON_SUBSTANTIVE_REASONS = {
    "n/a",
    "na",
    "none",
    "not applicable",
    "not needed",
    "unnecessary",
    "skip",
    "skipped",
}


class DuplicateKeyError(ValueError):
    """Raised when JSON repeats an object key."""


def object_without_duplicate_keys(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for key, value in pairs:
        if key in result:
            raise DuplicateKeyError(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def normalized_token(value: str) -> str:
    return "-".join(value.strip().lower().replace("_", "-").split())


def nonempty_string(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def substantive_reason(value: Any) -> bool:
    if not nonempty_string(value):
        return False
    normalized = " ".join(str(value).strip().lower().replace("-", " ").split())
    return normalized not in NON_SUBSTANTIVE_REASONS and len(normalized) >= 12 and len(normalized.split()) >= 2


def require_substantive(value: dict[str, Any], key: str, label: str, errors: list[str]) -> None:
    if not substantive_reason(value.get(key)):
        errors.append(f"{label}.{key} must contain a substantive reason")


def markdown_anchor(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r"[^\w\- ]", "", value)
    return re.sub(r"[ _]+", "-", value)


def resolve_repository_file(path: Path) -> Path | None:
    """Resolve a regular repo file without following any symlink component."""
    if path.is_absolute() or ".." in path.parts:
        return None
    current = ROOT
    for part in path.parts:
        current = current / part
        if current.is_symlink():
            return None
    try:
        resolved = (ROOT / path).resolve(strict=True)
        resolved.relative_to(ROOT.resolve())
    except (FileNotFoundError, OSError, ValueError):
        return None
    return resolved if resolved.is_file() else None


def validate_locator(
    value: Any,
    label: str,
    stage: str,
    errors: list[str],
    allowed_roots: tuple[str, ...] = (),
) -> None:
    if not nonempty_string(value):
        errors.append(f"{label} must be a non-empty repository-relative path")
        return
    if stage not in IMPLEMENTATION_STAGES:
        return
    raw_locator = str(value)
    raw_path, _, fragment = raw_locator.partition("#")
    path = Path(raw_path)
    if path.is_absolute() or ".." in path.parts:
        errors.append(f"{label} must stay inside the repository")
        return
    if (
        any(part in {".tmp", "global-runtime"} for part in path.parts)
        or path.name.lower() == "readme.md"
        or "template" in path.stem.lower().split("-")
    ):
        errors.append(f"{label} cannot use a template, generated export, README, or temporary artifact as live authority")
        return
    if allowed_roots and not any(path == Path(root) or Path(root) in path.parents for root in allowed_roots):
        errors.append(f"{label} has the wrong artifact type/location: {raw_path}")
        return
    resolved = resolve_repository_file(path)
    if resolved is None:
        if any((ROOT.joinpath(*path.parts[:index])).is_symlink() for index in range(1, len(path.parts) + 1)):
            errors.append(f"{label} must not traverse a symlink: {raw_path}")
        else:
            errors.append(f"{label} does not exist or escapes the repository: {raw_path}")
        return
    if fragment:
        if path.suffix.lower() != ".md":
            errors.append(f"{label} uses a fragment on a non-Markdown artifact")
            return
        headings = {
            markdown_anchor(line.lstrip("#").strip())
            for line in resolved.read_text(encoding="utf-8").splitlines()
            if re.match(r"^#{1,6}\s+\S", line)
        }
        if fragment not in headings:
            errors.append(f"{label} references a missing Markdown anchor: #{fragment}")


def require_object(value: Any, label: str, errors: list[str]) -> dict[str, Any]:
    if not isinstance(value, dict):
        errors.append(f"{label} must be an object")
        return {}
    return value


def locator_text(value: Any) -> str:
    if not nonempty_string(value):
        return ""
    path = resolve_repository_file(Path(str(value).split("#", 1)[0]))
    if path is None:
        return ""
    return path.read_text(encoding="utf-8").lower()


def attest_markers(value: Any, markers: dict[str, str], label: str, stage: str, errors: list[str]) -> None:
    if stage not in IMPLEMENTATION_STAGES:
        return
    text = locator_text(value)
    if not text:
        return
    for field, marker in markers.items():
        if marker.lower() not in text:
            errors.append(f"{label}.{field} is not attested by the referenced artifact")


def require_keys(value: dict[str, Any], keys: set[str], label: str, errors: list[str]) -> None:
    for key in sorted(keys - set(value)):
        errors.append(f"{label} missing key: {key}")


def require_nonempty(value: dict[str, Any], key: str, label: str, errors: list[str]) -> None:
    if not nonempty_string(value.get(key)):
        errors.append(f"{label}.{key} must be a non-empty string")


def duplicate_values(values: list[str]) -> list[str]:
    seen: set[str] = set()
    duplicates: set[str] = set()
    for value in values:
        if value in seen:
            duplicates.add(value)
        seen.add(value)
    return sorted(duplicates)


def minimum_mode(triggers: list[str]) -> str:
    tokens = {normalized_token(trigger) for trigger in triggers}
    if tokens & CRITICAL_TRIGGERS:
        return "critical"
    if tokens & HIERARCHICAL_TRIGGERS:
        return "hierarchical"
    if tokens & STANDARD_TRIGGERS:
        return "standard"
    return "micro"


def validate_classification(manifest: dict[str, Any], errors: list[str]) -> tuple[str, list[str]]:
    mutation = manifest.get("mutation")
    if not isinstance(mutation, bool):
        errors.append("mutation must be a boolean")

    classification = require_object(manifest.get("classification"), "classification", errors)
    require_keys(classification, {"triggers", "selected_mode", "override"}, "classification", errors)
    triggers = classification.get("triggers")
    if not isinstance(triggers, list) or not triggers or not all(nonempty_string(item) for item in triggers):
        errors.append("classification.triggers must be a non-empty list of strings")
        triggers = []
    normalized_triggers = {normalized_token(str(item)) for item in triggers}
    if mutation is True:
        for trigger in sorted(normalized_triggers - MUTATION_TRIGGERS):
            errors.append(f"classification.triggers contains unknown mutation trigger: {trigger}")
    elif mutation is False and normalized_triggers != {"read-only"}:
        errors.append("read-only no-op classification.triggers must be exactly ['read-only']")
    selected_mode = classification.get("selected_mode")
    if mutation is True and selected_mode not in SDD_MODES:
        errors.append("mutation classification mode must be micro, standard, hierarchical, or critical; mode none is forbidden")
    elif mutation is False and selected_mode != "none":
        errors.append("read-only no-op classification.selected_mode must be none")

    override = classification.get("override")
    if override is not None:
        override = require_object(override, "classification.override", errors)
        require_keys(override, {"reason", "approved_by", "requested_mode"}, "classification.override", errors)
        require_nonempty(override, "reason", "classification.override", errors)
        require_nonempty(override, "approved_by", "classification.override", errors)
        requested_mode = override.get("requested_mode")
        if requested_mode not in SDD_MODES:
            errors.append("classification.override.requested_mode must be a valid SDD mode")
        elif mutation is False:
            errors.append("read-only no-op cannot declare an SDD override")

    if mutation is True and selected_mode in SDD_MODES and triggers:
        required_mode = minimum_mode(triggers)
        if MODE_RANK[selected_mode] < MODE_RANK[required_mode]:
            errors.append(
                f"classification under-classification: triggers require {required_mode}, selected {selected_mode}"
            )
        if override is None and MODE_RANK[selected_mode] > MODE_RANK[required_mode]:
            errors.append("classification above the deterministic minimum requires a recorded upward override")
        if isinstance(override, dict) and override.get("requested_mode") in SDD_MODES:
            requested_mode = override["requested_mode"]
            if requested_mode != selected_mode:
                errors.append("classification.override.requested_mode must equal the effective selected_mode")
            if MODE_RANK[requested_mode] < MODE_RANK[required_mode]:
                errors.append("classification.override cannot lower the deterministic minimum mode")
    return str(selected_mode), [str(item) for item in triggers]


def validate_sdd(
    manifest: dict[str, Any], selected_mode: str, stage: str, errors: list[str]
) -> dict[str, Any]:
    sdd = require_object(manifest.get("sdd"), "sdd", errors)
    require_keys(sdd, {"id", "mode", "status", "locator"}, "sdd", errors)
    for key in ("id", "locator"):
        require_nonempty(sdd, key, "sdd", errors)
    validate_locator(sdd.get("locator"), "sdd.locator", stage, errors, ("planning/architecture",))

    mode = sdd.get("mode")
    if manifest.get("mutation") is True and mode not in SDD_MODES:
        errors.append("mutation sdd.mode cannot be none and must use a proportional SDD mode")
    if mode != selected_mode:
        errors.append("sdd.mode must match classification.selected_mode")

    status = sdd.get("status")
    if status not in {"draft", "accepted", "implementing", "superseded"}:
        errors.append("sdd.status must be draft, accepted, implementing, or superseded")
    if stage in IMPLEMENTATION_STAGES and status not in {"accepted", "implementing"}:
        errors.append(f"sdd.status {status!r} cannot authorize {stage}; use accepted or implementing")
    attest_markers(
        sdd.get("locator"),
        {
            "id": f"- id: `{sdd.get('id')}`",
            "mode": f"- mode: `{mode}`",
            "status": f"- status: `{status}`",
        },
        "sdd",
        stage,
        errors,
    )

    if mode == "micro":
        capsule = require_object(sdd.get("spec_capsule"), "sdd.spec_capsule", errors)
        for key in ("intent", "scope", "acceptance", "proof"):
            require_nonempty(capsule, key, "sdd.spec_capsule", errors)
    elif mode == "hierarchical":
        children = sdd.get("children")
        if not isinstance(children, list) or not children:
            errors.append("hierarchical sdd.children must contain explicit child dispositions")
        else:
            child_ids: list[str] = []
            for index, raw_child in enumerate(children):
                label = f"sdd.children[{index}]"
                child = require_object(raw_child, label, errors)
                require_keys(child, {"id", "disposition", "reason"}, label, errors)
                require_nonempty(child, "id", label, errors)
                require_nonempty(child, "reason", label, errors)
                if nonempty_string(child.get("id")):
                    child_ids.append(child["id"].strip())
                if child.get("disposition") not in {"included", "separate", "deferred", "not-applicable"}:
                    errors.append(f"{label}.disposition is invalid")
                if child.get("disposition") == "separate" and not nonempty_string(child.get("locator")):
                    errors.append(f"{label}.locator is required for a separate child")
                if child.get("disposition") == "separate":
                    validate_locator(child.get("locator"), f"{label}.locator", stage, errors, ("planning", "agents"))
            for duplicate in duplicate_values(child_ids):
                errors.append(f"duplicate child SDD id: {duplicate}")
    return sdd


def validate_dispositions(
    manifest: dict[str, Any], mode: str, triggers: list[str], stage: str, errors: list[str]
) -> dict[str, Any]:
    dispositions = require_object(manifest.get("dispositions"), "dispositions", errors)
    require_keys(dispositions, COMMON_DISPOSITIONS, "dispositions", errors)
    if mode == "critical":
        require_keys(dispositions, {"threat_model"}, "critical dispositions", errors)

    for name in sorted(COMMON_DISPOSITIONS | ({"threat_model"} if mode == "critical" else set())):
        if name not in dispositions:
            continue
        label = f"dispositions.{name}"
        disposition = require_object(dispositions[name], label, errors)
        require_keys(disposition, {"status", "reason"}, label, errors)
        status = disposition.get("status")
        if status not in DISPOSITION_STATUSES:
            errors.append(f"{label}.status is invalid")
        require_substantive(disposition, "reason", label, errors)
        if status in {"separate", "existing"} and not nonempty_string(disposition.get("locator")):
            errors.append(f"{label}.locator is required when status is {status}")
        if status in {"separate", "existing"}:
            roots_by_disposition = {
                "adr": ("planning/architecture",),
                "design": ("planning/design",),
                "test_design": ("planning/testing",),
                "agents": ("agents", "planning/architecture"),
                "threat_model": ("planning", "security"),
            }
            validate_locator(
                disposition.get("locator"),
                f"{label}.locator",
                stage,
                errors,
                roots_by_disposition.get(name, ("planning",)),
            )
            if stage in IMPLEMENTATION_STAGES:
                text = locator_text(disposition.get("locator"))
                if name == "adr" and "# adr-" not in text and "decision id:" not in text:
                    errors.append(f"{label}.locator does not attest an ADR artifact")
                if name == "threat_model" and "threat model" not in text:
                    errors.append(f"{label}.locator does not attest a threat model artifact")
                if name == "rollback" and "rollback" not in text:
                    errors.append(f"{label}.locator does not attest a rollback artifact")

    if mode == "critical":
        for name in ("adr", "threat_model", "test_design", "rollback"):
            if isinstance(dispositions.get(name), dict) and dispositions[name].get("status") != "separate":
                errors.append(f"critical mode requires dispositions.{name}.status to be separate")

    tokens = {normalized_token(trigger) for trigger in triggers}
    if tokens & {"ui", "structural-ui"}:
        design = dispositions.get("design")
        if isinstance(design, dict) and design.get("status") not in {"separate", "existing"}:
            errors.append("UI or structural-UI work requires a separate or existing DESIGN disposition")
    return dispositions


def validate_requirements(manifest: dict[str, Any], stage: str, errors: list[str]) -> None:
    requirements = manifest.get("requirements")
    if not isinstance(requirements, list) or not requirements:
        errors.append("requirements must be a non-empty list")
        return

    requirement_ids: list[str] = []
    case_ids: list[str] = []
    for index, raw_requirement in enumerate(requirements):
        label = f"requirements[{index}]"
        requirement = require_object(raw_requirement, label, errors)
        require_keys(requirement, {"id", "task", "proof"}, label, errors)
        require_nonempty(requirement, "id", label, errors)
        require_nonempty(requirement, "task", label, errors)
        if nonempty_string(requirement.get("id")):
            requirement_ids.append(requirement["id"].strip())

        test = requirement.get("test")
        exception = requirement.get("exception")
        if test is None and exception is None:
            errors.append(f"{label} must contain test or a justified exception")
        if test is not None:
            test = require_object(test, f"{label}.test", errors)
            require_keys(test, {"case_id", "locator"}, f"{label}.test", errors)
            require_nonempty(test, "case_id", f"{label}.test", errors)
            require_nonempty(test, "locator", f"{label}.test", errors)
            validate_locator(test.get("locator"), f"{label}.test.locator", stage, errors, ("tests",))
            if nonempty_string(test.get("case_id")):
                case_ids.append(test["case_id"].strip())
                if stage in IMPLEMENTATION_STAGES:
                    test_text = locator_text(test.get("locator"))
                    registered = re.search(
                        rf"\brun_case\s+{re.escape(test['case_id'].strip())}\b",
                        test_text,
                        flags=re.IGNORECASE,
                    )
                    if not registered:
                        errors.append(f"{label}.test.case_id is not attested by its test locator")
        if exception is not None:
            if isinstance(exception, str):
                if not substantive_reason(exception):
                    errors.append(f"{label}.exception must contain a substantive reason")
            elif isinstance(exception, dict):
                require_substantive(exception, "reason", f"{label}.exception", errors)
            else:
                errors.append(f"{label}.exception must be a string or object")

        proof = require_object(requirement.get("proof"), f"{label}.proof", errors)
        require_keys(proof, {"status", "locator"}, f"{label}.proof", errors)
        require_nonempty(proof, "locator", f"{label}.proof", errors)
        validate_locator(proof.get("locator"), f"{label}.proof.locator", stage, errors, ("planning/evidence",))
        proof_status = proof.get("status")
        if proof_status not in {"planned", "observed-red", "observed-green", "observed", "blocked"}:
            errors.append(f"{label}.proof.status is invalid")
        if stage in IMPLEMENTATION_STAGES and proof_status == "planned":
            errors.append(f"{label}.proof cannot remain planned at {stage} stage")
        if stage in IMPLEMENTATION_STAGES and proof_status == "blocked":
            errors.append(f"{label}.proof cannot authorize {stage} while blocked")
        if stage in {"review", "closure"} and proof_status not in {"observed-green", "observed"}:
            errors.append(f"{label}.proof must be observed and passing at {stage} stage")
        if stage in IMPLEMENTATION_STAGES and proof_status == "observed-green" and nonempty_string(proof.get("locator")):
            proof_path = resolve_repository_file(Path(str(proof["locator"]).split("#", 1)[0]))
            if proof_path is not None:
                proof_text = proof_path.read_text(encoding="utf-8").lower()
                if "proof status: `observed-green`" not in proof_text:
                    errors.append(f"{label}.proof locator does not attest observed-green status")
                requirement_id = str(requirement.get("id", "")).lower()
                case_id = str(test.get("case_id", "")).lower() if isinstance(test, dict) else ""
                if requirement_id not in proof_text or (case_id and case_id not in proof_text):
                    errors.append(f"{label}.proof locator does not attest its requirement and stable case")

    for duplicate in duplicate_values(requirement_ids):
        errors.append(f"duplicate requirement id: {duplicate}")
    for duplicate in duplicate_values(case_ids):
        errors.append(f"duplicate test case id: {duplicate}")

    tasks = manifest.get("tasks")
    task_ids: list[str] = []
    if not isinstance(tasks, list) or not tasks:
        errors.append("tasks must be a non-empty list")
    else:
        for index, raw_task in enumerate(tasks):
            task = require_object(raw_task, f"tasks[{index}]", errors)
            require_nonempty(task, "id", f"tasks[{index}]", errors)
            if nonempty_string(task.get("id")):
                task_ids.append(task["id"].strip())
        for duplicate in duplicate_values(task_ids):
            errors.append(f"duplicate task id: {duplicate}")
    for index, requirement in enumerate(requirements):
        if isinstance(requirement, dict) and nonempty_string(requirement.get("task")) and requirement["task"].strip() not in task_ids:
            errors.append(f"requirements[{index}].task references unknown task id: {requirement['task'].strip()}")


def validate_test_design(manifest: dict[str, Any], stage: str, errors: list[str]) -> None:
    test_design = require_object(manifest.get("test_design"), "test_design", errors)
    require_keys(test_design, {"id", "status", "owner", "independent_reviewer", "accepted_by", "locator", "dimensions"}, "test_design", errors)
    for key in ("id", "owner", "independent_reviewer", "accepted_by", "locator"):
        require_nonempty(test_design, key, "test_design", errors)
    validate_locator(test_design.get("locator"), "test_design.locator", stage, errors, ("planning/testing",))
    if test_design.get("status") not in {"draft", "accepted", "superseded"}:
        errors.append("test_design.status must be draft, accepted, or superseded")
    if stage in IMPLEMENTATION_STAGES and test_design.get("status") != "accepted":
        errors.append(f"test_design.status must be accepted at {stage} stage")
    owner = test_design.get("owner")
    reviewer = test_design.get("independent_reviewer")
    accepted_by = test_design.get("accepted_by")
    identities = [value for value in (owner, reviewer, accepted_by) if nonempty_string(value)]
    if len(set(identities)) != len(identities):
        errors.append("test_design owner, independent reviewer, and acceptor must be distinct")
    if accepted_by != "accelerate-root":
        errors.append("test_design.accepted_by must be accelerate-root")
    attest_markers(
        test_design.get("locator"),
        {
            "id": f"- id: `{test_design.get('id')}`",
            "status": f"- status: `{test_design.get('status')}`",
            "owner": f"- owner: `{owner}`",
            "independent_reviewer": f"- independent reviewer: `{reviewer}`",
            "accepted_by": f"- accepted by: `{accepted_by}`",
        },
        "test_design",
        stage,
        errors,
    )
    dimensions = require_object(test_design.get("dimensions"), "test_design.dimensions", errors)
    require_keys(dimensions, TEST_DESIGN_DIMENSIONS, "test_design.dimensions", errors)
    for name in sorted(TEST_DESIGN_DIMENSIONS):
        if name not in dimensions:
            continue
        label = f"test_design.dimensions.{name}"
        dimension = require_object(dimensions[name], label, errors)
        require_keys(dimension, {"status", "reason"}, label, errors)
        if dimension.get("status") not in {"covered", "not-applicable"}:
            errors.append(f"{label}.status must be covered or not-applicable")
        require_substantive(dimension, "reason", label, errors)


def validate_tdd_receipt(manifest: dict[str, Any], stage: str, errors: list[str]) -> None:
    change_kind = manifest.get("change_kind")
    if change_kind not in TDD_MODE_BY_CHANGE_KIND:
        errors.append(f"change_kind must be one of: {', '.join(sorted(TDD_MODE_BY_CHANGE_KIND))}")

    receipt = require_object(manifest.get("tdd_receipt"), "tdd_receipt", errors)
    require_keys(
        receipt,
        {
            "id", "locator", "state", "mode", "baseline", "implementation_owner",
            "test_writer", "independent_reviewer", "correction_evidence", "proof_order",
            "independent_review_verdict", "correction_generation", "proof_generation",
        },
        "tdd_receipt",
        errors,
    )
    for key in ("id", "locator", "implementation_owner", "test_writer", "independent_reviewer"):
        require_nonempty(receipt, key, "tdd_receipt", errors)
    validate_locator(receipt.get("locator"), "tdd_receipt.locator", stage, errors, ("planning/testing",))
    state = receipt.get("state")
    if state not in {"planned", "baseline-observed", "corrected", "reproved", "reviewed", "stale", "blocked"}:
        errors.append("tdd_receipt.state is invalid")
    identities = [receipt.get(key) for key in ("implementation_owner", "test_writer", "independent_reviewer")]
    if all(nonempty_string(value) for value in identities) and len(set(identities)) != len(identities):
        errors.append("tdd_receipt implementation owner, test writer, and independent reviewer must be distinct")
    mode = receipt.get("mode")
    expected_mode = TDD_MODE_BY_CHANGE_KIND.get(change_kind)
    if expected_mode is not None and mode != expected_mode:
        errors.append(f"change_kind {change_kind} requires tdd_receipt.mode {expected_mode}, got {mode}")
    constituent_modes = receipt.get("constituent_modes")
    if mode == "hybrid":
        allowed_constituents = set(TDD_MODE_BY_CHANGE_KIND.values()) - {"hybrid"}
        if (
            not isinstance(constituent_modes, list)
            or len(constituent_modes) < 2
            or len(constituent_modes) != len(set(constituent_modes))
            or any(item not in allowed_constituents for item in constituent_modes)
        ):
            errors.append("hybrid tdd_receipt requires at least two unique valid constituent_modes")
    elif constituent_modes is not None:
        errors.append("tdd_receipt.constituent_modes is only valid for hybrid mode")

    baseline = require_object(receipt.get("baseline"), "tdd_receipt.baseline", errors)
    require_keys(baseline, {"status", "locator"}, "tdd_receipt.baseline", errors)
    require_nonempty(baseline, "locator", "tdd_receipt.baseline", errors)
    validate_locator(
        baseline.get("locator"),
        "tdd_receipt.baseline.locator",
        stage,
        errors,
        ("planning/evidence",),
    )
    baseline_status = baseline.get("status")
    if baseline_status not in {"planned", "observed-red", "observed-characterization", "observed-contract", "blocked"}:
        errors.append("tdd_receipt.baseline.status is invalid")
    if stage in IMPLEMENTATION_STAGES:
        allowed_baselines = BASELINE_BY_TDD_MODE.get(str(mode), set())
        if baseline_status not in allowed_baselines:
            errors.append(
                f"tdd_receipt baseline {baseline_status!r} is invalid for mode {mode!r} at {stage} stage"
            )

    correction_generation = receipt.get("correction_generation")
    proof_generation = receipt.get("proof_generation")
    if not isinstance(correction_generation, int) or isinstance(correction_generation, bool) or correction_generation < 0:
        errors.append("tdd_receipt.correction_generation must be a non-negative integer")
    if not isinstance(proof_generation, int) or isinstance(proof_generation, bool) or proof_generation < 0:
        errors.append("tdd_receipt.proof_generation must be a non-negative integer")
    if (
        isinstance(correction_generation, int)
        and not isinstance(correction_generation, bool)
        and isinstance(proof_generation, int)
        and not isinstance(proof_generation, bool)
        and proof_generation != correction_generation
    ):
        errors.append("proof generation must equal correction generation; every correction requires same-generation reproof")
    if stage in {"review", "closure"} and correction_generation == 0 and proof_generation == 0:
        errors.append(f"{stage} requires an implemented correction generation greater than zero")

    correction_evidence = require_object(receipt.get("correction_evidence"), "tdd_receipt.correction_evidence", errors)
    require_keys(correction_evidence, {"status", "locator"}, "tdd_receipt.correction_evidence", errors)
    if correction_evidence.get("status") not in {"pending", "observed-green"}:
        errors.append("tdd_receipt.correction_evidence.status must be pending or observed-green")
    validate_locator(
        correction_evidence.get("locator"),
        "tdd_receipt.correction_evidence.locator",
        stage,
        errors,
        ("planning/evidence",),
    )
    if isinstance(correction_generation, int) and correction_generation > 0 and correction_evidence.get("status") != "observed-green":
        errors.append("positive correction generation requires observed-green correction evidence")
    if correction_evidence.get("status") == "observed-green" and nonempty_string(correction_evidence.get("locator")):
        evidence_path = resolve_repository_file(Path(str(correction_evidence["locator"]).split("#", 1)[0]))
        if evidence_path is not None and "proof status: `observed-green`" not in evidence_path.read_text(encoding="utf-8").lower():
            errors.append("tdd_receipt correction evidence does not attest observed-green status")

    proof_order = require_object(receipt.get("proof_order"), "tdd_receipt.proof_order", errors)
    proof_lanes = {"implementation", "qa", "browser_truth", "persistent_regression", "forensic_review"}
    require_keys(proof_order, proof_lanes, "tdd_receipt.proof_order", errors)
    if set(proof_order) - proof_lanes:
        errors.append("tdd_receipt.proof_order contains unknown lanes")
    for lane, lane_status in proof_order.items():
        if lane_status not in {"pending", "observed", "not-applicable", "blocked"}:
            errors.append(f"tdd_receipt.proof_order.{lane} has invalid status")
    verdict = receipt.get("independent_review_verdict")
    if verdict not in {"pending", "pass", "fail", "blocked"}:
        errors.append("tdd_receipt.independent_review_verdict is invalid")
    if stage in IMPLEMENTATION_STAGES and nonempty_string(receipt.get("locator")):
        receipt_path = resolve_repository_file(Path(str(receipt["locator"]).split("#", 1)[0]))
        if receipt_path is not None:
            receipt_text = receipt_path.read_text(encoding="utf-8").lower()
            declared_markers = {
                "id": f"receipt id: `{receipt.get('id')}`",
                "state": f"state: `{state}`",
                "implementation_owner": f"implementation owner: `{receipt.get('implementation_owner')}`",
                "test_writer": f"test/fixture writer: `{receipt.get('test_writer')}`",
                "independent_reviewer": f"independent reviewer: `{receipt.get('independent_reviewer')}`",
                "correction_generation": f"correction generation: `{correction_generation}`",
                "proof_generation": f"proof generation: `{proof_generation}`",
                "independent_review_verdict": f"independent review verdict: `{verdict}`",
                "change_kind": f"change kind: `{change_kind}`",
                "mode": f"proof mode: `{mode}`",
                "baseline_status": f"baseline status: `{baseline_status}`",
                "baseline_locator": f"baseline locator: `{baseline.get('locator')}`",
                "correction_evidence_status": f"correction evidence status: `{correction_evidence.get('status')}`",
                "correction_evidence_locator": f"correction evidence locator: `{correction_evidence.get('locator')}`",
            }
            for field, marker in declared_markers.items():
                if marker.lower() not in receipt_text:
                    errors.append(f"tdd_receipt.{field} is not attested by its dated receipt")
            lane_labels = {
                "implementation": "implementation proof",
                "qa": "backend/frontend qa",
                "browser_truth": "browser truth",
                "persistent_regression": "persistent regression",
                "forensic_review": "forensic closure review",
            }
            for lane, lane_label in lane_labels.items():
                lane_status = proof_order.get(lane)
                if f"| {lane_label} | {lane_status} |" not in receipt_text:
                    errors.append(f"tdd_receipt.proof_order.{lane} is not attested by its dated receipt")
    if stage in {"review", "closure"}:
        if state != "reviewed" or verdict != "pass":
            errors.append(f"{stage} requires a reviewed TDD receipt with an independent pass verdict")
        if proof_order.get("implementation") != "observed" or proof_order.get("qa") != "observed":
            errors.append(f"{stage} requires observed implementation and QA proof lanes")
    if stage == "closure" and proof_order.get("forensic_review") != "observed":
        errors.append("closure requires observed forensic review in TDD proof order")


def validate_manifest(manifest: dict[str, Any], stage: str) -> list[str]:
    errors: list[str] = []
    require_keys(
        manifest,
        {"schema_version", "mutation", "change_kind", "classification"},
        "manifest",
        errors,
    )
    if manifest.get("schema_version") != 1:
        errors.append("schema_version must be 1")

    selected_mode, triggers = validate_classification(manifest, errors)
    if manifest.get("mutation") is False:
        if manifest.get("change_kind") != "read-only":
            errors.append("non-mutation manifest change_kind must be read-only")
        if not substantive_reason(manifest.get("outcome")):
            errors.append("non-mutation manifest requires a substantive read-only outcome")
        forbidden = {"sdd", "dispositions", "tasks", "requirements", "test_design", "tdd_receipt"} & set(manifest)
        if forbidden:
            errors.append(f"non-mutation no-op must not fabricate mutation artifacts: {', '.join(sorted(forbidden))}")
        return sorted(set(errors))

    require_keys(
        manifest,
        {"sdd", "dispositions", "tasks", "requirements", "test_design", "tdd_receipt"},
        "mutation manifest",
        errors,
    )
    sdd = validate_sdd(manifest, selected_mode, stage, errors)
    dispositions = validate_dispositions(manifest, str(sdd.get("mode")), triggers, stage, errors)
    validate_requirements(manifest, stage, errors)
    validate_test_design(manifest, stage, errors)
    validate_tdd_receipt(manifest, stage, errors)
    test_design = manifest.get("test_design")
    disposition = dispositions.get("test_design") if isinstance(dispositions, dict) else None
    if isinstance(test_design, dict) and isinstance(disposition, dict):
        if disposition.get("locator") != test_design.get("locator"):
            errors.append("dispositions.test_design.locator must match test_design.locator")
    if sdd.get("mode") == "critical":
        live_locators = [sdd.get("locator")]
        for name in ("adr", "threat_model", "test_design", "rollback"):
            value = dispositions.get(name) if isinstance(dispositions, dict) else None
            if isinstance(value, dict):
                live_locators.append(value.get("locator"))
        normalized = [item for item in live_locators if nonempty_string(item)]
        if len(normalized) != len(set(normalized)):
            errors.append("critical SDD, ADR, threat model, Test Design, and rollback locators must be distinct")
    return sorted(set(errors))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate an Engineering Artifact Manifest.")
    parser.add_argument("manifest", type=Path)
    parser.add_argument(
        "--stage",
        choices=("specification", "plan", "implementation", "review", "closure"),
        default="plan",
    )
    args = parser.parse_args(argv)

    try:
        document = json.loads(args.manifest.read_text(), object_pairs_hook=object_without_duplicate_keys)
        if not isinstance(document, dict):
            raise ValueError("manifest root must be an object")
        errors = validate_manifest(document, args.stage)
    except (OSError, json.JSONDecodeError, DuplicateKeyError, ValueError) as error:
        print(f"engineering artifact manifest invalid: {error}", file=sys.stderr)
        return 1

    if errors:
        print("engineering artifact manifest invalid:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print(f"engineering artifact manifest valid: {args.manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
