#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
  echo "usage: $0 /path/to/target-repo artifact-path comment-title [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
artifact_path="$2"
comment_title="$3"
mode="${4:-}"
if [ -n "${mode}" ] && [ "${mode}" != "--dry-run" ]; then
  echo "invalid mode: ${mode}. expected --dry-run" >&2
  exit 1
fi

case "${artifact_path}" in /*|*..*) echo "artifact path must be relative and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
artifact_abs="${root}/${artifact_path}"
[ -f "${artifact_abs}" ] || { echo "missing artifact: ${artifact_abs}" >&2; exit 1; }
artifact_real="$(readlink -f "${artifact_abs}")"
case "${artifact_real}" in "${root}"|"${root}"/*) ;; *) echo "resolved artifact escapes target repo: ${artifact_path}" >&2; exit 1 ;; esac
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${artifact_path}"

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

body_file="$(mktemp)"
trap 'rm -f "${body_file}"' EXIT
{
  printf '## %s\n\n' "${comment_title}"
  printf 'Source artifact: `%s`\n\n' "${artifact_path}"
  sed -n '1,200p' "${artifact_abs}"
} > "${body_file}"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","repo":"%s","branch":"%s","artifact":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}" "${artifact_path}"
  exit 0
fi

command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }

pr_number="$(gh -R "${repo_slug}" pr view "${branch}" --json number --jq .number)"
[ -n "${pr_number}" ] || { echo "no GitHub PR found for branch: ${branch}" >&2; exit 2; }
gh -R "${repo_slug}" pr comment "${pr_number}" --body-file "${body_file}"
