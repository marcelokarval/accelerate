#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 3 ]; then
  echo "usage: $0 /path/to/target-repo [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
if [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [output-path] [--dry-run]" >&2
  exit 1
fi
output_path="${2:-.accelerate/review/ship-readiness.json}"
case "${output_path}" in -*|/*|*..*) echo "output path must be relative, cannot start with '-', and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","operation":"ship-readiness","repo":"%s","branch":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }
output_abs="${root}/${output_path}"
mkdir -p "$(dirname "${output_abs}")"
output_tmp="${output_abs}.tmp.$$"
trap 'rm -f "${output_tmp}"' EXIT
pr_json="$(gh -R "${repo_slug}" pr view "${branch}" --json number,url,state,mergeable,reviewDecision,statusCheckRollup,headRefName,headRefOid,baseRefName)"
printf '%s\n' "${pr_json}" | REPO_SLUG="${repo_slug}" BRANCH="${branch}" OUTPUT_FILE="${output_abs}" python3 -c '
import json, sys
import os
data = json.load(sys.stdin)
checks = data.get("statusCheckRollup") or []
allowed_conclusions = {"SUCCESS", "NEUTRAL", "SKIPPED"}
allowed_states = {"SUCCESS"}
bad = []
pending = []
for c in checks:
    conclusion = c.get("conclusion")
    state = c.get("state")
    status = c.get("status")
    if conclusion is not None and conclusion not in allowed_conclusions:
        bad.append(c)
    elif state is not None and state not in allowed_states:
        bad.append(c)
    elif conclusion is None and state is None and status != "COMPLETED":
        pending.append(c)
repo = os.environ["REPO_SLUG"]
branch = os.environ["BRANCH"]
missing = []
if not checks:
    missing.append("status_checks")
review_decision = data.get("reviewDecision")
if isinstance(review_decision, str):
    review_decision = review_decision.strip()
if review_decision and review_decision != "APPROVED":
    missing.append("approved_review")
ready = data.get("state") == "OPEN" and data.get("mergeable") == "MERGEABLE" and data.get("headRefName") == branch and not bad and not pending and not missing
result = {"schema_version": 1, "adapter": "github-pr", "repo": repo, "branch": branch, "head_ref_oid": data.get("headRefOid"), "pr_number": data.get("number"), "ready": ready, "pr": data, "blocking_checks": bad, "pending_checks": pending, "missing_requirements": missing}
existing_path = os.environ["OUTPUT_FILE"]
try:
    with open(existing_path, encoding="utf-8") as fh:
        existing = json.load(fh)
except (FileNotFoundError, json.JSONDecodeError, OSError):
    existing = {}
if isinstance(existing, dict):
    for key in ("closure_comment_proof", "closure_artifact"):
        value = existing.get(key)
        if isinstance(value, str) and value.strip():
            result[key] = value
json.dump(result, sys.stdout, indent=2)
sys.stdout.write("\n")
' >"${output_tmp}"
mv "${output_tmp}" "${output_abs}"
trap - EXIT
printf '%s\n' "${output_path}"
