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
output_path="${2:-.accelerate/workflow/github-pr-rehydration.json}"
case "${output_path}" in -*|/*|*..*) echo "output path must be relative, cannot start with '-', and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }
raw_path="${output_path%.json}.raw.json"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"schema_version":1,"adapter":"github-pr","mode":"dry-run","operation":"rehydration","repo":"%s","branch":"%s","output":"%s","raw_output":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}" "${output_path}" "${raw_path}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }
mkdir -p "$(dirname "${root}/${output_path}")"
pr_json="$(gh -R "${repo_slug}" pr view "${branch}" --json number,url,headRefName,baseRefName,state,title,author,mergeable,reviewDecision,statusCheckRollup,comments,headRefOid)"
printf '%s\n' "${pr_json}" | "$(dirname "${BASH_SOURCE[0]}")/validate-github-pr-response.sh" "${branch}" >/dev/null
printf '%s\n' "${pr_json}" >"${root}/${raw_path}"
printf '%s\n' "${pr_json}" | REPO_SLUG="${repo_slug}" BRANCH="${branch}" RAW_PATH="${raw_path}" python3 -c '
import json, os, sys
pr = json.load(sys.stdin)
comments = pr.get("comments") or []
if isinstance(comments, dict):
    comments = comments.get("nodes") or []
checks = pr.get("statusCheckRollup") or []
packet = {
    "schema_version": 1,
    "adapter": "github-pr",
    "repo": os.environ["REPO_SLUG"],
    "branch": os.environ["BRANCH"],
    "identity": {
        "pr_number": pr.get("number"),
        "url": pr.get("url"),
        "title": pr.get("title"),
        "author": pr.get("author"),
        "head_ref": pr.get("headRefName"),
        "head_ref_oid": pr.get("headRefOid"),
        "base_ref": pr.get("baseRefName"),
    },
    "lifecycle": {
        "state": pr.get("state"),
        "mergeable": pr.get("mergeable"),
        "review_decision": pr.get("reviewDecision"),
    },
    "artifacts": {
        "comment_count": len(comments),
        "status_check_count": len(checks),
        "raw_provider_path": os.environ["RAW_PATH"],
    },
    "gaps": [],
    "raw_path": os.environ["RAW_PATH"],
}
if not packet["identity"]["pr_number"]:
    packet["gaps"].append("missing_pr_number")
if packet["lifecycle"]["review_decision"] != "APPROVED":
    packet["gaps"].append("approved_review")
if not checks:
    packet["gaps"].append("status_checks")
json.dump(packet, sys.stdout, indent=2)
sys.stdout.write("\n")
' >"${root}/${output_path}"
printf '%s\n' "${output_path}"
