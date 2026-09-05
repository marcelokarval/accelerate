from __future__ import annotations

import json
import hashlib
import subprocess
import sys
from copy import deepcopy
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
VALIDATOR = REPO / "scripts/validate-task-graph-heartbeat.py"
RECEIPT_BYTES = b"dispatch receipt\n"
RECEIPT_SHA256 = hashlib.sha256(RECEIPT_BYTES).hexdigest()


def snapshot(*, head: str = "a" * 64, staged_paths: list[str] | None = None, unstaged_paths: list[str] | None = None, untracked_paths: list[str] | None = None, operation: str = "none", conflict_paths: list[str] | None = None) -> dict[str, object]:
    digest = "a" * 64
    return {
        "head": head,
        "parents": [],
        "branch_mode": "branch",
        "branch": "feature/task-graph",
        "upstream": "origin/feature/task-graph",
        "upstream_divergence": {"ahead": 0, "behind": 0},
        "staged_fingerprint": digest,
        "unstaged_fingerprint": digest,
        "untracked_fingerprint": digest,
        "staged_paths": staged_paths or [],
        "unstaged_paths": unstaged_paths or [],
        "untracked_paths": untracked_paths or [],
        "operation_state": {"kind": operation, "conflict_paths": conflict_paths or []},
    }


def graph() -> dict[str, object]:
    return {
        "contract_version": "task-graph/v1",
        "graph_id": "graph-1",
        "semantic_id": "codex-22-slice-a2",
        "state": "FROZEN_CURRENT",
        "baseline": {"category": "delta-baseline", "git_snapshot": snapshot()},
        "nodes": [
            {"node_id": "contract", "assignment_id": "assignment-contract", "semantic_id": "contract", "candidate_sha256": None, "depends_on": [], "write_scopes": ["core/task-graph"]},
            {"node_id": "validator", "assignment_id": "assignment-1", "semantic_id": "validator", "candidate_sha256": "c" * 64, "depends_on": ["contract"], "write_scopes": ["scripts/validate-task-graph-heartbeat.py"]},
        ],
        "authority": {"kind": "planning-only", "may_authorize": False, "may_close": False},
    }


def heartbeat(task_graph: dict[str, object]) -> dict[str, object]:
    return {
        "contract_version": "development-heartbeat/v1",
        "heartbeat_id": "heartbeat-2",
        "graph_id": task_graph["graph_id"],
        "observed_at": "2026-09-01T12:01:00Z",
        "expires_at": "2026-09-01T12:16:00Z",
        "previous_sequence": 1,
        "sequence": 2,
        "observed_graph_state": task_graph["state"],
        "graph_baseline": deepcopy(task_graph["baseline"]),
        "observed_repository_snapshot": deepcopy(task_graph["baseline"]["git_snapshot"]),
        "triggers": [],
        "reanalysis": {"status": "not-required", "trigger_ids": []},
        "subject": {"node_id": "validator", "assignment_id": "assignment-1", "agent_id": "agent-1", "call_id": "call-1", "actor_epoch": 1, "candidate_sha256": "c" * 64, "observed_fence_token": "fence-1", "dispatch_receipt": {"locator": "receipts/dispatch-1.json", "sha256": RECEIPT_SHA256}},
        "authority": {"kind": "observation-reconciliation", "may_authorize": False, "may_lease": False, "may_approve": False, "may_close": False},
    }


def run_validator(tmp_path: Path, task_graph: dict[str, object], beat: dict[str, object], now: str = "2026-09-01T12:05:00Z", internal_receipt_symlink: bool = False) -> subprocess.CompletedProcess[str]:
    graph_path = tmp_path / "graph.json"
    heartbeat_path = tmp_path / "heartbeat.json"
    receipt = beat.get("subject", {}).get("dispatch_receipt", {})
    if internal_receipt_symlink:
        (tmp_path / "dispatch-1.json").write_bytes(RECEIPT_BYTES)
        (tmp_path / "receipts").symlink_to(".")
    elif isinstance(receipt, dict) and receipt.get("locator") == "receipts/dispatch-1.json":
        receipt_path = tmp_path / receipt["locator"]
        receipt_path.parent.mkdir(parents=True, exist_ok=True)
        receipt_path.write_bytes(RECEIPT_BYTES)
    graph_path.write_text(json.dumps(task_graph), encoding="utf-8")
    heartbeat_path.write_text(json.dumps(beat), encoding="utf-8")
    return subprocess.run([sys.executable, str(VALIDATOR), str(graph_path), str(heartbeat_path), now], cwd=REPO, text=True, capture_output=True)


def test_accepts_current_serialized_graph_and_observational_heartbeat(tmp_path: Path) -> None:
    result = run_validator(tmp_path, graph(), heartbeat(graph()))
    assert result.returncode == 0, result.stderr


