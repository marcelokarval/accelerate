#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/status/privacy-map.yaml"
[ -f "${file}" ] || { echo "missing privacy map: ${file}" >&2; exit 1; }
while IFS= read -r line; do
  if printf '%s' "${line}" | grep -Eq 'class: '; then
    class="$(printf '%s' "${line}" | sed 's/.*class: //')"
    case "${class}" in public-artifact|internal-operational|sensitive-local-proof|secret-prohibited|user-private-preference|generated-export) ;; *) echo "unknown privacy class: ${class}" >&2; exit 1 ;; esac
  fi
done < "${file}"
perl -0ne '
  my @entries = split /\n\s*- path: /;
  shift @entries if @entries && $entries[0] !~ /^\s*\.\S+/;
  for my $entry (@entries) {
    my ($path) = $entry =~ /^\s*([^\n]+)/;
    my ($class) = $entry =~ /\n\s*class:\s*([^\n]+)/;
    my ($export) = $entry =~ /\n\s*export:\s*([^\n]+)/;
    next unless defined $class;
    if ($class eq "secret-prohibited" && (!defined $export || $export ne "never")) {
      die "secret-prohibited artifact must be export: never: $path\n";
    }
    if (($entry =~ /(token|cookie|credential|private key)/i) && (!defined $export || $export ne "never")) {
      die "credential-like artifact must be export: never: $path\n";
    }
  }
' "${file}"
echo "export allowlist passed"
