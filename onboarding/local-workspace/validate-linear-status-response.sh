#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 STATUS_ID < response.json" >&2
  exit 1
fi

expected_status="$1"
EXPECTED_STATUS="${expected_status}" python3 -c '
import json, os, sys
data = json.load(sys.stdin)
if data.get("errors"):
    print("Linear GraphQL issue update returned errors", file=sys.stderr)
    raise SystemExit(1)
result = data.get("data", {}).get("issueUpdate")
if not result or not result.get("success"):
    print("Linear issueUpdate did not report success", file=sys.stderr)
    raise SystemExit(1)
issue = result.get("issue") or {}
state = issue.get("state") or {}
if not issue.get("id") or state.get("id") != os.environ["EXPECTED_STATUS"]:
    print("Linear issueUpdate returned unexpected issue/state", file=sys.stderr)
    raise SystemExit(1)
print(json.dumps(result))
'
