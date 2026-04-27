#!/usr/bin/env bash
set -euo pipefail

python3 -c '
import json, sys
data = json.load(sys.stdin)
if data.get("errors"):
    print("Linear GraphQL comment returned errors", file=sys.stderr)
    raise SystemExit(1)
result = data.get("data", {}).get("commentCreate")
if not result or not result.get("success"):
    print("Linear commentCreate did not report success", file=sys.stderr)
    raise SystemExit(1)
print(json.dumps(result))
'
