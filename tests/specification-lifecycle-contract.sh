#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

failures=0
tmp_dir="$(mktemp -d)"
symlink_sdd_locator="planning/architecture/.spec-lifecycle-symlink-$$.md"
symlink_test_locator="tests/.spec-lifecycle-symlink-$$.sh"
symlink_proof_locator="planning/evidence/dated-proof-appendix/.spec-lifecycle-symlink-$$.md"
cleanup() {
  for path in "$symlink_sdd_locator" "$symlink_test_locator" "$symlink_proof_locator"; do
    if [ -L "$path" ]; then
      unlink "$path"
    fi
  done
  rm -rf "$tmp_dir"
}
trap cleanup EXIT
cp planning/architecture/2026-08-12-quality-engineering-stack-sdd.md \
  "$tmp_dir/external-sdd.md"
cp tests/specification-lifecycle-contract.sh "$tmp_dir/external-test.sh"
cp planning/evidence/dated-proof-appendix/quality-stack-case-red-receipt-2026-08-12.md \
  "$tmp_dir/external-proof.md"
ln -s "$tmp_dir/external-sdd.md" "$symlink_sdd_locator"
ln -s "$tmp_dir/external-test.sh" "$symlink_test_locator"
ln -s "$tmp_dir/external-proof.md" "$symlink_proof_locator"

run_case() {
  local id="$1"
  local label="$2"
  shift 2
  local output="$tmp_dir/${id}.out"
  if "$@" >"$output" 2>&1; then
    printf 'PASS %s %s\n' "$id" "$label"
  else
    printf 'RED  %s %s\n' "$id" "$label" >&2
    sed 's/^/     /' "$output" >&2
    failures=$((failures + 1))
  fi
}

need_file() {
  [ -f "$1" ] || { printf 'missing %s\n' "$1" >&2; return 1; }
}

need_pattern() {
  local pattern="$1"
  local path="$2"
  need_file "$path" || return 1
  rg -n "$pattern" "$path" >/dev/null || {
    printf 'missing pattern %s in %s\n' "$pattern" "$path" >&2
    return 1
  }
}

validator="scripts/validate-engineering-artifact-manifest.py"
template="planning/specification/engineering-artifact-manifest-template.json"

python3 - "$tmp_dir" "$symlink_sdd_locator" "$symlink_test_locator" "$symlink_proof_locator" <<'PY'
import copy
import json
import sys
from pathlib import Path

