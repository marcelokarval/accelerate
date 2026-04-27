#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$1"
WORKSPACE="${TARGET_ROOT}/.accelerate"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILURES=0

required_files=(
  "${WORKSPACE}/README.md"
  "${WORKSPACE}/state.yaml"
  "${WORKSPACE}/status/readiness-dashboard.yaml"
  "${WORKSPACE}/status/evidence-registry.yaml"
  "${WORKSPACE}/status/timeline.jsonl"
  "${WORKSPACE}/status/learnings.jsonl"
  "${WORKSPACE}/status/questions.jsonl"
  "${WORKSPACE}/status/question-preferences.json"
  "${WORKSPACE}/status/privacy-map.yaml"
  "${WORKSPACE}/status/safety-overlay.yaml"
  "${WORKSPACE}/status/checkpoints/README.md"
  "${WORKSPACE}/onboarding/status.yaml"
  "${WORKSPACE}/onboarding/discovery.yaml"
  "${WORKSPACE}/onboarding/decisions.yaml"
  "${WORKSPACE}/onboarding/executive-bootstrap-plan.md"
  "${WORKSPACE}/planning/current-plan.md"
  "${WORKSPACE}/planning/user-story.md"
  "${WORKSPACE}/planning/prd-lite.md"
  "${WORKSPACE}/planning/sdd.md"
  "${WORKSPACE}/planning/executive-plan.md"
  "${WORKSPACE}/planning/task-breakdown.md"
  "${WORKSPACE}/planning/task-ledger.md"
  "${WORKSPACE}/planning/review-pipeline.md"
  "${WORKSPACE}/planning/open-questions.md"
  "${WORKSPACE}/review/review-ready-packet.md"
  "${WORKSPACE}/review/ai-review-report.md"
  "${WORKSPACE}/review/findings.jsonl"
  "${WORKSPACE}/review/qa-report.md"
  "${WORKSPACE}/review/design-feedback.json"
  "${WORKSPACE}/review/design-approved.json"
  "${WORKSPACE}/review/design-baseline.json"
  "${WORKSPACE}/review/closure-packet.md"
  "${WORKSPACE}/review/branch-entry-packet.md"
  "${WORKSPACE}/review/runtime-delta-packet.md"
  "${WORKSPACE}/review/handoff-summary.md"
  "${WORKSPACE}/review/pre-review-bundle.md"
  "${WORKSPACE}/review/closure-bundle.md"
  "${WORKSPACE}/review/current-slice-review.md"
  "${WORKSPACE}/review/current-slice-forensics.md"
  "${WORKSPACE}/review/defect-ledger.yaml"
  "${WORKSPACE}/review/seam-proof.md"
  "${WORKSPACE}/workflow/README.md"
  "${WORKSPACE}/workflow/adapter.yaml"
  "${WORKSPACE}/workflow/active-work-item.yaml"
  "${WORKSPACE}/workflow/work-items.jsonl"
  "${WORKSPACE}/workflow/events.jsonl"
  "${WORKSPACE}/workflow/topology.jsonl"
  "${WORKSPACE}/agents/status.yaml"
  "${WORKSPACE}/agents/candidates.yaml"
  "${WORKSPACE}/agents/gaps.yaml"
)

require_file() {
  local path="$1"
  if [ ! -f "${path}" ]; then
    echo "missing required file: ${path}" >&2
    FAILURES=$((FAILURES + 1))
  fi
}

require_key() {
  local path="$1"
  local key="$2"
  if [ ! -f "${path}" ] || ! grep -Eq "^${key}:" "${path}"; then
    echo "missing required key '${key}' in ${path}" >&2
    FAILURES=$((FAILURES + 1))
  fi
}

require_dir() {
  local path="$1"
  if [ ! -d "${path}" ]; then
    echo "missing required directory: ${path}" >&2
    FAILURES=$((FAILURES + 1))
  fi
}

