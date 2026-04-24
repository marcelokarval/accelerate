#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"

if [ ! -f "${READINESS_FILE}" ]; then
  echo "missing required file: ${READINESS_FILE}" >&2
  exit 1
fi

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

current_phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
governing_artifact_path="$(yaml_value "${READINESS_FILE}" "governing_artifact_path")"
last_updated="$(date +%F)"

cat <<EOF
schema_version: 1
governing_artifact_path: ${governing_artifact_path}
current_phase: ${current_phase}
last_updated: ${last_updated}
defects: []
EOF
