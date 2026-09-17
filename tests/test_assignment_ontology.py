from __future__ import annotations

import json
import copy
import subprocess
import sys
from pathlib import Path

from jsonschema import Draft202012Validator


REPO = Path(__file__).resolve().parents[1]
SCHEMA = REPO / "assets/schemas/assignment-ontology.schema.json"
VALIDATOR = REPO / "scripts/validate-assignment-ontology.py"


def receipt(role: str = "tester") -> dict:
    result = {
        "schema_version": "1.0", "assignment_id": "a1", "logical_profile": "qa",
        "logical_agent": "qa", "runtime_instance": {"agent_id": "tester-1", "call_id": "call-1"},
        "authority_role": "verifier", "work_role": "verification", "verification_mode": "standard", "review_mode": "none", "write_mode": "read-only",
        "closure_authority": False, "approval_authority": False,
        "target": {"surfaces": ["backend"], "domain_path": ["financial", "gateway", "refund"], "seam_proof": []},
        "proof_lanes": ["backend-qa"],
        "proof": {"evidence": ["pytest tests/test_refund.py"], "negative_evidence": []},
        "review": {"candidate": None, "candidate_binding": None, "spec_binding": None, "target": None, "coverage": None, "independent": False, "isolation_reference": None},
    }
    if role == "reviewer":
        result.update({"logical_profile": "reviewer", "logical_agent": "reviewer", "runtime_instance": {"agent_id": "reviewer-1", "call_id": "call-review"}, "authority_role": "reviewer", "work_role": "review", "verification_mode": "not-applicable", "review_mode": "independent-adversarial", "write_mode": "read-only"})
        result["proof"]["negative_evidence"] = ["negative-path-review"]
        result["review"] = {
            "candidate": {"assignment_id": "candidate-a1", "logical_profile": "python-backend", "logical_agent": "python-backend", "runtime_instance": {"agent_id": "implementer-1", "call_id": "call-implement"}},
            "candidate_binding": {"locator": "candidate:a1@call-implement", "sha256": "a" * 64},
            "spec_binding": {"locator": "spec:CODEX-22#acceptance", "sha256": "b" * 64},
            "target": copy.deepcopy(result["target"]), "coverage": copy.deepcopy(result["target"]),
            "independent": True, "isolation_reference": "separate-call-and-agent-receipt",
        }
    return result


