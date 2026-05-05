#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/production-readiness-gate"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  printf 'production-readiness-gate failed: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local output="$1"
  local expected="$2"
  printf '%s\n' "${output}" | rg -F -- "${expected}" >/dev/null || fail "missing expected text: ${expected}"
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

stabilize_for_execution() {
  local repo="$1"
  set_yaml_scalar "${repo}/.accelerate/onboarding/status.yaml" "status" "completed"
  set_yaml_scalar "${repo}/.accelerate/state.yaml" "onboarding_status" "completed"
  set_yaml_scalar "${repo}/.accelerate/state.yaml" "project_onboarded" "true"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "smallest sufficient artifact" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "path" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "bounded objective" "prove production readiness preflight"
}

seed_closure_evidence() {
  local repo="$1"
  mkdir -p "${repo}/.accelerate/proof" "${repo}/.tmp/browser"
  cat > "${repo}/.accelerate/proof/implementation_proof.md" <<'MD'
Implementation Proof

- validation: passed
- readiness impact: supports-closure
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "implementation_proof" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "implementation_proof_artifact" ".accelerate/proof/implementation_proof.md"
  cat > "${repo}/.accelerate/proof/qa_proof_lane.md" <<'MD'
QA Proof Lane

- validation: passed
- readiness impact: supports-closure
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "qa_proof_lane" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "qa_proof_lane_artifact" ".accelerate/proof/qa_proof_lane.md"
  printf '%s\n' "screenshot" > "${repo}/.tmp/browser/dashboard.png"
  printf '%s\n' '{"level":"info","message":"no console errors observed"}' > "${repo}/.tmp/browser/console.jsonl"
  printf '%s\n' '{"url":"/dashboard","status":200}' > "${repo}/.tmp/browser/network.jsonl"
  cat > "${repo}/.accelerate/proof/browser_proof.md" <<'MD'
Browser-Proof Packet

- surface / route family: /dashboard
- runtime target: http://localhost:3000/dashboard
- browser tool: Chrome DevTools
- browser session posture: isolated
- browser profile / isolation: --isolated
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
- visual comparison packet: not-needed
- residual route-family gaps: none
- readiness impact: supports-closure
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "browser_proof" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "browser_proof_artifact" ".accelerate/proof/browser_proof.md"
  cat > "${repo}/.accelerate/proof/backend_qa.md" <<'MD'
Backend QA

- validation: passed
- ownership: checked
- query: checked
- readiness impact: supports-closure
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "backend_qa" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "backend_qa_artifact" ".accelerate/proof/backend_qa.md"
  cat > "${repo}/.accelerate/proof/requested_vs_implemented.md" <<'MD'
Requested vs Implemented

- Requested: prove production readiness preflight
- Implemented: production readiness preflight proved
- status: met
- omissions: none
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "requested_vs_implemented" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "requested_vs_implemented_artifact" ".accelerate/proof/requested_vs_implemented.md"
  cat > "${repo}/.accelerate/proof/ai_review.md" <<'MD'
AI Review

## Findings
None.

## Omissions
None.

## Recommendation
Proceed.
MD
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "ai_review" "present"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "ai_review_artifact" ".accelerate/proof/ai_review.md"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "frontend_qa" "not-applicable"
  set_yaml_scalar "${repo}/.accelerate/status/evidence-registry.yaml" "persistent_e2e" "not-applicable"
}

seed_production_artifacts() {
  local repo="$1"
  mkdir -p "${repo}/.accelerate/review"
  cat > "${repo}/.accelerate/review/ship-readiness.json" <<'JSON'
{"schema_version":1,"adapter":"github-pr","ready":true,"pr":{"state":"OPEN"}}
JSON
  bash "${SCRIPTS}/render-deploy-verification-packet.sh" \
    "${repo}" \
    --persist \
    github-pr \
    production \
    passed \
    "manual adapter handoff" \
    "not-applicable with rationale" \
    "rollback path documented" >/dev/null
  cat > "${repo}/.accelerate/review/production-risk-approval.md" <<'MD'
# Production Risk Approval

- production-risk approval: approved
MD
}

