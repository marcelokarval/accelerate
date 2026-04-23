#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ] || [ "$#" -gt 5 ]; then
  echo "usage: $0 /path/to/target-repo checkpoint summary [status] [source]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
CHECKPOINT="$2"
SUMMARY="$3"
STATUS="${4:-info}"
SOURCE="${5:-mark-checkpoint.sh}"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "checkpoint:${CHECKPOINT}" \
  "${SUMMARY}" \
  "${STATUS}" \
  "${SOURCE}" >/dev/null

echo "marked checkpoint ${CHECKPOINT}"
