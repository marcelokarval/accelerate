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
bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run >/dev/null

assert_blocks "read-extra" "usage:" bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --dry-run extra
assert_blocks "read-invalid-mode" "invalid mode:" bash "${SCRIPTS}/read-github-pr-adapter.sh" "${WORK_ROOT}/repo" --bad-mode

assert_blocks "create-extra" "usage:" bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --dry-run extra
assert_blocks "create-invalid-mode" "invalid mode:" bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md" --bad-mode
git -C "${WORK_ROOT}/repo" branch -M main
assert_blocks "create-from-main" "refusing to create a PR from protected base branch" env ACCELERATE_ALLOW_GITHUB_PR_CREATE=1 bash "${SCRIPTS}/create-github-pr-adapter.sh" "${WORK_ROOT}/repo" "Test PR" ".accelerate/review/qa-report.md"
git -C "${WORK_ROOT}/repo" checkout -B feature/adapter-safety >/dev/null 2>&1

assert_blocks "attach-extra" "usage:" bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --dry-run extra
assert_blocks "attach-invalid-mode" "invalid mode:" bash "${SCRIPTS}/attach-github-pr-artifact.sh" "${WORK_ROOT}/repo" ".accelerate/review/qa-report.md" "QA Report" --bad-mode

assert_blocks "rehydrate-extra" "usage:" bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" ".accelerate/workflow/github-pr-rehydration.json" --dry-run extra
assert_blocks "rehydrate-dash-path" "cannot start with '-'" bash "${SCRIPTS}/rehydrate-github-pr-adapter.sh" "${WORK_ROOT}/repo" --bad-mode

assert_blocks "ship-extra" "usage:" bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run extra
assert_blocks "ship-dash-path" "cannot start with '-'" bash "${SCRIPTS}/check-ship-readiness.sh" "${WORK_ROOT}/repo" --bad-mode

assert_blocks "land-extra" "usage:" bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json" --dry-run extra
assert_blocks "land-dash-path" "cannot start with '-'" bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" --bad-mode
printf '%s\n' '{"schema_version":1,"adapter":"github-pr","repo":"example/repo","branch":"main","pr_number":1,"head_ref_oid":"abc","ready":true}' > "${WORK_ROOT}/repo/.accelerate/review/ship-readiness.json"
assert_blocks "land-production-preflight" "production readiness blocked" env ACCELERATE_ALLOW_LAND=1 bash "${SCRIPTS}/land-github-pr.sh" "${WORK_ROOT}/repo" ".accelerate/review/ship-readiness.json"

printf 'github pr adapter safety passed\n'
