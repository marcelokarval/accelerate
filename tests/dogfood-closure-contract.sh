#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail() {
  printf 'dogfood-closure-contract failed: %s\n' "$1" >&2
  exit 1
}

# 1. Verify prepare-closure detects materialization profile
state="${ROOT}/.accelerate/state.yaml"
[ -f "${state}" ] || fail "missing .accelerate/state.yaml"

profile="$(sed -n 's/^materialization_profile:[[:space:]]*//p' "${state}" | head -n 1)"
[ "${profile}" = "committed-dogfood-v2-index" ] || fail "expected materialization_profile committed-dogfood-v2-index, got '${profile}'"

# 2. Verify external authority binding exists and matches digest
auth_receipt="$(sed -n 's/^current_authority_receipt:[[:space:]]*//p' "${state}" | head -n 1)"
auth_digest="$(sed -n 's/^current_authority_digest:[[:space:]]*//p' "${state}" | head -n 1)"

[ -n "${auth_receipt}" ] || fail "missing current_authority_receipt in state.yaml"
[ -n "${auth_digest}" ] || fail "missing current_authority_digest in state.yaml"
[ -f "${ROOT}/${auth_receipt}" ] || fail "authority receipt does not exist: ${auth_receipt}"

actual_digest="sha256:$(sha256sum "${ROOT}/${auth_receipt}" | cut -d' ' -f1)"
[ "${actual_digest}" = "${auth_digest}" ] || fail "authority digest mismatch: expected ${auth_digest}, got ${actual_digest}"

# 3. Test running prepare-closure.sh on current repo
output="$(bash "${ROOT}/onboarding/local-workspace/prepare-closure.sh" "${ROOT}" 2>&1)" || fail "prepare-closure.sh failed on dogfood repo: ${output}"

# 4. Verify honest preparation: must not claim Done, closed, or accepted
readiness="${ROOT}/.accelerate/status/readiness-dashboard.yaml"
active_work_item="${ROOT}/.accelerate/workflow/active-work-item.yaml"

readiness_status="$(sed -n 's/^status:[[:space:]]*//p' "${readiness}" | head -n 1)"
[ "${readiness_status}" = "implementing-not-accepted" ] || fail "readiness status overclaim: expected implementing-not-accepted, got '${readiness_status}'"

active_status="$(sed -n 's/^status:[[:space:]]*//p' "${active_work_item}" | head -n 1)"
[ "${active_status}" = "in-progress" ] || fail "active work item status overclaim: expected in-progress, got '${active_status}'"

# 5. Verify closure preparation artifacts created under .accelerate/review/
[ -f "${ROOT}/.accelerate/review/dogfood-closure-handoff.md" ] || fail "missing .accelerate/review/dogfood-closure-handoff.md"
[ -f "${ROOT}/.accelerate/review/handoff-summary.md" ] || fail "missing .accelerate/review/handoff-summary.md"
[ -f "${ROOT}/.accelerate/review/closure-packet.md" ] || fail "missing .accelerate/review/closure-packet.md"

for artifact in dogfood-closure-handoff.md handoff-summary.md closure-packet.md; do
  art_path="${ROOT}/.accelerate/review/${artifact}"
  grep -Fq "${auth_receipt}" "${art_path}" || fail "${artifact} missing authority locator: ${auth_receipt}"
  grep -Fq "${auth_digest}" "${art_path}" || fail "${artifact} missing authority digest: ${auth_digest}"
  grep -Fq "In Progress" "${art_path}" || fail "${artifact} missing 'In Progress' lifecycle posture"
  grep -Fq "completed_at: null" "${art_path}" || fail "${artifact} missing 'completed_at: null'"
  grep -Fiq "Remote calls allowed: false" "${art_path}" || fail "${artifact} missing 'Remote calls allowed: false'"
  grep -Fiq "NOT claim acceptance" "${art_path}" || fail "${artifact} missing non-acceptance wording"
  grep -Fiq "Plane closure" "${art_path}" || fail "${artifact} missing non-closure wording"
done