target = Path(sys.argv[1])
symlink_sdd_locator, symlink_test_locator, symlink_proof_locator = sys.argv[2:]
base = {
    "schema_version": 1,
    "mutation": True,
    "change_kind": "governance",
    "classification": {"triggers": ["cross-control-plane"], "selected_mode": "hierarchical", "override": None},
    "sdd": {"id": "SDD-CODEX-QUALITY-001", "mode": "hierarchical", "status": "accepted", "locator": "planning/architecture/2026-08-12-quality-engineering-stack-sdd.md", "children": [{"id": "SDD-FIXTURE-CHILD", "disposition": "included", "reason": "child contract is included by the live root SDD"}]},
    "dispositions": {
        "adr": {"status": "separate", "reason": "durable cross-surface decision", "locator": "planning/architecture/2026-08-12-quality-engineering-stack-adr.md"},
        "design": {"status": "not-applicable", "reason": "no product UI is in scope"},
        "test_design": {"status": "separate", "reason": "semantic validator with negative fixtures", "locator": "planning/testing/2026-08-12-quality-engineering-stack-test-design.md"},
        "agents": {"status": "consolidated", "reason": "bounded plan"},
        "rollout": {"status": "consolidated", "reason": "source first"},
        "rollback": {"status": "consolidated", "reason": "revert bounded slice"},
        "observability": {"status": "consolidated", "reason": "diagnostics and receipts"},
        "agents_docs": {"status": "required", "reason": "root entry contract changes"},
    },
    "tasks": [{"id": "T1"}],
    "requirements": [{
        "id": "REQ-SPEC-001",
        "task": "T1",
        "test": {"case_id": "CASE-SPEC-001", "locator": "tests/specification-lifecycle-contract.sh"},
        "proof": {"status": "observed-red", "locator": "planning/evidence/dated-proof-appendix/quality-stack-case-red-receipt-2026-08-12.md#case-results"},
    }],
    "test_design": {
        "id": "TEST-DESIGN-CODEX-QUALITY-001",
        "status": "accepted",
        "owner": "test-engineering-lane",
        "independent_reviewer": "quality_spec_review",
        "accepted_by": "accelerate-root",
        "locator": "planning/testing/2026-08-12-quality-engineering-stack-test-design.md",
        "dimensions": {key: {"status": "covered", "reason": "covered by disposable fixture"} for key in (
            "happy", "negative", "boundary", "ownership", "concurrency_idempotency",
            "failure_recovery", "fixtures", "observability", "lowest_effective_level"
        )},
    },
    "tdd_receipt": {
        "id": "TDD-RECEIPT-CODEX-QUALITY-001",
        "locator": "planning/testing/2026-08-12-quality-engineering-stack-tdd-receipt.md",
        "state": "reviewed",
        "mode": "semantic-contract",
        "baseline": {"status": "observed-red", "locator": "planning/evidence/dated-proof-appendix/quality-stack-case-red-receipt-2026-08-12.md#receipt"},
        "implementation_owner": "accelerate-root",
        "test_writer": "quality-red-test-writer",
        "independent_reviewer": "quality-stack-final-review",
        "correction_evidence": {"status": "observed-green", "locator": "planning/evidence/dated-proof-appendix/quality-stack-post-restart-runtime-proof-2026-08-13.md#fresh-runtime-green"},
        "proof_order": {"implementation": "observed", "qa": "observed", "browser_truth": "not-applicable", "persistent_regression": "not-applicable", "forensic_review": "observed"},
        "independent_review_verdict": "pass",
        "correction_generation": 5,
        "proof_generation": 5,
    },
}

def write(name, mutate=lambda value: None):
    value = copy.deepcopy(base)
    mutate(value)
    (target / f"{name}.json").write_text(json.dumps(value))

