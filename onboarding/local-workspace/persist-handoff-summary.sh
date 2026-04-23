#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
HANDOFF_SUMMARY_FILE="${REVIEW_DIR}/handoff-summary.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${REVIEW_DIR}"

"${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "handoff-summary:persisted" \
  "Persisted local handoff summary from review and runtime packet surfaces" \
  "info" \
  "persist-handoff-summary.sh" >/dev/null

bash "${SCRIPT_DIR}/render-handoff-summary.sh" "${TARGET_ROOT}" > "${HANDOFF_SUMMARY_FILE}"

echo "persisted local handoff summary"
