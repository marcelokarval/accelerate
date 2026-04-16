#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$1"
WORKSPACE="${TARGET_ROOT}/.accelerate"
FAILURES=0

required_files=(
  "${WORKSPACE}/README.md"
  "${WORKSPACE}/state.yaml"
  "${WORKSPACE}/onboarding/status.yaml"
  "${WORKSPACE}/onboarding/discovery.yaml"
  "${WORKSPACE}/onboarding/decisions.yaml"
  "${WORKSPACE}/onboarding/executive-bootstrap-plan.md"
  "${WORKSPACE}/planning/current-plan.md"
  "${WORKSPACE}/planning/review-ready.md"
  "${WORKSPACE}/planning/execution-log.md"
  "${WORKSPACE}/planning/open-questions.md"
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
require_key "${WORKSPACE}/state.yaml" "active_profile"
require_key "${WORKSPACE}/state.yaml" "active_runtime_adapters"
require_key "${WORKSPACE}/state.yaml" "agent_mode"
require_key "${WORKSPACE}/state.yaml" "current_plan"

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
require_enum "${WORKSPACE}/state.yaml" "active_profile" "unknown" "django-inertia-react" "nextjs-tailwind"
require_enum "${WORKSPACE}/state.yaml" "agent_mode" "root-only" "agent-eligible"
require_listish "${WORKSPACE}/state.yaml" "active_runtime_adapters"

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

if [ "${FAILURES}" -ne 0 ]; then
  echo "V2 validation failed with ${FAILURES} error(s)." >&2
  exit 1
fi

echo "V2 validation passed for ${WORKSPACE}"
