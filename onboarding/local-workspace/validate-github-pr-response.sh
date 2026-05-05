#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 expected-branch < response.json" >&2
  exit 1
fi

payload="$(cat)"
EXPECTED_BRANCH="$1" GITHUB_PR_RESPONSE="${payload}" python3 - <<'PY'
import json
import os
import sys

data = json.loads(os.environ["GITHUB_PR_RESPONSE"])
if data.get("errors"):
    print("GitHub PR read returned errors", file=sys.stderr)
    raise SystemExit(1)

required = ["number", "url", "state", "headRefName", "baseRefName", "title"]
missing = [key for key in required if data.get(key) in (None, "")]
if missing:
    print(f"GitHub PR response missing fields: {', '.join(missing)}", file=sys.stderr)
    raise SystemExit(1)

expected_branch = os.environ["EXPECTED_BRANCH"]
if data.get("headRefName") != expected_branch:
    print("GitHub PR head branch mismatch", file=sys.stderr)
    raise SystemExit(1)

if not str(data.get("url", "")).startswith("https://github.com/"):
    print("GitHub PR URL is not a GitHub URL", file=sys.stderr)
    raise SystemExit(1)

checks = data.get("statusCheckRollup")
if checks is not None and not isinstance(checks, list):
    print("GitHub PR statusCheckRollup must be a list when present", file=sys.stderr)
    raise SystemExit(1)

print(data["number"])
PY
