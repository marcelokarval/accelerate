#!/usr/bin/env python3
"""Validate current CODEX-26 Phase-1 Prompt H entry without promoting CODEX-17 or C13."""
from __future__ import annotations

import argparse
import hashlib
import json
import stat
import sys
from pathlib import Path

PROMPT_H_AUTH = Path("planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-current-authority.json")
C13 = Path("planning/evidence/dated-proof-appendix/codex-26-phase1/c13-current-status-and-reentry-reconciliation.json")
HISTORICAL = Path("planning/evidence/dated-proof-appendix/codex-17-phase1-entry/phase1-entry-current-candidate-supersession.json")
PHASE0 = Path("planning/evidence/dated-proof-appendix/codex-25-phase0-acceptance/round-3/phase0-operator-acceptance.json")
PHASE1_AUTH = Path("planning/evidence/dated-proof-appendix/codex-26-phase1/phase-implementation-authorization.json")
C13_AUTH = Path("planning/evidence/dated-proof-appendix/codex-26-phase1/c13-operator-reentry-authorization.json")
C12_FAILURE = Path("planning/evidence/dated-proof-appendix/codex-26-phase1/c12-final-independent-gate-failure-and-round-exhaustion.md")
PROPOSAL = Path("planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md")

def fail(message: str) -> None:
    raise ValueError(message)

def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def digest(path: Path) -> str:
    return "sha256:" + file_sha256(path)

def no_duplicates(pairs: list[tuple[str, object]]) -> dict:
    result: dict = {}
    for key, value in pairs:
        if key in result:
            fail(f"duplicate JSON key: {key}")
        result[key] = value
    return result

def bound_path(root: Path, relative: str) -> Path:
    path = Path(relative)
    if path.is_absolute() or ".." in path.parts:
        fail(f"artifact path must be repository-relative and traversal-free: {relative}")
    candidate, cursor = root / path, root
    for component in path.parts:
        cursor /= component
        if cursor.is_symlink():
            fail(f"bound artifact path must not contain a symlink: {relative}")
    if not candidate.exists() or not stat.S_ISREG(candidate.stat().st_mode):
        fail(f"bound artifact must be an existing regular file: {relative}")
    return candidate

def load(root: Path, relative: Path) -> dict:
    try:
        value = json.loads(bound_path(root, str(relative)).read_text(encoding="utf-8"), object_pairs_hook=no_duplicates)
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON in {relative}: {exc}")
    if not isinstance(value, dict):
        fail(f"JSON object required: {relative}")
    return value

def exact(value: dict, keys: set[str], label: str) -> None:
    if set(value) != keys:
        fail(f"unexpected fields in {label}: expected {sorted(keys)}, got {sorted(value)}")

def binding(root: Path, value: object, expected_path: Path, label: str) -> None:
    if not isinstance(value, dict):
        fail(f"{label} must be an object")
    exact(value, {"path", "digest"}, label)
    if value.get("path") != str(expected_path):
        fail(f"{label} path mismatch")
    if value.get("digest") != digest(bound_path(root, str(expected_path))):
        fail(f"{label} digest mismatch")

