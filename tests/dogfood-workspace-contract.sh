#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INTERNAL_PROBE_TOKEN=""
if [ "$#" -eq 2 ] && [ "$1" = "--internal-probe" ]; then
  INTERNAL_PROBE_TOKEN="$2"
elif [ "$#" -ne 0 ]; then
  printf 'usage: %s [--internal-probe token]\n' "$0" >&2
  exit 2
fi
cd "${ROOT}"

fail() {
  printf 'dogfood-workspace-contract failed: %s\n' "$1" >&2
  exit 1
}

required_files=(
  ".accelerate/README.md"
  ".accelerate/.gitignore"
  ".accelerate/state.yaml"
  ".accelerate/workflow/README.md"
  ".accelerate/workflow/adapter.yaml"
  ".accelerate/workflow/active-work-item.yaml"
  ".accelerate/review/README.md"
  ".accelerate/status/readiness-dashboard.yaml"
)

for path in "${required_files[@]}"; do
  [ -f "${path}" ] || fail "missing ${path}"
  git ls-files --error-unmatch "${path}" >/dev/null 2>&1 || fail "required dogfood path is not tracked: ${path}"
done

value_for() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

require_value() {
  local path="$1"
  local key="$2"
  local expected="$3"
  local actual
  actual="$(value_for "${path}" "${key}")"
  [ "${actual}" = "${expected}" ] || fail "unexpected ${key} in ${path}: expected ${expected}, got ${actual:-<missing>}"
}

secret_regex='(sk_live|sk_test|pk_live|xox[baprs]-|ghp_[A-Za-z0-9_]+|github_pat_|LINEAR_API_KEY|Authorization: Bearer|BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY)'
tracked_dogfood_files=()
while IFS= read -r -d '' path; do
  tracked_dogfood_files+=("${path}")
done < <(git ls-files -z .accelerate)
if [ "${#tracked_dogfood_files[@]}" -gt 0 ] && grep -E --line-number "${secret_regex}" "${tracked_dogfood_files[@]}" >/tmp/accelerate-dogfood-secret-scan.out 2>/dev/null; then
  cat /tmp/accelerate-dogfood-secret-scan.out >&2
  fail "committed dogfood workspace contains a secret-like marker"
fi
rm -f /tmp/accelerate-dogfood-secret-scan.out

for generated_path in \
  ".accelerate/review/browser-proof.json" \
  ".accelerate/review/browser-proof.png" \
  ".accelerate/workflow/provider-response.jsonl" \
  ".accelerate/status/generated/private-proof.json"; do
  git check-ignore -q "${generated_path}" || fail "generated/private path is not ignored: ${generated_path}"
done

for committed_path in "${required_files[@]}"; do
  if git check-ignore -q "${committed_path}"; then
    fail "required committed dogfood path is ignored: ${committed_path}"
  fi
done

state=".accelerate/state.yaml"
readiness=".accelerate/status/readiness-dashboard.yaml"
active_work_item=".accelerate/workflow/active-work-item.yaml"
adapter=".accelerate/workflow/adapter.yaml"

# Historical cycle
historical_cycle="linear-oauth-runtime-proof-2026-05-08-rc24-rc27"
require_value "${state}" "last_accepted_cycle" "${historical_cycle}"
require_value "${state}" "last_accepted_status" "historical-accepted"
require_value "${adapter}" "active_work_item_id" "${historical_cycle}"
require_value "${adapter}" "active_work_item_locator" ".accelerate/workflow/active-work-item.yaml"

# Validate authority binding through python helper
python3 scripts/validate-dogfood-current-authority.py --root "${ROOT}" >/dev/null

auth_receipt="$(value_for "${state}" "current_authority_receipt")"
auth_digest="$(value_for "${state}" "current_authority_digest")"
[ -n "${auth_receipt}" ] || fail "missing current_authority_receipt in ${state}"
[ -f "${ROOT}/${auth_receipt}" ] || fail "current_authority_receipt not found: ${auth_receipt}"

actual_digest="sha256:$(sha256sum "${ROOT}/${auth_receipt}" | cut -d' ' -f1)"
[ "${actual_digest}" = "${auth_digest}" ] || fail "current_authority_digest mismatch: expected ${auth_digest}, got ${actual_digest}"

current_cycle="$(python3 -c "import json; print(json.load(open('${ROOT}/${auth_receipt}'))['current']['cycle'])")"
current_plan="$(python3 -c "import json; print(json.load(open('${ROOT}/${auth_receipt}'))['current']['plan'])")"
current_ledger="$(python3 -c "import json; print(json.load(open('${ROOT}/${auth_receipt}'))['current']['ledger'])")"
plane_id="$(python3 -c "import json; print(json.load(open('${ROOT}/${auth_receipt}'))['governing_issue']['id'])")"
plane_name="$(python3 -c "import json; print(json.load(open('${ROOT}/${auth_receipt}'))['governing_issue']['identifier'])")"

