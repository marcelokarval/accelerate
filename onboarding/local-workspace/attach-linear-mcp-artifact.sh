#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo issue-id artifact-path comment-title [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
artifact_path="$3"
comment_title="$4"
output_path="${5:-.accelerate/workflow/linear-mcp-comment.jsonl}"
mode="${6:-}"
case "${artifact_path}" in /*|*..*) echo "artifact path must be relative and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
[ -f "${root}/${artifact_path}" ] || { echo "missing artifact: ${artifact_path}" >&2; exit 1; }
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${artifact_path}"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","issue":"%s","artifact":"%s","remote_calls":false}\n' "${issue_id}" "${artifact_path}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
opencode mcp auth list | grep -Fq "linear" || { echo "linear MCP auth is not available" >&2; exit 1; }
mkdir -p "$(dirname "${root}/${output_path}")"
body="## ${comment_title}\n\nSource artifact: ${artifact_path}\n\n$(sed -n '1,120p' "${root}/${artifact_path}")"
opencode run --format json --agent build "Use the linear MCP server only. Add one comment to Linear issue ${issue_id} with this exact body: ${body}. Do not touch any other issue. Return concise JSON with issue id and comment write success." >"${root}/${output_path}"
printf '%s\n' "${output_path}"