require_exact_value() {
  local path="$1"
  local key="$2"
  local expected="$3"
  local actual
  actual="$(yaml_value "${path}" "${key}")"
  if [ "${actual}" != "${expected}" ]; then
    echo "unexpected value for '${key}' in ${path}: expected '${expected}', got '${actual}'" >&2
    FAILURES=$((FAILURES + 1))
  fi
}

require_enum() {
  local path="$1"
  local key="$2"
  shift 2
  local actual
  actual="$(yaml_value "${path}" "${key}")"
  for allowed in "$@"; do
    if [ "${actual}" = "${allowed}" ]; then
      return
    fi
  done
  echo "unexpected value for '${key}' in ${path}: ${actual}" >&2
  FAILURES=$((FAILURES + 1))
}

require_listish() {
  local path="$1"
  local key="$2"
  if grep -Eq "^${key}:[[:space:]]*\\[.*\\][[:space:]]*$" "${path}"; then
    return
  fi
  if grep -Eq "^${key}:[[:space:]]*$" "${path}"; then
    return
  fi
  echo "expected list-shaped field for '${key}' in ${path}" >&2
  FAILURES=$((FAILURES + 1))
}

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

warn_drift() {
  local message="$1"
  echo "drift warning: ${message}" >&2
}

if [ ! -d "${WORKSPACE}" ]; then
  echo "missing .accelerate workspace: ${WORKSPACE}" >&2
  exit 1
fi

if ! bash "${SCRIPT_DIR}/check-workspace-layout.sh" "${TARGET_ROOT}" >/dev/null; then
  bash "${SCRIPT_DIR}/check-workspace-layout.sh" "${TARGET_ROOT}" >&2 || true
  FAILURES=$((FAILURES + 1))
fi

for file in "${required_files[@]}"; do
  require_file "${file}"
done

require_dir "${WORKSPACE}/planning/history"

require_key "${WORKSPACE}/state.yaml" "schema_version"
require_key "${WORKSPACE}/state.yaml" "accelerate_stage"
require_key "${WORKSPACE}/state.yaml" "project_onboarded"
require_key "${WORKSPACE}/state.yaml" "installation_mode"
require_key "${WORKSPACE}/state.yaml" "repo_maturity"
require_key "${WORKSPACE}/state.yaml" "onboarding_status"
require_key "${WORKSPACE}/state.yaml" "reentry_status"
require_key "${WORKSPACE}/state.yaml" "workflow_backend"
require_key "${WORKSPACE}/state.yaml" "workflow_backend_detected"
require_key "${WORKSPACE}/state.yaml" "active_profile"
require_key "${WORKSPACE}/state.yaml" "active_runtime_adapters"
require_key "${WORKSPACE}/state.yaml" "agent_mode"
require_key "${WORKSPACE}/state.yaml" "current_plan"
require_key "${WORKSPACE}/state.yaml" "readiness_dashboard"
require_key "${WORKSPACE}/state.yaml" "timeline_file"
require_key "${WORKSPACE}/state.yaml" "learnings_file"
require_key "${WORKSPACE}/state.yaml" "evidence_registry"
require_key "${WORKSPACE}/state.yaml" "review_ready_packet"
require_key "${WORKSPACE}/state.yaml" "ai_review_report"
require_key "${WORKSPACE}/state.yaml" "closure_packet"
require_key "${WORKSPACE}/state.yaml" "branch_entry_packet"
require_key "${WORKSPACE}/state.yaml" "runtime_delta_packet"
require_key "${WORKSPACE}/state.yaml" "handoff_summary"
require_key "${WORKSPACE}/state.yaml" "pre_review_bundle"
require_key "${WORKSPACE}/state.yaml" "closure_bundle"
require_key "${WORKSPACE}/state.yaml" "current_slice_review"
require_key "${WORKSPACE}/state.yaml" "current_slice_forensics"
require_key "${WORKSPACE}/state.yaml" "defect_ledger"
require_key "${WORKSPACE}/state.yaml" "seam_proof"
require_key "${WORKSPACE}/state.yaml" "workflow_adapter"
require_key "${WORKSPACE}/state.yaml" "active_work_item"
require_key "${WORKSPACE}/state.yaml" "workflow_events"
require_key "${WORKSPACE}/state.yaml" "workflow_work_items"
require_key "${WORKSPACE}/state.yaml" "workflow_topology"

