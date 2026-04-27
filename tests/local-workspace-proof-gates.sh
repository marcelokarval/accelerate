#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/local-workspace-proof-gates"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if ! printf '%s' "${haystack}" | grep -Fq "${needle}"; then
    fail "expected output to contain: ${needle}"
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  if printf '%s' "${haystack}" | grep -Fq "${needle}"; then
    fail "expected output not to contain: ${needle}"
  fi
}

set_yaml_scalar() {
  local file="$1"
  local key="$2"
  local value="$3"
  perl -0pi -e "s#^${key}:.*#${key}: ${value}#m" "${file}"
}

set_plan_field() {
  local file="$1"
  local key="$2"
  local value="$3"
  perl -0pi -e "s#^- ${key}:.*#- ${key}: ${value}#m" "${file}"
}

reset_repo() {
  local name="$1"
  local target="${WORK_ROOT}/${name}"
  rm -rf "${target}"
  mkdir -p "${target}"
  bash "${SCRIPTS}/emit-v2.sh" "${target}" greenfield >/dev/null
  set_yaml_scalar "${target}/.accelerate/onboarding/status.yaml" "status" "completed"
  set_yaml_scalar "${target}/.accelerate/state.yaml" "onboarding_status" "completed"
  set_plan_field "${target}/.accelerate/planning/current-plan.md" "smallest sufficient artifact" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${target}/.accelerate/planning/current-plan.md" "path" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${target}/.accelerate/planning/current-plan.md" "bounded objective" "prove evidence gates"
  bash "${SCRIPTS}/refresh-readiness.sh" "${target}" >/dev/null
  printf '%s\n' "${target}"
}

set_evidence() {
  local target="$1"
  local key="$2"
  local value="$3"
  set_yaml_scalar "${target}/.accelerate/status/evidence-registry.yaml" "${key}" "${value}"
}

set_artifact() {
  local target="$1"
  local key="$2"
  local value="$3"
  set_yaml_scalar "${target}/.accelerate/status/evidence-registry.yaml" "${key}_artifact" "${value}"
}

write_valid_browser_proof() {
  local target="$1"
  mkdir -p "${target}/.accelerate/proof" "${target}/.tmp/browser"
  printf '%s\n' "screenshot" > "${target}/.tmp/browser/dashboard.png"
  printf '%s\n' '{"level":"info","message":"no console errors observed"}' > "${target}/.tmp/browser/console.jsonl"
  printf '%s\n' '{"url":"/dashboard","status":200}' > "${target}/.tmp/browser/network.jsonl"
  cat > "${target}/.accelerate/proof/browser_proof.md" <<'MD'
Browser-Proof Packet

- surface / route family: /dashboard
- runtime target: http://localhost:3000/dashboard
- browser tool: Chrome DevTools
- intensity: targeted
- viewport coverage: desktop
- state coverage: default
- session/auth posture: seeded user
- console/runtime errors: none
- console evidence: .tmp/browser/console.jsonl
- network/server truth: 200 responses
- network evidence: .tmp/browser/network.jsonl
- backend/frontend state reconciliation: present
- screenshots/captures: .tmp/browser/dashboard.png
- defects registered: none
- residual route-family gaps: none
- readiness impact: supports-closure
MD
  set_artifact "${target}" "browser_proof" ".accelerate/proof/browser_proof.md"
}

write_valid_design_implementation_proof() {
  local target="$1"
  mkdir -p "${target}/.accelerate/proof"
  cat > "${target}/.accelerate/proof/design_implementation_proof.md" <<'MD'
Design Implementation Proof Packet

- target surface: /dashboard
- active branch: visual / artifact-driven frontend
- contract authority: docs/reference/design-system.contract.md
- source visual evidence: docs/reference/design-system.html
- premium authority: none
- rollout / task driver: .accelerate/planning/current-plan.md
- owner layer: page
- component mapping:
  - source-observed: dashboard card
  - code-available: page component
  - premium-proposed: none
  - not-approved-yet: none
- anatomy fixed: yes
- token changes allowed: no
- viewport coverage: desktop
- state coverage: default
- runtime adapter used: Chrome DevTools
- captures: .tmp/browser/dashboard.png
- artifact comparison result: aligned
- defects opened: none
- defects fixed / reproved: none
- residual drift: none
- promotion posture: promotable
MD
  set_artifact "${target}" "design_implementation_proof" ".accelerate/proof/design_implementation_proof.md"
}

