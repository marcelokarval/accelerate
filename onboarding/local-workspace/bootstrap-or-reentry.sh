#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [greenfield|adoption]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"
MODE="${2:-}"
WORKSPACE="${TARGET_ROOT}/.accelerate"
STATE_FILE="${WORKSPACE}/state.yaml"
STATUS_FILE="${WORKSPACE}/onboarding/status.yaml"
DECISIONS_FILE="${WORKSPACE}/onboarding/decisions.yaml"

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

set_scalar() {
  local path="$1"
  local key="$2"
  local value="$3"
  perl -0pi -e "s#^${key}:.*#${key}: ${value}#m" "${path}"
}

if [ ! -d "${TARGET_ROOT}" ]; then
  echo "target repo does not exist: ${TARGET_ROOT}" >&2
  exit 1
fi

if [ ! -d "${WORKSPACE}" ]; then
  "${SCRIPT_DIR}/emit-v2.sh" "${TARGET_ROOT}" "${MODE:+${MODE}}"
  exit 0
fi

old_workflow_backend="$(yaml_value "${DECISIONS_FILE}" "selected_workflow_backend")"
old_profile="$(yaml_value "${DECISIONS_FILE}" "selected_profile")"
old_runtime_posture="$(yaml_value "${DECISIONS_FILE}" "selected_runtime_posture")"
old_docs_posture="$(yaml_value "${DECISIONS_FILE}" "selected_docs_posture")"

"${SCRIPT_DIR}/detect-signals.sh" "${TARGET_ROOT}" >/dev/null
"${SCRIPT_DIR}/classify-project.sh" "${TARGET_ROOT}" >/dev/null

new_workflow_backend="$(yaml_value "${DECISIONS_FILE}" "selected_workflow_backend")"
new_profile="$(yaml_value "${DECISIONS_FILE}" "selected_profile")"
new_runtime_posture="$(yaml_value "${DECISIONS_FILE}" "selected_runtime_posture")"
new_docs_posture="$(yaml_value "${DECISIONS_FILE}" "selected_docs_posture")"

reentry_status="clean"

if [ "${old_profile}" != "${new_profile}" ] || [ "${old_workflow_backend}" != "${new_workflow_backend}" ] || [ "${old_runtime_posture}" != "${new_runtime_posture}" ]; then
  reentry_status="structural_reonboarding"
elif [ "${old_docs_posture}" != "${new_docs_posture}" ]; then
  reentry_status="partial_reonboarding"
elif [ "${old_profile}" = "${new_profile}" ] && [ "${old_workflow_backend}" = "${new_workflow_backend}" ] && [ "${old_runtime_posture}" = "${new_runtime_posture}" ] && [ "${old_docs_posture}" = "${new_docs_posture}" ]; then
  reentry_status="light_reentry"
fi

set_scalar "${STATUS_FILE}" "reentry_status" "${reentry_status}"
set_scalar "${STATE_FILE}" "reentry_status" "${reentry_status}"
set_scalar "${STATUS_FILE}" "status" "partially_stabilized"
set_scalar "${STATE_FILE}" "onboarding_status" "partially_stabilized"
perl -0pi -e "s/^last_updated:.*/last_updated: $(date +%F)/m" "${STATUS_FILE}"
perl -0pi -e "s/^last_bootstrap_update:.*/last_bootstrap_update: $(date +%F)/m" "${STATE_FILE}"

"${SCRIPT_DIR}/validate-v2.sh" "${TARGET_ROOT}" >/dev/null

echo "reconciled local workspace at:"
echo "  ${WORKSPACE}"
echo "reentry_status: ${reentry_status}"
echo "profile: ${new_profile}"
echo "workflow_backend: ${new_workflow_backend}"
