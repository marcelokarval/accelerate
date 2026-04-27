#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

root="$(cd "$1" && pwd)"
out="${root}/.accelerate/status/readiness-dashboard.yaml"
findings="${root}/.accelerate/review/findings.jsonl"
status="ready"
if [ -s "${findings}" ] && grep -Fq '"classification":"blocker"' "${findings}"; then
  status="blocked"
fi
cat > "${out}" <<YAML
schema_version: 1
overall_status: ${status}
classification: ready
work_item: ready
plan: ready
task_ledger: ready
strategy_product_review: contextual
engineering_review: contextual
design_system_review: contextual
dx_review: contextual
security_review: contextual
qa_browser_review: contextual
regression_proof: contextual
docs_release_notes: contextual
closure_packet: contextual
handoff_summary: ready
YAML
echo "rendered readiness dashboard: ${out#${root}/}"