require_key "${WORKSPACE}/workflow/adapter.yaml" "schema_version"
require_key "${WORKSPACE}/workflow/adapter.yaml" "adapter"
require_key "${WORKSPACE}/workflow/adapter.yaml" "adapter_status"
require_key "${WORKSPACE}/workflow/adapter.yaml" "active_work_item_id"
require_key "${WORKSPACE}/workflow/adapter.yaml" "active_work_item_locator"
require_key "${WORKSPACE}/workflow/adapter.yaml" "last_event_id"
require_key "${WORKSPACE}/workflow/adapter.yaml" "last_updated"

require_key "${WORKSPACE}/workflow/active-work-item.yaml" "schema_version"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "id"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "locator"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "title"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "slug"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "lifecycle_state"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "owner"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "parent_id"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "related_ids"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "child_ids"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "labels"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "governing_artifact"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "one_shot_task_ledger"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "created_at"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "updated_at"
require_key "${WORKSPACE}/workflow/active-work-item.yaml" "closure_summary"

require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "schema_version"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "current_phase"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "governing_artifact_path"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "dashboard_verdict"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "execution_readiness"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "review_readiness"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "closure_readiness"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "required_gates"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "completed_gates"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "blocking_items"
require_key "${WORKSPACE}/status/readiness-dashboard.yaml" "last_updated"

require_key "${WORKSPACE}/status/evidence-registry.yaml" "schema_version"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "implementation_proof"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "qa_proof_lane"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "backend_qa"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "frontend_qa"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "browser_proof"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "persistent_e2e"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "ux_ui_fullstack_surface"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "design_implementation_proof"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "product_critical_closure"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "requested_vs_implemented"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "defect_ledger"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "correction_loop"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "seam_proof"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "ai_review"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "ai_review_rendered"
require_key "${WORKSPACE}/status/evidence-registry.yaml" "last_updated"

require_key "${WORKSPACE}/onboarding/status.yaml" "schema_version"
require_key "${WORKSPACE}/onboarding/status.yaml" "status"
require_key "${WORKSPACE}/onboarding/status.yaml" "reentry_status"
require_key "${WORKSPACE}/onboarding/status.yaml" "last_updated"

require_key "${WORKSPACE}/onboarding/discovery.yaml" "schema_version"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "languages"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "framework_signals"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "workflow_tool_signals"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "docs_posture_signals"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "proof_runtime_signals"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "package_manager_signals"
require_key "${WORKSPACE}/onboarding/discovery.yaml" "repo_notes"

require_key "${WORKSPACE}/onboarding/decisions.yaml" "schema_version"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "selected_workflow_backend"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "selected_workflow_backend_detected"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "selected_profile"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "selected_runtime_posture"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "selected_docs_posture"
require_key "${WORKSPACE}/onboarding/decisions.yaml" "explicit_non_goals"

require_key "${WORKSPACE}/agents/status.yaml" "schema_version"
require_key "${WORKSPACE}/agents/status.yaml" "agent_mode"
require_key "${WORKSPACE}/agents/status.yaml" "agent_readiness"

require_key "${WORKSPACE}/agents/candidates.yaml" "schema_version"
require_key "${WORKSPACE}/agents/candidates.yaml" "candidates"

require_key "${WORKSPACE}/agents/gaps.yaml" "schema_version"
require_key "${WORKSPACE}/agents/gaps.yaml" "gaps"

