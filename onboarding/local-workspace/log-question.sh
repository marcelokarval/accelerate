#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 5 ]; then
  echo "usage: $0 /path/to/target-repo question_id category door_type selected_option source" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
shift
question_id="$1"
category="$2"
door_type="$3"
selected_option="$4"
source="$5"

json_escape() {
  printf '%s' "$1" | perl -MJSON::PP -0777 -ne 'print encode_json($_)' | sed 's/^"//; s/"$//'
}

case "${door_type}" in one-way|two-way) ;; *) echo "invalid door_type: ${door_type}" >&2; exit 1 ;; esac
mkdir -p "${root}/.accelerate/status"
printf '{"ts":"%s","question_id":"%s","category":"%s","door_type":"%s","selected_option":"%s","source":"%s"}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(json_escape "${question_id}")" "$(json_escape "${category}")" "${door_type}" "$(json_escape "${selected_option}")" "$(json_escape "${source}")" \
  >> "${root}/.accelerate/status/questions.jsonl"