write("valid")
write("mode-none", lambda v: v["sdd"].update(mode="none"))
write("underclassified-auth", lambda v: (v["classification"].update(triggers=["auth"], selected_mode="standard"), v["sdd"].update(mode="standard")))
write("draft-authority", lambda v: v["sdd"].update(status="draft"))
write("missing-disposition", lambda v: v["dispositions"].pop("test_design"))
write("missing-task", lambda v: v["requirements"][0].update(task=""))
write("missing-test", lambda v: v["requirements"][0].pop("test"))
write("planned-proof", lambda v: v["requirements"][0]["proof"].update(status="planned"))
write("blocked-proof", lambda v: v["requirements"][0]["proof"].update(status="blocked"))
write("missing-dimension", lambda v: v["test_design"]["dimensions"].pop("ownership"))
write("wrong-tdd-mode", lambda v: (v.update(change_kind="feature"), v["tdd_receipt"].update(mode="semantic-contract")))
write("stale-proof", lambda v: v["tdd_receipt"].update(correction_generation=5, proof_generation=4))
write("proof-ahead", lambda v: v["tdd_receipt"].update(correction_generation=4, proof_generation=5))
write("missing-tdd-authority", lambda v: (v["tdd_receipt"].pop("id"), v["tdd_receipt"].pop("locator")))
write("closure-zero", lambda v: (v["requirements"][0]["proof"].update(status="observed-green"), v["tdd_receipt"].update(correction_generation=0, proof_generation=0)))
write("closure-blocked-baseline", lambda v: (v["requirements"][0]["proof"].update(status="observed-green"), v["tdd_receipt"]["baseline"].update(status="blocked")))
write("feature-wrong-baseline", lambda v: (v.update(change_kind="feature"), v["tdd_receipt"].update(mode="red-green-refactor"), v["tdd_receipt"]["baseline"].update(status="observed-contract")))
write("documented-external-provider", lambda v: (v.update(change_kind="external-provider"), v["tdd_receipt"].update(mode="provider-contract"), v["tdd_receipt"]["baseline"].update(status="observed-contract")))
write("documented-hybrid", lambda v: (v.update(change_kind="hybrid"), v["tdd_receipt"].update(mode="hybrid", constituent_modes=["semantic-contract", "provider-contract"]), v["tdd_receipt"]["baseline"].update(status="observed-contract")))
write("hybrid-missing-constituents", lambda v: (v.update(change_kind="hybrid"), v["tdd_receipt"].update(mode="hybrid"), v["tdd_receipt"]["baseline"].update(status="observed-contract")))
write("test-design-draft", lambda v: v["test_design"].update(status="draft"))
write("test-design-self-accepted", lambda v: v["test_design"].update(owner="accelerate-root"))
write("test-design-arbitrary-acceptor", lambda v: v["test_design"].update(accepted_by="random-reviewer"))
write("unknown-task-reference", lambda v: v["requirements"][0].update(task="T404"))
write("nonexistent-locator", lambda v: v["sdd"].update(locator="planning/does-not-exist.md"))
write("symlink-sdd-locator", lambda v: v["sdd"].update(locator=symlink_sdd_locator))
write("symlink-test-locator", lambda v: v["requirements"][0]["test"].update(locator=symlink_test_locator))
write("symlink-proof-locator", lambda v: v["requirements"][0]["proof"].update(locator=f"{symlink_proof_locator}#case-results"))
write("nonexistent-anchor", lambda v: v["requirements"][0]["proof"].update(locator="planning/evidence/dated-proof-appendix/quality-stack-case-red-receipt-2026-08-12.md#does-not-exist"))
write("swapped-sdd-locator", lambda v: v["sdd"].update(locator="tests/specification-lifecycle-contract.sh"))
write("sdd-content-mismatch", lambda v: v["sdd"].update(locator="planning/architecture/2026-08-12-quality-engineering-agent-communication.md"))
write("template-as-live-sdd", lambda v: v["sdd"].update(locator="planning/architecture/sdd-template.md"))
write("mismatched-test-design-locators", lambda v: v["dispositions"]["test_design"].update(locator="planning/testing/test-design-template.md"))
write("test-design-content-mismatch", lambda v: (v["dispositions"]["test_design"].update(locator="planning/testing/2026-08-12-quality-engineering-stack-tdd-receipt.md"), v["test_design"].update(locator="planning/testing/2026-08-12-quality-engineering-stack-tdd-receipt.md")))
write("test-design-owner-content-mismatch", lambda v: v["test_design"].update(owner="different-owner"))
write("green-labelled-red-receipt", lambda v: v["requirements"][0]["proof"].update(status="observed-green"))
write("fake-case-id", lambda v: v["requirements"][0]["test"].update(case_id="CASE-NOT-IN-TEST-FILE"))
write("cross-scope-green-proof", lambda v: v["requirements"][0].update(id="REQ-REV-001", test={"case_id": "CASE-REV-001", "locator": "tests/quality-skill-contract.sh"}, proof={"status": "observed-green", "locator": "planning/evidence/dated-proof-appendix/quality-stack-t2-t3-green-receipt-2026-08-12.md#focused-proof"}))
write("proof-order-content-mismatch", lambda v: v["tdd_receipt"]["proof_order"].update(qa="pending"))
write("receipt-mode-content-mismatch", lambda v: (v.update(change_kind="security"), v["tdd_receipt"].update(mode="security-contract")))
write("generic-reason", lambda v: v["dispositions"]["design"].update(reason="not needed"))
write("upward-override-not-applied", lambda v: v["classification"].update(override={"reason": "higher caution", "approved_by": "root", "requested_mode": "critical"}))
for trigger in (
    "pii", "destructive", "provider-write", "irreversible-migration", "safety-critical",
    "cross-domain", "architecture-boundary", "multi-runtime-migration",
    "externally-visible-behavior", "bug", "refactor-risk", "new-specialist-capability",
):
    write(f"underclassified-{trigger}", lambda v, trigger=trigger: (v["classification"].update(triggers=[trigger], selected_mode="micro"), v["sdd"].update(mode="micro", spec_capsule={"intent": "x", "scope": "x", "acceptance": "x", "proof": "x"})))