require_exact_value "${WORKSPACE}/state.yaml" "schema_version" "1"
require_exact_value "${WORKSPACE}/state.yaml" "accelerate_stage" "standalone-pre-agents"
require_enum "${WORKSPACE}/state.yaml" "project_onboarded" "true" "false"
require_enum "${WORKSPACE}/state.yaml" "installation_mode" "greenfield" "adoption"
require_enum "${WORKSPACE}/state.yaml" "repo_maturity" "empty" "early" "existing" "mature"
require_enum "${WORKSPACE}/state.yaml" "onboarding_status" "not_started" "in_progress" "partially_stabilized" "completed"
require_enum "${WORKSPACE}/state.yaml" "reentry_status" "clean" "light_reentry" "partial_reonboarding" "structural_reonboarding"
require_enum "${WORKSPACE}/state.yaml" "workflow_backend" "none-yet" "github" "linear"
require_enum "${WORKSPACE}/state.yaml" "workflow_backend_detected" "none-yet" "github" "linear"
require_enum "${WORKSPACE}/state.yaml" "active_profile" "unknown" "django-inertia-react" "nextjs-tailwind"
require_enum "${WORKSPACE}/state.yaml" "agent_mode" "root-only" "agent-eligible"
require_listish "${WORKSPACE}/state.yaml" "active_runtime_adapters"

require_exact_value "${WORKSPACE}/workflow/adapter.yaml" "schema_version" "1"
require_exact_value "${WORKSPACE}/workflow/adapter.yaml" "adapter" "local"
require_enum "${WORKSPACE}/workflow/adapter.yaml" "adapter_status" "initialized" "active" "blocked"
require_exact_value "${WORKSPACE}/workflow/active-work-item.yaml" "schema_version" "1"
require_enum "${WORKSPACE}/workflow/active-work-item.yaml" "lifecycle_state" "none" "planned" "ready" "in_progress" "review" "closure" "done" "blocked" "cancelled"
require_listish "${WORKSPACE}/workflow/active-work-item.yaml" "related_ids"
require_listish "${WORKSPACE}/workflow/active-work-item.yaml" "child_ids"
require_listish "${WORKSPACE}/workflow/active-work-item.yaml" "labels"

require_exact_value "${WORKSPACE}/status/readiness-dashboard.yaml" "schema_version" "1"
require_enum "${WORKSPACE}/status/readiness-dashboard.yaml" "current_phase" "onboarding" "planning" "execution" "review" "closure"
require_enum "${WORKSPACE}/status/readiness-dashboard.yaml" "dashboard_verdict" "blocked" "ready-for-execution" "ready-for-review" "ready-for-closure"
require_enum "${WORKSPACE}/status/readiness-dashboard.yaml" "execution_readiness" "blocked" "ready"
require_enum "${WORKSPACE}/status/readiness-dashboard.yaml" "review_readiness" "blocked" "ready"
require_enum "${WORKSPACE}/status/readiness-dashboard.yaml" "closure_readiness" "blocked" "ready"
require_listish "${WORKSPACE}/status/readiness-dashboard.yaml" "required_gates"
require_listish "${WORKSPACE}/status/readiness-dashboard.yaml" "completed_gates"
require_listish "${WORKSPACE}/status/readiness-dashboard.yaml" "blocking_items"

require_exact_value "${WORKSPACE}/status/evidence-registry.yaml" "schema_version" "1"
for evidence_key in \
  implementation_proof \
  qa_proof_lane \
  backend_qa \
  frontend_qa \
  browser_proof \
  persistent_e2e \
  ux_ui_fullstack_surface \
  design_implementation_proof \
  product_critical_closure \
  requested_vs_implemented \
  ai_review \
  ai_review_rendered; do
  require_enum "${WORKSPACE}/status/evidence-registry.yaml" "${evidence_key}" "missing" "present" "blocked" "not-applicable" "out-of-order"
done
require_enum "${WORKSPACE}/status/evidence-registry.yaml" "defect_ledger" "clear" "open-defects-remain" "waived-defects-present" "missing" "blocked"
require_enum "${WORKSPACE}/status/evidence-registry.yaml" "correction_loop" "not-needed" "completed" "incomplete" "missing" "blocked"
require_enum "${WORKSPACE}/status/evidence-registry.yaml" "seam_proof" "not-needed" "present" "missing" "insufficient" "blocked"

