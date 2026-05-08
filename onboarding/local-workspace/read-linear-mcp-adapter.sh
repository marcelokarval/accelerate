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
case "${issue_id}" in *[!A-Z0-9-]*|""|-*) echo "invalid Linear issue id: ${issue_id}" >&2; exit 1 ;; esac
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
case "${output_path}" in .accelerate/workflow/*) ;; *) echo "output path must be under .accelerate/workflow/: ${output_path}" >&2; exit 1 ;; esac

output_abs="${root}/${output_path}"
[ ! -L "${output_abs}" ] || { echo "output path must not be a symlink: ${output_path}" >&2; exit 1; }
mkdir -p "$(dirname "${output_abs}")"
output_dir_real="$(cd "$(dirname "${output_abs}")" && pwd)"
case "${output_dir_real}" in "${root}/.accelerate/workflow"|"${root}/.accelerate/workflow"/*) ;; *) echo "resolved output path escapes .accelerate/workflow: ${output_path}" >&2; exit 1 ;; esac

emit_line() {
  local line="$1"
  printf '%s\n' "${line}" >>"${output_abs}"
  printf '%s\n' "${line}"
}

if [ "${mode}" = "--dry-run" ]; then
  line="$(python3 - "${issue_id}" "${output_path}" <<'PY'
import json, sys
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "read-issue",
    "mode": "dry-run",
    "issue": sys.argv[1],
    "output": sys.argv[2],
    "remote_calls": False,
}, sort_keys=True))
PY
)"
  emit_line "${line}"
  exit 0
fi

[ -n "${LINEAR_API_KEY:-}" ] || { echo "LINEAR_API_KEY is not set" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is not installed" >&2; exit 1; }

query='query Issue($id: String!) { issue(id: $id) { id identifier title url state { name } assignee { email name } project { id name } team { id key name } } }'
payload="$(python3 - "${query}" "${issue_id}" <<'PY'
import json, sys
print(json.dumps({"query": sys.argv[1], "variables": {"id": sys.argv[2]}}))
PY
)"
response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${payload}")"
printf '%s' "${response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-issue-response.sh" "${issue_id}" >/dev/null
line="$(python3 - "${issue_id}" "${output_path}" "${response}" <<'PY'
import json, sys
issue_id, output_path, response = sys.argv[1:4]
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "read-issue",
    "mode": "live",
    "issue": issue_id,
    "output": output_path,
    "remote_calls": True,
    "response": json.loads(response),
}, sort_keys=True))
PY
)"
emit_line "${line}"
