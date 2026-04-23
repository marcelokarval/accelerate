#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
PLAN_FILE="${TARGET_ROOT}/.accelerate/planning/current-plan.md"

if [ ! -f "${PLAN_FILE}" ]; then
  echo "missing current plan: ${PLAN_FILE}" >&2
  exit 1
fi

plan_value() {
  local key="$1"
  sed -n "s/^- ${key}:[[:space:]]*//p" "${PLAN_FILE}" | head -n 1
}

phase="$(plan_value "phase")"
governing_path="$(plan_value "path")"
bounded_objective="$(plan_value "bounded objective")"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/refresh-readiness.sh" "${TARGET_ROOT}" >/dev/null

if [ -n "${phase}" ]; then
  summary="Synchronized current plan phase ${phase}"
  if [ -n "${governing_path}" ]; then
    summary="${summary} with governing artifact ${governing_path}"
  fi
  if [ -n "${bounded_objective}" ]; then
    summary="${summary}; objective: ${bounded_objective}"
  fi
  "${SCRIPT_DIR}/mark-checkpoint.sh" "${TARGET_ROOT}" "phase:${phase}" "${summary}" "info" "sync-plan-status.sh" >/dev/null
fi

echo "synchronized local plan status"
