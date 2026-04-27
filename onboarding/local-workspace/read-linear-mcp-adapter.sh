#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo issue-id [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
output_path="${3:-.accelerate/workflow/linear-mcp-read.jsonl}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","issue":"%s","output":"%s","remote_calls":false}\n' "${issue_id}" "${output_path}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
echo "Linear MCP reads through an LLM host are blocked until a structured read binding exists" >&2
exit 2
