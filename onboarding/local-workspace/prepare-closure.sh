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
STATE_FILE="${WORKSPACE}/state.yaml"

if [ ! -f "${READINESS_FILE}" ]; then
  echo "missing readiness dashboard: ${READINESS_FILE}" >&2
  exit 1
fi

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

profile=""
if [ -f "${STATE_FILE}" ]; then
  profile_count="$(grep -c -E '^materialization_profile[[:space:]]*:' "${STATE_FILE}" || true)"
  if [ "${profile_count}" -gt 1 ]; then
    echo "prepare-closure failed: duplicate materialization_profile keys in state file: ${STATE_FILE}" >&2
    exit 1
  fi
  if [ "${profile_count}" -eq 1 ]; then
    raw_val="$(sed -n 's/^materialization_profile:[[:space:]]*//p' "${STATE_FILE}" | head -n 1 | sed -e 's/[[:space:]]*#.*//')"
    profile="$(echo "${raw_val}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")"
    if [ -z "${profile}" ]; then
      echo "prepare-closure failed: blank or malformed materialization_profile in state file: ${STATE_FILE}" >&2
      exit 1
    fi
  fi
fi

if [ "${profile}" = "committed-dogfood-v2-index" ]; then
  exec bash "${SCRIPT_DIR}/prepare-dogfood-closure.sh" "${TARGET_ROOT}"
elif [ -n "${profile}" ] && [ "${profile}" != "full-v2" ]; then
  echo "prepare-closure failed: unknown or malformed materialization profile: ${profile}" >&2
  exit 1
fi

"${SCRIPT_DIR}/sync-plan-status.sh" "${TARGET_ROOT}" >/dev/null

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"

if [ "${dashboard_verdict}" = "blocked" ]; then
  echo "cannot prepare closure while dashboard_verdict=blocked" >&2
  exit 1
fi

if [ "${review_readiness}" != "ready" ]; then
  bash "${SCRIPT_DIR}/reconcile-readiness.sh" \
    "${TARGET_ROOT}" \
    "review-ready" \
    "Prepared local closure surface by first reconciling review readiness" >/dev/null
fi

if [ -f "${WORKSPACE}/workflow/active-work-item.yaml" ]; then
  active_work_item_id="$(sed -n 's/^id:[[:space:]]*//p' "${WORKSPACE}/workflow/active-work-item.yaml" | head -n 1)"
  if [ -n "${active_work_item_id}" ] && [ "${active_work_item_id}" != "none" ]; then
    bash "${SCRIPT_DIR}/transition-local-work-item.sh" \
      "${TARGET_ROOT}" \
      "closure" \
      "Prepared local closure surface" >/dev/null
  fi
fi

bash "${SCRIPT_DIR}/persist-review-artifacts.sh" "${TARGET_ROOT}" >/dev/null

perl -0pi -e "s#^ai_review_rendered:.*#ai_review_rendered: present#m" "${WORKSPACE}/status/evidence-registry.yaml"
perl -0pi -e "s#^ai_review_rendered_artifact:.*#ai_review_rendered_artifact: .accelerate/review/ai-review-report.md#m" "${WORKSPACE}/status/evidence-registry.yaml"
perl -0pi -e "s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKSPACE}/status/evidence-registry.yaml"

if [ "${closure_readiness}" != "ready" ]; then
  bash "${SCRIPT_DIR}/reconcile-readiness.sh" \
    "${TARGET_ROOT}" \
    "closure-ready" \
    "Prepared local closure surface from current readiness truth" >/dev/null
fi

bash "${SCRIPT_DIR}/persist-review-bundles.sh" "${TARGET_ROOT}" >/dev/null

bash "${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "prepare-closure:completed" \
  "Prepared local review artifacts, bundles, and closure handoff surface" \
  "info" \
  "prepare-closure.sh" >/dev/null

bash "${SCRIPT_DIR}/persist-runtime-packets.sh" "${TARGET_ROOT}" >/dev/null

echo "prepared local closure surface"
