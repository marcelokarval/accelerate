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
bash "${SCRIPTS}/reconcile-readiness.sh" "${ready_target}" review-ready >/dev/null
assert_contains "$(grep '^review_readiness:' "${ready_target}/.accelerate/status/readiness-dashboard.yaml")" "review_readiness: ready"

closure_target="$(reset_repo closure-blocks-without-ai-review)"
set_evidence "${closure_target}" "implementation_proof" "present"
set_evidence "${closure_target}" "qa_proof_lane" "present"
set_evidence "${closure_target}" "backend_qa" "present"
set_evidence "${closure_target}" "frontend_qa" "not-applicable"
set_evidence "${closure_target}" "browser_proof" "present"
set_evidence "${closure_target}" "requested_vs_implemented" "present"
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
bash "${SCRIPTS}/reconcile-readiness.sh" "${prepare_target}" review-ready >/dev/null
bash "${SCRIPTS}/prepare-closure.sh" "${prepare_target}" >/dev/null
assert_contains "$(grep '^closure_readiness:' "${prepare_target}/.accelerate/status/readiness-dashboard.yaml")" "closure_readiness: ready"
assert_contains "$(grep '^ai_review:' "${prepare_target}/.accelerate/status/evidence-registry.yaml")" "ai_review: present"

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
