#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 6 ]; then
  echo "usage: $0 /path/to/target-repo type key insight source confidence" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
type="$2"
key="$3"
insight="$4"
source="$5"
confidence="$6"
json_escape() {
  printf '%s' "$1" | perl -MJSON::PP -0777 -ne 'print encode_json($_)' | sed 's/^"//; s/"$//'
}
case "${type}" in pattern|pitfall|preference|architecture|tool|operational|design-system|workflow) ;; *) echo "invalid learning type: ${type}" >&2; exit 1 ;; esac
case "${confidence}" in [1-9]|10) ;; *) echo "invalid confidence: ${confidence}" >&2; exit 1 ;; esac
trusted=false
[ "${source}" = "user-stated" ] && trusted=true
printf '{"ts":"%s","type":"%s","key":"%s","insight":"%s","source":"%s","confidence":%s,"trusted":%s}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${type}" "$(json_escape "${key}")" "$(json_escape "${insight}")" "$(json_escape "${source}")" "${confidence}" "${trusted}" \
  >> "${root}/.accelerate/status/learnings.jsonl"