make_ready_repo() {
  local repo="$1"
  mkdir -p "${repo}"
  bash "${SCRIPTS}/emit-v2.sh" "${repo}" greenfield >/dev/null
  bash "${SCRIPTS}/create-local-work-item.sh" "${repo}" "production-readiness" "Production readiness" >/dev/null
  stabilize_for_execution "${repo}"
  seed_closure_evidence "${repo}"
  bash "${SCRIPTS}/prepare-closure.sh" "${repo}" >/dev/null
  seed_production_artifacts "${repo}"
}

clone_ready_repo() {
  local repo="$1"
  rm -rf "${repo}"
  cp -R "${ready_repo}" "${repo}"
}

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}"

not_closed_repo="${WORK_ROOT}/not-closed"
mkdir -p "${not_closed_repo}"
bash "${SCRIPTS}/emit-v2.sh" "${not_closed_repo}" greenfield >/dev/null
if bash "${SCRIPTS}/check-production-readiness.sh" "${not_closed_repo}" >"${WORK_ROOT}/not-closed.out" 2>&1; then
  fail "blocked closure readiness unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/not-closed.out")" "closure_readiness must be ready"

ready_repo="${WORK_ROOT}/ready"
make_ready_repo "${ready_repo}"
assert_contains "$(bash "${SCRIPTS}/check-production-readiness.sh" "${ready_repo}")" "production readiness passed"
assert_contains "$(grep '^production_readiness:' "${ready_repo}/.accelerate/status/readiness-dashboard.yaml")" "production_readiness: ready"
assert_contains "$(grep '^deploy_verification:' "${ready_repo}/.accelerate/status/readiness-dashboard.yaml")" "deploy_verification: ready"
assert_contains "$(grep '^production_readiness:' "${ready_repo}/.accelerate/status/evidence-registry.yaml")" "production_readiness: present"
assert_contains "$(bash "${SCRIPTS}/render-handoff-summary.sh" "${ready_repo}")" "- production readiness: ready"
assert_contains "$(bash "${SCRIPTS}/render-closure-packet.sh" "${ready_repo}")" "- Production Readiness=present"

missing_ship_repo="${WORK_ROOT}/missing-ship"
clone_ready_repo "${missing_ship_repo}"
rm -f "${missing_ship_repo}/.accelerate/review/ship-readiness.json"
if bash "${SCRIPTS}/check-production-readiness.sh" "${missing_ship_repo}" >"${WORK_ROOT}/missing-ship.out" 2>&1; then
  fail "missing ship readiness unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/missing-ship.out")" "missing ship readiness packet"

false_ship_repo="${WORK_ROOT}/false-ship"
clone_ready_repo "${false_ship_repo}"
printf '%s\n' '{"schema_version":1,"ready":false}' > "${false_ship_repo}/.accelerate/review/ship-readiness.json"
if bash "${SCRIPTS}/check-production-readiness.sh" "${false_ship_repo}" >"${WORK_ROOT}/false-ship.out" 2>&1; then
  fail "false ship readiness unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/false-ship.out")" "ship readiness ready must be true"

dry_ship_repo="${WORK_ROOT}/dry-ship"
clone_ready_repo "${dry_ship_repo}"
printf '%s\n' '{"schema_version":1,"mode":"dry-run","ready":true}' > "${dry_ship_repo}/.accelerate/review/ship-readiness.json"
if bash "${SCRIPTS}/check-production-readiness.sh" "${dry_ship_repo}" >"${WORK_ROOT}/dry-ship.out" 2>&1; then
  fail "dry-run ship readiness unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/dry-ship.out")" "ship readiness cannot be dry-run"

missing_deploy_repo="${WORK_ROOT}/missing-deploy"
clone_ready_repo "${missing_deploy_repo}"
rm -f "${missing_deploy_repo}/.accelerate/review/deploy-verification-packet.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${missing_deploy_repo}" >"${WORK_ROOT}/missing-deploy.out" 2>&1; then
  fail "missing deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/missing-deploy.out")" "missing deploy verification packet"

incomplete_deploy_repo="${WORK_ROOT}/incomplete-deploy"
clone_ready_repo "${incomplete_deploy_repo}"
printf '%s\n' '# Deploy Verification Packet' '- provider adapter: github-pr' > "${incomplete_deploy_repo}/.accelerate/review/deploy-verification-packet.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${incomplete_deploy_repo}" >"${WORK_ROOT}/incomplete-deploy.out" 2>&1; then
  fail "incomplete deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/incomplete-deploy.out")" "deploy verification packet missing marker"

