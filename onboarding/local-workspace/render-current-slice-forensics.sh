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
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
runtime_delta_path="$(yaml_value "${STATE_FILE}" "runtime_delta_packet")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"

cat <<EOF
# Current Slice Forensics

- current phase: ${current_phase}
- closure readiness: ${closure_readiness}
- likely seam focus: derive from active slice and review packet family
- corrected-state proof posture: required when in-scope defects are fixed
- runtime delta packet: ${runtime_delta_path:-.accelerate/review/runtime-delta-packet.md}
- latest timeline event: ${last_event:-n/a}
- forensic recommendation: inspect requested-vs-implemented, defect ledger, and seam proof before closure
EOF
