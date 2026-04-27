#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
file="${root}/.accelerate/status/safety-overlay.yaml"
[ -f "${file}" ] || { echo "missing safety overlay: ${file}" >&2; exit 1; }
mode="$(sed -n 's/^mode: //p' "${file}" | head -n 1)"
case "${mode}" in none|careful|freeze|guard) ;; *) echo "invalid safety mode: ${mode}" >&2; exit 1 ;; esac
if { [ "${mode}" = "freeze" ] || [ "${mode}" = "guard" ]; } && grep -Fq 'allowed_paths: []' "${file}"; then
  echo "freeze/guard require allowed paths" >&2
  exit 1
fi
echo "safety overlay passed"
