#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [ship-readiness-json] [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode=""
if [ "${@: -1}" = "--dry-run" ]; then
  mode="--dry-run"
  set -- "${@:1:$(($#-1))}"
fi
readiness_path="${2:-.accelerate/review/ship-readiness.json}"
case "${readiness_path}" in /*|*..*) echo "readiness path must be relative and cannot contain '..': ${readiness_path}" >&2; exit 1 ;; esac
origin_url="$(git -C "${root}" remote get-url origin 2>/dev/null || true)"
case "${origin_url}" in git@github.com:*|https://github.com/*) ;; *) echo "origin is not a GitHub remote: ${origin_url}" >&2; exit 1 ;; esac
repo_slug="$(printf '%s' "${origin_url}" | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","operation":"land","repo":"%s","branch":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}"
  exit 0
fi

[ "${ACCELERATE_ALLOW_LAND:-}" = "1" ] || { echo "land is blocked unless ACCELERATE_ALLOW_LAND=1" >&2; exit 2; }
[ -f "${root}/${readiness_path}" ] || { echo "missing ship readiness artifact: ${readiness_path}" >&2; exit 2; }
python3 -c 'import json,sys; data=json.load(open(sys.argv[1])); sys.exit(0 if data.get("ready") is True else 2)' "${root}/${readiness_path}" || { echo "ship readiness is not ready; refusing land" >&2; exit 2; }
command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }
pr_number="$(gh -R "${repo_slug}" pr view "${branch}" --json number --jq .number)"
[ -n "${pr_number}" ] || { echo "no GitHub PR found for branch: ${branch}" >&2; exit 2; }
gh -R "${repo_slug}" pr merge "${pr_number}" --squash --delete-branch
