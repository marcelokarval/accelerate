#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for script in \
  log-question.sh check-question-preferences.sh log-timeline-event.sh read-timeline.sh \
  log-learning.sh search-learnings.sh save-context.sh restore-context.sh \
  update-task-ledger.sh log-review-finding.sh check-review-findings.sh \
  render-readiness-dashboard.sh check-qa-report.sh set-safety-overlay.sh \
  check-safety-overlay.sh check-runtime-adapters.sh render-proof-document.sh \
  export-proof-document.sh check-export-allowlist.sh probe-github-pr-adapter.sh \
  probe-linear-adapter.sh read-github-pr-adapter.sh attach-github-pr-artifact.sh \
  read-linear-adapter.sh attach-linear-artifact.sh require-export-approved.sh \
  validate-linear-issue-response.sh validate-linear-comment-response.sh \
  capture-browser-proof.sh create-github-pr-adapter.sh \
  rehydrate-github-pr-adapter.sh write-github-pr-recovery.sh \
  read-linear-mcp-adapter.sh create-linear-mcp-issue.sh \
  attach-linear-mcp-artifact.sh write-linear-mcp-recovery.sh; do
  path="${ROOT}/onboarding/local-workspace/${script}"
  [ -x "${path}" ] || { echo "missing executable script: ${path}" >&2; exit 1; }
done

[ -x "${ROOT}/scripts/export-runtime-host.sh" ] || { echo "missing executable script: ${ROOT}/scripts/export-runtime-host.sh" >&2; exit 1; }

echo "doc snippet integrity passed"
