#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 5 ]; then
  echo "usage: $0 /path/to/target-repo team-id project-id-or-none assignee-id-or-none title [output-path] [--dry-run]" >&2
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
case "${team}" in ""|-*|*[!A-Za-z0-9_-]*) echo "invalid Linear team id/key: ${team}" >&2; exit 1 ;; esac
case "${project}" in "") echo "project must be an id/key or 'none'" >&2; exit 1 ;; *..*|/*) echo "invalid Linear project id: ${project}" >&2; exit 1 ;; esac
case "${assignee}" in "") echo "assignee must be an email/id or 'none'" >&2; exit 1 ;; *..*|/*) echo "invalid Linear assignee: ${assignee}" >&2; exit 1 ;; esac
[ -n "${title}" ] || { echo "title must not be empty" >&2; exit 1; }
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
  line="$(python3 - "${team}" "${project}" "${assignee}" "${title}" "${output_path}" <<'PY'
import json, sys
team, project, assignee, title, output = sys.argv[1:6]
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "create-issue",
    "mode": "dry-run",
    "team": team,
    "project": project,
    "assignee": assignee,
    "title": title,
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

query='mutation IssueCreate($input: IssueCreateInput!) { issueCreate(input: $input) { success issue { id identifier title url team { key name } project { id name } assignee { email name } } } }'
payload="$(python3 - "${query}" "${team}" "${project}" "${assignee}" "${title}" <<'PY'
import json, sys
query, team, project, assignee, title = sys.argv[1:6]
issue_input = {"teamId": team, "title": title}
if project.lower() != "none":
    issue_input["projectId"] = project
if assignee.lower() != "none":
    # Linear accepts assigneeId in IssueCreateInput. Use an explicit id here;
    # callers that only have an email should resolve it before live writes.
    issue_input["assigneeId"] = assignee
print(json.dumps({"query": query, "variables": {"input": issue_input}}))
PY
)"
response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${payload}")"
line="$(python3 - "${team}" "${project}" "${assignee}" "${title}" "${output_path}" "${response}" <<'PY'
import json, sys
team, project, assignee, title, output, response = sys.argv[1:7]
data = json.loads(response)
if data.get("errors"):
    print("Linear GraphQL create returned errors", file=sys.stderr)
    raise SystemExit(1)
result = data.get("data", {}).get("issueCreate")
if not result or not result.get("success") or not result.get("issue", {}).get("id"):
    print("Linear issueCreate did not report success", file=sys.stderr)
    raise SystemExit(1)
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "create-issue",
    "mode": "live",
    "team": team,
    "project": project,
    "assignee": assignee,
    "title": title,
    "output": output,
    "remote_calls": True,
    "response": data,
}, sort_keys=True))
PY
)"
emit_line "${line}"
