#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo issue-id [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
output_path="${3:-.accelerate/workflow/linear-mcp-read.jsonl}"
mode="${4:-}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","issue":"%s","output":"%s","remote_calls":false}\n' "${issue_id}" "${output_path}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
opencode mcp auth list | grep -Fq "linear" || { echo "linear MCP auth is not available" >&2; exit 1; }
mkdir -p "$(dirname "${root}/${output_path}")"
opencode run --format json --agent build "Use the linear MCP server only. Read issue ${issue_id}. Do not create or update anything. Return concise JSON with id, title, url, status, assignee, project, team." >"${root}/${output_path}"
printf '%s\n' "${output_path}"
