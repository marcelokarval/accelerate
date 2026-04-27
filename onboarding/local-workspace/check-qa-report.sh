#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/review/qa-report.md"
[ -f "${file}" ] || { echo "missing QA report: ${file}" >&2; exit 1; }
for marker in "screenshots/captures" "console evidence" "network evidence" "ship readiness"; do
  if ! grep -Fq "${marker}" "${file}"; then
    echo "QA report missing marker: ${marker}" >&2
    exit 1
  fi
done
echo "QA report passed"