seed_required_artifacts() {
  local target="$1"
  mkdir -p "${target}/.accelerate/proof"
  for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
    printf '%s\n' "${key}" > "${target}/.accelerate/proof/${key}.md"
    set_artifact "${target}" "${key}" ".accelerate/proof/${key}.md"
  done
  write_valid_browser_proof "${target}"
}

mkdir -p "${WORK_ROOT}"

review_target="$(reset_repo review-blocks-without-evidence)"
review_gate_output="${WORK_ROOT}/accelerate-review-gate.out"
if bash "${SCRIPTS}/reconcile-readiness.sh" "${review_target}" review-ready >"${review_gate_output}" 2>&1; then
  fail "review-ready reconciliation succeeded without evidence"
fi
assert_contains "$(cat "${review_gate_output}")" "evidence gate blocked review-ready"

ready_target="$(reset_repo review-succeeds-with-evidence)"
set_evidence "${ready_target}" "implementation_proof" "present"
set_evidence "${ready_target}" "qa_proof_lane" "present"
seed_required_artifacts "${ready_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${ready_target}" review-ready >/dev/null
assert_contains "$(grep '^review_readiness:' "${ready_target}/.accelerate/status/readiness-dashboard.yaml")" "review_readiness: ready"

closure_target="$(reset_repo closure-blocks-without-ai-review)"
set_evidence "${closure_target}" "implementation_proof" "present"
set_evidence "${closure_target}" "qa_proof_lane" "present"
set_evidence "${closure_target}" "backend_qa" "present"
set_evidence "${closure_target}" "frontend_qa" "not-applicable"
set_evidence "${closure_target}" "browser_proof" "present"
set_evidence "${closure_target}" "requested_vs_implemented" "present"
seed_required_artifacts "${closure_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${closure_target}" review-ready >/dev/null
closure_gate_output="${WORK_ROOT}/accelerate-closure-gate.out"
if bash "${SCRIPTS}/reconcile-readiness.sh" "${closure_target}" closure-ready >"${closure_gate_output}" 2>&1; then
  fail "closure-ready reconciliation succeeded without ai_review evidence"
fi
assert_contains "$(cat "${closure_gate_output}")" "evidence gate blocked closure-ready"

lane_target="$(reset_repo closure-blocks-without-browser-proof)"
set_evidence "${lane_target}" "implementation_proof" "present"
set_evidence "${lane_target}" "qa_proof_lane" "present"
set_evidence "${lane_target}" "backend_qa" "present"
set_evidence "${lane_target}" "frontend_qa" "not-applicable"
set_evidence "${lane_target}" "requested_vs_implemented" "present"
set_evidence "${lane_target}" "ai_review" "present"
seed_required_artifacts "${lane_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${lane_target}" review-ready >/dev/null
lane_gate_output="${WORK_ROOT}/accelerate-lane-gate.out"
if bash "${SCRIPTS}/reconcile-readiness.sh" "${lane_target}" closure-ready >"${lane_gate_output}" 2>&1; then
  fail "closure-ready reconciliation succeeded without browser proof"
fi
assert_contains "$(cat "${lane_gate_output}")" "evidence gate blocked closure-ready"

lane_packet_output="$(bash "${SCRIPTS}/render-closure-packet.sh" "${lane_target}")"
assert_contains "${lane_packet_output}" "Browser-Proof=missing"
assert_contains "${lane_packet_output}" "blocking lane: browser_proof"
assert_not_contains "${lane_packet_output}" "recommendation: done"

prepare_target="$(reset_repo prepare-closure-renders-ai-review-before-final-gate)"
set_evidence "${prepare_target}" "implementation_proof" "present"
set_evidence "${prepare_target}" "qa_proof_lane" "present"
set_evidence "${prepare_target}" "backend_qa" "present"
set_evidence "${prepare_target}" "frontend_qa" "not-applicable"
set_evidence "${prepare_target}" "browser_proof" "present"
set_evidence "${prepare_target}" "requested_vs_implemented" "present"
seed_required_artifacts "${prepare_target}"
set_evidence "${prepare_target}" "ai_review" "missing"
set_artifact "${prepare_target}" "ai_review" ""
bash "${SCRIPTS}/reconcile-readiness.sh" "${prepare_target}" review-ready >/dev/null
if bash "${SCRIPTS}/prepare-closure.sh" "${prepare_target}" >"${WORK_ROOT}/prepare-closure-ai.out" 2>&1; then
  fail "prepare-closure self-certified ai_review and reached closure-ready"