require_exact_value "${WORKSPACE}/onboarding/status.yaml" "schema_version" "1"
require_enum "${WORKSPACE}/onboarding/status.yaml" "status" "not_started" "in_progress" "partially_stabilized" "completed"
require_enum "${WORKSPACE}/onboarding/status.yaml" "reentry_status" "clean" "light_reentry" "partial_reonboarding" "structural_reonboarding"

require_exact_value "${WORKSPACE}/onboarding/discovery.yaml" "schema_version" "1"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "languages"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "framework_signals"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "workflow_tool_signals"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "docs_posture_signals"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "proof_runtime_signals"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "package_manager_signals"
require_listish "${WORKSPACE}/onboarding/discovery.yaml" "repo_notes"

require_exact_value "${WORKSPACE}/onboarding/decisions.yaml" "schema_version" "1"
require_enum "${WORKSPACE}/onboarding/decisions.yaml" "selected_workflow_backend" "none-yet" "github" "linear"
require_enum "${WORKSPACE}/onboarding/decisions.yaml" "selected_workflow_backend_detected" "none-yet" "github" "linear"
require_enum "${WORKSPACE}/onboarding/decisions.yaml" "selected_profile" "unknown" "django-inertia-react" "nextjs-tailwind"
require_enum "${WORKSPACE}/onboarding/decisions.yaml" "selected_docs_posture" "default" "custom" "none-yet"
require_listish "${WORKSPACE}/onboarding/decisions.yaml" "selected_runtime_posture"
require_listish "${WORKSPACE}/onboarding/decisions.yaml" "explicit_non_goals"

require_exact_value "${WORKSPACE}/agents/status.yaml" "schema_version" "1"
require_enum "${WORKSPACE}/agents/status.yaml" "agent_mode" "root-only" "agent-eligible"
require_exact_value "${WORKSPACE}/agents/status.yaml" "agent_readiness" "pre-agents"
require_enum "${WORKSPACE}/agents/status.yaml" "promotion_discussion" "true" "false"
require_enum "${WORKSPACE}/agents/status.yaml" "catalog_required" "true" "false"

require_exact_value "${WORKSPACE}/agents/candidates.yaml" "schema_version" "1"
require_listish "${WORKSPACE}/agents/candidates.yaml" "candidates"
require_exact_value "${WORKSPACE}/agents/gaps.yaml" "schema_version" "1"
require_listish "${WORKSPACE}/agents/gaps.yaml" "gaps"

state_onboarding_status="$(yaml_value "${WORKSPACE}/state.yaml" "onboarding_status")"
detail_onboarding_status="$(yaml_value "${WORKSPACE}/onboarding/status.yaml" "status")"
if [ -n "${state_onboarding_status}" ] && [ -n "${detail_onboarding_status}" ] && [ "${state_onboarding_status}" != "${detail_onboarding_status}" ]; then
  warn_drift "state.yaml onboarding_status (${state_onboarding_status}) != onboarding/status.yaml status (${detail_onboarding_status})"
fi

state_reentry_status="$(yaml_value "${WORKSPACE}/state.yaml" "reentry_status")"
detail_reentry_status="$(yaml_value "${WORKSPACE}/onboarding/status.yaml" "reentry_status")"
if [ -n "${state_reentry_status}" ] && [ -n "${detail_reentry_status}" ] && [ "${state_reentry_status}" != "${detail_reentry_status}" ]; then
  warn_drift "state.yaml reentry_status (${state_reentry_status}) != onboarding/status.yaml reentry_status (${detail_reentry_status})"
fi

state_agent_mode="$(yaml_value "${WORKSPACE}/state.yaml" "agent_mode")"
detail_agent_mode="$(yaml_value "${WORKSPACE}/agents/status.yaml" "agent_mode")"
if [ -n "${state_agent_mode}" ] && [ -n "${detail_agent_mode}" ] && [ "${state_agent_mode}" != "${detail_agent_mode}" ]; then
  warn_drift "state.yaml agent_mode (${state_agent_mode}) != agents/status.yaml agent_mode (${detail_agent_mode})"
