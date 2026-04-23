#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cat <<EOF
# Closure Bundle

## Closure Packet

$("${SCRIPT_DIR}/render-closure-packet.sh" "${TARGET_ROOT}" | sed '1{/^Closure Packet$/d;}')

## AI Review Report

$("${SCRIPT_DIR}/render-ai-review-report.sh" "${TARGET_ROOT}" | sed '1{/^## AI Review Report$/d;}')
EOF
