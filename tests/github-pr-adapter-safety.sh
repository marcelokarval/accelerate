#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/github-pr-adapter-safety"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  printf 'github-pr-adapter-safety failed: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local output="$1"
  local expected="$2"
  printf '%s\n' "${output}" | rg -F -- "${expected}" >/dev/null || fail "missing expected text: ${expected}"
}

assert_blocks() {
  local name="$1"
  local expected="$2"
  shift 2
  if "$@" >"${WORK_ROOT}/${name}.out" 2>&1; then
    fail "${name} unexpectedly passed"
  fi
  assert_contains "$(<"${WORK_ROOT}/${name}.out")" "${expected}"
}

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}/repo"

bash "${SCRIPTS}/emit-v2.sh" "${WORK_ROOT}/repo" greenfield >/dev/null
git -C "${WORK_ROOT}/repo" init >/dev/null
git -C "${WORK_ROOT}/repo" remote add origin https://github.com/example/repo.git
perl -0pi -e 's#export: blocked-unless-approved#export: approved#' "${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml"

bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run >/dev/null
bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --dry-run >/dev/null
bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run >/dev/null
bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/github-pr-rehydration.json" --dry-run >/dev/null
bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run >/dev/null
cat >"${WORK_ROOT}/repo/.accelerate/review/closure-packet.md" <<'EOF'
# Accelerate Closure Packet

Proof: focused tests passed.
Self-review: completed.
Forensic review: no known blockers.
Residual risks: remote writes were not performed.
EOF
cat >>"${WORK_ROOT}/repo/.accelerate/status/privacy-map.yaml" <<'YAML'
  - path: .accelerate/review/closure-packet.md
    class: internal-operational
    export: approved
YAML
bash "${SCRIPTS}/comment-github-pr-closure.sh" "${WORK_ROOT}/repo" ".accelerate/review/closure-packet.md" --dry-run >/dev/null
recovery_path="$(bash "${SCRIPTS}/write-github-pr-recovery.sh" "${WORK_ROOT}/repo" land "test recovery")"
bash "${SCRIPTS}/validate-github-pr-recovery.sh" "${WORK_ROOT}/repo" "${recovery_path}" >/dev/null
bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run >/dev/null
bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run >/dev/null
bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run-target >/dev/null

assert_blocks "probe-extra" "usage:" bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run extra
assert_blocks "probe-invalid-mode" "invalid mode:" bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --bad-mode

git -C "${WORK_ROOT}/repo" remote set-url origin https://github.com/example/repo/extra.git
assert_blocks "read-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run
assert_blocks "create-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --dry-run
assert_blocks "attach-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run
assert_blocks "closure-comment-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/comment-github-pr-closure.sh" "${WORK_ROOT}/repo" ".accelerate/review/closure-packet.md" --dry-run
assert_blocks "rehydrate-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/github-pr-rehydration.json" --dry-run
assert_blocks "ship-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run
assert_blocks "land-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run
assert_blocks "probe-target-malformed-slug" "invalid GitHub owner/repo slug" bash "${SCRIPTS}/probe-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run-target
git -C "${WORK_ROOT}/repo" remote set-url origin https://github.com/example/repo.git

assert_blocks "read-extra" "usage:" bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run extra
assert_blocks "read-invalid-mode" "invalid mode:" bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --bad-mode

assert_blocks "create-extra" "usage:" bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --dry-run extra
assert_blocks "create-invalid-mode" "invalid mode:" bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --bad-mode
git -C "${WORK_ROOT}/repo" branch -M main
assert_blocks "create-from-main" "refusing to create a PR from protected base branch" env ACCELERATE_ALLOW_GITHUB_PR_CREATE=1 bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md"
git -C "${WORK_ROOT}/repo" checkout -B feature/adapter-safety >/dev/null 2>&1

assert_blocks "attach-extra" "usage:" bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run extra
assert_blocks "attach-invalid-mode" "invalid mode:" bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --bad-mode

assert_blocks "closure-comment-extra" "usage:" bash "${SCRIPTS}/comment-github-pr-closure.sh" "${WORK_ROOT}/repo" ".accelerate/review/closure-packet.md" --dry-run extra
assert_blocks "closure-comment-invalid-mode" "invalid mode:" bash "${SCRIPTS}/comment-github-pr-closure.sh" "${WORK_ROOT}/repo" ".accelerate/review/closure-packet.md" --bad-mode
printf '# Closure\n\nTODO\n' >"${WORK_ROOT}/repo/.accelerate/review/bad-closure.md"
assert_blocks "closure-comment-bad-artifact" "closure artifact" bash "${SCRIPTS}/comment-github-pr-closure.sh" "${WORK_ROOT}/repo" ".accelerate/review/bad-closure.md" --dry-run

assert_blocks "rehydrate-extra" "usage:" bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/github-pr-rehydration.json" --dry-run extra
assert_blocks "rehydrate-dash-path" "cannot start with '-'" bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" --bad-mode

assert_blocks "ship-extra" "usage:" bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run extra
assert_blocks "ship-dash-path" "cannot start with '-'" bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" --bad-mode

