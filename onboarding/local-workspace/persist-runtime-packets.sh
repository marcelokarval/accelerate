#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
BRANCH_ENTRY_FILE="${REVIEW_DIR}/branch-entry-packet.md"
RUNTIME_DELTA_FILE="${REVIEW_DIR}/runtime-delta-packet.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${REVIEW_DIR}"

bash "${SCRIPT_DIR}/render-branch-entry-packet.sh" "${TARGET_ROOT}" > "${BRANCH_ENTRY_FILE}"
bash "${SCRIPT_DIR}/render-runtime-delta-packet.sh" "${TARGET_ROOT}" > "${RUNTIME_DELTA_FILE}"

"${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "runtime-packets:persisted" \
  "Persisted local branch entry packet and runtime delta packet" \
  "info" \
  "persist-runtime-packets.sh" >/dev/null

echo "persisted local runtime packets"