def test_accepts_stale_graph_with_exact_reanalysis_trigger_inventory(tmp_path: Path) -> None:
    value = graph()
    value["state"] = "STALE_REANALYSIS_REQUIRED"
    beat = heartbeat(value)
    beat["triggers"] = [{"trigger_id": "review-1", "kind": "review-evidence-change", "evidence": "new review finding"}]
    beat["reanalysis"] = {"status": "required", "trigger_ids": ["review-1"]}
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 0, result.stderr


def test_rejects_duplicate_json_key(tmp_path: Path) -> None:
    graph_path = tmp_path / "graph.json"
    heartbeat_path = tmp_path / "heartbeat.json"
    graph_path.write_text('{"contract_version":"task-graph/v1","contract_version":"task-graph/v1"}', encoding="utf-8")
    heartbeat_path.write_text(json.dumps(heartbeat(graph())), encoding="utf-8")
    result = subprocess.run([sys.executable, str(VALIDATOR), str(graph_path), str(heartbeat_path), "2026-09-01T12:05:00Z"], cwd=REPO, text=True, capture_output=True)
    assert result.returncode == 1
    assert "duplicate key" in result.stderr


def test_rejects_cycles_dangling_dependencies_duplicate_semantics_and_unserialized_overlap(tmp_path: Path) -> None:
    for mutate, expected in (
        (lambda value: value["nodes"][0].update({"depends_on": ["validator"]}), "cycle"),
        (lambda value: value["nodes"][1].update({"depends_on": ["missing"]}), "dangling"),
        (lambda value: value["nodes"][1].update({"semantic_id": "contract"}), "duplicate semantic"),
        (lambda value: value["nodes"][1].update({"depends_on": [], "write_scopes": ["core"]}), "overlapping write scopes"),
    ):
        value = graph()
        mutate(value)
        result = run_validator(tmp_path, value, heartbeat(value))
        assert result.returncode == 1
        assert expected in result.stderr


def test_rejects_non_delta_baseline_and_heartbeat_mismatch_or_regression(tmp_path: Path) -> None:
    for mutate, expected in (
        (lambda task, beat: task["baseline"].update({"category": "commit"}), "delta-baseline"),
        (lambda task, beat: beat.update({"sequence": 1}), "regressive"),
        (lambda task, beat: beat.update({"observed_graph_state": "STALE_REANALYSIS_REQUIRED"}), "state mismatch"),
        (lambda task, beat: beat["graph_baseline"]["git_snapshot"].update({"head": "b" * 64}), "baseline mismatch"),
    ):
        value = graph()
        beat = heartbeat(value)
        mutate(value, beat)
        result = run_validator(tmp_path, value, beat)
        assert result.returncode == 1
        assert expected in result.stderr