write("structural-ui-underclassified", lambda v: (v["classification"].update(triggers=["structural-ui"], selected_mode="micro"), v["sdd"].update(mode="micro", spec_capsule={"intent": "x", "scope": "x", "acceptance": "x", "proof": "x"}), v["dispositions"]["design"].update(status="separate", locator="planning/design/design-disposition-template.md")))
PY

validator_accepts() {
  need_file "$validator" || return 1
  need_file "$template" || return 1
  python3 "$validator" "$tmp_dir/valid.json" --stage implementation
}

natural_noop_accepts() {
  need_file "$validator" || return 1
  cat >"$tmp_dir/noop.json" <<'JSON'
{"schema_version":1,"mutation":false,"change_kind":"read-only","classification":{"triggers":["read-only"],"selected_mode":"none","override":null},"outcome":"read-only analysis"}
JSON
  python3 "$validator" "$tmp_dir/noop.json" --stage implementation
}

validator_rejects() {
  local fixture="$1"
  need_file "$validator" || return 1
  if python3 "$validator" "$tmp_dir/$fixture.json" --stage implementation; then
    printf 'validator accepted invalid fixture %s\n' "$fixture" >&2
    return 1
  fi
}

validator_accepts_fixture() {
  local fixture="$1"
  local stage="${2:-implementation}"
  need_file "$validator" || return 1
  python3 "$validator" "$tmp_dir/$fixture.json" --stage "$stage"
}

case_spec_001() {
  validator_rejects mode-none || return 1
  need_pattern 'mutation.*mode.*none|mode.*none.*mutation' core/control-plane/sdd-mode-gate.md || return 1
  need_pattern 'direct-fast-path.*Issue Bootstrap.*Spec Capsule.*Manifest|Issue Bootstrap.*Spec Capsule.*Manifest.*direct root execution' core/control-plane/quick-invocation-map.md || return 1
}

case_spec_002() {
  validator_accepts || return 1
  validator_rejects underclassified-auth || return 1
  for fixture in "$tmp_dir"/underclassified-*.json "$tmp_dir/structural-ui-underclassified.json"; do
    validator_rejects "$(basename "$fixture" .json)" || return 1
  done
  validator_rejects upward-override-not-applied || return 1
  natural_noop_accepts || return 1
  need_pattern 'micro.*standard.*hierarchical.*critical' core/control-plane/sdd-mode-gate.md || return 1
  need_pattern 'under-classification|underclassification' core/control-plane/sdd-mode-gate.md || return 1
}

case_spec_003() { validator_rejects draft-authority; }

case_spec_004() {
  validator_rejects missing-disposition || return 1
  validator_rejects generic-reason || return 1
  validator_rejects nonexistent-locator || return 1
  validator_rejects symlink-sdd-locator || return 1
  validator_rejects symlink-test-locator || return 1
  validator_rejects symlink-proof-locator || return 1
  validator_rejects nonexistent-anchor || return 1
  validator_rejects swapped-sdd-locator || return 1
  validator_rejects sdd-content-mismatch || return 1
  validator_rejects template-as-live-sdd || return 1
  validator_rejects mismatched-test-design-locators || return 1
  validator_rejects test-design-content-mismatch || return 1
  validator_rejects test-design-owner-content-mismatch || return 1
  need_file planning/specification/2026-08-12-quality-engineering-stack-manifest.json || return 1
  python3 "$validator" planning/specification/2026-08-12-quality-engineering-stack-manifest.json --stage implementation || return 1
  for path in \
    planning/specification/spec-capsule-template.md \
    planning/architecture/delta-sdd-template.md \
    planning/architecture/adr-template.md \
    planning/design/design-disposition-template.md; do
    need_file "$path" || return 1
  done
}

