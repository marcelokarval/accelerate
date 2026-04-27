#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 8 ]; then
  echo "usage: $0 /path/to/target-repo finding_id fingerprint severity confidence category classification summary evidence [recommended_fix] [reviewer]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
finding_id="$2"
fingerprint="$3"
severity="$4"
confidence="$5"
category="$6"
classification="$7"
summary="$8"
evidence="${9:-none}"
recommended_fix="${10:-not recorded}"
reviewer="${11:-local}"
json_escape() {
  printf '%s' "$1" | perl -MJSON::PP -0777 -ne 'print encode_json($_)' | sed 's/^"//; s/"$//'
}
case "${classification}" in auto-fix|ask|blocker|informational) ;; *) echo "invalid finding classification: ${classification}" >&2; exit 1 ;; esac
case "${severity}" in critical|high|medium|low|informational|CRITICAL|HIGH|MEDIUM|LOW|INFORMATIONAL) ;; *) echo "invalid finding severity: ${severity}" >&2; exit 1 ;; esac
case "${confidence}" in [1-9]|10) ;; *) echo "invalid finding confidence: ${confidence}" >&2; exit 1 ;; esac
printf '{"finding_id":"%s","fingerprint":"%s","severity":"%s","confidence":%s,"category":"%s","classification":"%s","summary":"%s","evidence":"%s","recommended_fix":"%s","reviewer":"%s","status":"open"}\n' \
  "$(json_escape "${finding_id}")" "$(json_escape "${fingerprint}")" "${severity}" "${confidence}" "$(json_escape "${category}")" "${classification}" "$(json_escape "${summary}")" "$(json_escape "${evidence}")" "$(json_escape "${recommended_fix}")" "$(json_escape "${reviewer}")" \
  >> "${root}/.accelerate/review/findings.jsonl"
