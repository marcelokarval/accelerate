#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
for file in "${ROOT}"/adapters/runtime/*/capabilities.yaml; do
  [ -f "${file}" ] || continue
  for key in name type status authority_boundary validation_command privacy_notes; do
    if ! grep -Eq "^${key}:" "${file}"; then
      echo "adapter manifest missing ${key}: ${file}" >&2
      exit 1
    fi
  done
  status="$(sed -n 's/^status: //p' "${file}" | head -n 1)"
  case "${status}" in planned|available|experimental|disabled) ;; *) echo "invalid adapter status ${status}: ${file}" >&2; exit 1 ;; esac
  validation_command="$(sed -n 's/^validation_command: //p' "${file}" | head -n 1)"
  if [ "${status}" = "available" ] && [ "${validation_command}" = "none-yet" ]; then
    echo "available adapter requires validation_command: ${file}" >&2
    exit 1
  fi
done
echo "runtime adapters passed"
