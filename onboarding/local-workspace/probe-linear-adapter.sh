#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [--dry-run]" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
mode="${2:-}"
manifest="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/adapters/workflow/linear/capabilities.yaml"

[ -f "${manifest}" ] || { echo "missing Linear adapter manifest" >&2; exit 1; }
if [ "${mode}" = "--dry-run" ]; then
  echo "linear probe dry-run: manifest present, no remote calls made"
  exit 0
fi

if [ -z "${LINEAR_API_KEY:-}" ]; then
  echo "LINEAR_API_KEY is not set" >&2
  exit 1
fi

state_file="${root}/.accelerate/workflow/active-work-item.yaml"
[ -f "${state_file}" ] || { echo "missing active work item: ${state_file}" >&2; exit 1; }
work_item="$(sed -n 's/^id:[[:space:]]*//p' "${state_file}" | head -n 1)"
printf '{"adapter":"linear","probe":"auth-present","local_work_item":"%s","remote_calls":"not-implemented"}\n' "${work_item:-none}"
