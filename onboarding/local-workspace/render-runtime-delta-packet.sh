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
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"

for required in "${STATE_FILE}" "${READINESS_FILE}" "${TIMELINE_FILE}" "${LEARNINGS_FILE}" "${PLAN_FILE}"; do
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

count_jsonl() {
  local path="$1"
  if [ ! -s "${path}" ]; then
    echo 0
    return
  fi
  grep -cve '^[[:space:]]*$' "${path}" || true
}

next_action_value() {
  local key="$1"
  local output
  output="$(bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suggest-next-local-action.sh" "${TARGET_ROOT}")"
  printf '%s\n' "${output}" | sed -n "s/^${key}=//p" | head -n 1
}

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"
reentry_status="$(yaml_value "${STATE_FILE}" "reentry_status")"
governing_path="$(plan_value "path")"
smallest_artifact="$(plan_value "smallest sufficient artifact")"
next_action="$(next_action_value "next_action")"

readiness_transition="n/a"
phase_transition="n/a"
local_action_transition="n/a"
qa_lane_transition="n/a"

case "${last_event}" in
  readiness:review-ready|prepare-review:completed)
    readiness_transition="ready-for-execution -> ready-for-review"
    phase_transition="execution -> review"
    local_action_transition="prepare-review -> prepare-closure"
    qa_lane_transition="ready-for-review-handoff -> review-active"
    ;;
  readiness:closure-ready|prepare-closure:completed)
    readiness_transition="ready-for-review -> ready-for-closure"
    phase_transition="review -> closure"
    local_action_transition="prepare-closure -> none"
    qa_lane_transition="review-active -> closure-active"
    ;;
  checkpoint:phase:execution)
    readiness_transition="blocked -> ready-for-execution"
    phase_transition="planning -> execution"
    local_action_transition="n/a -> prepare-review"
    qa_lane_transition="blocked -> ready-for-review-handoff"
    ;;
esac

learning_transition="n/a -> none"
if [ "$(count_jsonl "${LEARNINGS_FILE}")" -gt 0 ]; then
  learning_transition="n/a -> durably-registered"
fi

cat <<EOF
Runtime Delta Packet

- skills added: none
- skills removed: none
- ADRs / references added:
  - onboarding/local-workspace/README.md
- ADRs / references removed:
  - n/a
- gates opened: $(if [ "${next_action}" = "prepare-review" ] || [ "${next_action}" = "prepare-closure" ]; then echo "review/closure preparation"; else echo "none"; fi)
- gates passed: $(if [ "${dashboard_verdict}" = "ready-for-closure" ]; then echo "review-readiness, closure-readiness"; elif [ "${dashboard_verdict}" = "ready-for-review" ]; then echo "review-readiness"; elif [ "${dashboard_verdict}" = "ready-for-execution" ]; then echo "execution-readiness"; else echo "none"; fi)
- gates failed: $(if [ "${dashboard_verdict}" = "blocked" ]; then echo "readiness"; else echo "none"; fi)
- local workspace transition: unchanged -> ${reentry_status}
- readiness transition: ${readiness_transition}
- timeline checkpoint transition: n/a -> ${last_event:-n/a}
- learning disposition transition: ${learning_transition}
- local review / closure action transition: ${local_action_transition}
- persona transition: n/a
- phase transition: ${phase_transition}
- product/spec artifact transition: n/a -> ${smallest_artifact:-n/a}@${governing_path:-n/a}
- QA / proof lane transition: ${qa_lane_transition}
- browser-proof intensity transition: n/a
- issue stack transition: unchanged -> local-governed
EOF
