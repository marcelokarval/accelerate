#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
STATE_FILE="${WORKSPACE}/state.yaml"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
TIMELINE_FILE="${WORKSPACE}/status/timeline.jsonl"
LEARNINGS_FILE="${WORKSPACE}/status/learnings.jsonl"
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"

for required in "${STATE_FILE}" "${READINESS_FILE}" "${TIMELINE_FILE}" "${LEARNINGS_FILE}" "${PLAN_FILE}"; do
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

last_jsonl_field() {
  local path="$1"
  local key="$2"
  if [ ! -s "${path}" ]; then
    return
  fi
  (grep -ve '^[[:space:]]*$' "${path}" | tail -n 1 | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p") || true
}

count_jsonl() {
  local path="$1"
  if [ ! -s "${path}" ]; then
    echo 0
    return
  fi
  grep -cve '^[[:space:]]*$' "${path}" || true
}

next_action_value() {
  local key="$1"
  local output
  output="$(bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suggest-next-local-action.sh" "${TARGET_ROOT}")"
  printf '%s\n' "${output}" | sed -n "s/^${key}=//p" | head -n 1
}

classification="orchestrated non-trivial work"
dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"

learning_disposition="none"
if [ "$(count_jsonl "${LEARNINGS_FILE}")" -gt 0 ]; then
  learning_disposition="durably-registered"
fi

phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
current_plan="$(yaml_value "${STATE_FILE}" "current_plan")"
readiness_path="$(yaml_value "${STATE_FILE}" "readiness_dashboard")"
timeline_path="$(yaml_value "${STATE_FILE}" "timeline_file")"
learnings_path="$(yaml_value "${STATE_FILE}" "learnings_file")"
agents_status="$(yaml_value "${STATE_FILE}" "agents_status_file")"
onboarding_status="$(yaml_value "${STATE_FILE}" "onboarding_status")"
reentry_status="$(yaml_value "${STATE_FILE}" "reentry_status")"
bounded_objective="$(plan_value "bounded objective")"
governing_path="$(plan_value "path")"
smallest_artifact="$(plan_value "smallest sufficient artifact")"
story_path="$(plan_value "user story")"
prd_path="$(plan_value "PRD-lite")"
sdd_path="$(plan_value "SDD")"
task_path="$(plan_value "task breakdown")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"

[ -n "${story_path}" ] || story_path=".accelerate/planning/user-story.md"
[ -n "${prd_path}" ] || prd_path=".accelerate/planning/prd-lite.md"
[ -n "${sdd_path}" ] || sdd_path=".accelerate/planning/sdd.md"
[ -n "${task_path}" ] || task_path=".accelerate/planning/task-breakdown.md"

cat <<EOF
Branch Entry Packet

- classification: ${classification}
- active branch: local-workspace governed handoff
- active persona: root owner
- active stack: local workspace / planning / review handoff
- active skills: accelerate
- active ADRs / references:
  - onboarding/local-workspace/README.md
  - core/runtime-packets/templates.md
- local workspace:
  - .accelerate=present
  - action=reused
  - onboarding status=${onboarding_status}
  - reentry status=${reentry_status}
  - readiness dashboard=${readiness_path:-.accelerate/status/readiness-dashboard.yaml}
  - readiness status=${dashboard_verdict}
  - timeline=${timeline_path:-.accelerate/status/timeline.jsonl}
  - current checkpoint=${last_event:-n/a}
  - learnings=${learnings_path:-.accelerate/status/learnings.jsonl}
  - learning disposition=${learning_disposition}
  - current governing artifact=${governing_path:-n/a}
  - local agents status=${agents_status:-.accelerate/agents/status.yaml}
  - drift status=clean
- gate ledger: local-workspace-entry=passed, readiness-dashboard=visible, next-action-derived=passed
- phase / SDLC: ${phase}
- persona handoff artifact: ${current_plan:-.accelerate/planning/current-plan.md}
- product/spec artifact chain:
  - source story=${story_path}
  - PRD-lite=${prd_path}
  - SDD=${sdd_path}
  - task breakdown=${task_path}
- artifact sufficiency decision: ${smallest_artifact:-missing blocker}
- mandatory gates: local-workspace-entry, review-readiness, timeline-continuity
- required artifacts: current-plan, readiness-dashboard, timeline, review handoff packet
- closure blockers: $(if [ "${dashboard_verdict}" = "ready-for-closure" ]; then echo "none"; else echo "${dashboard_verdict}"; fi)
- QA / proof lane: $(if [ "${dashboard_verdict}" = "ready-for-execution" ]; then echo "ready-for-review-handoff"; elif [ "${dashboard_verdict}" = "ready-for-review" ]; then echo "review-active"; elif [ "${dashboard_verdict}" = "ready-for-closure" ]; then echo "closure-active"; else echo "blocked"; fi)
- issue stack status: local-governed / $(if [ -n "${bounded_objective}" ]; then echo "planning-present"; else echo "planning-thin"; fi)
- browser-proof intensity: n/a
- persistent E2E status: n/a
- local review / closure action: $(next_action_value "next_action")
- single-threaded exception: n/a
EOF