fi
assert_contains "$(cat "${WORK_ROOT}/prepare-closure-ai.out")" "evidence gate blocked closure-ready"
assert_contains "$(grep '^closure_readiness:' "${prepare_target}/.accelerate/status/readiness-dashboard.yaml")" "closure_readiness: blocked"
assert_contains "$(grep '^ai_review_rendered:' "${prepare_target}/.accelerate/status/evidence-registry.yaml")" "ai_review_rendered: present"
assert_contains "$(grep '^ai_review:' "${prepare_target}/.accelerate/status/evidence-registry.yaml")" "ai_review: missing"

artifact_target="$(reset_repo closure-blocks-present-without-artifacts)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${artifact_target}" "${key}" "present"
done
set_evidence "${artifact_target}" "frontend_qa" "not-applicable"
set_evidence "${artifact_target}" "persistent_e2e" "not-applicable"
mkdir -p "${artifact_target}/.accelerate/proof"
for key in implementation_proof qa_proof_lane; do
  printf '%s\n' "${key}" > "${artifact_target}/.accelerate/proof/${key}.md"
  set_artifact "${artifact_target}" "${key}" ".accelerate/proof/${key}.md"
done
bash "${SCRIPTS}/reconcile-readiness.sh" "${artifact_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${artifact_target}" closure-ready >"${WORK_ROOT}/artifact-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with present statuses but empty artifacts"
fi
assert_contains "$(cat "${WORK_ROOT}/artifact-gate.out")" "artifact gate blocked"

junk_browser_target="$(reset_repo closure-blocks-junk-browser-proof-artifact)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${junk_browser_target}" "${key}" "present"
done
set_evidence "${junk_browser_target}" "frontend_qa" "not-applicable"
set_evidence "${junk_browser_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${junk_browser_target}"
printf '%s\n' "browser proof" > "${junk_browser_target}/.accelerate/proof/browser_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${junk_browser_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${junk_browser_target}" closure-ready >"${WORK_ROOT}/junk-browser-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with junk browser proof artifact"
fi
assert_contains "$(cat "${WORK_ROOT}/junk-browser-gate.out")" "artifact gate blocked: browser_proof_artifact missing required marker: Browser-Proof Packet"

partial_browser_target="$(reset_repo closure-blocks-partial-browser-proof-artifact)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${partial_browser_target}" "${key}" "present"
done
set_evidence "${partial_browser_target}" "frontend_qa" "not-applicable"
set_evidence "${partial_browser_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${partial_browser_target}"
cat > "${partial_browser_target}/.accelerate/proof/browser_proof.md" <<'MD'
Browser-Proof Packet

- surface / route family: /dashboard
MD
bash "${SCRIPTS}/reconcile-readiness.sh" "${partial_browser_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${partial_browser_target}" closure-ready >"${WORK_ROOT}/partial-browser-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with partial browser proof artifact"
fi
assert_contains "$(cat "${WORK_ROOT}/partial-browser-gate.out")" "artifact gate blocked: browser_proof_artifact missing required marker: - runtime target:"

missing_capture_target="$(reset_repo closure-blocks-missing-browser-capture)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${missing_capture_target}" "${key}" "present"
done
set_evidence "${missing_capture_target}" "frontend_qa" "not-applicable"
set_evidence "${missing_capture_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${missing_capture_target}"
perl -0pi -e 's#\.tmp/browser/dashboard\.png#.tmp/browser/missing.png#g' "${missing_capture_target}/.accelerate/proof/browser_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_capture_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_capture_target}" closure-ready >"${WORK_ROOT}/missing-capture-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with missing browser capture"
fi
assert_contains "$(cat "${WORK_ROOT}/missing-capture-gate.out")" "artifact gate blocked: browser_proof_artifact capture path does not exist: .tmp/browser/missing.png"

