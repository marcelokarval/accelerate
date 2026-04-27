#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 LINEAR-123 < response.json" >&2
  exit 1
fi

expected_id="$1"
EXPECTED_ID="${expected_id}" EXPECTED_PROJECT="${LINEAR_EXPECTED_PROJECT:-}" EXPECTED_ASSIGNEE="${LINEAR_EXPECTED_ASSIGNEE_EMAIL:-}" python3 -c '
import json, os, sys
data = json.load(sys.stdin)
if data.get("errors"):
    print("Linear GraphQL read returned errors", file=sys.stderr)
    raise SystemExit(1)
issue = data.get("data", {}).get("issue")
if not issue or not issue.get("id"):
    print("Linear issue not found", file=sys.stderr)
    raise SystemExit(1)
if issue.get("identifier") != os.environ["EXPECTED_ID"]:
    print("Linear issue identifier mismatch", file=sys.stderr)
    raise SystemExit(1)
expected_project = os.environ.get("EXPECTED_PROJECT")
if expected_project and (issue.get("project") or {}).get("name") != expected_project:
    print("Linear issue project mismatch", file=sys.stderr)
    raise SystemExit(1)
expected_assignee = os.environ.get("EXPECTED_ASSIGNEE")
if expected_assignee and (issue.get("assignee") or {}).get("email") != expected_assignee:
    print("Linear issue assignee mismatch", file=sys.stderr)
    raise SystemExit(1)
print(issue["id"])
'
