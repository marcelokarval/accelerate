#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
git -C "${root}" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "target is not a git repository" >&2; exit 1; }

origin_url="$(git -C "${root}" remote get-url origin 2>/dev/null || true)"
case "${origin_url}" in
  git@github.com:*|https://github.com/*) ;;
  *) echo "origin is not a GitHub remote: ${origin_url}" >&2; exit 1 ;;
esac

repo_slug="$(printf '%s' "${origin_url}" | sed -E 's#^(git@github.com:|https://github.com/)##; s#\.git$##')"

owner="${repo_slug%%/*}"
repo="${repo_slug#*/}"
if [ "${owner}" = "${repo_slug}" ] || [ -z "${owner}" ] || [ -z "${repo}" ]; then
  echo "cannot determine GitHub owner/repo from origin" >&2
  exit 1
fi
if [[ "${repo_slug}" == */*/* || "${repo_slug}" == /* || "${repo_slug}" == */ || "${repo_slug}" == *..* || "${repo_slug}" == *//* || "${repo_slug}" == *:* || "${repo_slug}" =~ [[:space:]] ]]; then
  echo "invalid GitHub owner/repo slug from origin: ${repo_slug}" >&2
  exit 1
fi
if [[ ! "${owner}" =~ ^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?$ ]]; then
  echo "invalid GitHub owner in origin slug: ${owner}" >&2
  exit 1
fi
if [[ ! "${repo}" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "invalid GitHub repo in origin slug: ${repo}" >&2
  exit 1
fi

printf '%s\n' "${repo_slug}"
