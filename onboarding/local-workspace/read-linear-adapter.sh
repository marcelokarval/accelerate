#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 /path/to/target-repo LINEAR-123 [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
mode="${3:-}"
case "${issue_id}" in *[!A-Z0-9-]*|""|-*) echo "invalid Linear issue id: ${issue_id}" >&2; exit 1 ;; esac

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","mode":"dry-run","issue":"%s","remote_calls":false}\n' "${issue_id}"
  exit 0
fi

[ -n "${LINEAR_API_KEY:-}" ] || { echo "LINEAR_API_KEY is not set" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is not installed" >&2; exit 1; }

query='query Issue($id: String!) { issue(id: $id) { id identifier title url state { name } assignee { email } project { name } } }'
payload="$(python3 - "${query}" "${issue_id}" <<'PY'
import json
import sys
print(json.dumps({"query": sys.argv[1], "variables": {"id": sys.argv[2]}}))
PY
)"
response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${payload}")"
printf '%s' "${response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-issue-response.sh" "${issue_id}" >/dev/null
printf '%s\n' "${response}"
