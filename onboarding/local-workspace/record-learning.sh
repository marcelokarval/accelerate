#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ] || [ "$#" -gt 6 ]; then
  echo "usage: $0 /path/to/target-repo type key insight [source] [confidence]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
TYPE="$2"
KEY="$3"
INSIGHT="$4"
SOURCE="${5:-observed}"
CONFIDENCE="${6:-7}"
LEARNINGS_FILE="${TARGET_ROOT}/.accelerate/status/learnings.jsonl"

if [ ! -f "${LEARNINGS_FILE}" ]; then
  echo "missing learnings file: ${LEARNINGS_FILE}" >&2
  exit 1
fi

json_escape() {
  printf '%s' "$1" | perl -0777 -pe 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g'
}

branch="$(git -C "${TARGET_ROOT}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || branch="unknown"
commit="$(git -C "${TARGET_ROOT}" rev-parse --short HEAD 2>/dev/null || true)"
[ -n "${commit}" ] || commit="unknown"

printf '{"ts":"%s","type":"%s","key":"%s","insight":"%s","source":"%s","confidence":%s,"branch":"%s","commit":"%s"}\n' \
  "$(date -Iseconds)" \
  "$(json_escape "${TYPE}")" \
  "$(json_escape "${KEY}")" \
  "$(json_escape "${INSIGHT}")" \
  "$(json_escape "${SOURCE}")" \
  "${CONFIDENCE}" \
  "$(json_escape "${branch}")" \
  "$(json_escape "${commit}")" \
  >> "${LEARNINGS_FILE}"

"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "learning_recorded" \
  "Recorded learning ${KEY}" \
  "info" \
  "record-learning.sh" >/dev/null

echo "recorded learning ${KEY}"
