#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
STATE_FILE="${WORKSPACE}/state.yaml"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
TIMELINE_FILE="${WORKSPACE}/status/timeline.jsonl"
REVIEW_READY_FILE="${REVIEW_DIR}/review-ready-packet.md"
AI_REVIEW_FILE="${REVIEW_DIR}/ai-review-report.md"
CLOSURE_FILE="${REVIEW_DIR}/closure-packet.md"
BRANCH_ENTRY_FILE="${REVIEW_DIR}/branch-entry-packet.md"
RUNTIME_DELTA_FILE="${REVIEW_DIR}/runtime-delta-packet.md"
PRE_REVIEW_FILE="${REVIEW_DIR}/pre-review-bundle.md"
CLOSURE_BUNDLE_FILE="${REVIEW_DIR}/closure-bundle.md"
CURRENT_SLICE_REVIEW_FILE="${REVIEW_DIR}/current-slice-review.md"
CURRENT_SLICE_FORENSICS_FILE="${REVIEW_DIR}/current-slice-forensics.md"
DEFECT_LEDGER_FILE="${REVIEW_DIR}/defect-ledger.yaml"
SEAM_PROOF_FILE="${REVIEW_DIR}/seam-proof.md"
WORK_ITEM_FILE="${WORKSPACE}/workflow/active-work-item.yaml"

for required in \
  "${STATE_FILE}" \
  "${READINESS_FILE}" \
  "${TIMELINE_FILE}" \
  "${REVIEW_READY_FILE}" \
  "${AI_REVIEW_FILE}" \
  "${CLOSURE_FILE}" \
  "${BRANCH_ENTRY_FILE}" \
  "${RUNTIME_DELTA_FILE}" \
  "${PRE_REVIEW_FILE}" \
  "${CLOSURE_BUNDLE_FILE}" \
  "${CURRENT_SLICE_REVIEW_FILE}" \
  "${CURRENT_SLICE_FORENSICS_FILE}" \
  "${DEFECT_LEDGER_FILE}" \
  "${SEAM_PROOF_FILE}"; do
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

workflow_value() {
  local key="$1"
  if [ ! -f "${WORK_ITEM_FILE}" ]; then
    printf 'none\n'
    return
  fi
  local value
  value="$(yaml_value "${WORK_ITEM_FILE}" "${key}")"
  printf '%s\n' "${value:-none}"
}

last_jsonl_field() {
  local path="$1"
  local key="$2"
  if [ ! -s "${path}" ]; then
    return
  fi
  (grep -ve '^[[:space:]]*$' "${path}" | tail -n 1 | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p") || true
}

current_phase="$(yaml_value "${READINESS_FILE}" "current_phase")"
dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
execution_readiness="$(yaml_value "${READINESS_FILE}" "execution_readiness")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"
review_ready_path="$(yaml_value "${STATE_FILE}" "review_ready_packet")"
ai_review_path="$(yaml_value "${STATE_FILE}" "ai_review_report")"
closure_path="$(yaml_value "${STATE_FILE}" "closure_packet")"
branch_entry_path="$(yaml_value "${STATE_FILE}" "branch_entry_packet")"
runtime_delta_path="$(yaml_value "${STATE_FILE}" "runtime_delta_packet")"
pre_review_path="$(yaml_value "${STATE_FILE}" "pre_review_bundle")"
closure_bundle_path="$(yaml_value "${STATE_FILE}" "closure_bundle")"
current_slice_review_path="$(yaml_value "${STATE_FILE}" "current_slice_review")"
current_slice_forensics_path="$(yaml_value "${STATE_FILE}" "current_slice_forensics")"
defect_ledger_path="$(yaml_value "${STATE_FILE}" "defect_ledger")"
seam_proof_path="$(yaml_value "${STATE_FILE}" "seam_proof")"

current_handoff="review"
if [ "${closure_readiness}" = "ready" ]; then
  current_handoff="closure"
fi

summary_recommendation="follow-up"
if [ "${closure_readiness}" = "ready" ]; then
  summary_recommendation="done"
elif [ "${review_readiness}" != "ready" ]; then
  summary_recommendation="prepare-review-first"
fi

cat <<EOF
# Handoff Summary

## Status

- current phase: ${current_phase}
- dashboard verdict: ${dashboard_verdict}
- execution readiness: ${execution_readiness}
- review readiness: ${review_readiness}
- closure readiness: ${closure_readiness}
- current handoff surface: ${current_handoff}
- latest timeline event: ${last_event:-n/a}
- summary recommendation: ${summary_recommendation}

## Workflow Identity

- workflow work item: $(workflow_value "id")
- workflow locator: $(workflow_value "locator")
- workflow lifecycle state: $(workflow_value "lifecycle_state")
- workflow title: $(workflow_value "title")

## Canonical Review Surface

- review-ready packet: ${review_ready_path:-.accelerate/review/review-ready-packet.md}
- AI Review Report: ${ai_review_path:-.accelerate/review/ai-review-report.md}
- closure packet: ${closure_path:-.accelerate/review/closure-packet.md}
- branch entry packet: ${branch_entry_path:-.accelerate/review/branch-entry-packet.md}
- runtime delta packet: ${runtime_delta_path:-.accelerate/review/runtime-delta-packet.md}
- pre-review bundle: ${pre_review_path:-.accelerate/review/pre-review-bundle.md}
- closure bundle: ${closure_bundle_path:-.accelerate/review/closure-bundle.md}
- current slice review: ${current_slice_review_path:-.accelerate/review/current-slice-review.md}
- current slice forensics: ${current_slice_forensics_path:-.accelerate/review/current-slice-forensics.md}
- defect ledger: ${defect_ledger_path:-.accelerate/review/defect-ledger.yaml}
- seam proof: ${seam_proof_path:-.accelerate/review/seam-proof.md}

## Reading Order

1. branch entry packet
2. runtime delta packet
3. review-ready packet
4. AI Review Report
5. closure packet
6. current slice review
7. current slice forensics
8. defect ledger
9. seam proof
10. pre-review or closure bundle, depending on readiness
EOF
