#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/gstack-pattern-adoption"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file() {
  [ -f "${ROOT}/$1" ] || fail "missing file: $1"
}

assert_contains() {
  local file="$1"
  local text="$2"
  grep -Fq "${text}" "${file}" || fail "${file} missing ${text}"
}

required_files=(
  core/control-plane/decision-taxonomy.md
  core/control-plane/question-registry.md
  core/control-plane/one-way-door-policy.md
  core/control-plane/privacy-classification.md
  core/control-plane/export-allowlist-policy.md
  core/control-plane/ship-readiness-gate.md
  core/control-plane/land-deploy-gate.md
  core/runtime-packets/decision-audit-trail.md
  core/runtime-packets/timeline-event-schema.md
  core/runtime-packets/learning-record-schema.md
  core/runtime-packets/context-checkpoint-packet.md
  core/runtime-packets/task-ledger-schema.md
  core/runtime-packets/review-finding-schema.md
  core/runtime-packets/review-readiness-dashboard.md
  core/runtime-packets/qa-report-packet.md
  core/runtime-packets/design-approval-packet.md
  core/runtime-packets/design-feedback-packet.md
  core/runtime-packets/design-baseline-packet.md
  core/runtime-packets/safety-overlay-state.md
  core/runtime-packets/ship-readiness-packet.md
  core/runtime-packets/deploy-verification-packet.md
  core/runtime-packets/document-export-packet.md
  core/planning/review-pipeline.md
  core/planning/strategy-review-contract.md
  core/planning/engineering-review-contract.md
  core/planning/design-system-review-contract.md
  core/planning/devex-review-contract.md
  core/planning/security-review-contract.md
  core/review/fix-first-taxonomy.md
  core/review/design-system-workflow-pipeline.md
  core/overlays/careful-command-policy.md
  core/overlays/edit-freeze-policy.md
  core/overlays/guard-policy.md
  adapters/runtime/adapter-registry-contract.md
  adapters/runtime/host-export-contract.md
  adapters/runtime/browser/capabilities.yaml
  adapters/runtime/document-export/capabilities.yaml
  adapters/workflow/github-pr/capabilities.yaml
  adapters/workflow/github-issues/capabilities.yaml
  adapters/workflow/provider-comment-contract.md
  adapters/workflow/provider-state-rehydration-contract.md
)

for file in "${required_files[@]}"; do
  assert_file "${file}"
done

assert_contains "${ROOT}/core/control-plane/one-way-door-policy.md" "One-way-door decisions require explicit user approval"
assert_contains "${ROOT}/core/runtime-packets/qa-report-packet.md" "Screenshot-only QA proof is insufficient"
assert_contains "${ROOT}/adapters/runtime/browser/capabilities.yaml" "status: planned"

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}/repo"
bash "${SCRIPTS}/emit-v2.sh" "${WORK_ROOT}/repo" greenfield >/dev/null
bash "${SCRIPTS}/validate-v2.sh" "${WORK_ROOT}/repo" >/dev/null

bash "${SCRIPTS}/log-question.sh" "${WORK_ROOT}/repo" "workflow.low-risk-default" "workflow" "two-way" "recommended" "user-stated"
bash "${SCRIPTS}/check-question-preferences.sh" "${WORK_ROOT}/repo" >/dev/null

bash "${SCRIPTS}/log-timeline-event.sh" "${WORK_ROOT}/repo" "classification_completed" "classification" "classified request" ".accelerate/planning/current-plan.md"
bash "${SCRIPTS}/read-timeline.sh" "${WORK_ROOT}/repo" | grep -Fq "classification_completed" || fail "timeline read missing event"

bash "${SCRIPTS}/log-learning.sh" "${WORK_ROOT}/repo" "workflow" "gstack-pattern" "artifact-first workflow memory" "observed" "8"
bash "${SCRIPTS}/search-learnings.sh" "${WORK_ROOT}/repo" "gstack-pattern" | grep -Fq "artifact-first" || fail "learning search missing record"

checkpoint_path="$(bash "${SCRIPTS}/save-context.sh" "${WORK_ROOT}/repo" "GStack adoption")"
[ -f "${WORK_ROOT}/repo/${checkpoint_path}" ] || fail "checkpoint was not written"
bash "${SCRIPTS}/restore-context.sh" "${WORK_ROOT}/repo" >/dev/null

bash "${SCRIPTS}/update-task-ledger.sh" "${WORK_ROOT}/repo" "GSA-TEST" "implemented" "root" ".accelerate/status/timeline.jsonl"
grep -Fq "GSA-TEST" "${WORK_ROOT}/repo/.accelerate/planning/task-ledger.md" || fail "task ledger missing update"

bash "${SCRIPTS}/log-review-finding.sh" "${WORK_ROOT}/repo" "RF-1" "fp-1" "medium" "8" "workflow" "informational" "recorded finding" "timeline"
bash "${SCRIPTS}/check-review-findings.sh" "${WORK_ROOT}/repo" >/dev/null

bash "${SCRIPTS}/render-readiness-dashboard.sh" "${WORK_ROOT}/repo" >/dev/null
grep -Fq "overall_status:" "${WORK_ROOT}/repo/.accelerate/status/readiness-dashboard.yaml" || fail "readiness dashboard missing status"

