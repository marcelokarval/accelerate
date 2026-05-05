#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [--dry-run|--dry-run-target]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode="${2:-}"
if [ -n "${mode}" ] && [ "${mode}" != "--dry-run" ] && [ "${mode}" != "--dry-run-target" ]; then
  echo "invalid mode: ${mode}. expected --dry-run or --dry-run-target" >&2
  exit 1
fi
manifest="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/adapters/workflow/github-pr/capabilities.yaml"

[ -f "${manifest}" ] || { echo "missing GitHub PR adapter manifest" >&2; exit 1; }
if [ "${mode}" = "--dry-run" ]; then
  echo "github-pr probe dry-run: manifest present, no remote calls made"
  exit 0
fi

if [ "${mode}" = "--dry-run-target" ]; then
  repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
  echo "github-pr target dry-run: ${repo_slug}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
git -C "${root}" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "target is not a git repository" >&2; exit 1; }

if ! gh auth status >/dev/null 2>&1; then
  echo "gh auth is not available" >&2
  exit 1
fi

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if gh -R "${repo_slug}" pr view "${branch}" --json number,url,headRefName,baseRefName,state,title >/dev/null 2>&1; then
  gh -R "${repo_slug}" pr view "${branch}" --json number,url,headRefName,baseRefName,state,title
else
  echo "no GitHub PR found for branch: ${branch}" >&2
  exit 2
fi
