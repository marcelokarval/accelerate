#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
STATE_FILE="${WORKSPACE}/state.yaml"
STATUS_FILE="${WORKSPACE}/onboarding/status.yaml"
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"

for required in "${STATE_FILE}" "${STATUS_FILE}" "${PLAN_FILE}" "${READINESS_FILE}"; do
  if [ ! -f "${required}" ]; then
    echo "missing required file: ${required}" >&2
    exit 1
  fi
done

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

plan_value() {
  local key="$1"
  sed -n "s/^- ${key}:[[:space:]]*//p" "${PLAN_FILE}" | head -n 1
}

write_list() {
  local indent="$1"
  shift
  if [ "$#" -eq 0 ]; then
    return
  fi
  for item in "$@"; do
    printf "%s- %s\n" "${indent}" "${item}"
  done
}

onboarding_status="$(yaml_value "${STATUS_FILE}" "status")"
reentry_status="$(yaml_value "${STATUS_FILE}" "reentry_status")"
project_onboarded="$(yaml_value "${STATE_FILE}" "project_onboarded")"
smallest_artifact="$(plan_value "smallest sufficient artifact")"
governing_path="$(plan_value "path")"
bounded_objective="$(plan_value "bounded objective")"
current_review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
current_closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"

current_phase="onboarding"
dashboard_verdict="blocked"
execution_readiness="blocked"
review_readiness="blocked"
closure_readiness="blocked"

required_gates=(
  "local-workspace-entry"
  "planning-artifact-sufficiency"
  "issue-bootstrap-or-explicit-no-backend-exception"
  "implementation-proof"
  "qa-proof-lane"
  "ai-review"
)

completed_gates=()
blocking_items=()

completed_gates+=("local-workspace-materialized")

if [ "${project_onboarded}" = "true" ]; then
  completed_gates+=("discovery-classified")
fi

case "${onboarding_status}" in
  completed)
    current_phase="planning"
    completed_gates+=("onboarding-completed")
    ;;
  partially_stabilized)
    current_phase="planning"
    completed_gates+=("onboarding-stabilized")
    ;;
  in_progress)
    blocking_items+=("onboarding still in progress")
    ;;
  *)
    blocking_items+=("onboarding not stabilized yet")
    ;;
esac

case "${reentry_status}" in
  clean|light_reentry)
    ;;
  partial_reonboarding)
    current_phase="onboarding"
    blocking_items+=("partial reonboarding still needs reconciliation")
    ;;
  structural_reonboarding)
    current_phase="onboarding"
    blocking_items+=("structural reonboarding blocks normal execution")
    ;;
esac

if [ -n "${smallest_artifact}" ] && [ -n "${governing_path}" ] && [ -n "${bounded_objective}" ]; then
  execution_readiness="ready"
  current_phase="execution"
  completed_gates+=("planning-artifact-sufficiency")
else
  [ -n "${smallest_artifact}" ] || blocking_items+=("smallest sufficient artifact not declared")
  [ -n "${governing_path}" ] || blocking_items+=("current governing artifact not declared yet")
  [ -n "${bounded_objective}" ] || blocking_items+=("bounded objective not declared yet")
fi

if [ "${#blocking_items[@]}" -gt 0 ]; then
  dashboard_verdict="blocked"
elif [ "${current_closure_readiness}" = "ready" ]; then
  current_phase="closure"
  execution_readiness="ready"
  review_readiness="ready"
  closure_readiness="ready"
  dashboard_verdict="ready-for-closure"
elif [ "${current_review_readiness}" = "ready" ]; then
  current_phase="review"
  execution_readiness="ready"
  review_readiness="ready"
  closure_readiness="blocked"
  dashboard_verdict="ready-for-review"
elif [ "${execution_readiness}" = "ready" ]; then
  review_readiness="blocked"
  closure_readiness="blocked"
  dashboard_verdict="ready-for-execution"
fi

cat > "${READINESS_FILE}" <<EOF
schema_version: 1
current_phase: ${current_phase}
dashboard_verdict: ${dashboard_verdict}
execution_readiness: ${execution_readiness}
review_readiness: ${review_readiness}
closure_readiness: ${closure_readiness}
required_gates:
$(write_list "  " "${required_gates[@]}")
completed_gates:
$(write_list "  " "${completed_gates[@]}")
blocking_items:
$(write_list "  " "${blocking_items[@]}")
last_updated: $(date +%F)
EOF

echo "refreshed readiness dashboard at ${READINESS_FILE}"
