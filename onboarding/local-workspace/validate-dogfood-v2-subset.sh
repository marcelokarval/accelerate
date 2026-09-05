#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$1"
WORKSPACE="${TARGET_ROOT}/.accelerate"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
FAILURES=0

fail() {
  printf 'validate-dogfood-v2-subset failed: %s\n' "$1" >&2
  exit 1
}

record_failure() {
  printf 'validate-dogfood-v2-subset failed: %s\n' "$1" >&2
  FAILURES=$((FAILURES + 1))
}

require_file() {
  local path="$1"
  if [ ! -f "${path}" ]; then
    record_failure "missing ${path#${TARGET_ROOT}/}"
  fi
}

require_tracked() {
  local rel_path="$1"
  if ! git -C "${TARGET_ROOT}" ls-files --error-unmatch "${rel_path}" >/dev/null 2>&1; then
    record_failure "required dogfood path is not tracked: ${rel_path}"
  fi
}

require_marker() {
  local marker="$1"
  if ! grep -R --line-number --fixed-strings "${marker}" "${subset_files[@]}" >/dev/null; then
    record_failure "missing marker ${marker}"
  fi
}

require_key() {
  local path="$1"
  local key="$2"
  if [ ! -f "${path}" ] || ! grep -Eq "^${key}:" "${path}"; then
    record_failure "missing required key '${key}' in ${path#${TARGET_ROOT}/}"
  fi
}

require_exact_value() {
  local path="$1"
  local key="$2"
  local expected="$3"
  local actual
  actual="$(sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1)"
  if [ "${actual}" != "${expected}" ]; then
    record_failure "unexpected value for '${key}' in ${path#${TARGET_ROOT}/}: expected '${expected}', got '${actual}'"
  fi
}

require_enum() {
  local path="$1"
  local key="$2"
  shift 2
  local actual
  actual="$(sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1)"
  for allowed in "$@"; do
    if [ "${actual}" = "${allowed}" ]; then
      return
    fi
  done
  record_failure "unexpected value for '${key}' in ${path#${TARGET_ROOT}/}: ${actual}"
}

if [ ! -d "${TARGET_ROOT}" ]; then
  fail "target repo does not exist: ${TARGET_ROOT}"
fi

if ! git -C "${TARGET_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  fail "target repo is not a git worktree: ${TARGET_ROOT}"
fi

if [ ! -d "${WORKSPACE}" ]; then
  fail "missing .accelerate workspace: ${WORKSPACE}"
fi

required_rel_files=(
  ".accelerate/state.yaml"
  ".accelerate/workflow/adapter.yaml"
  ".accelerate/workflow/active-work-item.yaml"
  ".accelerate/status/readiness-dashboard.yaml"
  ".accelerate/README.md"
  ".accelerate/workflow/README.md"
)

subset_files=()
for rel_path in "${required_rel_files[@]}"; do
  abs_path="${TARGET_ROOT}/${rel_path}"
  require_file "${abs_path}"
  require_tracked "${rel_path}"
  subset_files+=("${abs_path}")
done

state="${WORKSPACE}/state.yaml"
adapter="${WORKSPACE}/workflow/adapter.yaml"
active_work_item="${WORKSPACE}/workflow/active-work-item.yaml"
readiness="${WORKSPACE}/status/readiness-dashboard.yaml"

require_key "${state}" "schema_version"
require_key "${state}" "kind"
require_key "${state}" "materialization_profile"
require_key "${state}" "v2_contract_decision"
require_key "${state}" "project_onboarded"
require_key "${state}" "onboarding_status"
require_key "${state}" "reentry_status"
require_key "${state}" "workflow_backend"
require_key "${state}" "workflow_backend_detected"
require_key "${state}" "active_runtime_adapters"
require_key "${state}" "agent_mode"
require_key "${state}" "current_plan"
require_key "${state}" "current_task_ledger"
require_key "${state}" "current_authority_receipt"
require_key "${state}" "current_authority_digest"
require_key "${state}" "readiness_dashboard"
require_key "${state}" "workflow_adapter"
require_key "${state}" "active_work_item"
require_key "${state}" "last_accepted_cycle"
require_key "${state}" "last_accepted_status"
require_key "${state}" "secret_policy"
require_key "${state}" "generated_private_boundary"

