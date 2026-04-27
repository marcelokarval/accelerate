#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "usage: $0 /path/to/target-repo LINEAR-123 artifact-path comment-title [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
issue_id="$2"
artifact_path="$3"
comment_title="$4"
mode="${5:-}"
case "${issue_id}" in *[!A-Z0-9-]*|""|-*) echo "invalid Linear issue id: ${issue_id}" >&2; exit 1 ;; esac
case "${artifact_path}" in /*|*..*) echo "artifact path must be relative and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
artifact_abs="${root}/${artifact_path}"
[ -f "${artifact_abs}" ] || { echo "missing artifact: ${artifact_abs}" >&2; exit 1; }
artifact_real="$(readlink -f "${artifact_abs}")"
case "${artifact_real}" in "${root}"|"${root}"/*) ;; *) echo "resolved artifact escapes target repo: ${artifact_path}" >&2; exit 1 ;; esac
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${artifact_path}"

body="$(python3 - "${comment_title}" "${artifact_path}" "${artifact_abs}" <<'PY'
import sys
from pathlib import Path
title, artifact_path, artifact_abs = sys.argv[1:4]
text = Path(artifact_abs).read_text(encoding="utf-8")
print(f"## {title}\n\nSource artifact: `{artifact_path}`\n\n{text[:6000]}")
PY
)"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"linear","mode":"dry-run","issue":"%s","artifact":"%s","remote_calls":false}\n' "${issue_id}" "${artifact_path}"
  exit 0
fi

[ -n "${LINEAR_API_KEY:-}" ] || { echo "LINEAR_API_KEY is not set" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is not installed" >&2; exit 1; }
read_query='query Issue($id: String!) { issue(id: $id) { id identifier title url project { name } assignee { email } } }'
read_payload="$(python3 - "${read_query}" "${issue_id}" <<'PY'
import json
import sys
print(json.dumps({"query": sys.argv[1], "variables": {"id": sys.argv[2]}}))
PY
)"
read_response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${read_payload}")"
linear_uuid="$(printf '%s' "${read_response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-issue-response.sh" "${issue_id}")"
query='mutation CommentCreate($input: CommentCreateInput!) { commentCreate(input: $input) { success comment { id url } } }'
payload="$(python3 - "${query}" "${linear_uuid}" "${body}" <<'PY'
import json
import sys
print(json.dumps({"query": sys.argv[1], "variables": {"input": {"issueId": sys.argv[2], "body": sys.argv[3]}}}))
PY
)"
response="$(curl -fsS https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data "${payload}")"
printf '%s' "${response}" | "$(dirname "${BASH_SOURCE[0]}")/validate-linear-comment-response.sh"
