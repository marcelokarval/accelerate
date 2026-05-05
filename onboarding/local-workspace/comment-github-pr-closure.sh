#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "usage: $0 /path/to/target-repo closure-artifact [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
artifact_path="$2"
mode="${3:-}"
if [ -n "${mode}" ] && [ "${mode}" != "--dry-run" ]; then
  echo "invalid mode: ${mode}. expected --dry-run" >&2
  exit 1
fi
case "${artifact_path}" in -*|/*|*..*) echo "closure artifact path must be relative, cannot start with '-', and cannot contain '..': ${artifact_path}" >&2; exit 1 ;; esac
artifact_abs="${root}/${artifact_path}"
[ -f "${artifact_abs}" ] || { echo "missing closure artifact: ${artifact_path}" >&2; exit 1; }

bash "$(dirname "${BASH_SOURCE[0]}")/validate-closure-comment-artifact.sh" "${root}" "${artifact_path}"
bash "$(dirname "${BASH_SOURCE[0]}")/require-export-approved.sh" "${root}" "${artifact_path}"

repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || { echo "cannot determine current branch" >&2; exit 1; }

body_file="$(mktemp)"
trap 'rm -f "${body_file}"' EXIT
{
  printf '## Accelerate Closure Comment\n\n'
  printf 'Closure artifact: `%s`\n\n' "${artifact_path}"
  printf '<!-- accelerate:closure-comment:v1 -->\n\n'
  sed -n '1,240p' "${artifact_abs}"
} > "${body_file}"

if [ "${mode}" = "--dry-run" ]; then
  printf '{"adapter":"github-pr","mode":"dry-run","operation":"closure-comment","repo":"%s","branch":"%s","artifact":"%s","remote_calls":false}\n' "${repo_slug}" "${branch}" "${artifact_path}"
  exit 0
fi

[ "${ACCELERATE_ALLOW_GITHUB_PR_CLOSURE_COMMENT:-}" = "1" ] || { echo "closure comment is blocked unless ACCELERATE_ALLOW_GITHUB_PR_CLOSURE_COMMENT=1" >&2; exit 2; }
command -v gh >/dev/null 2>&1 || { echo "gh CLI is not installed" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "gh auth is not available" >&2; exit 1; }
pr_number="$(gh -R "${repo_slug}" pr view "${branch}" --json number --jq .number)"
[ -n "${pr_number}" ] || { echo "no GitHub PR found for branch: ${branch}" >&2; exit 2; }
gh -R "${repo_slug}" pr comment "${pr_number}" --body-file "${body_file}"