placeholder_deploy_repo="${WORK_ROOT}/placeholder-deploy"
clone_ready_repo "${placeholder_deploy_repo}"
cat > "${placeholder_deploy_repo}/.accelerate/review/deploy-verification-packet.md" <<'MD'
# Deploy Verification Packet

- provider adapter: <adapter>
- deploy target: production
- CI/check status: passed
- deployment action: manual handoff
- canary evidence: not-applicable with rationale
- rollback posture: rollback path documented
- production readiness result: ready
MD
if bash "${SCRIPTS}/check-production-readiness.sh" "${placeholder_deploy_repo}" >"${WORK_ROOT}/placeholder-deploy.out" 2>&1; then
  fail "placeholder deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/placeholder-deploy.out")" "deploy verification packet contains blocked marker"

blocked_deploy_repo="${WORK_ROOT}/blocked-deploy"
clone_ready_repo "${blocked_deploy_repo}"
perl -0pi -e 's#production readiness result: ready#production readiness result: blocked#m' "${blocked_deploy_repo}/.accelerate/review/deploy-verification-packet.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${blocked_deploy_repo}" >"${WORK_ROOT}/blocked-deploy.out" 2>&1; then
  fail "blocked deploy result unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/blocked-deploy.out")" "production readiness result: ready"

failed_ci_repo="${WORK_ROOT}/failed-ci-deploy"
clone_ready_repo "${failed_ci_repo}"
bash "${SCRIPTS}/render-deploy-verification-packet.sh" \
  "${failed_ci_repo}" \
  --persist \
  github-pr \
  production \
  failed \
  "manual adapter handoff" \
  "not-applicable with rationale" \
  "rollback path documented" >/dev/null
assert_contains "$(cat "${failed_ci_repo}/.accelerate/review/deploy-verification-packet.md")" "production readiness result: blocked"
if bash "${SCRIPTS}/check-production-readiness.sh" "${failed_ci_repo}" >"${WORK_ROOT}/failed-ci-deploy.out" 2>&1; then
  fail "failed CI deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/failed-ci-deploy.out")" "CI/check status must be one of"

weak_canary_repo="${WORK_ROOT}/weak-canary-deploy"
clone_ready_repo "${weak_canary_repo}"
perl -0pi -e 's#canary evidence: not-applicable with rationale#canary evidence: placeholder#m' "${weak_canary_repo}/.accelerate/review/deploy-verification-packet.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${weak_canary_repo}" >"${WORK_ROOT}/weak-canary-deploy.out" 2>&1; then
  fail "weak canary deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/weak-canary-deploy.out")" "blocked canary evidence: placeholder"

weak_rollback_repo="${WORK_ROOT}/weak-rollback-deploy"
clone_ready_repo "${weak_rollback_repo}"
perl -0pi -e 's#rollback posture: rollback path documented#rollback posture: not-documented#m' "${weak_rollback_repo}/.accelerate/review/deploy-verification-packet.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${weak_rollback_repo}" >"${WORK_ROOT}/weak-rollback-deploy.out" 2>&1; then
  fail "weak rollback deploy packet unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/weak-rollback-deploy.out")" "blocked rollback posture: not-documented"

missing_approval_repo="${WORK_ROOT}/missing-approval"
clone_ready_repo "${missing_approval_repo}"
rm -f "${missing_approval_repo}/.accelerate/review/production-risk-approval.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${missing_approval_repo}" >"${WORK_ROOT}/missing-approval.out" 2>&1; then
  fail "missing approval unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/missing-approval.out")" "missing production risk approval"

bad_approval_repo="${WORK_ROOT}/bad-approval"
clone_ready_repo "${bad_approval_repo}"
printf '%s\n' '# Production Risk Approval' '- production-risk approval: pending' > "${bad_approval_repo}/.accelerate/review/production-risk-approval.md"
if bash "${SCRIPTS}/check-production-readiness.sh" "${bad_approval_repo}" >"${WORK_ROOT}/bad-approval.out" 2>&1; then
  fail "bad approval unexpectedly passed"
fi
assert_contains "$(<"${WORK_ROOT}/bad-approval.out")" "production risk approval must contain"

printf 'production readiness gate passed\n'
