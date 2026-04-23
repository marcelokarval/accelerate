#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
DISCOVERY_FILE="${WORKSPACE}/onboarding/discovery.yaml"
DECISIONS_FILE="${WORKSPACE}/onboarding/decisions.yaml"
STATE_FILE="${WORKSPACE}/state.yaml"
STATUS_FILE="${WORKSPACE}/onboarding/status.yaml"

for required in "${DISCOVERY_FILE}" "${DECISIONS_FILE}" "${STATE_FILE}" "${STATUS_FILE}"; do
  if [ ! -f "${required}" ]; then
    echo "missing required file: ${required}" >&2
    exit 1
  fi
done

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

list_contains() {
  local listish="$1"
  local needle="$2"
  printf '%s' "${listish}" | grep -Fq "${needle}"
}

set_scalar() {
  local path="$1"
  local key="$2"
  local value="$3"
  perl -0pi -e "s#^${key}:.*#${key}: ${value}#m" "${path}"
}

framework_signals="$(yaml_value "${DISCOVERY_FILE}" "framework_signals")"
workflow_tool_signals="$(yaml_value "${DISCOVERY_FILE}" "workflow_tool_signals")"
docs_posture_signals="$(yaml_value "${DISCOVERY_FILE}" "docs_posture_signals")"
proof_runtime_signals="$(yaml_value "${DISCOVERY_FILE}" "proof_runtime_signals")"
package_manager_signals="$(yaml_value "${DISCOVERY_FILE}" "package_manager_signals")"
repo_notes="$(yaml_value "${DISCOVERY_FILE}" "repo_notes")"

selected_profile="unknown"
selected_workflow_backend="none-yet"
selected_runtime_posture="[]"
selected_docs_posture="default"
reentry_status="clean"

if list_contains "${framework_signals}" "django" && list_contains "${framework_signals}" "inertia" && list_contains "${framework_signals}" "react"; then
  selected_profile="django-inertia-react"
elif list_contains "${framework_signals}" "nextjs" && list_contains "${framework_signals}" "tailwind"; then
  selected_profile="nextjs-tailwind"
fi

if list_contains "${workflow_tool_signals}" "github"; then
  selected_workflow_backend="github"
elif list_contains "${workflow_tool_signals}" "linear-signal"; then
  selected_workflow_backend="linear"
fi

runtime_items=()
if [ -f "${TARGET_ROOT}/package.json" ]; then
  runtime_items+=("'node'")
fi
if list_contains "${package_manager_signals}" "uv" || [ -f "${TARGET_ROOT}/pyproject.toml" ] || [ -f "${TARGET_ROOT}/manage.py" ]; then
  runtime_items+=("'python-uv'")
fi
if list_contains "${framework_signals}" "react" || list_contains "${framework_signals}" "nextjs" || list_contains "${repo_notes}" "frontend-surface"; then
  runtime_items+=("'chrome-devtools'")
fi
if list_contains "${proof_runtime_signals}" "playwright"; then
  runtime_items+=("'playwright'")
fi

if [ "${#runtime_items[@]}" -gt 0 ]; then
  selected_runtime_posture="[$(IFS=', '; echo "${runtime_items[*]}")]"
fi

if list_contains "${docs_posture_signals}" "docs-dir" || list_contains "${docs_posture_signals}" "mkdocs" || list_contains "${docs_posture_signals}" "docusaurus"; then
  selected_docs_posture="custom"
fi

set_scalar "${DECISIONS_FILE}" "selected_workflow_backend" "${selected_workflow_backend}"
set_scalar "${DECISIONS_FILE}" "selected_profile" "${selected_profile}"
set_scalar "${DECISIONS_FILE}" "selected_runtime_posture" "${selected_runtime_posture}"
set_scalar "${DECISIONS_FILE}" "selected_docs_posture" "${selected_docs_posture}"

set_scalar "${STATE_FILE}" "workflow_backend" "${selected_workflow_backend}"
set_scalar "${STATE_FILE}" "active_profile" "${selected_profile}"
set_scalar "${STATE_FILE}" "active_runtime_adapters" "${selected_runtime_posture}"

set_scalar "${STATE_FILE}" "project_onboarded" "true"
set_scalar "${STATE_FILE}" "onboarding_status" "partially_stabilized"
set_scalar "${STATUS_FILE}" "status" "partially_stabilized"

current_reentry_status="$(yaml_value "${STATUS_FILE}" "reentry_status")"
if [ "${current_reentry_status}" = "not_started" ] || [ -z "${current_reentry_status}" ]; then
  reentry_status="clean"
else
  reentry_status="${current_reentry_status}"
fi
set_scalar "${STATE_FILE}" "reentry_status" "${reentry_status}"
set_scalar "${STATUS_FILE}" "reentry_status" "${reentry_status}"

perl -0pi -e "s/^last_bootstrap_update:.*/last_bootstrap_update: $(date +%F)/m" "${STATE_FILE}"
perl -0pi -e "s/^last_updated:.*/last_updated: $(date +%F)/m" "${STATUS_FILE}"

echo "classified project into profile=${selected_profile} workflow_backend=${selected_workflow_backend}"