fi

project_onboarded="$(yaml_value "${WORKSPACE}/state.yaml" "project_onboarded")"
if [ "${project_onboarded}" = "true" ] && [ "${detail_onboarding_status}" = "not_started" ]; then
  echo "inconsistent onboarding truth: project_onboarded=true but onboarding/status.yaml is not_started" >&2
  FAILURES=$((FAILURES + 1))
fi

selected_workflow_backend="$(yaml_value "${WORKSPACE}/onboarding/decisions.yaml" "selected_workflow_backend")"
workflow_tool_signals="$(yaml_value "${WORKSPACE}/onboarding/discovery.yaml" "workflow_tool_signals")"
if [ "${selected_workflow_backend}" != "none-yet" ] && [ "${workflow_tool_signals}" = "[]" ]; then
  warn_drift "decisions selected_workflow_backend (${selected_workflow_backend}) is stronger than empty workflow_tool_signals; verify whether this came from explicit user direction"
fi

selected_profile="$(yaml_value "${WORKSPACE}/onboarding/decisions.yaml" "selected_profile")"
framework_signals="$(yaml_value "${WORKSPACE}/onboarding/discovery.yaml" "framework_signals")"
if [ "${selected_profile}" != "unknown" ] && [ "${framework_signals}" = "[]" ]; then
  warn_drift "decisions selected_profile (${selected_profile}) is stronger than empty framework_signals; verify whether this came from explicit user direction"
fi

current_plan="$(yaml_value "${WORKSPACE}/state.yaml" "current_plan")"
if [ -n "${current_plan}" ] && [ ! -f "${TARGET_ROOT}/${current_plan}" ]; then
  echo "state.yaml current_plan does not exist: ${TARGET_ROOT}/${current_plan}" >&2
  FAILURES=$((FAILURES + 1))
fi

readiness_dashboard="$(yaml_value "${WORKSPACE}/state.yaml" "readiness_dashboard")"
if [ -n "${readiness_dashboard}" ] && [ ! -f "${TARGET_ROOT}/${readiness_dashboard}" ]; then
  echo "state.yaml readiness_dashboard does not exist: ${TARGET_ROOT}/${readiness_dashboard}" >&2
  FAILURES=$((FAILURES + 1))
fi

timeline_file="$(yaml_value "${WORKSPACE}/state.yaml" "timeline_file")"
if [ -n "${timeline_file}" ] && [ ! -f "${TARGET_ROOT}/${timeline_file}" ]; then
  echo "state.yaml timeline_file does not exist: ${TARGET_ROOT}/${timeline_file}" >&2
  FAILURES=$((FAILURES + 1))
fi

learnings_file="$(yaml_value "${WORKSPACE}/state.yaml" "learnings_file")"
if [ -n "${learnings_file}" ] && [ ! -f "${TARGET_ROOT}/${learnings_file}" ]; then
  echo "state.yaml learnings_file does not exist: ${TARGET_ROOT}/${learnings_file}" >&2
  FAILURES=$((FAILURES + 1))
fi

for state_ref_key in \
  questions_file \
  question_preferences \
  privacy_map \
  safety_overlay \
  task_ledger \
  review_findings \
  qa_report \
  design_feedback \
  design_approved \
  design_baseline; do
  state_ref="$(yaml_value "${WORKSPACE}/state.yaml" "${state_ref_key}")"
  if [ -n "${state_ref}" ] && [ ! -f "${TARGET_ROOT}/${state_ref}" ]; then
    echo "state.yaml ${state_ref_key} does not exist: ${TARGET_ROOT}/${state_ref}" >&2
    FAILURES=$((FAILURES + 1))
  fi
done

