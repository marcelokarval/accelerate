#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
AI_REVIEW_FILE="${REVIEW_DIR}/ai-review-report.md"
REVIEW_READY_FILE="${REVIEW_DIR}/review-ready-packet.md"
CLOSURE_FILE="${REVIEW_DIR}/closure-packet.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${REVIEW_DIR}"

"${SCRIPT_DIR}/render-ai-review-report.sh" "${TARGET_ROOT}" > "${AI_REVIEW_FILE}"
"${SCRIPT_DIR}/render-review-ready-packet.sh" "${TARGET_ROOT}" > "${REVIEW_READY_FILE}"
"${SCRIPT_DIR}/render-closure-packet.sh" "${TARGET_ROOT}" > "${CLOSURE_FILE}"

"${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "review-artifacts:persisted" \
  "Persisted local AI review report, review-ready packet, and closure packet" \
  "info" \
  "persist-review-artifacts.sh" >/dev/null

echo "persisted local review artifacts"