# 6. Verify deterministic output across consecutive runs (hash stability)
h1_handoff="$(sha256sum "${ROOT}/.accelerate/review/dogfood-closure-handoff.md" | cut -d' ' -f1)"
h1_summary="$(sha256sum "${ROOT}/.accelerate/review/handoff-summary.md" | cut -d' ' -f1)"
h1_packet="$(sha256sum "${ROOT}/.accelerate/review/closure-packet.md" | cut -d' ' -f1)"

bash "${ROOT}/onboarding/local-workspace/prepare-closure.sh" "${ROOT}" >/dev/null

h2_handoff="$(sha256sum "${ROOT}/.accelerate/review/dogfood-closure-handoff.md" | cut -d' ' -f1)"
h2_summary="$(sha256sum "${ROOT}/.accelerate/review/handoff-summary.md" | cut -d' ' -f1)"
h2_packet="$(sha256sum "${ROOT}/.accelerate/review/closure-packet.md" | cut -d' ' -f1)"

[ "${h1_handoff}" = "${h2_handoff}" ] || fail "dogfood-closure-handoff.md hash drift across consecutive runs: ${h1_handoff} != ${h2_handoff}"
[ "${h1_summary}" = "${h2_summary}" ] || fail "handoff-summary.md hash drift across consecutive runs: ${h1_summary} != ${h2_summary}"
[ "${h1_packet}" = "${h2_packet}" ] || fail "closure-packet.md hash drift across consecutive runs: ${h1_packet} != ${h2_packet}"

# 7. Focused negative fixtures for prepare-closure.sh materialization profile handling
test_tmp="$(mktemp -d)"
cleanup_test_tmp() {
  rm -rf "${test_tmp}"
}
trap cleanup_test_tmp EXIT

mkdir -p "${test_tmp}/repo/.accelerate/status" "${test_tmp}/repo/.accelerate/workflow"
cp "${ROOT}/.accelerate/status/readiness-dashboard.yaml" "${test_tmp}/repo/.accelerate/status/"
cp "${ROOT}/.accelerate/workflow/active-work-item.yaml" "${test_tmp}/repo/.accelerate/workflow/"

# 7a. Blank profile key fails closed
sed -e 's/^materialization_profile:.*/materialization_profile:/' "${state}" > "${test_tmp}/repo/.accelerate/state.yaml"
if err_blank="$(bash "${ROOT}/onboarding/local-workspace/prepare-closure.sh" "${test_tmp}/repo" 2>&1)"; then
  fail "prepare-closure unexpectedly succeeded with blank materialization_profile"
fi
echo "${err_blank}" | grep -q "blank or malformed materialization_profile" || fail "prepare-closure failed with unexpected error for blank profile: ${err_blank}"

# 7b. Duplicate profile keys fail closed
{
  cat "${state}"
  echo "materialization_profile: full-v2"
} > "${test_tmp}/repo/.accelerate/state.yaml"
if err_dup="$(bash "${ROOT}/onboarding/local-workspace/prepare-closure.sh" "${test_tmp}/repo" 2>&1)"; then
  fail "prepare-closure unexpectedly succeeded with duplicate materialization_profile keys"
fi
echo "${err_dup}" | grep -q "duplicate materialization_profile keys" || fail "prepare-closure failed with unexpected error for duplicate profile: ${err_dup}"

# 7c. Unknown materialization profile fails closed
sed -e 's/^materialization_profile:.*/materialization_profile: unknown-profile-xyz/' "${state}" > "${test_tmp}/repo/.accelerate/state.yaml"
if err_unk="$(bash "${ROOT}/onboarding/local-workspace/prepare-closure.sh" "${test_tmp}/repo" 2>&1)"; then
  fail "prepare-closure unexpectedly succeeded with unknown materialization_profile"
fi
echo "${err_unk}" | grep -q "unknown or malformed materialization profile" || fail "prepare-closure failed with unexpected error for unknown profile: ${err_unk}"

cleanup_test_tmp
trap - EXIT

printf 'dogfood closure contract passed\n'
