#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/target-repo artifact-path" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
artifact_path="$2"
privacy_map="${root}/.accelerate/status/privacy-map.yaml"
[ -f "${privacy_map}" ] || { echo "missing privacy map: ${privacy_map}" >&2; exit 1; }

if ! SOURCE_PATH="${artifact_path}" perl -0ne '
  my $source = $ENV{SOURCE_PATH};
  my @entries = split /\n\s*-\s+/, "\n" . $_;
  my $matches = 0;
  my $approved = 0;
  for my $entry (@entries) {
    my ($path) = $entry =~ /(?:^|\n)\s*path:\s*([^\n]+)/;
    next unless defined $path && $path eq $source;
    $matches++;
    my ($class) = $entry =~ /\n\s*class:\s*([^\n]+)/;
    my ($export) = $entry =~ /\n\s*export:\s*([^\n]+)/;
    exit 5 unless defined $class && $class =~ /^(public-artifact|internal-operational|sensitive-local-proof|secret-prohibited|user-private-preference|generated-export)$/;
    exit 4 if defined $class && $class eq "secret-prohibited";
    exit 6 if defined $export && ($export eq "never" || $export =~ /^blocked/);
    $approved++ if defined $export && ($export eq "allowed" || $export eq "approved");
  }
  exit 3 if $matches == 0;
  exit 7 if $matches > 1;
  exit($approved == 1 ? 0 : 2);
' "${privacy_map}"; then
  echo "artifact is not export-approved in privacy map: ${artifact_path}" >&2
  exit 1
fi
