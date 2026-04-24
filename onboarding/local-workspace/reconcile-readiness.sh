#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "usage: $0 /path/to/target-repo review-ready|closure-ready [summary]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
TARGET_STATE="$2"
SUMMARY="${3:-}"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "${READINESS_FILE}" ]; then
  echo "missing readiness dashboard: ${READINESS_FILE}" >&2
  exit 1
fi

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

append_list_item_if_missing() {
  local path="$1"
  local key="$2"
  local item="$3"
  if grep -Fq "  - ${item}" "${path}"; then
    return
  fi
  perl -0pi -e "s#^${key}:\n#${key}:\n  - ${item}\n#m" "${path}"
}

remove_blocking_item() {
  local path="$1"
  local item="$2"
  perl -0pi -e 's/^\s*-\s*\Q'"${item}"'\E\n//mg' "${path}"
}

current_execution="$(yaml_value "${READINESS_FILE}" "execution_readiness")"
current_review="$(yaml_value "${READINESS_FILE}" "review_readiness")"
current_closure="$(yaml_value "${READINESS_FILE}" "closure_readiness")"

case "${TARGET_STATE}" in
  review-ready)
    if [ "${current_execution}" != "ready" ]; then
      echo "cannot reconcile to review-ready before execution_readiness=ready" >&2
      exit 1
    fi
    bash "${SCRIPT_DIR}/check-evidence-gate.sh" "${TARGET_ROOT}" "review-ready" >/dev/null
    set_scalar "${READINESS_FILE}" "current_phase" "review"
    set_scalar "${READINESS_FILE}" "dashboard_verdict" "ready-for-review"
    set_scalar "${READINESS_FILE}" "review_readiness" "ready"
    append_list_item_if_missing "${READINESS_FILE}" "completed_gates" "qa-proof-lane"
    remove_blocking_item "${READINESS_FILE}" "qa-proof-lane still pending"
    ;;
  closure-ready)
    if [ "${current_execution}" != "ready" ] || [ "${current_review}" != "ready" ]; then
      echo "cannot reconcile to closure-ready before execution_readiness=ready and review_readiness=ready" >&2
      exit 1
    fi
    bash "${SCRIPT_DIR}/check-evidence-gate.sh" "${TARGET_ROOT}" "closure-ready" >/dev/null
    set_scalar "${READINESS_FILE}" "current_phase" "closure"
    set_scalar "${READINESS_FILE}" "dashboard_verdict" "ready-for-closure"
    set_scalar "${READINESS_FILE}" "closure_readiness" "ready"
    append_list_item_if_missing "${READINESS_FILE}" "completed_gates" "ai-review"
    remove_blocking_item "${READINESS_FILE}" "ai-review still pending"
    ;;
  *)
    echo "invalid target state: ${TARGET_STATE}" >&2
    exit 1
    ;;
esac

perl -0pi -e "s/^last_updated:.*/last_updated: $(date +%F)/m" "${READINESS_FILE}"

bash "${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "readiness:${TARGET_STATE}" \
  "${SUMMARY:-Reconciled readiness to ${TARGET_STATE}}" \
  "info" \
  "reconcile-readiness.sh" >/dev/null

echo "reconciled readiness to ${TARGET_STATE}"
