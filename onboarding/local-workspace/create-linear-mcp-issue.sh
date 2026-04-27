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
output_path="${6:-.accelerate/workflow/linear-mcp-create.jsonl}"
mode="${7:-}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","team":"%s","project":"%s","assignee":"%s","remote_calls":false}\n' "${team}" "${project}" "${assignee}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
opencode mcp auth list | grep -Fq "linear" || { echo "linear MCP auth is not available" >&2; exit 1; }
mkdir -p "$(dirname "${root}/${output_path}")"
opencode run --format json --agent build "Use the linear MCP server only. Create one Linear issue in team ${team}, project ${project}, assigned to ${assignee}, title exactly '${title}'. Do not touch any other issue. Return concise JSON with created issue id, url, assignee, project, team, status." >"${root}/${output_path}"
printf '%s\n' "${output_path}"