def validate(root: Path) -> None:
    # 1. Validate Prompt H current authority
    current_auth = load(root, PROMPT_H_AUTH)
    exact(current_auth, {"schema_version", "authority_id", "governing_issue", "current", "supersedes", "immutable_inputs", "authority_effect"}, "Prompt H current authority receipt")
    if current_auth["schema_version"] != "codex26-phase1-current-authority-v1":
        fail("unsupported Prompt H authority schema")
    if current_auth["authority_id"] != "CODEX-26-PHASE1-PROMPT-H-CURRENT":
        fail("unexpected Prompt H authority id")

    gov = current_auth["governing_issue"]
    if not isinstance(gov, dict):
        fail("governing_issue must be an object")
    exact(gov, {"identifier", "id", "project_id", "workspace_slug", "expected_state", "expected_completed_at"}, "governing_issue")
    if gov["identifier"] != "CODEX-26" or gov["id"] != "549d5c6e-9066-440c-85a6-973a33b7eefe" or gov["expected_state"] != "In Progress" or gov["expected_completed_at"] is not None:
        fail("governing issue must bind active CODEX-26 in progress")

    cur = current_auth["current"]
    if not isinstance(cur, dict):
        fail("current must be an object")
    exact(cur, {"cycle", "plan", "ledger", "phase_status", "local_work_item_status", "materialization_profile", "remote_calls_allowed"}, "current")
    if cur["cycle"] != "codex-26-phase1-dogfood-closure-prompt-h":
        fail(f"unexpected current cycle: {cur['cycle']}")
    if cur["phase_status"] != "implementing-not-accepted":
        fail(f"unexpected current phase_status: {cur['phase_status']}")
    if cur["local_work_item_status"] != "in-progress":
        fail(f"unexpected current local_work_item_status: {cur['local_work_item_status']}")
    if cur["materialization_profile"] != "committed-dogfood-v2-index":
        fail(f"unexpected current materialization_profile: {cur['materialization_profile']}")
    if cur["remote_calls_allowed"] is not False:
        fail("remote_calls_allowed must be false")

    # Verify immutable inputs
    inputs = current_auth["immutable_inputs"]
    if not isinstance(inputs, dict):
        fail("immutable_inputs must be an object")
    exact(inputs, {"prompt_h_execution_contract", "prompt_h_task_graph", "prompt_g_final_result", "prompt_g_final_freeze"}, "immutable_inputs")
    for key, spec in inputs.items():
        if not isinstance(spec, dict) or set(spec) != {"path", "sha256"}:
            fail(f"invalid immutable input entry: {key}")
        p = bound_path(root, spec["path"])
        actual_sha = file_sha256(p)
        if actual_sha != spec["sha256"]:
            fail(f"immutable input {key} digest mismatch: expected {spec['sha256']}, got {actual_sha}")

    # Authority effect
    effect = current_auth["authority_effect"]
    if not isinstance(effect, dict):
        fail("authority_effect must be an object")
    exact(effect, {"prompt_h_is_current", "phase1_accepted", "plane_closure_authorized", "runtime_or_promotion_authorized", "phase2_authorized"}, "authority_effect")
    if effect["prompt_h_is_current"] is not True:
        fail("prompt_h_is_current must be true")
    if effect["phase1_accepted"] is not False:
        fail("phase1_accepted must be false")
    if effect["plane_closure_authorized"] is not False:
        fail("plane_closure_authorized must be false")
    if effect["runtime_or_promotion_authorized"] is not False:
        fail("runtime_or_promotion_authorized must be false")
    if effect["phase2_authorized"] is not False:
        fail("phase2_authorized must be false")

    # Supersedes
    supersedes = current_auth.get("supersedes", [])
    if not isinstance(supersedes, list):
        fail("supersedes must be a list")
    superseded_names = {entry.get("authority"): entry.get("disposition") for entry in supersedes if isinstance(entry, dict)}
    if superseded_names.get("CODEX-26 C13 reentry") != "historical-lineage-not-current":
        fail("C13 must be superseded as historical lineage")
    if superseded_names.get("CODEX-26 Prompt G closure review") != "historical-no-go-input":
        fail("Prompt G must be superseded as historical no-go input")

    # 2. Historical C13 lineage validation
    c13 = load(root, C13)
    exact(c13, {"schema_version", "receipt_id", "current_work_item", "proposal", "authority_lineage", "local_workspace", "suite", "authority_effect"}, "C13 receipt")
    if c13["schema_version"] != "codex26-phase1-c13-current-status-and-reentry-v1":
        fail("unsupported C13 schema")
    binding(root, c13["proposal"], PROPOSAL, "proposal")
    lineage = c13["authority_lineage"]
    exact(lineage, {"historical_codex17", "codex25_phase0_acceptance", "codex26_phase1_authorization", "c13_reentry_authorization", "rejected_c12_predecessor"}, "authority_lineage")
    for name, path, label in (
        ("historical_codex17", HISTORICAL, "historical CODEX-17"),
        ("codex25_phase0_acceptance", PHASE0, "CODEX-25 Phase-0 acceptance"),
        ("codex26_phase1_authorization", PHASE1_AUTH, "CODEX-26 Phase-1 authorization"),
        ("c13_reentry_authorization", C13_AUTH, "C13 reentry authorization"),
        ("rejected_c12_predecessor", C12_FAILURE, "rejected C12 predecessor")
    ):
        binding(root, lineage[name], path, label)

    phase1 = load(root, PHASE1_AUTH)
    c13_auth = load(root, C13_AUTH)
    if phase1.get("authorization_work_item", {}).get("identifier") != "CODEX-26" or phase1.get("proposal", {}).get("digest") != c13["proposal"]["digest"].removeprefix("sha256:"):
        fail("CODEX-26 Phase-1 authorization does not bind current proposal")
    if c13_auth.get("issue_id") != "CODEX-26" or c13_auth.get("governing_proposal", {}).get("sha256") != c13["proposal"]["digest"].removeprefix("sha256:"):
        fail("C13 reentry authorization does not bind current proposal")

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        validate(args.root.resolve())
    except ValueError as exc:
        print(f"FAIL phase1 entry currentness: {exc}", file=sys.stderr)
        return 1
    print("PASS phase1 entry currentness: CODEX-17 and C13 are historical; CODEX-26 Prompt H is current and unaccepted")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
