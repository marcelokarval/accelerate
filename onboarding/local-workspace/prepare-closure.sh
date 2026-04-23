#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
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

"${SCRIPT_DIR}/sync-plan-status.sh" "${TARGET_ROOT}" >/dev/null

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"

if [ "${dashboard_verdict}" = "blocked" ]; then
  echo "cannot prepare closure while dashboard_verdict=blocked" >&2
  exit 1
fi

if [ "${review_readiness}" != "ready" ]; then
  "${SCRIPT_DIR}/reconcile-readiness.sh" \
    "${TARGET_ROOT}" \
    "review-ready" \
    "Prepared local closure surface by first reconciling review readiness" >/dev/null
fi

if [ "${closure_readiness}" != "ready" ]; then
  "${SCRIPT_DIR}/reconcile-readiness.sh" \
    "${TARGET_ROOT}" \
    "closure-ready" \
    "Prepared local closure surface from current readiness truth" >/dev/null
fi

"${SCRIPT_DIR}/persist-review-bundles.sh" "${TARGET_ROOT}" >/dev/null

"${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "prepare-closure:completed" \
  "Prepared local review artifacts, bundles, and closure handoff surface" \
  "info" \
  "prepare-closure.sh" >/dev/null

bash "${SCRIPT_DIR}/persist-runtime-packets.sh" "${TARGET_ROOT}" >/dev/null

echo "prepared local closure surface"
