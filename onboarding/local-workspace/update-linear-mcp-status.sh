#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo issue-id status-id output-path [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
status_id="$3"
output_path="$4"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
fi

case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
output_abs="${root}/${output_path}"
mkdir -p "$(dirname "${output_abs}")"
case "$(readlink -f "$(dirname "${output_abs}")")" in "${root}"|"${root}"/*) ;; *) echo "output escapes target repo: ${output_path}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","operation":"status-transition","mode":"dry-run","issue":"%s","status":"%s","remote_calls":false,"structured_write":false,"blocked_reason":"structured_status_transition_binding_not_implemented"}\n' "${issue_id}" "${status_id}" | tee -a "${output_abs}"
  exit 0
fi

echo "Linear MCP status transition is blocked until a structured non-LLM status-transition binding is implemented and proven" >&2
exit 2
