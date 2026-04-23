#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
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

backend_qa="missing"
frontend_qa="missing"
browser_proof="missing"
persistent_e2e="missing"
blocking_lane="proof-state-not-declared"

if [ "${review_readiness}" = "ready" ] || [ "${closure_readiness}" = "ready" ]; then
  backend_qa="present"
  frontend_qa="present"
  browser_proof="present"
  persistent_e2e="n/a"
  blocking_lane="none"
fi

cat <<EOF
Closure Packet

- requested vs implemented: ${bounded_objective:-n/a} -> local status-backed closure summary
- promised vs delivered: dashboard_verdict=${dashboard_verdict}, execution=${execution_readiness}, review=${review_readiness}, closure=${closure_readiness}
- issue scope vs landing: ${governing_path:-n/a}
- readiness summary: ${dashboard_verdict}
- timeline closure checkpoint: ${last_event:-missing}
- learning registration status: ${learning_status}
- proof lane status:
  - Backend QA=${backend_qa}
  - Frontend QA=${frontend_qa}
  - Browser-Proof=${browser_proof}
  - Persistent E2E=${persistent_e2e}
- blocking lane: ${blocking_lane}
- residual risk: $(if [ "${closure_readiness}" = "ready" ]; then echo "low from local status perspective"; else echo "closure not yet reconciled to ready"; fi)
- recommendation: $(if [ "${closure_readiness}" = "ready" ]; then echo "done"; elif [ "${review_readiness}" = "ready" ]; then echo "follow-up"; else echo "blocked"; fi)
EOF