def run(candidate: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run([sys.executable, str(VALIDATOR), str(candidate)], cwd=REPO, text=True, capture_output=True, check=False)


def write(tmp_path: Path, value: dict, name: str = "receipt.json") -> Path:
    path = tmp_path / name
    path.write_text(json.dumps(value), encoding="utf-8")
    return path


def test_schema_is_closed_and_uses_draft_2020_12():
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    assert schema["$schema"] == "https://json-schema.org/draft/2020-12/schema"
    assert schema["additionalProperties"] is False
    assert set(schema["$defs"]["target"]["properties"]["surfaces"]["items"]["enum"]) == {"backend", "frontend", "integrations", "data", "runtime", "governance"}
    candidate = receipt()
    candidate["unknown"] = True
    assert any("Additional properties" in error.message for error in Draft202012Validator(schema).iter_errors(candidate))


def test_each_surface_has_an_accepted_proof_lane(tmp_path: Path):
    cases = {
        "backend": "backend-qa", "frontend": "frontend-qa", "integrations": "seam-proof",
        "data": "contract-proof", "runtime": "runtime-proof", "governance": "forensic-closure",
    }
    for surface, lane in cases.items():
        candidate = receipt()
        candidate["target"] = {"surfaces": [surface], "domain_path": ["domain", surface], "seam_proof": []}
        candidate["proof_lanes"] = [lane]
        result = run(write(tmp_path, candidate, f"{surface}.json"))
        assert result.returncode == 0, result.stderr


def test_adversarial_tester_is_a_positive_verifier_posture(tmp_path: Path):
    tester = receipt()
    tester["verification_mode"] = "adversarial"
    tester["proof"]["negative_evidence"] = ["negative-refund-path"]
    result = run(write(tmp_path, tester, "adversarial-tester.json"))
    assert result.returncode == 0, result.stderr


def test_duplicate_keys_unknown_values_and_verifier_authority_fail_closed(tmp_path: Path):
    duplicate = tmp_path / "duplicate.json"
    duplicate.write_text('{"schema_version":"1.0","schema_version":"1.0"}', encoding="utf-8")
    assert "duplicate key" in run(duplicate).stderr
    unknown = receipt()
    unknown["target"]["surfaces"] = ["mobile"]
    assert "schema violation" in run(write(tmp_path, unknown, "unknown.json")).stderr
    unknown_lane = receipt()
    unknown_lane["proof_lanes"] = ["unbounded-confidence"]
    assert "schema violation" in run(write(tmp_path, unknown_lane, "unknown-lane.json")).stderr
    authority = receipt()
    authority["closure_authority"] = True
    assert "only root may have approval or closure authority" in run(write(tmp_path, authority, "authority.json")).stderr


def test_multisurface_self_review_and_insufficient_coverage_fail_closed(tmp_path: Path):
    multi = receipt()
    multi["target"]["surfaces"] = ["backend", "integrations"]
    assert "multi-surface target requires seam_proof" in run(write(tmp_path, multi, "multi.json")).stderr
    self_review = receipt("reviewer")
    self_review["review"]["candidate"]["runtime_instance"]["agent_id"] = self_review["runtime_instance"]["agent_id"]
    assert "distinct runtime agent_id and call_id" in run(write(tmp_path, self_review, "self.json")).stderr
    same_assignment = receipt("reviewer")
    same_assignment["review"]["candidate"]["assignment_id"] = same_assignment["assignment_id"]
    assert "distinct candidate assignment_id" in run(write(tmp_path, same_assignment, "same-assignment.json")).stderr
    partial = receipt("reviewer")
    partial["review"]["target"]["surfaces"] = ["backend", "integrations"]
    partial["review"]["target"]["seam_proof"] = ["seam"]
    partial["target"] = copy.deepcopy(partial["review"]["target"])
    partial["proof_lanes"] = ["backend-qa", "seam-proof"]
    partial["review"]["coverage"]["surfaces"] = ["backend"]
    assert "coverage does not cover target surfaces" in run(write(tmp_path, partial, "partial.json")).stderr


def test_reviewer_authority_bindings_and_modes_fail_closed(tmp_path: Path):
    approval = receipt("reviewer")
    approval["approval_authority"] = True
    assert "only root may have approval or closure authority" in run(write(tmp_path, approval, "reviewer-approval.json")).stderr
    bindings = receipt("reviewer")
    bindings["review"]["candidate_binding"] = None
    assert "exact candidate/spec bindings" in run(write(tmp_path, bindings, "missing-candidate-binding.json")).stderr
    spec = receipt("reviewer")
    spec["review"]["spec_binding"] = None
    assert "exact candidate/spec bindings" in run(write(tmp_path, spec, "missing-spec-binding.json")).stderr
    malformed = receipt("reviewer")
    malformed["review"]["candidate_binding"]["sha256"] = "not-a-digest"
    assert "schema violation" in run(write(tmp_path, malformed, "malformed-binding.json")).stderr
    malformed_spec = receipt("reviewer")
    malformed_spec["review"]["spec_binding"]["sha256"] = "B" * 64
    assert "schema violation" in run(write(tmp_path, malformed_spec, "malformed-spec-binding.json")).stderr
    mode = receipt("reviewer")
    mode["review_mode"] = "self-review"
    assert "review_mode and authority_role combination is invalid" in run(write(tmp_path, mode, "misleading-mode.json")).stderr
    verifier = receipt()
    verifier["review_mode"] = "runtime-adversarial"
    assert "review_mode and authority_role combination is invalid" in run(write(tmp_path, verifier, "verifier-mode.json")).stderr
    executor = receipt()
    executor.update({"authority_role": "executor", "work_role": "implementation", "verification_mode": "adversarial", "write_mode": "bounded-write"})
    assert "only verifier may declare a verification_mode" in run(write(tmp_path, executor, "executor-verification.json")).stderr


def test_independent_review_target_write_and_negative_proof_invariants_fail_closed(tmp_path: Path):
    not_independent = receipt("reviewer")
    not_independent["review"]["independent"] = False
    assert "reviewer requires independent review" in run(write(tmp_path, not_independent, "not-independent.json")).stderr
    target_mismatch = receipt("reviewer")
    target_mismatch["review"]["target"]["domain_path"] = ["other", "domain"]
    assert "target must exactly equal" in run(write(tmp_path, target_mismatch, "target-mismatch.json")).stderr
    verifier_review = receipt()
    verifier_review["review"]["isolation_reference"] = "not-allowed"
    assert "verifier cannot satisfy review or independence" in run(write(tmp_path, verifier_review, "verifier-review.json")).stderr
    executor_review = receipt()
    executor_review.update({"authority_role": "executor", "work_role": "implementation", "verification_mode": "not-applicable", "write_mode": "bounded-write"})
    executor_review["review"]["isolation_reference"] = "not-allowed"
    assert "null review fields" in run(write(tmp_path, executor_review, "executor-review.json")).stderr
    root_review = receipt()
    root_review.update({"authority_role": "root", "work_role": "orchestration", "verification_mode": "not-applicable", "review_mode": "none", "write_mode": "root-only"})
    root_review["review"]["isolation_reference"] = "not-allowed"
    assert "null review fields" in run(write(tmp_path, root_review, "root-review.json")).stderr
    reviewer_write = receipt("reviewer")
    reviewer_write["write_mode"] = "bounded-write"
    assert "write_mode and authority_role" in run(write(tmp_path, reviewer_write, "reviewer-write.json")).stderr
    missing_negative = receipt()
    missing_negative["verification_mode"] = "adversarial"
    assert "requires negative_evidence" in run(write(tmp_path, missing_negative, "missing-negative.json")).stderr
    proof_mismatch = receipt()
    proof_mismatch["target"]["surfaces"] = ["frontend"]
    proof_mismatch["proof_lanes"] = ["backend-qa"]
    assert "surface frontend requires an applicable proof_lane" in run(write(tmp_path, proof_mismatch, "proof-mismatch.json")).stderr