evidence_registry="$(yaml_value "${WORKSPACE}/state.yaml" "evidence_registry")"
if [ -n "${evidence_registry}" ] && [ ! -f "${TARGET_ROOT}/${evidence_registry}" ]; then
  echo "state.yaml evidence_registry does not exist: ${TARGET_ROOT}/${evidence_registry}" >&2
  FAILURES=$((FAILURES + 1))
fi

review_ready_packet="$(yaml_value "${WORKSPACE}/state.yaml" "review_ready_packet")"
if [ -n "${review_ready_packet}" ] && [ ! -f "${TARGET_ROOT}/${review_ready_packet}" ]; then
  echo "state.yaml review_ready_packet does not exist: ${TARGET_ROOT}/${review_ready_packet}" >&2
  FAILURES=$((FAILURES + 1))
fi

ai_review_report="$(yaml_value "${WORKSPACE}/state.yaml" "ai_review_report")"
if [ -n "${ai_review_report}" ] && [ ! -f "${TARGET_ROOT}/${ai_review_report}" ]; then
  echo "state.yaml ai_review_report does not exist: ${TARGET_ROOT}/${ai_review_report}" >&2
  FAILURES=$((FAILURES + 1))
fi

closure_packet="$(yaml_value "${WORKSPACE}/state.yaml" "closure_packet")"
if [ -n "${closure_packet}" ] && [ ! -f "${TARGET_ROOT}/${closure_packet}" ]; then
  echo "state.yaml closure_packet does not exist: ${TARGET_ROOT}/${closure_packet}" >&2
  FAILURES=$((FAILURES + 1))
fi

branch_entry_packet="$(yaml_value "${WORKSPACE}/state.yaml" "branch_entry_packet")"
if [ -n "${branch_entry_packet}" ] && [ ! -f "${TARGET_ROOT}/${branch_entry_packet}" ]; then
  echo "state.yaml branch_entry_packet does not exist: ${TARGET_ROOT}/${branch_entry_packet}" >&2
  FAILURES=$((FAILURES + 1))
fi

runtime_delta_packet="$(yaml_value "${WORKSPACE}/state.yaml" "runtime_delta_packet")"
if [ -n "${runtime_delta_packet}" ] && [ ! -f "${TARGET_ROOT}/${runtime_delta_packet}" ]; then
  echo "state.yaml runtime_delta_packet does not exist: ${TARGET_ROOT}/${runtime_delta_packet}" >&2
  FAILURES=$((FAILURES + 1))
fi

handoff_summary="$(yaml_value "${WORKSPACE}/state.yaml" "handoff_summary")"
if [ -n "${handoff_summary}" ] && [ ! -f "${TARGET_ROOT}/${handoff_summary}" ]; then
  echo "state.yaml handoff_summary does not exist: ${TARGET_ROOT}/${handoff_summary}" >&2
  FAILURES=$((FAILURES + 1))
fi

pre_review_bundle="$(yaml_value "${WORKSPACE}/state.yaml" "pre_review_bundle")"
if [ -n "${pre_review_bundle}" ] && [ ! -f "${TARGET_ROOT}/${pre_review_bundle}" ]; then
  echo "state.yaml pre_review_bundle does not exist: ${TARGET_ROOT}/${pre_review_bundle}" >&2
  FAILURES=$((FAILURES + 1))
fi

closure_bundle="$(yaml_value "${WORKSPACE}/state.yaml" "closure_bundle")"
if [ -n "${closure_bundle}" ] && [ ! -f "${TARGET_ROOT}/${closure_bundle}" ]; then
  echo "state.yaml closure_bundle does not exist: ${TARGET_ROOT}/${closure_bundle}" >&2
  FAILURES=$((FAILURES + 1))
fi

current_slice_review="$(yaml_value "${WORKSPACE}/state.yaml" "current_slice_review")"
if [ -n "${current_slice_review}" ] && [ ! -f "${TARGET_ROOT}/${current_slice_review}" ]; then
  echo "state.yaml current_slice_review does not exist: ${TARGET_ROOT}/${current_slice_review}" >&2
  FAILURES=$((FAILURES + 1))
fi

