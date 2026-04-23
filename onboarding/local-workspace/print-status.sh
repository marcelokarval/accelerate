#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
STATE_FILE="${WORKSPACE}/state.yaml"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
TIMELINE_FILE="${WORKSPACE}/status/timeline.jsonl"
LEARNINGS_FILE="${WORKSPACE}/status/learnings.jsonl"

for required in "${STATE_FILE}" "${READINESS_FILE}" "${TIMELINE_FILE}" "${LEARNINGS_FILE}"; do
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

count_jsonl() {
  local path="$1"
  if [ ! -s "${path}" ]; then
    echo 0
    return
  fi
  grep -cve '^[[:space:]]*$' "${path}" || true
}

last_jsonl_field() {
  local path="$1"
  local key="$2"
  if [ ! -s "${path}" ]; then
    return
  fi
  (grep -ve '^[[:space:]]*$' "${path}" | tail -n 1 | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p") || true
}

next_action_value() {
  local key="$1"
  local output
  output="$(bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suggest-next-local-action.sh" "${TARGET_ROOT}")"
  printf '%s\n' "${output}" | sed -n "s/^${key}=//p" | head -n 1
}

printf 'Accelerate Local Status\n\n'
printf 'workspace: %s\n' "${WORKSPACE}"
printf 'onboarding_status: %s\n' "$(yaml_value "${STATE_FILE}" "onboarding_status")"
printf 'reentry_status: %s\n' "$(yaml_value "${STATE_FILE}" "reentry_status")"
printf 'workflow_backend: %s\n' "$(yaml_value "${STATE_FILE}" "workflow_backend")"
printf 'active_profile: %s\n' "$(yaml_value "${STATE_FILE}" "active_profile")"
printf 'current_phase: %s\n' "$(yaml_value "${READINESS_FILE}" "current_phase")"
printf 'dashboard_verdict: %s\n' "$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
printf 'execution_readiness: %s\n' "$(yaml_value "${READINESS_FILE}" "execution_readiness")"
printf 'review_readiness: %s\n' "$(yaml_value "${READINESS_FILE}" "review_readiness")"
printf 'closure_readiness: %s\n' "$(yaml_value "${READINESS_FILE}" "closure_readiness")"
printf 'timeline_events: %s\n' "$(count_jsonl "${TIMELINE_FILE}")"
printf 'last_timeline_event: %s\n' "$(last_jsonl_field "${TIMELINE_FILE}" "event")"
printf 'learning_count: %s\n' "$(count_jsonl "${LEARNINGS_FILE}")"
printf 'last_learning_key: %s\n' "$(last_jsonl_field "${LEARNINGS_FILE}" "key")"
printf 'next_canonical_local_action: %s\n' "$(next_action_value "next_action")"
printf 'next_action_reason: %s\n' "$(next_action_value "reason")"
