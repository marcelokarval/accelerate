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
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"

for required in "${READINESS_FILE}" "${TIMELINE_FILE}" "${PLAN_FILE}"; do
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

plan_value() {
  local key="$1"
  sed -n "s/^- ${key}:[[:space:]]*//p" "${PLAN_FILE}" | head -n 1
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

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
governing_path="$(plan_value "path")"
bounded_objective="$(plan_value "bounded objective")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"

cat <<EOF
Review-Ready Packet

- governing artifact: ${governing_path:-n/a}
- bounded objective: ${bounded_objective:-n/a}
- current phase: ${phase}
- dashboard verdict: ${dashboard_verdict}
- review readiness: ${review_readiness}
- closure readiness: ${closure_readiness}
- latest checkpoint: ${last_event:-n/a}
- next canonical local action: $(next_action_value "next_action")
- next action reason: $(next_action_value "reason")
- recommendation: $(if [ "${review_readiness}" = "ready" ] || [ "${closure_readiness}" = "ready" ]; then echo "ready-for-review"; else echo "not-ready"; fi)
EOF
