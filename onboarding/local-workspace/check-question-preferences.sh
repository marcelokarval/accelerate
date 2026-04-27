#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/status/question-preferences.json"
[ -f "${file}" ] || { echo "missing question preferences: ${file}" >&2; exit 1; }
if grep -Eq '"door_type"[[:space:]]*:[[:space:]]*"one-way"' "${file}" && grep -Eq '"suppress"[[:space:]]*:[[:space:]]*true' "${file}"; then
  echo "question preferences cannot suppress one-way-door questions" >&2
  exit 1
fi
echo "question preferences passed"
