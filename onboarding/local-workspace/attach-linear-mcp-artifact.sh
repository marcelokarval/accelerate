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
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
output_path="${5:-.accelerate/workflow/linear-mcp-comment.jsonl}"
case "${artifact_path}" in /*|*..*) echo "artifact path must be relative and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
[ -f "${root}/${artifact_path}" ] || { echo "missing artifact: ${artifact_path}" >&2; exit 1; }
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${artifact_path}"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","transport":"mcp","mode":"dry-run","issue":"%s","artifact":"%s","remote_calls":false}\n' "${issue_id}" "${artifact_path}"
  exit 0
fi

command -v opencode >/dev/null 2>&1 || { echo "opencode is required for Linear MCP adapter" >&2; exit 1; }
echo "Linear MCP artifact attachment is blocked until a structured non-LLM write binding exists" >&2
exit 2