require_exact_value "${state}" "schema_version" "1"
require_exact_value "${state}" "kind" "accelerate-dogfood-state-index"
require_exact_value "${state}" "materialization_profile" "committed-dogfood-v2-index"
require_exact_value "${state}" "v2_contract_decision" "materialize-summary-index-and-local-workflow-adapter; keep generated/private proof outputs ignored"
require_enum "${state}" "project_onboarded" "true" "false"
require_enum "${state}" "onboarding_status" "not_started" "in_progress" "partially_stabilized" "completed" "partial-reonboarding"
require_enum "${state}" "reentry_status" "clean" "light_reentry" "partial_reonboarding" "partial-reonboarding" "structural_reonboarding"
require_enum "${state}" "workflow_backend" "none-yet" "github" "linear" "plane"
require_enum "${state}" "workflow_backend_detected" "none-yet" "github" "linear" "plane"
require_enum "${state}" "agent_mode" "root-only" "agent-eligible"
require_exact_value "${state}" "readiness_dashboard" ".accelerate/status/readiness-dashboard.yaml"
require_exact_value "${state}" "workflow_adapter" ".accelerate/workflow/adapter.yaml"
require_exact_value "${state}" "active_work_item" ".accelerate/workflow/active-work-item.yaml"
require_enum "${state}" "last_accepted_status" "accepted" "historical-accepted"

require_key "${adapter}" "schema_version"
require_key "${adapter}" "kind"
require_key "${adapter}" "adapter"
require_key "${adapter}" "adapter_status"
require_key "${adapter}" "remote_workflow_backend"
require_key "${adapter}" "host_authenticated_workflow_surface"
require_key "${adapter}" "active_work_item_id"
require_key "${adapter}" "active_work_item_locator"
require_key "${adapter}" "last_event_id"
require_key "${adapter}" "last_updated"
require_key "${adapter}" "boundary"

require_exact_value "${adapter}" "schema_version" "1"
require_exact_value "${adapter}" "kind" "accelerate-dogfood-workflow-adapter"
require_exact_value "${adapter}" "adapter" "local"
require_enum "${adapter}" "adapter_status" "initialized" "active" "blocked"
require_exact_value "${adapter}" "active_work_item_locator" ".accelerate/workflow/active-work-item.yaml"

require_key "${active_work_item}" "schema_version"
require_key "${active_work_item}" "kind"
require_key "${active_work_item}" "id"
require_key "${active_work_item}" "status"
require_key "${active_work_item}" "classification"
require_key "${active_work_item}" "execution_model"
require_key "${active_work_item}" "root_orchestrator"
require_key "${active_work_item}" "plan"
require_key "${active_work_item}" "ledger"
require_key "${active_work_item}" "provider_boundary"
require_key "${active_work_item}" "remote_calls_allowed"
require_key "${active_work_item}" "secret_policy"
require_key "${active_work_item}" "generated_private_outputs"
require_key "${active_work_item}" "proof_commands"
require_key "${active_work_item}" "next_queue_source"

require_exact_value "${active_work_item}" "schema_version" "1"
require_exact_value "${active_work_item}" "kind" "accelerate-local-dogfood-active-work-item"
require_enum "${active_work_item}" "status" "accepted" "in-progress"
require_exact_value "${active_work_item}" "remote_calls_allowed" "false"

require_key "${readiness}" "schema_version"
require_key "${readiness}" "kind"
require_key "${readiness}" "cycle"
require_key "${readiness}" "plan"
require_key "${readiness}" "ledger"
require_key "${readiness}" "status"
require_key "${readiness}" "entries"
require_key "${readiness}" "residuals"

require_exact_value "${readiness}" "schema_version" "1"
require_exact_value "${readiness}" "kind" "accelerate-local-dogfood-readiness-dashboard"
require_enum "${readiness}" "status" "accepted" "implementing-not-accepted"

