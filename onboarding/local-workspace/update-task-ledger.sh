#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo task_id status owner [proof]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
task_id="$2"
status="$3"
owner="$4"
proof="${5:-none}"
case "${status}" in pending|in_progress|blocked|implemented|under_review|needs_correction|reproof_required|accepted|closed) ;; *) echo "invalid task status: ${status}" >&2; exit 1 ;; esac
ledger="${root}/.accelerate/planning/task-ledger.md"
[ -f "${ledger}" ] || { echo "missing task ledger: ${ledger}" >&2; exit 1; }
printf '| %s | active | %s | %s | manual update | %s | required | open |\n' "${task_id}" "${status}" "${owner}" "${proof}" >> "${ledger}"
