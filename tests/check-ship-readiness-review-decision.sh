#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/check-ship-readiness-review-decision"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  printf 'check-ship-readiness-review-decision failed: %s\n' "$1" >&2
  exit 1
}

assert_json() {
  local path="$1"
  local check="$2"
  local message="$3"
  python3 - "$path" "$check" <<'PY' || fail "$message"
import json
import sys
path, check = sys.argv[1], sys.argv[2]
with open(path, encoding="utf-8") as fh:
    data = json.load(fh)
checks = {
    "ready_true": lambda d: d["ready"] is True,
    "approved_not_missing": lambda d: "approved_review" not in d["missing_requirements"],
    "closure_not_invented": lambda d: "closure_comment_proof" not in d,
    "closure_preserved": lambda d: d["closure_comment_proof"] == ".accelerate/review/closure-packet.md",
    "artifact_preserved": lambda d: d["closure_artifact"] == ".accelerate/review/closure-artifact.md",
    "provider_fields_refreshed": lambda d: d["repo"] == "example/repo" and d["branch"] == "feature/ship-ready" and d["pr_number"] == 2 and d["head_ref_oid"] == "abc123" and d["ready"] is True,
    "provider_checks_refreshed": lambda d: d["pr"]["headRefOid"] == "abc123" and d["blocking_checks"] == [] and d["pending_checks"] == [] and d["missing_requirements"] == [],
    "ready_false": lambda d: d["ready"] is False,
    "approved_missing": lambda d: "approved_review" in d["missing_requirements"],
}
try:
    ok = checks[check](data)
except KeyError:
    raise SystemExit(f"unknown check: {check}")
if not ok:
    raise SystemExit(1)
PY
}

run_case() {
  local name="$1"
  local review_decision_json="$2"
  local existing_readiness_json="${3:-}"
  local repo="${WORK_ROOT}/${name}/repo"
  mkdir -p "${repo}"
  git -C "${repo}" init >/dev/null
  git -C "${repo}" checkout -B feature/ship-ready >/dev/null 2>&1
  git -C "${repo}" remote add origin https://github.com/example/repo.git
  if [ -n "${existing_readiness_json}" ]; then
    mkdir -p "${repo}/.accelerate/review"
    printf '%s\n' "${existing_readiness_json}" >"${repo}/.accelerate/review/ship-readiness.json"
  fi
  GH_REVIEW_DECISION_JSON="${review_decision_json}" PATH="${WORK_ROOT}/bin:${PATH}" \
    bash "${SCRIPTS}/check-ship-readiness.sh" "${repo}" ".accelerate/review/ship-readiness.json" >/dev/null
  printf '%s\n' "${repo}/.accelerate/review/ship-readiness.json"
}

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}/bin"
cat >"${WORK_ROOT}/bin/gh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
if [ "${1:-}" = "auth" ] && [ "${2:-}" = "status" ]; then
  exit 0
fi
if [ "${1:-}" = "-R" ] && [ "${3:-}" = "pr" ] && [ "${4:-}" = "view" ]; then
  python3 - <<'PY'
import os
review_decision = os.environ["GH_REVIEW_DECISION_JSON"]
print('{'
      '"number":2,'
      '"url":"https://github.com/example/repo/pull/2",'
      '"state":"OPEN",'
      '"mergeable":"MERGEABLE",'
      f'"reviewDecision":{review_decision},'
      '"statusCheckRollup":[{"name":"ci","conclusion":"SUCCESS","status":"COMPLETED"}],'
      '"headRefName":"feature/ship-ready",'
      '"headRefOid":"abc123",'
      '"baseRefName":"main"'
      '}')
PY
  exit 0
fi
printf 'unexpected gh invocation: %s\n' "$*" >&2
exit 64
SH
chmod +x "${WORK_ROOT}/bin/gh"

empty_output="$(run_case empty '""')"
assert_json "${empty_output}" ready_true 'empty reviewDecision with successful checks was not ready'
assert_json "${empty_output}" approved_not_missing 'empty reviewDecision still required approved_review'
assert_json "${empty_output}" closure_not_invented 'closure_comment_proof was invented when absent'

preserved_output="$(run_case preserved '"APPROVED"' '{"schema_version":1,"adapter":"github-pr","repo":"stale/repo","branch":"stale-branch","pr_number":999,"head_ref_oid":"stale","ready":false,"closure_comment_proof":".accelerate/review/closure-packet.md","closure_artifact":".accelerate/review/closure-artifact.md"}')"
assert_json "${preserved_output}" closure_preserved 'closure_comment_proof was not preserved across refresh'
assert_json "${preserved_output}" artifact_preserved 'closure_artifact was not preserved across refresh'
assert_json "${preserved_output}" provider_fields_refreshed 'provider-derived readiness fields were not refreshed'
assert_json "${preserved_output}" provider_checks_refreshed 'provider-derived PR/check fields were not refreshed'

null_output="$(run_case null null)"
assert_json "${null_output}" ready_true 'null reviewDecision with successful checks was not ready'
assert_json "${null_output}" approved_not_missing 'null reviewDecision still required approved_review'

review_required_output="$(run_case review-required '"REVIEW_REQUIRED"')"
assert_json "${review_required_output}" ready_false 'REVIEW_REQUIRED unexpectedly ready'
assert_json "${review_required_output}" approved_missing 'REVIEW_REQUIRED did not report missing approved_review'

changes_requested_output="$(run_case changes-requested '"CHANGES_REQUESTED"')"
assert_json "${changes_requested_output}" ready_false 'CHANGES_REQUESTED unexpectedly ready'
assert_json "${changes_requested_output}" approved_missing 'CHANGES_REQUESTED did not report missing approved_review'

printf 'check ship readiness review decision passed\n'
