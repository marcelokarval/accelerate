#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/local-workflow-adapter"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if ! printf '%s' "${haystack}" | grep -Fq -- "${needle}"; then
    fail "expected output to contain: ${needle}"
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

stabilize_for_execution() {
  local repo="$1"
  set_yaml_scalar "${repo}/.accelerate/onboarding/status.yaml" "status" "completed"
  set_yaml_scalar "${repo}/.accelerate/state.yaml" "onboarding_status" "completed"
  set_yaml_scalar "${repo}/.accelerate/state.yaml" "project_onboarded" "true"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "smallest sufficient artifact" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "path" ".accelerate/planning/task-breakdown.md"
  set_plan_field "${repo}/.accelerate/planning/current-plan.md" "bounded objective" "prove workflow identity attachment"
}

seed_review_evidence() {
  local repo="$1"
  mkdir -p "${repo}/.accelerate/proof"
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
}

write_valid_browser_proof() {
  local repo="$1"
  mkdir -p "${repo}/.accelerate/proof" "${repo}/.tmp/browser"
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
}

seed_closure_evidence() {
  local repo="$1"
  seed_review_evidence "${repo}"
  write_valid_browser_proof "${repo}"
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

- Requested: prove workflow identity attachment
- Implemented: workflow identity attachment proved
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

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}"

target="${WORK_ROOT}/repo"
mkdir -p "${target}"

bash "${SCRIPTS}/emit-v2.sh" "${target}" greenfield >/dev/null

for path in \
  ".accelerate/workflow/README.md" \
  ".accelerate/workflow/adapter.yaml" \
  ".accelerate/workflow/active-work-item.yaml" \
  ".accelerate/workflow/work-items.jsonl" \
  ".accelerate/workflow/events.jsonl" \
  ".accelerate/workflow/topology.jsonl"; do
  [ -f "${target}/${path}" ] || fail "missing workflow path: ${path}"
done

bash "${SCRIPTS}/validate-v2.sh" "${target}" >/dev/null

mkdir -p "${target}/.accelerate/random-output"
if bash "${SCRIPTS}/validate-v2.sh" "${target}" >"${WORK_ROOT}/bad-layout.out" 2>&1; then
  fail "unknown .accelerate directory was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/bad-layout.out")" "unregistered .accelerate directory: .accelerate/random-output"
rm -rf "${target}/.accelerate/random-output"
bash "${SCRIPTS}/validate-v2.sh" "${target}" >/dev/null

create_output="$(bash "${SCRIPTS}/create-local-work-item.sh" "${target}" "live-workflow-adapter" "Build live workflow adapter")"
assert_contains "${create_output}" "created local work item LWI-"
assert_contains "$(grep '^active_work_item_id:' "${target}/.accelerate/workflow/adapter.yaml")" "LWI-"
assert_contains "$(grep '^lifecycle_state:' "${target}/.accelerate/workflow/active-work-item.yaml")" "planned"
assert_contains "$(cat "${target}/.accelerate/workflow/work-items.jsonl")" "work_item_created"

render_output="$(bash "${SCRIPTS}/render-local-work-item.sh" "${target}")"
assert_contains "${render_output}" "Local Workflow Work Item"
assert_contains "${render_output}" "- slug: live-workflow-adapter"
assert_contains "${render_output}" "- lifecycle state: planned"

transition_output="$(bash "${SCRIPTS}/transition-local-work-item.sh" "${target}" "in_progress" "Started implementation")"
assert_contains "${transition_output}" "to in_progress"
assert_contains "$(grep '^lifecycle_state:' "${target}/.accelerate/workflow/active-work-item.yaml")" "in_progress"
assert_contains "$(cat "${target}/.accelerate/workflow/events.jsonl")" "work_item_transitioned"
assert_contains "$(cat "${target}/.accelerate/status/timeline.jsonl")" "local_work_item_transitioned"
assert_contains "$(bash "${SCRIPTS}/list-local-work-items.sh" "${target}")" "| in_progress | live-workflow-adapter | Build live workflow adapter"
bash "${SCRIPTS}/select-local-work-item.sh" "${target}" "$(sed -n 's/^id:[[:space:]]*//p' "${target}/.accelerate/workflow/active-work-item.yaml" | head -n 1)" >/dev/null
assert_contains "$(grep '^lifecycle_state:' "${target}/.accelerate/workflow/active-work-item.yaml")" "in_progress"

