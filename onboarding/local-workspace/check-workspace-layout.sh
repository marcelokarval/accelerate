#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
failures=0

if [ ! -d "${WORKSPACE}" ]; then
  echo "workspace layout blocked: missing .accelerate workspace: ${WORKSPACE}" >&2
  exit 1
fi

is_allowed_dir() {
  local rel="$1"
  case "${rel}" in
    .accelerate|\
    .accelerate/onboarding|\
    .accelerate/status|\
    .accelerate/status/checkpoints|\
    .accelerate/planning|\
    .accelerate/planning/history|\
    .accelerate/review|\
    .accelerate/review/componentization|\
    .accelerate/review/componentization/pages|\
    .accelerate/agents|\
    .accelerate/workflow|\
    .accelerate/proof)
      return 0
      ;;
  esac
  return 1
}

while IFS= read -r dir; do
  rel="${dir#${TARGET_ROOT}/}"
  if ! is_allowed_dir "${rel}"; then
    echo "workspace layout blocked: unregistered .accelerate directory: ${rel}" >&2
    failures=$((failures + 1))
  fi
done < <(find "${WORKSPACE}" -type d | sort)

if [ "${failures}" -gt 0 ]; then
  exit 1
fi

echo "workspace layout passed"