outside_capture_target="$(reset_repo closure-blocks-browser-capture-outside-project-tmp)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${outside_capture_target}" "${key}" "present"
done
set_evidence "${outside_capture_target}" "frontend_qa" "not-applicable"
set_evidence "${outside_capture_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${outside_capture_target}"
mkdir -p "${outside_capture_target}/screenshots"
printf '%s\n' "screenshot" > "${outside_capture_target}/screenshots/dashboard.png"
perl -0pi -e 's#\.tmp/browser/dashboard\.png#screenshots/dashboard.png#g' "${outside_capture_target}/.accelerate/proof/browser_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${outside_capture_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${outside_capture_target}" closure-ready >"${WORK_ROOT}/outside-capture-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with browser capture outside project .tmp"
fi
assert_contains "$(cat "${WORK_ROOT}/outside-capture-gate.out")" "artifact gate blocked: browser_proof_artifact capture path must be under project .tmp/: screenshots/dashboard.png"

missing_console_evidence_target="$(reset_repo closure-blocks-missing-console-evidence)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${missing_console_evidence_target}" "${key}" "present"
done
set_evidence "${missing_console_evidence_target}" "frontend_qa" "not-applicable"
set_evidence "${missing_console_evidence_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${missing_console_evidence_target}"
perl -0pi -e 's#\.tmp/browser/console\.jsonl#.tmp/browser/missing-console.jsonl#g' "${missing_console_evidence_target}/.accelerate/proof/browser_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_console_evidence_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_console_evidence_target}" closure-ready >"${WORK_ROOT}/missing-console-evidence-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with missing console evidence"
fi
assert_contains "$(cat "${WORK_ROOT}/missing-console-evidence-gate.out")" "artifact gate blocked: browser_proof_artifact capture path does not exist: .tmp/browser/missing-console.jsonl"

missing_network_evidence_target="$(reset_repo closure-blocks-missing-network-evidence)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${missing_network_evidence_target}" "${key}" "present"
done
set_evidence "${missing_network_evidence_target}" "frontend_qa" "not-applicable"
set_evidence "${missing_network_evidence_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${missing_network_evidence_target}"
perl -0pi -e 's#\.tmp/browser/network\.jsonl#.tmp/browser/missing-network.jsonl#g' "${missing_network_evidence_target}/.accelerate/proof/browser_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_network_evidence_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_network_evidence_target}" closure-ready >"${WORK_ROOT}/missing-network-evidence-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with missing network evidence"
fi
assert_contains "$(cat "${WORK_ROOT}/missing-network-evidence-gate.out")" "artifact gate blocked: browser_proof_artifact capture path does not exist: .tmp/browser/missing-network.jsonl"

junk_design_target="$(reset_repo closure-blocks-junk-design-proof-artifact)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review design_implementation_proof; do
  set_evidence "${junk_design_target}" "${key}" "present"
done
set_evidence "${junk_design_target}" "frontend_qa" "not-applicable"
set_evidence "${junk_design_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${junk_design_target}"
mkdir -p "${junk_design_target}/.accelerate/proof"
printf '%s\n' "design proof" > "${junk_design_target}/.accelerate/proof/design_implementation_proof.md"
set_artifact "${junk_design_target}" "design_implementation_proof" ".accelerate/proof/design_implementation_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${junk_design_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${junk_design_target}" closure-ready >"${WORK_ROOT}/junk-design-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with junk design implementation proof artifact"
fi
assert_contains "$(cat "${WORK_ROOT}/junk-design-gate.out")" "artifact gate blocked: design_implementation_proof_artifact missing required marker: Design Implementation Proof Packet"

missing_design_capture_target="$(reset_repo closure-blocks-missing-design-capture)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review design_implementation_proof; do
  set_evidence "${missing_design_capture_target}" "${key}" "present"
done
set_evidence "${missing_design_capture_target}" "frontend_qa" "not-applicable"
set_evidence "${missing_design_capture_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${missing_design_capture_target}"
write_valid_design_implementation_proof "${missing_design_capture_target}"
perl -0pi -e 's#\.tmp/browser/dashboard\.png#.tmp/browser/missing-design.png#g' "${missing_design_capture_target}/.accelerate/proof/design_implementation_proof.md"
bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_design_capture_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${missing_design_capture_target}" closure-ready >"${WORK_ROOT}/missing-design-capture-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with missing design proof capture"
fi
assert_contains "$(cat "${WORK_ROOT}/missing-design-capture-gate.out")" "artifact gate blocked: design_implementation_proof_artifact capture path does not exist: .tmp/browser/missing-design.png"

