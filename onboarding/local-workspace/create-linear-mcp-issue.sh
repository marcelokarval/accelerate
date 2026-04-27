#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 5 ]; then
  echo "usage: $0 /path/to/target-repo team project assignee-email title [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
team="$2"
project="$3"
assignee="$4"
title="$5"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
output_path="${6:-.accelerate/workflow/linear-mcp-create.jsonl}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","team":"%s","project":"%s","assignee":"%s","remote_calls":false}\n' "${team}" "${project}" "${assignee}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
echo "Linear MCP issue creation is blocked until a structured non-LLM write binding exists" >&2
exit 2
