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

governing_artifact_path="$(yaml_value "${READINESS_FILE}" "governing_artifact_path")"
current_phase="$(yaml_value "${READINESS_FILE}" "current_phase")"

cat <<EOF
# Seam Proof

- current phase: ${current_phase}
- governing artifact: ${governing_artifact_path}
- seam verdict: not-yet-assessed
- evidence root: project-root/.tmp/seam-proof/
- note: use this surface when route-level proof is too coarse for the active slice
EOF
