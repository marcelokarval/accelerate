#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/review/findings.jsonl"
[ -f "${file}" ] || { echo "missing review findings: ${file}" >&2; exit 1; }
while IFS= read -r line; do
  [ -n "${line}" ] || continue
  if ! printf '%s' "${line}" | perl -MJSON::PP -e 'my $j = join "", <>; decode_json($j);' >/dev/null 2>&1; then
    echo "invalid review finding JSON: ${line}" >&2
    exit 1
  fi
  for key in finding_id fingerprint severity confidence category classification summary evidence recommended_fix reviewer status; do
    if ! printf '%s' "${line}" | KEY="${key}" perl -MJSON::PP -e 'my $o=decode_json(do { local $/; <STDIN> }); exit(exists $o->{$ENV{KEY}} ? 0 : 1);' >/dev/null 2>&1; then
      echo "review finding missing ${key}: ${line}" >&2
      exit 1
    fi
  done
  if printf '%s' "${line}" | grep -Fq '"classification":"blocker"' && printf '%s' "${line}" | grep -Fq '"evidence":"none"'; then
    echo "blocker finding requires evidence" >&2
    exit 1
  fi
  classification="$(printf '%s' "${line}" | perl -MJSON::PP -e 'my $o=decode_json(join "", <>); print $o->{classification};')"
  case "${classification}" in auto-fix|ask|blocker|informational) ;; *) echo "invalid finding classification: ${classification}" >&2; exit 1 ;; esac
  confidence="$(printf '%s' "${line}" | perl -MJSON::PP -e 'my $o=decode_json(join "", <>); print $o->{confidence};')"
  case "${confidence}" in [1-9]|10) ;; *) echo "invalid finding confidence: ${confidence}" >&2; exit 1 ;; esac
done < "${file}"
echo "review findings passed"