if bash "${SCRIPTS}/transition-local-work-item.sh" "${target}" "shipped" "Invalid transition" >"${WORK_ROOT}/invalid.out" 2>&1; then
  fail "invalid lifecycle state was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/invalid.out")" "invalid lifecycle state: shipped"

direct_done_target="${WORK_ROOT}/direct-done-repo"
mkdir -p "${direct_done_target}"
bash "${SCRIPTS}/emit-v2.sh" "${direct_done_target}" greenfield >/dev/null
bash "${SCRIPTS}/create-local-work-item.sh" "${direct_done_target}" "direct-done" "Direct done should block" >/dev/null
if bash "${SCRIPTS}/transition-local-work-item.sh" "${direct_done_target}" "done" "Unsafe direct done" >"${WORK_ROOT}/direct-done.out" 2>&1; then
  fail "unsafe planned->done transition was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/direct-done.out")" "invalid lifecycle transition: planned -> done"

if bash "${SCRIPTS}/transition-local-work-item.sh" "${target}" "done" "Phase 1 complete" >"${WORK_ROOT}/in-progress-done.out" 2>&1; then
  fail "unsafe in_progress->done transition was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/in-progress-done.out")" "done transition requires closure-ready evidence gate"

bash "${SCRIPTS}/validate-v2.sh" "${target}" >/dev/null

topology_target="${WORK_ROOT}/topology-repo"
mkdir -p "${topology_target}"
bash "${SCRIPTS}/emit-v2.sh" "${topology_target}" greenfield >/dev/null
parent_output="$(bash "${SCRIPTS}/create-local-work-item.sh" "${topology_target}" "parent-work" "Parent work")"
parent_id="$(printf '%s\n' "${parent_output}" | sed -n 's/.*created local work item \(LWI-[0-9-]*\).*/\1/p')"
child_output="$(bash "${SCRIPTS}/create-local-work-item.sh" "${topology_target}" "child-work" "Child work")"
child_id="$(printf '%s\n' "${child_output}" | sed -n 's/.*created local work item \(LWI-[0-9-]*\).*/\1/p')"
related_output="$(bash "${SCRIPTS}/create-local-work-item.sh" "${topology_target}" "related-work" "Related work")"
related_id="$(printf '%s\n' "${related_output}" | sed -n 's/.*created local work item \(LWI-[0-9-]*\).*/\1/p')"

bash "${SCRIPTS}/link-local-work-item.sh" \
  "${topology_target}" \
  --parent "${parent_id}" \
  --child "${child_id}" \
  --related "${related_id}" \
  --task-ledger "planning/executive/live-workflow-adapter-progressive-task-ledger.md" >/dev/null

topology_render="$(bash "${SCRIPTS}/render-local-work-item.sh" "${topology_target}")"
assert_contains "${topology_render}" "- parent id: ${parent_id}"
assert_contains "${topology_render}" "- child ids: [${child_id}]"
assert_contains "${topology_render}" "- related ids: [${related_id}]"
assert_contains "${topology_render}" "- one-shot task ledger: planning/executive/live-workflow-adapter-progressive-task-ledger.md"
assert_contains "$(cat "${topology_target}/.accelerate/workflow/topology.jsonl")" "work_item_parent_linked"
assert_contains "$(cat "${topology_target}/.accelerate/workflow/topology.jsonl")" "work_item_task_ledger_linked"

list_output="$(bash "${SCRIPTS}/list-local-work-items.sh" "${topology_target}")"
assert_contains "${list_output}" "${parent_id}"
assert_contains "${list_output}" "${child_id}"
bash "${SCRIPTS}/select-local-work-item.sh" "${topology_target}" "${related_id}" >/dev/null
assert_contains "$(grep '^id:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "${related_id}"
assert_contains "$(grep '^parent_id:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "${parent_id}"
assert_contains "$(grep '^child_ids:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "[${child_id}]"
assert_contains "$(grep '^related_ids:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "[${related_id}]"
assert_contains "$(grep '^one_shot_task_ledger:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "planning/executive/live-workflow-adapter-progressive-task-ledger.md"
bash "${SCRIPTS}/select-local-work-item.sh" "${topology_target}" "${parent_id}" >/dev/null
assert_contains "$(grep '^id:' "${topology_target}/.accelerate/workflow/active-work-item.yaml")" "${parent_id}"