state_active_work_item="$(sed -n 's/^active_work_item:[[:space:]]*//p' "${state}" | head -n 1)"
adapter_active_work_item_locator="$(sed -n 's/^active_work_item_locator:[[:space:]]*//p' "${adapter}" | head -n 1)"
if [ "${state_active_work_item}" != "${adapter_active_work_item_locator}" ]; then
  record_failure "state active_work_item (${state_active_work_item}) does not match adapter active_work_item_locator (${adapter_active_work_item_locator})"
fi

state_last_cycle="$(sed -n 's/^last_accepted_cycle:[[:space:]]*//p' "${state}" | head -n 1)"
adapter_work_item_id="$(sed -n 's/^active_work_item_id:[[:space:]]*//p' "${adapter}" | head -n 1)"
if [ "${state_last_cycle}" != "${adapter_work_item_id}" ]; then
  record_failure "state last_accepted_cycle (${state_last_cycle}) does not match adapter active_work_item_id (${adapter_work_item_id})"
fi

# Run authority validator (fail closed)
AUTH_VALIDATOR="${REPO_ROOT}/scripts/validate-dogfood-current-authority.py"
if [ ! -f "${AUTH_VALIDATOR}" ]; then
  record_failure "missing required authority validator: ${AUTH_VALIDATOR}"
else
  if ! python3 "${AUTH_VALIDATOR}" --root "${TARGET_ROOT}" 2>&1; then
    record_failure "authority binding or consistency failure"
  fi
fi

for marker in \
  "planning/executive/2026-05-08-linear-oauth-runtime-proof-executive-plan.md" \
  "planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md" \
  "P4Y-1298" \
  "P4Y-1302" \
  "linear-oauth-runtime-proof-2026-05-08-rc24-rc27" \
  "v2_contract_decision: materialize-summary-index-and-local-workflow-adapter" \
  "adapter: local" \
  "Last Accepted Dogfood Cycle" \
  "planning/executive/2026-05-08-recursive-cycle-18-22-executive-plan.md" \
  "planning/executive/2026-05-08-recursive-cycle-18-22-task-ledger.md" \
  "root orchestrator" \
  "bounded subagent" \
  "generated/private" \
  "no secrets"; do
  require_marker "${marker}"
done

for path_ref in \
  "$(sed -n 's/^current_plan:[[:space:]]*//p' "${state}" | head -n 1)" \
  "$(sed -n 's/^current_task_ledger:[[:space:]]*//p' "${state}" | head -n 1)" \
  "$(sed -n 's/^plan:[[:space:]]*//p' "${active_work_item}" | head -n 1)" \
  "$(sed -n 's/^ledger:[[:space:]]*//p' "${active_work_item}" | head -n 1)" \
  "$(sed -n 's/^plan:[[:space:]]*//p' "${readiness}" | head -n 1)" \
  "$(sed -n 's/^ledger:[[:space:]]*//p' "${readiness}" | head -n 1)"; do
  if [ -n "${path_ref}" ] && [ ! -f "${TARGET_ROOT}/${path_ref}" ]; then
    record_failure "referenced governing artifact does not exist: ${path_ref}"
  fi
done

secret_regex='(sk_live|sk_test|pk_live|xox[baprs]-|ghp_[A-Za-z0-9_]+|github_pat_|LINEAR_API_KEY|Authorization: Bearer|BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY)'
if grep -E --line-number "${secret_regex}" "${subset_files[@]}" >/tmp/accelerate-dogfood-v2-subset-secret-scan.out 2>/dev/null; then
  cat /tmp/accelerate-dogfood-v2-subset-secret-scan.out >&2
  record_failure "committed dogfood V2 subset contains a secret-like marker"
fi
rm -f /tmp/accelerate-dogfood-v2-subset-secret-scan.out

if grep -R --line-number -E '^status:[[:space:]]*active$' "${state}" "${readiness}" "${adapter}" "${active_work_item}" >/tmp/accelerate-dogfood-v2-subset-active-status.out 2>/dev/null; then
  cat /tmp/accelerate-dogfood-v2-subset-active-status.out >&2
  record_failure "accepted dogfood cycle drifted back to active status"
fi
rm -f /tmp/accelerate-dogfood-v2-subset-active-status.out

if [ "${FAILURES}" -gt 0 ]; then
  exit 1
fi

printf 'dogfood V2 subset validator passed\n'
