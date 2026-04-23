#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
TIMELINE_FILE="${WORKSPACE}/status/timeline.jsonl"

for required in "${READINESS_FILE}" "${TIMELINE_FILE}"; do
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

last_jsonl_field() {
  local path="$1"
  local key="$2"
  if [ ! -s "${path}" ]; then
    return
  fi
  (grep -ve '^[[:space:]]*$' "${path}" | tail -n 1 | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p") || true
}

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
execution_readiness="$(yaml_value "${READINESS_FILE}" "execution_readiness")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"

next_action="blocked"
reason="dashboard still blocked"

if [ "${closure_readiness}" = "ready" ]; then
  next_action="none"
  reason="closure already prepared"
elif [ "${review_readiness}" = "ready" ]; then
  next_action="prepare-closure"
  reason="review-ready state is active and closure is not yet prepared"
elif [ "${execution_readiness}" = "ready" ] && [ "${dashboard_verdict}" != "blocked" ]; then
  next_action="prepare-review"
  reason="execution-ready state is active and review is the next honest handoff"
fi

if [ "${next_action}" = "prepare-review" ] && [ "${last_event}" = "prepare-review:completed" ]; then
  next_action="prepare-closure"
  reason="review surface already prepared and closure is the next honest handoff"
fi

if [ "${next_action}" = "prepare-closure" ] && [ "${last_event}" = "prepare-closure:completed" ]; then
  next_action="none"
  reason="closure surface already prepared"
fi

printf 'next_action=%s\n' "${next_action}"
printf 'reason=%s\n' "${reason}"
