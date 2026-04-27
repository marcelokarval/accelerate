#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo event phase summary [artifact]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
event="$2"
phase="$3"
summary="$4"
artifact="${5:-none}"
json_escape() {
  printf '%s' "$1" | perl -MJSON::PP -0777 -ne 'print encode_json($_)' | sed 's/^"//; s/"$//'
}
mkdir -p "${root}/.accelerate/status"
printf '{"ts":"%s","event":"%s","phase":"%s","summary":"%s","artifact":"%s"}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(json_escape "${event}")" "$(json_escape "${phase}")" "$(json_escape "${summary}")" "$(json_escape "${artifact}")" \
  >> "${root}/.accelerate/status/timeline.jsonl"