design_without_browser_target="$(reset_repo closure-blocks-design-proof-without-browser-proof)"
for key in implementation_proof qa_proof_lane backend_qa requested_vs_implemented ai_review design_implementation_proof; do
  set_evidence "${design_without_browser_target}" "${key}" "present"
done
set_evidence "${design_without_browser_target}" "frontend_qa" "not-applicable"
set_evidence "${design_without_browser_target}" "browser_proof" "not-applicable"
set_evidence "${design_without_browser_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${design_without_browser_target}"
write_valid_design_implementation_proof "${design_without_browser_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${design_without_browser_target}" review-ready >/dev/null
if bash "${SCRIPTS}/reconcile-readiness.sh" "${design_without_browser_target}" closure-ready >"${WORK_ROOT}/design-without-browser-gate.out" 2>&1; then
  fail "closure-ready reconciliation succeeded with design proof but no browser proof"
fi
assert_contains "$(cat "${WORK_ROOT}/design-without-browser-gate.out")" "evidence gate blocked closure-ready: design_implementation_proof requires browser_proof present"

valid_design_target="$(reset_repo closure-accepts-valid-browser-and-design-proof-packets)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review design_implementation_proof; do
  set_evidence "${valid_design_target}" "${key}" "present"
done
set_evidence "${valid_design_target}" "frontend_qa" "not-applicable"
set_evidence "${valid_design_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${valid_design_target}"
write_valid_design_implementation_proof "${valid_design_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${valid_design_target}" review-ready >/dev/null
bash "${SCRIPTS}/reconcile-readiness.sh" "${valid_design_target}" closure-ready >/dev/null
assert_contains "$(grep '^closure_readiness:' "${valid_design_target}/.accelerate/status/readiness-dashboard.yaml")" "closure_readiness: ready"

stale_target="$(reset_repo stale-readiness-downgrades-after-evidence-regression)"
for key in implementation_proof qa_proof_lane backend_qa browser_proof requested_vs_implemented ai_review; do
  set_evidence "${stale_target}" "${key}" "present"
done
set_evidence "${stale_target}" "frontend_qa" "not-applicable"
set_evidence "${stale_target}" "persistent_e2e" "not-applicable"
seed_required_artifacts "${stale_target}"
bash "${SCRIPTS}/reconcile-readiness.sh" "${stale_target}" review-ready >/dev/null
bash "${SCRIPTS}/reconcile-readiness.sh" "${stale_target}" closure-ready >/dev/null
set_evidence "${stale_target}" "browser_proof" "missing"
bash "${SCRIPTS}/refresh-readiness.sh" "${stale_target}" >/dev/null
assert_contains "$(grep '^closure_readiness:' "${stale_target}/.accelerate/status/readiness-dashboard.yaml")" "closure_readiness: blocked"
assert_contains "$(grep '^dashboard_verdict:' "${stale_target}/.accelerate/status/readiness-dashboard.yaml")" "dashboard_verdict: ready-for-review"

packet_target="$(reset_repo closure-packet-uses-evidence)"
set_yaml_scalar "${packet_target}/.accelerate/status/readiness-dashboard.yaml" "review_readiness" "ready"
packet_output="$(bash "${SCRIPTS}/render-closure-packet.sh" "${packet_target}")"
assert_contains "${packet_output}" "Backend QA=missing"
assert_contains "${packet_output}" "Browser-Proof=missing"
assert_contains "${packet_output}" "Design Implementation Proof=not-applicable"
assert_not_contains "${packet_output}" "blocking lane: none"

entry_target="$(reset_repo blocked-branch-not-trivial)"
entry_output="$(bash "${SCRIPTS}/render-branch-entry-packet.sh" "${entry_target}")"
assert_not_contains "${entry_output}" "classification: trivial bounded engineering work"
assert_contains "${entry_output}" "classification: orchestrated non-trivial work"

workflow_target="$(reset_repo workflow-detected-not-enforced)"
mkdir -p "${workflow_target}/.github"
bash "${SCRIPTS}/detect-signals.sh" "${workflow_target}" >/dev/null
bash "${SCRIPTS}/classify-project.sh" "${workflow_target}" >/dev/null
assert_contains "$(grep '^workflow_backend:' "${workflow_target}/.accelerate/state.yaml")" "workflow_backend: none-yet"
assert_contains "$(grep '^workflow_backend_detected:' "${workflow_target}/.accelerate/state.yaml")" "workflow_backend_detected: github"

echo "local workspace proof gate tests passed"
