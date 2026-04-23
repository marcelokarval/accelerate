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
LEARNINGS_FILE="${WORKSPACE}/status/learnings.jsonl"
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"

for required in "${READINESS_FILE}" "${TIMELINE_FILE}" "${LEARNINGS_FILE}" "${PLAN_FILE}"; do
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

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
execution_readiness="$(yaml_value "${READINESS_FILE}" "execution_readiness")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
bounded_objective="$(plan_value "bounded objective")"
governing_path="$(plan_value "path")"
smallest_artifact="$(plan_value "smallest sufficient artifact")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"
learning_count="$(count_jsonl "${LEARNINGS_FILE}")"
last_learning_key="$(last_jsonl_field "${LEARNINGS_FILE}" "key")"

classification="partial"
status_recommendation="In Review"
if [ "${closure_readiness}" = "ready" ]; then
  classification="exact"
  status_recommendation="Done"
elif [ "${review_readiness}" = "ready" ]; then
  classification="drifted-but-complete"
  status_recommendation="In Review"
elif [ "${execution_readiness}" = "ready" ]; then
  classification="partial"
  status_recommendation="In Progress"
fi

cat <<EOF
## AI Review Report

### Requested vs Implemented

- requested: ${bounded_objective:-n/a}
- implemented: local status-backed execution state derived from ${governing_path:-n/a}

### Promised vs Delivered

- smallest sufficient artifact: ${smallest_artifact:-n/a}
- dashboard verdict: ${dashboard_verdict}
- execution readiness: ${execution_readiness}
- review readiness: ${review_readiness}
- closure readiness: ${closure_readiness}

### Evidence

- governing artifact: ${governing_path:-n/a}
- last timeline event: ${last_event:-n/a}
- durable learning count: ${learning_count}
- last learning key: ${last_learning_key:-n/a}

### Classification

- classification: ${classification}
- status recommendation: ${status_recommendation}

### Residuals / Omissions

- if readiness is below closure-ready, remaining blockers still exist outside this synthesized review
- if learning_count > 0, confirm whether the last learning already has a stronger durable home than local JSONL
EOF
