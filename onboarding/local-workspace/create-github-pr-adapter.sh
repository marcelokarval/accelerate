#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 /path/to/target-repo title body-file [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
title="$2"
body_file="$3"
mode="${4:-}"

case "${body_file}" in /*|*..*) echo "body file must be relative and cannot contain '..': ${body_file}" >&2; exit 1 ;; esac
[ -f "${root}/${body_file}" ] || { echo "missing body file: ${body_file}" >&2; exit 1; }

origin_url="$(git -C "${root}" remote get-url origin 2>/dev/null || true)"
case "${origin_url}" in git@github.com:*|https://github.com/*) ;; *) echo "origin is not a GitHub remote: ${origin_url}" >&2; exit 1 ;; esac
repo_slug="$(printf '%s' "${origin_url}" | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","repo":"%s","branch":"%s","title":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}" "${title}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }

if ! git -C "${root}" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git -C "${root}" push -u origin "${branch}"
fi

gh -R "${repo_slug}" pr create --head "${branch}" --base main --title "${title}" --body-file "${root}/${body_file}"