def test_requires_reanalysis_for_a_trigger_and_rejects_authority_overclaim(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": "HEAD changed"}]
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "reanalysis" in result.stderr

    value = graph()
    beat = heartbeat(value)
    beat["authority"]["may_close"] = True
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "authority" in result.stderr


def test_requires_git_trigger_and_stale_state_for_changed_head_or_dirty_inventory(tmp_path: Path) -> None:
    for observed in (
        snapshot(head="b" * 64),
        snapshot(staged_paths=["core/task-graph/README.md"], unstaged_paths=["core/task-graph/README.md"]),
    ):
        value = graph()
        beat = heartbeat(value)
        beat["observed_repository_snapshot"] = observed
        result = run_validator(tmp_path, value, beat)
        assert result.returncode == 1
        assert "git-change" in result.stderr

        value["state"] = "STALE_REANALYSIS_REQUIRED"
        beat = heartbeat(value)
        beat["observed_repository_snapshot"] = observed
        beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": "repository snapshot differs"}]
        beat["reanalysis"] = {"status": "required", "trigger_ids": ["git-1"]}
        result = run_validator(tmp_path, value, beat)
        assert result.returncode == 0, result.stderr


def test_requires_git_trigger_for_merge_rebase_or_conflict_and_rejects_unjustified_one(tmp_path: Path) -> None:
    for operation in ("merge", "rebase"):
        value = graph()
        value["state"] = "STALE_REANALYSIS_REQUIRED"
        beat = heartbeat(value)
        beat["observed_repository_snapshot"] = snapshot(operation=operation)
        beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": operation}]
        beat["reanalysis"] = {"status": "required", "trigger_ids": ["git-1"]}
        result = run_validator(tmp_path, value, beat)
        assert result.returncode == 0, result.stderr

    value = graph()
    beat = heartbeat(value)
    beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": "not enough"}]
    beat["reanalysis"] = {"status": "required", "trigger_ids": ["git-1"]}
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "unjustified git-change" in result.stderr


def test_rejects_commit_as_spec_or_runtime_authority(tmp_path: Path) -> None:
    value = graph()
    value["baseline"]["category"] = "commit"
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 1
    assert "delta-baseline" in result.stderr

    value = graph()
    beat = heartbeat(value)
    beat["authority"]["kind"] = "commit-spec-runtime-authority"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "authority" in result.stderr


def test_rejects_baseline_dirty_paths_overlapping_a_node_write_scope(tmp_path: Path) -> None:
    value = graph()
    value["baseline"]["git_snapshot"]["unstaged_paths"] = ["core/task-graph/README.md"]
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 1
    assert "baseline dirty path overlaps" in result.stderr

    value = graph()
    value["baseline"]["git_snapshot"]["unstaged_paths"] = ["docs/notes.md"]
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 0, result.stderr


def test_rejects_unknown_subject_or_nonphysical_subject_ids(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    beat["subject"]["node_id"] = "missing"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "subject node" in result.stderr

    value = graph()
    beat = heartbeat(value)
    beat["subject"]["agent_id"] = ""
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "agent_id" in result.stderr


def test_rejects_expired_or_not_yet_observed_heartbeat(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    result = run_validator(tmp_path, value, beat, "2026-09-01T12:17:00Z")
    assert result.returncode == 1
    assert "expired" in result.stderr

    result = run_validator(tmp_path, value, beat, "2026-09-01T12:00:00Z")
    assert result.returncode == 1
    assert "before observed_at" in result.stderr

    beat["expires_at"] = "2026-09-01T12:16:01Z"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "15-minute" in result.stderr


def test_rejects_path_aliases_and_noncanonical_scope_before_overlap_checks(tmp_path: Path) -> None:
    value = graph()
    value["baseline"]["git_snapshot"]["unstaged_paths"] = ["core/./task-graph"]
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 1

    value = graph()
    value["nodes"][0]["write_scopes"] = ["."]
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 1


def test_requires_subject_assignment_and_dispatch_receipt_binding(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    beat["subject"]["assignment_id"] = "assignment-other"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "assignment" in result.stderr

    for dispatch_receipt in ({"locator": "receipts/dispatch-1.json"}, {"locator": "receipts/dispatch-1.json", "sha256": "e" * 64}):
        value = graph()
        beat = heartbeat(value)
        beat["subject"]["dispatch_receipt"] = dispatch_receipt
        result = run_validator(tmp_path, value, beat)
        assert result.returncode == 1
        assert "dispatch" in result.stderr


def test_reads_dispatch_receipt_from_heartbeat_parent_and_rejects_missing_file(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    beat["subject"]["dispatch_receipt"]["locator"] = "receipts/missing.json"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "dispatch receipt" in result.stderr


def test_requires_subject_candidate_to_match_the_selected_node(tmp_path: Path) -> None:
    value = graph()
    beat = heartbeat(value)
    beat["subject"]["candidate_sha256"] = "e" * 64
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "candidate" in result.stderr

    value = graph()
    value["nodes"][1]["candidate_sha256"] = None
    beat = heartbeat(value)
    beat["subject"]["candidate_sha256"] = None
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 0, result.stderr


def test_conflicting_write_scope_requires_blocked_but_nonconflict_merge_may_be_stale(tmp_path: Path) -> None:
    value = graph()
    value["state"] = "STALE_REANALYSIS_REQUIRED"
    beat = heartbeat(value)
    beat["observed_repository_snapshot"] = snapshot(operation="merge", conflict_paths=["core/task-graph/README.md"])
    beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": "merge conflict"}]
    beat["reanalysis"] = {"status": "required", "trigger_ids": ["git-1"]}
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 1
    assert "BLOCKED" in result.stderr

    value["state"] = "BLOCKED"
    beat["observed_graph_state"] = "BLOCKED"
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 0, result.stderr

    value = graph()
    value["state"] = "STALE_REANALYSIS_REQUIRED"
    beat = heartbeat(value)
    beat["observed_repository_snapshot"] = snapshot(operation="merge")
    beat["triggers"] = [{"trigger_id": "git-1", "kind": "git-change", "evidence": "merge in progress"}]
    beat["reanalysis"] = {"status": "required", "trigger_ids": ["git-1"]}
    result = run_validator(tmp_path, value, beat)
    assert result.returncode == 0, result.stderr


def test_rejects_control_characters_but_accepts_unicode_repo_paths(tmp_path: Path) -> None:
    for path in ("docs/\u0001notes.md", "docs/\u007fnotes.md", "docs/\u0085notes.md"):
        value = graph()
        value["baseline"]["git_snapshot"]["untracked_paths"] = [path]
        result = run_validator(tmp_path, value, heartbeat(value))
        assert result.returncode == 1

    value = graph()
    value["baseline"]["git_snapshot"]["untracked_paths"] = ["docs/ação.md"]
    result = run_validator(tmp_path, value, heartbeat(value))
    assert result.returncode == 0, result.stderr


def test_rejects_internal_parent_symlink_in_dispatch_locator(tmp_path: Path) -> None:
    result = run_validator(tmp_path, graph(), heartbeat(graph()), internal_receipt_symlink=True)
    assert result.returncode == 1
    assert "symlink" in result.stderr