mkdir -p "${WORK_ROOT}/bin"
cat >"${WORK_ROOT}/bin/gh" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${GH_STUB_LOG:?}"
if [ "${1:-}" = "auth" ] && [ "${2:-}" = "status" ]; then
  exit 0
fi
if [ "${1:-}" = "-R" ] && [ "${3:-}" = "pr" ] && [ "${4:-}" = "view" ]; then
  printf '%s\n' '{"number":1,"url":"https://github.com/example/repo/pull/1","state":"OPEN","mergeable":"MERGEABLE","reviewDecision":"APPROVED","statusCheckRollup":[{"conclusion":"SUCCESS","status":"COMPLETED"}],"headRefName":"feature/adapter-safety","headRefOid":"abc","baseRefName":"main"}'
  exit 0
fi
if [ "${1:-}" = "-R" ] && [ "${3:-}" = "pr" ] && [ "${4:-}" = "merge" ]; then
  echo "unexpected live merge in safety test" >&2
  exit 70
fi
echo "unexpected gh invocation: $*" >&2
exit 64
EOF
chmod +x "${WORK_ROOT}/bin/gh"
export PATH="${WORK_ROOT}/bin:${PATH}"
export GH_STUB_LOG="${WORK_ROOT}/gh-stub.log"

assert_blocks "land-extra" "usage:" bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run extra
assert_blocks "land-dash-path" "cannot start with '-'" bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" --bad-mode
rm -f "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json" "${GH_STUB_LOG}"
assert_blocks "land-missing-readiness" "missing ship readiness artifact" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"
[ ! -s "${GH_STUB_LOG}" ] || fail "missing readiness should block before refreshing ship readiness"
printf '%s\n' '{"schema_version":1,"adapter":"github-pr","repo":"example/repo","branch":"feature/adapter-safety","pr_number":1,"head_ref_oid":"abc","ready":false,"missing_requirements":["approved_review"]}' > "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json"
assert_blocks "land-stale-readiness-refresh" "closure proof is required before land" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"
python3 -c 'import json,sys; data=json.load(open(sys.argv[1])); sys.exit(0 if data.get("ready") is True else 1)' "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json" || fail "stale ready=false readiness was not refreshed to ready=true before later land gates"
assert_contains "$(<"${GH_STUB_LOG}")" "pr view"
printf '%s\n' '{"schema_version":1,"adapter":"github-pr","repo":"example/repo","branch":"feature/adapter-safety","pr_number":1,"head_ref_oid":"abc","ready":true}' > "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json"
assert_blocks "land-closure-preflight" "closure proof is required before land" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"
printf '%s\n' '{"schema_version":1,"adapter":"github-pr","repo":"example/repo","branch":"feature/adapter-safety","pr_number":1,"head_ref_oid":"abc","ready":true,"closure_comment_proof":".accelerate/review/unapproved-closure-packet.md"}' > "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json"
cp "${WORK_ROOT}/repo/.accelerate/review/closure-packet.md" "${WORK_ROOT}/repo/.accelerate/review/unapproved-closure-packet.md"
assert_blocks "land-closure-export-preflight" "closure proof is not export-approved before land" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"
printf '%s\n' '{"schema_version":1,"adapter":"github-pr","repo":"example/repo","branch":"feature/adapter-safety","pr_number":1,"head_ref_oid":"abc","ready":true,"closure_comment_proof":".accelerate/review/closure-packet.md"}' > "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json"
assert_blocks "land-production-preflight" "production readiness blocked" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"

cat >"${WORK_ROOT}/repo/.accelerate/workflow/bad-recovery-unknown-repo.md" <<'EOF'
# GitHub PR Recovery Packet

- schema_version: 1
- adapter: github-pr
- operation: land
- reason: test
- recorded_at: 2026-05-05T00:00:00Z
- repo: unknown/unknown
- branch: feature/adapter-safety
- retry_required: true
- retry_command: retry
- remote_write_allowed: false
- zero_context_resume: resume
EOF
assert_blocks "recovery-unknown-repo" "repo cannot be unknown/unknown" bash "${SCRIPTS}/validate-github-pr-recovery.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/bad-recovery-unknown-repo.md"
cat >"${WORK_ROOT}/repo/.accelerate/workflow/bad-recovery-operation.md" <<'EOF'
# GitHub PR Recovery Packet

- schema_version: 1
- adapter: github-pr
- operation: unknown
- reason: test
- recorded_at: 2026-05-05T00:00:00Z
- repo: example/repo
- branch: feature/adapter-safety
- retry_required: true
- retry_command: retry
- remote_write_allowed: false
- zero_context_resume: resume
EOF
assert_blocks "recovery-invalid-operation" "invalid operation" bash "${SCRIPTS}/validate-github-pr-recovery.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/bad-recovery-operation.md"
assert_blocks "write-recovery-invalid-operation" "invalid recovery operation" bash "${SCRIPTS}/write-github-pr-recovery.sh" "${WORK_ROOT}/repo" unknown "test recovery"

printf 'github pr adapter safety passed\n'
