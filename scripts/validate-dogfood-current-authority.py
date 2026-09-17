#!/usr/bin/env python3
"""Validate dogfood workspace consistency against external authority receipt."""
from __future__ import annotations

import argparse
import hashlib
import json
import stat
import sys
from pathlib import Path

def fail(message: str) -> None:
    raise ValueError(message)

def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def digest(path: Path) -> str:
    return "sha256:" + file_sha256(path)

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

def parse_top_level_yaml_scalars(text: str, filename: str = "") -> dict[str, str]:
    result: dict[str, str] = {}
    for line_num, line in enumerate(text.splitlines(), start=1):
        if not line or line.startswith(("#", " ", "\t")):
            continue
        if ":" not in line:
            continue
        key, sep, val = line.partition(":")
        key = key.strip()
        if not key:
            continue
        val = val.strip()
        if "#" in val and not ((val.startswith('"') and val.endswith('"')) or (val.startswith("'") and val.endswith("'"))):
            val = val.split("#", 1)[0].strip()
        val = val.strip("'\"")
        if key in result:
            context = f" in {filename}" if filename else ""
            fail(f"duplicate top-level key '{key}'{context} at line {line_num}")
        result[key] = val
    return result


def validate(root: Path) -> None:
    state_file = bound_path(root, ".accelerate/state.yaml")
    readiness_file = bound_path(root, ".accelerate/status/readiness-dashboard.yaml")
    active_file = bound_path(root, ".accelerate/workflow/active-work-item.yaml")

    state = parse_top_level_yaml_scalars(state_file.read_text(encoding="utf-8"), filename=".accelerate/state.yaml")
    readiness = parse_top_level_yaml_scalars(readiness_file.read_text(encoding="utf-8"), filename=".accelerate/status/readiness-dashboard.yaml")
    active = parse_top_level_yaml_scalars(active_file.read_text(encoding="utf-8"), filename=".accelerate/workflow/active-work-item.yaml")

    # 1. Parity check on authority locator
    state_receipt = state.get("current_authority_receipt")
    if not state_receipt:
        fail("missing current_authority_receipt in .accelerate/state.yaml")
    readiness_receipt = readiness.get("authority_receipt")
    if not readiness_receipt:
        fail("missing authority_receipt in .accelerate/status/readiness-dashboard.yaml")
    active_receipt = active.get("authority_receipt")
    if not active_receipt:
        fail("missing authority_receipt in .accelerate/workflow/active-work-item.yaml")

    if state_receipt != readiness_receipt:
        fail(f"authority locator parity mismatch: state ({state_receipt}) != readiness ({readiness_receipt})")
    if state_receipt != active_receipt:
        fail(f"authority locator parity mismatch: state ({state_receipt}) != active ({active_receipt})")

    # 2. Parity check on authority digest
    state_digest = state.get("current_authority_digest")
    if not state_digest:
        fail("missing current_authority_digest in .accelerate/state.yaml")
    readiness_digest = readiness.get("authority_digest")
    if not readiness_digest:
        fail("missing authority_digest in .accelerate/status/readiness-dashboard.yaml")
    active_digest = active.get("authority_digest")
    if not active_digest:
        fail("missing authority_digest in .accelerate/workflow/active-work-item.yaml")

    if state_digest != readiness_digest:
        fail(f"authority digest parity mismatch: state ({state_digest}) != readiness ({readiness_digest})")
    if state_digest != active_digest:
        fail(f"authority digest parity mismatch: state ({state_digest}) != active ({active_digest})")

    # 3. Check actual file and digest
    auth_path = bound_path(root, state_receipt)
    actual_digest = digest(auth_path)
    if actual_digest != state_digest:
        fail(f"current authority digest mismatch: expected {state_digest}, got {actual_digest}")

    try:
        auth = json.loads(auth_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON in authority receipt: {exc}")
    if not isinstance(auth, dict):
        fail("authority receipt must be a JSON object")

    gov = auth.get("governing_issue", {})
    cur = auth.get("current", {})
    effect = auth.get("authority_effect", {})

    # 4. Expected Plane state
    if gov.get("identifier") != "CODEX-26":
        fail(f"governing issue identifier mismatch: expected CODEX-26, got {gov.get('identifier')}")
    if gov.get("id") != "549d5c6e-9066-440c-85a6-973a33b7eefe":
        fail(f"governing issue id mismatch: expected 549d5c6e-9066-440c-85a6-973a33b7eefe, got {gov.get('id')}")
    if gov.get("expected_state") != "In Progress":
        fail(f"governing issue expected_state mismatch: expected 'In Progress', got '{gov.get('expected_state')}'")
    if gov.get("expected_completed_at") is not None:
        fail("governing issue expected_completed_at must be null")

    # 5. Materialization profile parity
    auth_profile = cur.get("materialization_profile")
    if auth_profile != "committed-dogfood-v2-index":
        fail(f"unexpected materialization_profile in authority receipt: {auth_profile}")
    state_profile = state.get("materialization_profile")
    if not state_profile:
        fail("missing or blank materialization_profile in .accelerate/state.yaml")
    if state_profile != auth_profile:
        fail(f"materialization profile parity mismatch: state ({state_profile}) != authority ({auth_profile})")

    # 6. All no-acceptance / no-promotion / no-Phase2 authority effects
    if effect.get("prompt_h_is_current") is not True:
        fail("authority indicates prompt_h_is_current is not true")
    if effect.get("phase1_accepted") is not False:
        fail("authority indicates phase1_accepted is not false")
    if effect.get("plane_closure_authorized") is not False:
        fail("authority indicates plane_closure_authorized is not false")
    if effect.get("runtime_or_promotion_authorized") is not False:
        fail("authority indicates runtime_or_promotion_authorized is not false")
    if effect.get("phase2_authorized") is not False:
        fail("authority indicates phase2_authorized is not false")
    if cur.get("remote_calls_allowed") is not False:
        fail("authority indicates remote_calls_allowed is not false")
    if cur.get("cycle") == "codex-26-phase1-c13-reentry":
        fail("C13 must not be current cycle")

    # 7. Required supersedes dispositions
    supersedes = auth.get("supersedes", [])
    if not isinstance(supersedes, list):
        fail("supersedes in authority receipt must be a list")
    disp_map = {entry.get("authority"): entry.get("disposition") for entry in supersedes if isinstance(entry, dict)}
    if disp_map.get("CODEX-26 C13 reentry") != "historical-lineage-not-current":
        fail("missing or invalid disposition for CODEX-26 C13 reentry in supersedes")
    if disp_map.get("CODEX-26 Prompt G closure review") != "historical-no-go-input":
        fail("missing or invalid disposition for CODEX-26 Prompt G closure review in supersedes")

    # 8. Plan parity
    cur_plan = cur.get("plan")
    if state.get("current_plan") != cur_plan:
        fail(f"state current_plan mismatch: expected {cur_plan}, got {state.get('current_plan')}")
    if readiness.get("plan") != cur_plan:
        fail(f"readiness plan mismatch: expected {cur_plan}, got {readiness.get('plan')}")
    if active.get("plan") != cur_plan:
        fail(f"active work item plan mismatch: expected {cur_plan}, got {active.get('plan')}")

    # 9. Ledger parity
    cur_ledger = cur.get("ledger")
    if state.get("current_task_ledger") != cur_ledger:
        fail(f"state current_task_ledger mismatch: expected {cur_ledger}, got {state.get('current_task_ledger')}")
    if readiness.get("ledger") != cur_ledger:
        fail(f"readiness ledger mismatch: expected {cur_ledger}, got {readiness.get('ledger')}")
    if active.get("ledger") != cur_ledger:
        fail(f"active work item ledger mismatch: expected {cur_ledger}, got {active.get('ledger')}")

    # 10. Governing plane work item parity across state, readiness, and active
    if state.get("governing_plane_work_item") != gov.get("identifier"):
        fail(f"state governing_plane_work_item mismatch: expected {gov.get('identifier')}, got {state.get('governing_plane_work_item')}")
    if state.get("governing_plane_work_item_id") != gov.get("id"):
        fail(f"state governing_plane_work_item_id mismatch: expected {gov.get('id')}, got {state.get('governing_plane_work_item_id')}")
    if readiness.get("governing_plane_work_item") != gov.get("identifier"):
        fail(f"readiness governing_plane_work_item mismatch: expected {gov.get('identifier')}, got {readiness.get('governing_plane_work_item')}")
    if readiness.get("governing_plane_work_item_id") != gov.get("id"):
        fail(f"readiness governing_plane_work_item_id mismatch: expected {gov.get('id')}, got {readiness.get('governing_plane_work_item_id')}")
    if active.get("governing_plane_work_item") != gov.get("identifier"):
        fail(f"active work item governing_plane_work_item mismatch: expected {gov.get('identifier')}, got {active.get('governing_plane_work_item')}")
    if active.get("governing_plane_work_item_id") != gov.get("id"):
        fail(f"active work item governing_plane_work_item_id mismatch: expected {gov.get('id')}, got {active.get('governing_plane_work_item_id')}")

    # 11. Cycle & Status parity
    if readiness.get("cycle") != cur.get("cycle"):
        fail(f"readiness cycle mismatch: expected {cur.get('cycle')}, got {readiness.get('cycle')}")
    if readiness.get("status") != cur.get("phase_status"):
        fail(f"readiness status mismatch: expected {cur.get('phase_status')}, got {readiness.get('status')}")
    if readiness.get("status") == "accepted":
        fail("readiness status must not be accepted")

    if active.get("id") != gov.get("identifier"):
        fail(f"active work item id mismatch: expected {gov.get('identifier')}, got {active.get('id')}")
    if active.get("status") != cur.get("local_work_item_status"):
        fail(f"active work item status mismatch: expected {cur.get('local_work_item_status')}, got {active.get('status')}")
    if active.get("status") in ("closed", "accepted", "Done"):
        fail(f"active work item status must not be closed or accepted: {active.get('status')}")
    if active.get("remote_calls_allowed") != "false":
        fail(f"active work item remote_calls_allowed must be false, got {active.get('remote_calls_allowed')}")
    if "accepted_scope" in active:
        fail("active work item must not carry accepted_scope while in-progress")
    if "in_progress_scope" not in active:
        fail("active work item must carry in_progress_scope")

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        validate(args.root.resolve())
    except ValueError as exc:
        print(f"FAIL dogfood current authority: {exc}", file=sys.stderr)
        return 1
    print("PASS dogfood current authority: state, readiness, and active work item bind authority receipt")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