if bash "${SCRIPTS}/link-local-work-item.sh" "${topology_target}" --parent "bad-id" >"${WORK_ROOT}/bad-link.out" 2>&1; then
  fail "invalid topology parent id was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/bad-link.out")" "invalid parent id: bad-id"

bash "${SCRIPTS}/validate-v2.sh" "${topology_target}" >/dev/null

review_target="${WORK_ROOT}/review-repo"
mkdir -p "${review_target}"
bash "${SCRIPTS}/emit-v2.sh" "${review_target}" greenfield >/dev/null
bash "${SCRIPTS}/create-local-work-item.sh" "${review_target}" "review-workflow" "Review workflow identity" >/dev/null
seed_review_evidence "${review_target}"
stabilize_for_execution "${review_target}"
bash "${SCRIPTS}/prepare-review.sh" "${review_target}" >/dev/null
assert_contains "$(grep '^lifecycle_state:' "${review_target}/.accelerate/workflow/active-work-item.yaml")" "review"
assert_contains "$(cat "${review_target}/.accelerate/review/review-ready-packet.md")" "- workflow work item: LWI-"
assert_contains "$(cat "${review_target}/.accelerate/review/review-ready-packet.md")" "- workflow lifecycle state: review"
assert_contains "$(cat "${review_target}/.accelerate/review/pre-review-bundle.md")" "- workflow locator: local:LWI-"
assert_contains "$(cat "${review_target}/.accelerate/review/handoff-summary.md")" "## Workflow Identity"
assert_contains "$(cat "${review_target}/.accelerate/review/handoff-summary.md")" "- workflow lifecycle state: review"

closure_target="${WORK_ROOT}/closure-repo"
mkdir -p "${closure_target}"
bash "${SCRIPTS}/emit-v2.sh" "${closure_target}" greenfield >/dev/null
bash "${SCRIPTS}/create-local-work-item.sh" "${closure_target}" "closure-workflow" "Closure workflow identity" >/dev/null
seed_closure_evidence "${closure_target}"
stabilize_for_execution "${closure_target}"
bash "${SCRIPTS}/prepare-closure.sh" "${closure_target}" >/dev/null
assert_contains "$(grep '^lifecycle_state:' "${closure_target}/.accelerate/workflow/active-work-item.yaml")" "closure"
assert_contains "$(cat "${closure_target}/.accelerate/review/closure-packet.md")" "- workflow work item: LWI-"
assert_contains "$(cat "${closure_target}/.accelerate/review/closure-packet.md")" "- workflow lifecycle state: closure"
assert_contains "$(cat "${closure_target}/.accelerate/review/closure-bundle.md")" "- workflow locator: local:LWI-"
assert_contains "$(cat "${closure_target}/.accelerate/review/handoff-summary.md")" "- workflow lifecycle state: closure"
bash "${SCRIPTS}/transition-local-work-item.sh" "${closure_target}" "done" "Closure complete" >/dev/null
assert_contains "$(grep '^lifecycle_state:' "${closure_target}/.accelerate/workflow/active-work-item.yaml")" "done"
assert_contains "$(grep '^closure_summary:' "${closure_target}/.accelerate/workflow/active-work-item.yaml")" "Closure complete"

review_done_target="${WORK_ROOT}/review-done-repo"
mkdir -p "${review_done_target}"
bash "${SCRIPTS}/emit-v2.sh" "${review_done_target}" greenfield >/dev/null
bash "${SCRIPTS}/create-local-work-item.sh" "${review_done_target}" "review-done" "Review done should block" >/dev/null
bash "${SCRIPTS}/transition-local-work-item.sh" "${review_done_target}" "review" "Review without closure proof" >/dev/null
if bash "${SCRIPTS}/transition-local-work-item.sh" "${review_done_target}" "done" "Unsafe review done" >"${WORK_ROOT}/review-done.out" 2>&1; then
  fail "unsafe review->done transition was accepted"
fi
assert_contains "$(cat "${WORK_ROOT}/review-done.out")" "done transition requires closure-ready evidence gate"

echo "local workflow adapter tests passed"
