#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
HANDOFF_SUMMARY_FILE="${WORKSPACE}/review/handoff-summary.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "${WORKSPACE}" ]; then
  echo "missing .accelerate workspace: ${WORKSPACE}" >&2
  exit 1
fi

if [ -f "${HANDOFF_SUMMARY_FILE}" ] && grep -q "^## Status$" "${HANDOFF_SUMMARY_FILE}"; then
  cat "${HANDOFF_SUMMARY_FILE}"
  exit 0
fi

cat <<EOF
# Handoff Summary

## Status

- source: fallback local status
- reason: persisted handoff summary is not materialized yet

## Fallback Local Status

EOF

bash "${SCRIPT_DIR}/print-status.sh" "${TARGET_ROOT}"