current_slice_forensics="$(yaml_value "${WORKSPACE}/state.yaml" "current_slice_forensics")"
if [ -n "${current_slice_forensics}" ] && [ ! -f "${TARGET_ROOT}/${current_slice_forensics}" ]; then
  echo "state.yaml current_slice_forensics does not exist: ${TARGET_ROOT}/${current_slice_forensics}" >&2
  FAILURES=$((FAILURES + 1))
fi

defect_ledger="$(yaml_value "${WORKSPACE}/state.yaml" "defect_ledger")"
if [ -n "${defect_ledger}" ] && [ ! -f "${TARGET_ROOT}/${defect_ledger}" ]; then
  echo "state.yaml defect_ledger does not exist: ${TARGET_ROOT}/${defect_ledger}" >&2
  FAILURES=$((FAILURES + 1))
fi

seam_proof="$(yaml_value "${WORKSPACE}/state.yaml" "seam_proof")"
if [ -n "${seam_proof}" ] && [ ! -f "${TARGET_ROOT}/${seam_proof}" ]; then
  echo "state.yaml seam_proof does not exist: ${TARGET_ROOT}/${seam_proof}" >&2
  FAILURES=$((FAILURES + 1))
fi

workflow_adapter="$(yaml_value "${WORKSPACE}/state.yaml" "workflow_adapter")"
if [ -n "${workflow_adapter}" ] && [ ! -f "${TARGET_ROOT}/${workflow_adapter}" ]; then
  echo "state.yaml workflow_adapter does not exist: ${TARGET_ROOT}/${workflow_adapter}" >&2
  FAILURES=$((FAILURES + 1))
fi

active_work_item="$(yaml_value "${WORKSPACE}/state.yaml" "active_work_item")"
if [ -n "${active_work_item}" ] && [ ! -f "${TARGET_ROOT}/${active_work_item}" ]; then
  echo "state.yaml active_work_item does not exist: ${TARGET_ROOT}/${active_work_item}" >&2
  FAILURES=$((FAILURES + 1))
fi

workflow_events="$(yaml_value "${WORKSPACE}/state.yaml" "workflow_events")"
if [ -n "${workflow_events}" ] && [ ! -f "${TARGET_ROOT}/${workflow_events}" ]; then
  echo "state.yaml workflow_events does not exist: ${TARGET_ROOT}/${workflow_events}" >&2
  FAILURES=$((FAILURES + 1))
fi

workflow_work_items="$(yaml_value "${WORKSPACE}/state.yaml" "workflow_work_items")"
if [ -n "${workflow_work_items}" ] && [ ! -f "${TARGET_ROOT}/${workflow_work_items}" ]; then
  echo "state.yaml workflow_work_items does not exist: ${TARGET_ROOT}/${workflow_work_items}" >&2
  FAILURES=$((FAILURES + 1))
fi

workflow_topology="$(yaml_value "${WORKSPACE}/state.yaml" "workflow_topology")"
if [ -n "${workflow_topology}" ] && [ ! -f "${TARGET_ROOT}/${workflow_topology}" ]; then
  echo "state.yaml workflow_topology does not exist: ${TARGET_ROOT}/${workflow_topology}" >&2
  FAILURES=$((FAILURES + 1))
fi

for planning_ref in \
  ".accelerate/planning/user-story.md" \
  ".accelerate/planning/prd-lite.md" \
  ".accelerate/planning/sdd.md" \
  ".accelerate/planning/executive-plan.md" \
  ".accelerate/planning/task-breakdown.md"; do
  if ! grep -Fq "${planning_ref}" "${WORKSPACE}/planning/current-plan.md"; then
    echo "planning/current-plan.md is missing artifact reference: ${planning_ref}" >&2
    FAILURES=$((FAILURES + 1))
  fi
done

if [ "${FAILURES}" -ne 0 ]; then
  echo "V2 validation failed with ${FAILURES} error(s)." >&2
  exit 1
fi

echo "V2 validation passed for ${WORKSPACE}"
