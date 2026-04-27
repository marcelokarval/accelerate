#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [output-path] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
output_path="${2:-.accelerate/review/ship-readiness.json}"
mode="${3:-}"
case "${output_path}" in /*|*..*) echo "output path must be relative and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac

origin_url="$(git -C "${root}" remote get-url origin 2>/dev/null || true)"
case "${origin_url}" in git@github.com:*|https://github.com/*) ;; *) echo "origin is not a GitHub remote: ${origin_url}" >&2; exit 1 ;; esac
repo_slug="$(printf '%s' "${origin_url}" | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","operation":"ship-readiness","repo":"%s","branch":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }
mkdir -p "$(dirname "${root}/${output_path}")"
pr_json="$(gh -R "${repo_slug}" pr view "${branch}" --json number,url,state,mergeable,reviewDecision,statusCheckRollup)"
printf '%s\n' "${pr_json}" >"${root}/${output_path}"
printf '%s\n' "${output_path}"