bash "${SCRIPTS}/check-qa-report.sh" "${WORK_ROOT}/repo" >/dev/null
bash "${SCRIPTS}/set-safety-overlay.sh" "${WORK_ROOT}/repo" "guard" "root" "test" ".accelerate" >/dev/null
bash "${SCRIPTS}/check-safety-overlay.sh" "${WORK_ROOT}/repo" >/dev/null
bash "${SCRIPTS}/check-runtime-adapters.sh" >/dev/null
bash "${SCRIPTS}/render-proof-document.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" ".accelerate/review/qa-report-copy.md" >/dev/null
[ -f "${WORK_ROOT}/repo/.accelerate/review/qa-report-copy.md" ] || fail "proof document not rendered"
if bash "${SCRIPTS}/export-proof-document.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" ".accelerate/review/qa-report.html" >"${WORK_ROOT}/blocked-export.out" 2>&1; then
  fail "unapproved proof document export was accepted"
fi
perl -0pi -e 's#export: blocked-unless-approved#export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
exported_html="$(bash "${SCRIPTS}/export-proof-document.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" ".accelerate/review/qa-report.html")"
[ "${exported_html}" = ".accelerate/review/qa-report.html" ] || fail "unexpected document export output"
[ -f "${WORK_ROOT}/repo/.accelerate/review/qa-report.html" ] || fail "HTML proof document not exported"
[ -f "${WORK_ROOT}/repo/.accelerate/review/document-export-packet.md" ] || fail "document export packet missing"
perl -0pi -e 's#class: sensitive-local-proof\n    export: approved#class: secret-prohibited\n    export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
if bash "${SCRIPTS}/export-proof-document.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" ".accelerate/review/qa-report-secret.html" >"${WORK_ROOT}/secret-export.out" 2>&1; then
  fail "secret-prohibited proof document export was accepted"
fi
perl -0pi -e 's#class: secret-prohibited\n    export: approved#class: generated-export\n    export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
perl -0pi -e 's#class: generated-export\n    export: approved#export: approved\n    class: secret-prohibited#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
if bash "${SCRIPTS}/export-proof-document.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" ".accelerate/review/qa-report-secret-reordered.html" >"${WORK_ROOT}/secret-export-reordered.out" 2>&1; then
  fail "secret-prohibited reordered proof document export was accepted"
fi
perl -0pi -e 's#export: approved\n    class: secret-prohibited#class: generated-export\n    export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
perl -0pi -e 's#class: generated-export\n    export: approved#export: approved\n    path: .accelerate/review/qa-report.md\n    class: generated-export#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
bash "${SCRIPTS}/require-export-approved.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" >/dev/null
perl -0pi -e 's#export: approved\n    path: .accelerate/review/qa-report.md\n    class: generated-export#path: .accelerate/review/qa-report.md\n    class: generated-export\n    export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
cat >> "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml" <<'YAML'
  - path: .accelerate/review/qa-report.md
    class: secret-prohibited
    export: never
YAML
if bash "${SCRIPTS}/require-export-approved.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" >"${WORK_ROOT}/duplicate-privacy.out" 2>&1; then
  fail "duplicate privacy-map entry was accepted"
fi
perl -0pi -e 's#\n  - path: \.accelerate/review/qa-report\.md\n    class: secret-prohibited\n    export: never\n##' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
bash "${SCRIPTS}/check-export-allowlist.sh" "${WORK_ROOT}/repo" >/dev/null
host_export="$(bash "${ROOT}/scripts/export-runtime-host.sh" codex "${WORK_ROOT}/host-export")"
[ -f "${host_export}" ] || fail "host export not generated"
if bash "${ROOT}/scripts/export-runtime-host.sh" "../bad" "${WORK_ROOT}/host-export" >"${WORK_ROOT}/bad-host.out" 2>&1; then
  fail "invalid host name accepted"
fi
bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run >/dev/null
git -C "${WORK_ROOT}/repo" init >/dev/null
git -C "${WORK_ROOT}/repo" remote add origin https://github.com/example/repo.git
bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run-target | grep -Fq "example/repo" || fail "github target dry-run did not validate repo slug"
git -C "${WORK_ROOT}/repo" remote set-url origin https://gitlab.com/example/repo.git
if bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run-target >"${WORK_ROOT}/gitlab-probe.out" 2>&1; then
  fail "non-GitHub remote accepted by GitHub probe"
fi
git -C "${WORK_ROOT}/repo" remote set-url origin https://github.com/example/repo.git
bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run >/dev/null
bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run >/dev/null
perl -0pi -e 's#export: approved#export: blocked-unless-approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
if bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run >"${WORK_ROOT}/blocked-gh-attach.out" 2>&1; then
  fail "unapproved GitHub artifact attachment was accepted"
fi
perl -0pi -e 's#export: blocked-unless-approved#export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"
bash "${SCRIPTS}/probe-linear-adapter.sh" "${WORK_ROOT}/repo" --dry-run >/dev/null
bash "${SCRIPTS}/read-linear-adapter.sh" "${WORK_ROOT}/repo" "P4Y-123" --dry-run >/dev/null
bash "${SCRIPTS}/attach-linear-artifact.sh" "${WORK_ROOT}/repo" "P4Y-123" ".accelerate/review/qa-report.md" "QA Report" --dry-run >/dev/null

mkdir -p "${WORK_ROOT}/repo/.accelerate/freeform"
if bash "${SCRIPTS}/validate-v2.sh" "${WORK_ROOT}/repo" >"${WORK_ROOT}/bad-layout.out" 2>&1; then
  fail "freeform .accelerate directory accepted"
fi
grep -Fq "unregistered .accelerate directory" "${WORK_ROOT}/bad-layout.out" || fail "layout failure missing expected message"

echo "gstack pattern adoption tests passed"
