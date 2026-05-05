#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode="${2:-}"
if [ -n "${mode}" ] && [ "${mode}" != "--dry-run" ]; then
  echo "invalid mode: ${mode}. expected --dry-run" >&2
  exit 1
fi

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","repo":"%s","branch":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }

gh -R "${repo_slug}" pr view "${branch}" --json number,url,headRefName,baseRefName,state,title,author,mergeable,reviewDecision,statusCheckRollup