[ "${current_cycle}" != "codex-26-phase1-c13-reentry" ] || fail "C13 cannot be restored as current cycle"

require_value "${state}" "materialization_profile" "committed-dogfood-v2-index"
require_value "${state}" "onboarding_status" "partial-reonboarding"
require_value "${state}" "reentry_status" "partial-reonboarding"
require_value "${state}" "governing_plane_work_item" "${plane_name}"
require_value "${state}" "governing_plane_work_item_id" "${plane_id}"
require_value "${state}" "current_plan" "${current_plan}"
require_value "${state}" "current_task_ledger" "${current_ledger}"

require_value "${readiness}" "cycle" "${current_cycle}"
require_value "${readiness}" "governing_plane_work_item" "${plane_name}"
require_value "${readiness}" "governing_plane_work_item_id" "${plane_id}"
require_value "${readiness}" "plan" "${current_plan}"
require_value "${readiness}" "ledger" "${current_ledger}"
require_value "${readiness}" "status" "implementing-not-accepted"

require_value "${active_work_item}" "id" "${plane_name}"
require_value "${active_work_item}" "governing_plane_work_item" "${plane_name}"
require_value "${active_work_item}" "governing_plane_work_item_id" "${plane_id}"
require_value "${active_work_item}" "plan" "${current_plan}"
require_value "${active_work_item}" "ledger" "${current_ledger}"
require_value "${active_work_item}" "status" "in-progress"
require_value "${active_work_item}" "remote_calls_allowed" "false"
grep -q '^in_progress_scope:' "${active_work_item}" || fail "active work item missing in_progress_scope"
! grep -q '^accepted_scope:' "${active_work_item}" || fail "active work item must not carry accepted_scope while in-progress"

