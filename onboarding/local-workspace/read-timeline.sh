#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/status/timeline.jsonl"
[ -f "${file}" ] || { echo "missing timeline: ${file}" >&2; exit 1; }
if [ ! -s "${file}" ]; then
  echo "timeline empty"
else
  while IFS= read -r line; do
    [ -n "${line}" ] || continue
    case "${line}" in \{*\}) printf '%s\n' "${line}" ;; *) echo "invalid timeline jsonl line: ${line}" >&2; exit 1 ;; esac
  done < "${file}"
fi
