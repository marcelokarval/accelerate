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
  set -- "${@:1:$(($#-1))}"
fi

case "${issue_id}" in *[!A-Z0-9-]*|""|-*) echo "invalid Linear issue id: ${issue_id}" >&2; exit 1 ;; esac
case "${status_id}" in ""|-*|*[!A-Za-z0-9_-]*) echo "invalid Linear status id: ${status_id}" >&2; exit 1 ;; esac
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
  line="$(python3 - "${issue_id}" "${status_id}" "${output_path}" <<'PY'
import json, sys
issue, status, output = sys.argv[1:4]
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "status-transition",
    "mode": "dry-run",
    "issue": issue,
    "status": status,
    "output": output,
    "remote_calls": False,
}, sort_keys=True))
PY
)"
  emit_line "${line}"
  exit 0
fi

[ -n "${LINEAR_API_KEY:-}" ] || { echo "LINEAR_API_KEY is not set" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is not installed" >&2; exit 1; }

read_query='query Issue($id: String!) { issue(id: $id) { id identifier title url state { id name type } project { name } assignee { email } team { id key name } } }'
read_payload="$(python3 - "${read_query}" "${issue_id}" <<'PY'
import json, sys
print(json.dumps({"query": sys.argv[1], "variables": {"id": sys.argv[2]}}))
PY
)"
read_response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${read_payload}")"
linear_uuid="$(printf '%s' "${read_response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-issue-response.sh" "${issue_id}")"
query='mutation IssueUpdate($id: String!, $input: IssueUpdateInput!) { issueUpdate(id: $id, input: $input) { success issue { id identifier url state { id name type } } } }'
payload="$(python3 - "${query}" "${linear_uuid}" "${status_id}" <<'PY'
import json, sys
print(json.dumps({"query": sys.argv[1], "variables": {"id": sys.argv[2], "input": {"stateId": sys.argv[3]}}}))
PY
)"
response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${payload}")"
printf '%s' "${response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-status-response.sh" "${status_id}" >/dev/null
line="$(python3 - "${issue_id}" "${status_id}" "${output_path}" "${read_response}" "${response}" <<'PY'
import json, sys
issue, status, output, read_response, response = sys.argv[1:6]
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "status-transition",
    "mode": "live",
    "issue": issue,
    "status": status,
    "output": output,
    "remote_calls": True,
    "read_response": json.loads(read_response),
    "response": json.loads(response),
}, sort_keys=True))
PY
)"
emit_line "${line}"
