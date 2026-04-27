#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [query]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
query="${2:-}"
file="${root}/.accelerate/status/learnings.jsonl"
[ -f "${file}" ] || { echo "missing learnings: ${file}" >&2; exit 1; }
if [ -z "${query}" ]; then
  awk 'NF {print}' "${file}"
else
  awk -v q="${query}" 'index($0, q) > 0 {print}' "${file}"
fi
