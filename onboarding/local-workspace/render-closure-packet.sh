#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
EVIDENCE_FILE="${WORKSPACE}/status/evidence-registry.yaml"
TIMELINE_FILE="${WORKSPACE}/status/timeline.jsonl"
LEARNINGS_FILE="${WORKSPACE}/status/learnings.jsonl"
PLAN_FILE="${WORKSPACE}/planning/current-plan.md"

for required in "${READINESS_FILE}" "${TIMELINE_FILE}" "${LEARNINGS_FILE}" "${PLAN_FILE}"; do
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

evidence_value() {
  local key="$1"
  local default="$2"
  if [ ! -f "${EVIDENCE_FILE}" ]; then
    printf '%s\n' "${default}"
    return
  fi
  local value
  value="$(yaml_value "${EVIDENCE_FILE}" "${key}")"
  printf '%s\n' "${value:-${default}}"
}

plan_value() {
  local key="$1"
  sed -n "s/^- ${key}:[[:space:]]*//p" "${PLAN_FILE}" | head -n 1
}

count_jsonl() {
  local path="$1"
  if [ ! -s "${path}" ]; then
    echo 0
    return
  fi
  grep -cve '^[[:space:]]*$' "${path}" || true
}

last_jsonl_field() {
  local path="$1"
  local key="$2"
  if [ ! -s "${path}" ]; then
    return
  fi
  (grep -ve '^[[:space:]]*$' "${path}" | tail -n 1 | sed -n "s/.*\"${key}\":\"\\([^\"]*\\)\".*/\\1/p") || true
}

next_action_value() {
  local key="$1"
  local output
  output="$(bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/suggest-next-local-action.sh" "${TARGET_ROOT}")"
  printf '%s\n' "${output}" | sed -n "s/^${key}=//p" | head -n 1
}

dashboard_verdict="$(yaml_value "${READINESS_FILE}" "dashboard_verdict")"
execution_readiness="$(yaml_value "${READINESS_FILE}" "execution_readiness")"
review_readiness="$(yaml_value "${READINESS_FILE}" "review_readiness")"
closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
bounded_objective="$(plan_value "bounded objective")"
governing_path="$(plan_value "path")"
last_event="$(last_jsonl_field "${TIMELINE_FILE}" "event")"
learning_count="$(count_jsonl "${LEARNINGS_FILE}")"

learning_status="none"
if [ "${learning_count}" -gt 0 ]; then
  if [ "${closure_readiness}" = "ready" ]; then
    learning_status="durably-registered"
  else
    learning_status="candidate"
  fi
fi

implementation_proof="$(evidence_value "implementation_proof" "missing")"
qa_proof_lane="$(evidence_value "qa_proof_lane" "missing")"
backend_qa="$(evidence_value "backend_qa" "missing")"
frontend_qa="$(evidence_value "frontend_qa" "missing")"
browser_proof="$(evidence_value "browser_proof" "missing")"
persistent_e2e="$(evidence_value "persistent_e2e" "missing")"
design_implementation_proof="$(evidence_value "design_implementation_proof" "not-applicable")"
product_critical_closure="$(evidence_value "product_critical_closure" "not-applicable")"
requested_vs_implemented="$(evidence_value "requested_vs_implemented" "missing")"
defect_ledger="$(evidence_value "defect_ledger" "missing")"
correction_loop="$(evidence_value "correction_loop" "missing")"
seam_proof="$(evidence_value "seam_proof" "missing")"
ai_review="$(evidence_value "ai_review" "missing")"

blocking_lane="none"
for lane in \
  "implementation_proof:${implementation_proof}" \
  "qa_proof_lane:${qa_proof_lane}" \
  "requested_vs_implemented:${requested_vs_implemented}" \
  "ai_review:${ai_review}"; do
  key="${lane%%:*}"
  value="${lane#*:}"
  if [ "${value}" != "present" ]; then
    blocking_lane="${key}"
    break
  fi
done

for lane in \
  "defect_ledger:${defect_ledger}" \
  "correction_loop:${correction_loop}" \
  "seam_proof:${seam_proof}" \
  "design_implementation_proof:${design_implementation_proof}" \
  "product_critical_closure:${product_critical_closure}"; do
  key="${lane%%:*}"
  value="${lane#*:}"
  if [ "${blocking_lane}" = "none" ] && [ "${value}" != "present" ] && [ "${value}" != "not-applicable" ] && [ "${value}" != "clear" ] && [ "${value}" != "not-needed" ]; then
    blocking_lane="${key}"
  fi
done

cat <<EOF
Closure Packet

- requested vs implemented: ${bounded_objective:-n/a} -> local status-backed closure summary
- promised vs delivered: dashboard_verdict=${dashboard_verdict}, execution=${execution_readiness}, review=${review_readiness}, closure=${closure_readiness}
- issue scope vs landing: ${governing_path:-n/a}
- defect ledger status: ${defect_ledger}
- correction loop status: ${correction_loop}
- seam-proof status: ${seam_proof}
- readiness summary: ${dashboard_verdict}
- timeline closure checkpoint: ${last_event:-missing}
- learning registration status: ${learning_status}
- local review / closure preparation: $(next_action_value "next_action")
- proof lane status:
  - Implementation Proof=${implementation_proof}
  - QA Proof Lane=${qa_proof_lane}
  - Backend QA=${backend_qa}
  - Frontend QA=${frontend_qa}
  - Browser-Proof=${browser_proof}
  - Persistent E2E=${persistent_e2e}
  - Design Implementation Proof=${design_implementation_proof}
  - Product-Critical Closure=${product_critical_closure}
  - Requested-Vs-Implemented=${requested_vs_implemented}
  - AI Review=${ai_review}
- blocking lane: ${blocking_lane}
- residual risk: $(if [ "${blocking_lane}" = "none" ] && [ "${closure_readiness}" = "ready" ]; then echo "low from local status perspective"; else echo "evidence-backed closure not satisfied"; fi)
- recommendation: $(if [ "${blocking_lane}" = "none" ] && [ "${closure_readiness}" = "ready" ]; then echo "done"; elif [ "${review_readiness}" = "ready" ]; then echo "follow-up"; else echo "blocked"; fi)
EOF
