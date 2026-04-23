#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
REVIEW_DIR="${WORKSPACE}/review"
PRE_REVIEW_FILE="${REVIEW_DIR}/pre-review-bundle.md"
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

mkdir -p "${REVIEW_DIR}"

"${SCRIPT_DIR}/sync-plan-status.sh" "${TARGET_ROOT}" >/dev/null

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"

if [ "${dashboard_verdict}" = "blocked" ]; then
  echo "cannot prepare review while dashboard_verdict=blocked" >&2
  exit 1
fi

if [ "${review_readiness}" != "ready" ]; then
  "${SCRIPT_DIR}/reconcile-readiness.sh" \
    "${TARGET_ROOT}" \
    "review-ready" \
    "Prepared local review surface from current plan and readiness truth" >/dev/null
fi

"${SCRIPT_DIR}/persist-review-artifacts.sh" "${TARGET_ROOT}" >/dev/null
"${SCRIPT_DIR}/render-pre-review-bundle.sh" "${TARGET_ROOT}" > "${PRE_REVIEW_FILE}"

"${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "prepare-review:completed" \
  "Prepared local review artifacts, pre-review bundle, and review handoff surface" \
  "info" \
  "prepare-review.sh" >/dev/null

bash "${SCRIPT_DIR}/persist-runtime-packets.sh" "${TARGET_ROOT}" >/dev/null
bash "${SCRIPT_DIR}/persist-handoff-summary.sh" "${TARGET_ROOT}" >/dev/null

echo "prepared local review surface"
