#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

STATE_FILE="${WORKSPACE}/state.yaml"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
ACTIVE_WORK_ITEM_FILE="${WORKSPACE}/workflow/active-work-item.yaml"
REVIEW_DIR="${WORKSPACE}/review"

if [ ! -f "${STATE_FILE}" ]; then
  echo "prepare-dogfood-closure failed: missing state file: ${STATE_FILE}" >&2
  exit 1
fi
if [ ! -f "${READINESS_FILE}" ]; then
  echo "prepare-dogfood-closure failed: missing readiness dashboard: ${READINESS_FILE}" >&2
  exit 1
fi
if [ ! -f "${ACTIVE_WORK_ITEM_FILE}" ]; then
  echo "prepare-dogfood-closure failed: missing active work item: ${ACTIVE_WORK_ITEM_FILE}" >&2
  exit 1
fi

AUTH_VALIDATOR="${REPO_ROOT}/scripts/validate-dogfood-current-authority.py"
if [ ! -f "${AUTH_VALIDATOR}" ]; then
  echo "prepare-dogfood-closure failed: missing required authority validator: ${AUTH_VALIDATOR}" >&2
  exit 1
fi

python3 "${AUTH_VALIDATOR}" --root "${TARGET_ROOT}"

mkdir -p "${REVIEW_DIR}"

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

profile="$(yaml_value "${STATE_FILE}" "materialization_profile")"
current_plan="$(yaml_value "${STATE_FILE}" "current_plan")"
current_ledger="$(yaml_value "${STATE_FILE}" "current_task_ledger")"
gov_issue="$(yaml_value "${STATE_FILE}" "governing_plane_work_item")"
gov_id="$(yaml_value "${STATE_FILE}" "governing_plane_work_item_id")"
auth_receipt="$(yaml_value "${STATE_FILE}" "current_authority_receipt")"
auth_digest="$(yaml_value "${STATE_FILE}" "current_authority_digest")"
readiness_status="$(yaml_value "${READINESS_FILE}" "status")"
work_item_status="$(yaml_value "${ACTIVE_WORK_ITEM_FILE}" "status")"
cycle="$(yaml_value "${READINESS_FILE}" "cycle")"

cat > "${REVIEW_DIR}/dogfood-closure-handoff.md" <<TXT
# Dogfood Closure Preparation Handoff Packet

- Materialization profile: ${profile}
- Governing work item: ${gov_issue} (${gov_id})
- Cycle: ${cycle}
- Current plan: ${current_plan}
- Current task ledger: ${current_ledger}
- Bound authority receipt: ${auth_receipt}
- Bound authority digest: ${auth_digest}
- Authority locator: ${auth_receipt}
- Authority digest: ${auth_digest}
- Local readiness status: ${readiness_status}
- Local active work item status: ${work_item_status}
- Remote calls allowed: false
- Lifecycle posture: In Progress (completed_at: null)

## Honest Handoff Verdict

Closure preparation succeeded for the committed dogfood V2 subset without full-V2 fabrication.
This artifact provides honest local handoff and review evidence.
It does NOT claim acceptance, Done, Plane closure, deployment, or Phase 2.
TXT

cat > "${REVIEW_DIR}/handoff-summary.md" <<TXT
# Dogfood Handoff Summary

- Profile: ${profile}
- Issue: ${gov_issue} (${gov_id})
- Cycle: ${cycle}
- State: ${work_item_status}
- Lifecycle posture: In Progress (completed_at: null)
- Readiness: ${readiness_status}
- Authority locator: ${auth_receipt}
- Authority digest: ${auth_digest}
- Remote calls allowed: false

## Handoff Posture

This summary provides honest local dogfood handoff evidence.
It does NOT claim acceptance, Done, Plane closure, deployment, or Phase 2.
TXT

cat > "${REVIEW_DIR}/closure-packet.md" <<TXT
# Dogfood Closure Packet

- Issue: ${gov_issue} (${gov_id})
- Cycle: ${cycle}
- Profile: ${profile}
- Status: ${work_item_status} (not accepted)
- Lifecycle posture: In Progress (completed_at: null)
- Authority locator: ${auth_receipt}
- Authority digest: ${auth_digest}
- Remote calls allowed: false
- Disposition: closure-preparation-complete-open-lifecycle

## Non-Acceptance and Non-Closure Notice

Closure preparation is complete for the committed dogfood subset.
This packet does NOT claim acceptance, Done, Plane closure, deployment, or Phase 2.
TXT

echo "prepared local dogfood closure surface"