run_negative_probes() {
  local probe_parent probe_root probe_marker probe_token worktrees_before worktrees_after
  worktrees_before="$(git -C "${ROOT}" worktree list --porcelain)"
  probe_parent="$(mktemp -d)"
  probe_root="${probe_parent}/repo"
  probe_marker="${probe_root}/.accelerate/.dogfood-workspace-contract-probe"
  probe_token="${RANDOM}-${RANDOM}-${RANDOM}-${RANDOM}-${BASHPID}"

  cleanup_probe_root() {
    git -C "${ROOT}" worktree remove --force "${probe_root}" >/dev/null 2>&1 || true
    rmdir "${probe_parent}" >/dev/null 2>&1 || true
  }

  git -C "${ROOT}" worktree add --detach "${probe_root}" HEAD >/dev/null
  trap cleanup_probe_root EXIT

  run_negative_probe() {
    local name="$1"
    local path="$2"
    local expression="$3"
    local expected_failure="$4"
    local probe_output

    git -C "${probe_root}" checkout -- .accelerate
    cp -a "${ROOT}/.accelerate/." "${probe_root}/.accelerate/"
    mkdir -p "${probe_root}/scripts" "${probe_root}/planning"
    cp -a "${ROOT}/scripts/." "${probe_root}/scripts/"
    cp -a "${ROOT}/planning/." "${probe_root}/planning/"
    cp -p "${ROOT}/tests/dogfood-workspace-contract.sh" "${probe_root}/tests/.dogfood-workspace-contract-probe.sh"
    printf '%s\n' "${probe_token}" >"${probe_marker}"
    sed -i "${expression}" "${probe_root}/${path}"

    if probe_output="$(bash "${probe_root}/tests/.dogfood-workspace-contract-probe.sh" --internal-probe "${probe_token}" 2>&1)"; then
      fail "negative probe unexpectedly passed: ${name}"
    fi
    printf '%s\n' "${probe_output}" | grep --fixed-strings "${expected_failure}" >/dev/null || fail "negative probe failed for an unexpected reason: ${name} (got: ${probe_output})"
    printf 'dogfood workspace negative probe passed: %s\n' "${name}"
  }

  run_negative_probe \
    "current false acceptance" \
    ".accelerate/status/readiness-dashboard.yaml" \
    's/^status: implementing-not-accepted$/status: accepted/' \
    "readiness status mismatch: expected implementing-not-accepted, got accepted"

  run_negative_probe \
    "current false closure" \
    ".accelerate/workflow/active-work-item.yaml" \
    's/^status: in-progress$/status: closed/' \
    "active work item status mismatch: expected in-progress, got closed"

  run_negative_probe \
    "remote-call promotion" \
    ".accelerate/workflow/active-work-item.yaml" \
    's/^remote_calls_allowed: false$/remote_calls_allowed: true/' \
    "active work item remote_calls_allowed must be false, got true"

  run_negative_probe \
    "stale Linear plan as current" \
    ".accelerate/state.yaml" \
    's#^current_plan: .*#current_plan: planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md#' \
    "state current_plan mismatch"

  run_negative_probe \
    "authority digest drift" \
    ".accelerate/state.yaml" \
    's/^current_authority_digest:.*/current_authority_digest: sha256:0000000000000000000000000000000000000000000000000000000000000000/' \
    "authority digest"

  run_negative_probe \
    "unknown materialization profile" \
    ".accelerate/state.yaml" \
    's/^materialization_profile:.*/materialization_profile: unknown-profile/' \
    "materialization profile parity mismatch"

  run_negative_probe \
    "blank materialization profile" \
    ".accelerate/state.yaml" \
    's/^materialization_profile:.*/materialization_profile:/' \
    "missing or blank materialization_profile in .accelerate/state.yaml"

  run_negative_probe \
    "duplicate top-level key in state" \
    ".accelerate/state.yaml" \
    's/^materialization_profile:.*/materialization_profile: committed-dogfood-v2-index\nmaterialization_profile: committed-dogfood-v2-index/' \
    "duplicate top-level key 'materialization_profile' in .accelerate/state.yaml"

  run_negative_probe \
    "C13 restored as current" \
    ".accelerate/status/readiness-dashboard.yaml" \
    's/^cycle:.*/cycle: codex-26-phase1-c13-reentry/' \
    "readiness cycle mismatch"

  run_negative_probe \
    "missing authority receipt in state" \
    ".accelerate/state.yaml" \
    '/^current_authority_receipt:/d' \
    "missing current_authority_receipt in .accelerate/state.yaml"

  run_negative_probe \
    "ledger mismatch in active work item" \
    ".accelerate/workflow/active-work-item.yaml" \
    's#^ledger: .*#ledger: planning/executive/2026-05-08-linear-oauth-runtime-proof-task-ledger.md#' \
    "active work item ledger mismatch"

  run_negative_probe \
    "readiness authority digest parity mismatch (triple binding probe)" \
    ".accelerate/status/readiness-dashboard.yaml" \
    's/^authority_digest:.*/authority_digest: sha256:1111111111111111111111111111111111111111111111111111111111111111/' \
    "authority digest parity mismatch: state"

  run_negative_probe \
    "active authority locator parity mismatch (triple binding probe)" \
    ".accelerate/workflow/active-work-item.yaml" \
    's#^authority_receipt: .*#authority_receipt: planning/evidence/dated-proof-appendix/codex-26-phase1/c13-current-status-and-reentry-reconciliation.json#' \
    "authority locator parity mismatch: state"

  run_negative_probe \
    "active governing plane work item id drift" \
    ".accelerate/workflow/active-work-item.yaml" \
    's/^governing_plane_work_item_id:.*/governing_plane_work_item_id: 00000000-0000-0000-0000-000000000000/' \
    "active work item governing_plane_work_item_id mismatch"

  run_negative_probe \
    "active work item carries accepted_scope" \
    ".accelerate/workflow/active-work-item.yaml" \
    's/^in_progress_scope:/accepted_scope:/' \
    "active work item must not carry accepted_scope while in-progress"

  cleanup_probe_root
  trap - EXIT
  worktrees_after="$(git -C "${ROOT}" worktree list --porcelain)"
  if [ "${worktrees_before}" != "${worktrees_after}" ]; then
    fail "negative probe changed the registered worktree set"
  fi
}

if [ -n "${INTERNAL_PROBE_TOKEN}" ]; then
  probe_marker=".accelerate/.dogfood-workspace-contract-probe"
  [ "$(basename "${BASH_SOURCE[0]}")" = ".dogfood-workspace-contract-probe.sh" ] || fail "internal probe must use the copied probe script"
  [ -f "${ROOT}/.git" ] || fail "internal probe must run in a linked worktree"
  git -C "${ROOT}" worktree list --porcelain | awk -v expected="${ROOT}" '
    $1 == "worktree" { current = ($2 == expected); next }
    current && $1 == "detached" { found = 1 }
    END { exit !found }
  ' || fail "internal probe must run in a registered detached worktree"
  [ -f "${probe_marker}" ] || fail "internal probe marker is missing"
  [ "$(<"${probe_marker}")" = "${INTERNAL_PROBE_TOKEN}" ] || fail "internal probe token is invalid"
else
  run_negative_probes
fi

printf 'dogfood workspace contract passed\n'
