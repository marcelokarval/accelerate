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

for required in "${STATE_FILE}" "${READINESS_FILE}" "${TIMELINE_FILE}"; do
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

current_phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
governing_artifact_path="$(yaml_value "${READINESS_FILE}" "governing_artifact_path")"
dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
review_ready_path="$(yaml_value "${STATE_FILE}" "review_ready_packet")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"

cat <<EOF
# Current Slice Review

- current phase: ${current_phase}
- governing artifact: ${governing_artifact_path}
- dashboard verdict: ${dashboard_verdict}
- requested-vs-implemented packet: runtime packet family / active slice required
- review-ready packet: ${review_ready_path:-.accelerate/review/review-ready-packet.md}
- latest timeline event: ${last_event:-n/a}
- defect disposition: see .accelerate/review/defect-ledger.yaml
EOF
