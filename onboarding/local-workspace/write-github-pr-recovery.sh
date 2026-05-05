#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "usage: $0 /path/to/target-repo operation reason [output-path]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
operation="$2"
reason="$3"
output_path="${4:-.accelerate/workflow/github-pr-recovery.md}"
case "${operation}" in read|create|attach|rehydrate|ship-readiness|closure-comment|land|probe|comment) ;;
  *) echo "invalid recovery operation: ${operation}" >&2; exit 1 ;;
esac
case "${output_path}" in -*|/*|*..*) echo "output path must be relative, cannot start with '-', and cannot contain '..': ${output_path}" >&2; exit 1 ;; esac
repo_slug="$("$(dirname "${BASH_SOURCE[0]}")/resolve-github-repo-slug.sh" "${root}")"
branch="$(git -C "${root}" branch --show-current 2>/dev/null || true)"
[ -n "${branch}" ] || branch="unknown"
mkdir -p "$(dirname "${root}/${output_path}")"
cat >"${root}/${output_path}" <<EOF
# GitHub PR Recovery Packet

- schema_version: 1
- adapter: github-pr
- operation: ${operation}
- reason: ${reason}
- recorded_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
- repo: ${repo_slug}
- branch: ${branch}
- retry_required: true
- retry_command: re-run the failed guarded helper with the same repo, branch, artifact, and opt-in environment after resolving the blocker
- remote_write_allowed: false
- zero_context_resume: read this packet, inspect the matching readiness/rehydration artifacts, rerun the relevant dry-run first, then opt in explicitly if the provider write is still intended
EOF
bash "$(dirname "${BASH_SOURCE[0]}")/validate-github-pr-recovery.sh" "${root}" "${output_path}" >/dev/null
printf '%s\n' "${output_path}"
