#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ] || [ "$#" -gt 5 ]; then
  echo "usage: $0 /path/to/target-repo event summary [status] [source]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
EVENT="$2"
SUMMARY="$3"
STATUS="${4:-info}"
SOURCE="${5:-local-workspace}"
TIMELINE_FILE="${TARGET_ROOT}/.accelerate/status/timeline.jsonl"

if [ ! -f "${TIMELINE_FILE}" ]; then
  echo "missing timeline file: ${TIMELINE_FILE}" >&2
  exit 1
fi

json_escape() {
  printf '%s' "$1" | perl -0777 -pe 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g'
}

branch="$(git -C "${TARGET_ROOT}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || branch="unknown"

printf '{"ts":"%s","event":"%s","status":"%s","source":"%s","branch":"%s","summary":"%s"}\n' \
  "$(date -Iseconds)" \
  "$(json_escape "${EVENT}")" \
  "$(json_escape "${STATUS}")" \
  "$(json_escape "${SOURCE}")" \
  "$(json_escape "${branch}")" \
  "$(json_escape "${SUMMARY}")" \
  >> "${TIMELINE_FILE}"

echo "appended timeline event ${EVENT}"
