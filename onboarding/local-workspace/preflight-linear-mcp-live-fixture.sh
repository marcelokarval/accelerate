#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
output_path="${2:-.accelerate/workflow/linear-mcp-live-preflight.jsonl}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
case "${output_path}" in .accelerate/workflow/*) ;; *) echo "output path must be under .accelerate/workflow/: ${output_path}" >&2; exit 1 ;; esac

output_abs="${root}/${output_path}"
[ ! -L "${output_abs}" ] || { echo "output path must not be a symlink: ${output_path}" >&2; exit 1; }
mkdir -p "$(dirname "${output_abs}")"
output_dir_real="$(cd "$(dirname "${output_abs}")" && pwd)"
case "${output_dir_real}" in "${root}/.accelerate/workflow"|"${root}/.accelerate/workflow"/*) ;; *) echo "resolved output path escapes .accelerate/workflow: ${output_path}" >&2; exit 1 ;; esac

team="${LINEAR_FIXTURE_TEAM_ID:-${LINEAR_FIXTURE_TEAM_KEY:-}}"
status="${LINEAR_FIXTURE_STATUS_ID:-}"
project="${LINEAR_FIXTURE_PROJECT_ID:-none}"
assignee="${LINEAR_FIXTURE_ASSIGNEE_ID:-none}"
opt_in="${ACCELERATE_LINEAR_LIVE_FIXTURE:-}"
token_present=false
[ -n "${LINEAR_API_KEY:-}" ] && token_present=true

reason="ready"
ready=true
if [ "${token_present}" != true ]; then
  ready=false
  reason="missing LINEAR_API_KEY"
elif [ "${opt_in}" != "1" ]; then
  ready=false
  reason="missing ACCELERATE_LINEAR_LIVE_FIXTURE=1 opt-in"
elif [ -z "${team}" ]; then
  ready=false
  reason="missing LINEAR_FIXTURE_TEAM_ID or LINEAR_FIXTURE_TEAM_KEY"
elif [ -z "${status}" ]; then
  ready=false
  reason="missing LINEAR_FIXTURE_STATUS_ID"
fi

case "${team}" in "") ;; -*|*[!A-Za-z0-9_-]*) echo "invalid Linear fixture team id/key" >&2; exit 1 ;; esac
case "${status}" in "") ;; -*|*[!A-Za-z0-9_-]*) echo "invalid Linear fixture status id" >&2; exit 1 ;; esac
case "${project}" in "") echo "LINEAR_FIXTURE_PROJECT_ID must be an id/key or unset" >&2; exit 1 ;; *..*|/*) echo "invalid LINEAR_FIXTURE_PROJECT_ID" >&2; exit 1 ;; esac
case "${assignee}" in "") echo "LINEAR_FIXTURE_ASSIGNEE_ID must be an id or unset" >&2; exit 1 ;; *..*|/*) echo "invalid LINEAR_FIXTURE_ASSIGNEE_ID" >&2; exit 1 ;; esac

verified=false
verify_reason="not-run"
remote_calls=false
if [ "${mode}" != "--dry-run" ] && [ "${ready}" = true ]; then
  command -v curl >/dev/null 2>&1 || { echo "curl is not installed" >&2; exit 1; }
  query='query LinearFixturePreflight($team: String!) { team(id: $team) { id key name states { nodes { id name type } } } }'
  payload="$(python3 - "${query}" "${team}" <<'PY'
import json, sys
print(json.dumps({"query": sys.argv[1], "variables": {"team": sys.argv[2]}}))
PY
)"
  response="$(curl -fsS https://api.linear.app/graphql \
    -H "Authorization: ${LINEAR_API_KEY}" \
    -H "Content-Type: application/json" \
    --data "${payload}")"
  remote_calls=true
  verify_reason="$(python3 - "${status}" "${response}" <<'PY'
import json, sys
status_id, raw = sys.argv[1:3]
data = json.loads(raw)
if data.get("errors"):
    print("Linear GraphQL preflight returned errors")
    raise SystemExit(2)
team = data.get("data", {}).get("team")
if not team or not team.get("id"):
    print("fixture team not found")
    raise SystemExit(3)
states = ((team.get("states") or {}).get("nodes") or [])
if not any(state.get("id") == status_id for state in states):
    print("fixture status not found on fixture team")
    raise SystemExit(4)
print("team/status verified")
PY
)" || {
    code=$?
    ready=false
    verified=false
    reason="${verify_reason}"
  }
  if [ "${ready}" = true ]; then
    verified=true
    reason="ready: ${verify_reason}"
  fi
fi

line="$(python3 - "${output_path}" "${mode:-live-preflight}" "${token_present}" "${opt_in}" "${team}" "${status}" "${project}" "${assignee}" "${ready}" "${reason}" "${verified}" "${remote_calls}" <<'PY'
import json, sys
(output, mode, token_present, opt_in, team, status, project, assignee, ready, reason, verified, remote_calls) = sys.argv[1:]
print(json.dumps({
    "adapter": "linear",
    "transport": "graphql",
    "binding": "linear-mcp-structured-non-llm",
    "operation": "live-fixture-preflight",
    "mode": "dry-run" if mode == "--dry-run" else "live-preflight",
    "output": output,
    "credential": "present" if token_present == "true" else "absent",
    "live_fixture_opt_in": opt_in == "1",
    "fixture_team": "present" if team else "absent",
    "fixture_status": "present" if status else "absent",
    "fixture_project": "present" if project != "none" else "none",
    "fixture_assignee": "present" if assignee != "none" else "none",
    "ready": ready == "true",
    "verified": verified == "true",
    "blocked_reason": None if ready == "true" else reason,
    "remote_calls": remote_calls == "true",
}, sort_keys=True))
PY
)"
printf '%s\n' "${line}" >>"${output_abs}"
printf '%s\n' "${line}"

[ "${ready}" = true ] || exit 2