case_spec_005() {
  for marker in 'Specification Lifecycle' 'Software Design Document' 'Source Verification' 'TEST-DESIGN.md' 'TDD Receipt'; do
    need_pattern "$marker" references/specification-layer.md || return 1
  done
  if rg -n 'SDD[^\n]*(Spec Driven|Source Driven)' references/specification-layer.md >/dev/null; then
    printf 'SDD remains an ambiguous lifecycle/source alias\n' >&2
    return 1
  fi
}

case_trace_001() {
  validator_rejects missing-task || return 1
  validator_rejects missing-test || return 1
  validator_rejects unknown-task-reference || return 1
  validator_rejects fake-case-id || return 1
  validator_rejects cross-scope-green-proof || return 1
  need_file planning/specification/traceability-template.md || return 1
}

case_trace_002() {
  validator_rejects planned-proof || return 1
  validator_rejects blocked-proof || return 1
  validator_rejects green-labelled-red-receipt || return 1
}

case_test_001() {
  validator_rejects missing-dimension || return 1
  validator_rejects test-design-draft || return 1
  validator_rejects test-design-self-accepted || return 1
  validator_rejects test-design-arbitrary-acceptor || return 1
  need_file planning/testing/test-design-template.md || return 1
}

case_test_002() {
  validator_rejects wrong-tdd-mode || return 1
  validator_rejects feature-wrong-baseline || return 1
  validator_accepts_fixture documented-external-provider plan || return 1
  validator_accepts_fixture documented-hybrid plan || return 1
  validator_rejects hybrid-missing-constituents || return 1
  validator_rejects receipt-mode-content-mismatch || return 1
  need_file planning/testing/tdd-receipt-template.md || return 1
  need_pattern 'feature.*[Rr]ed.*[Gg]reen.*[Rr]efactor' core/control-plane/tdd-entry-gate.md || return 1
  need_pattern 'bug.*repro|refactor.*characterization|docs.*semantic' core/control-plane/tdd-entry-gate.md || return 1
}

case_test_003() {
  validator_rejects missing-tdd-authority || return 1
  validator_rejects stale-proof || return 1
  validator_rejects proof-ahead || return 1
  validator_rejects proof-order-content-mismatch || return 1
  need_file "$validator" || return 1
  if python3 "$validator" "$tmp_dir/closure-zero.json" --stage closure; then
    printf 'validator accepted zero-generation closure\n' >&2
    return 1
  fi
  if python3 "$validator" "$tmp_dir/closure-blocked-baseline.json" --stage closure; then
    printf 'validator accepted blocked baseline at closure\n' >&2
    return 1
  fi
  need_pattern 'stale.*proof|correction.*reproof' core/control-plane/tdd-entry-gate.md || return 1
}

run_case CASE-SPEC-001 'mutation cannot use SDD mode none' case_spec_001
run_case CASE-SPEC-002 'mode selection is deterministic and fails underclassification' case_spec_002
run_case CASE-SPEC-003 'draft design cannot authorize implementation' case_spec_003
run_case CASE-SPEC-004 'all artifact dispositions are explicit' case_spec_004
run_case CASE-SPEC-005 'specification terminology is unambiguous' case_spec_005
run_case CASE-TRACE-001 'requirements map to task and test or exception' case_trace_001
run_case CASE-TRACE-002 'planned proof cannot masquerade as observed' case_trace_002
run_case CASE-TEST-001 'test design covers every required dimension' case_test_001
run_case CASE-TEST-002 'TDD mode matches the change kind' case_test_002
run_case CASE-TEST-003 'correction invalidates stale proof' case_test_003

if [ "$failures" -ne 0 ]; then
  printf 'specification lifecycle contract: %s case(s) failed\n' "$failures" >&2
  exit 1
fi

printf 'specification lifecycle contract passed (10 cases)\n'
