#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${REVIEW_DIR}"

bash "${SCRIPT_DIR}/render-current-slice-review.sh" "${TARGET_ROOT}" > "${REVIEW_DIR}/current-slice-review.md"
bash "${SCRIPT_DIR}/render-current-slice-forensics.sh" "${TARGET_ROOT}" > "${REVIEW_DIR}/current-slice-forensics.md"

DEFECT_LEDGER="${REVIEW_DIR}/defect-ledger.yaml"
SEAM_PROOF="${REVIEW_DIR}/seam-proof.md"

if [ ! -s "${DEFECT_LEDGER}" ] || grep -Eq '^defects:[[:space:]]*\[\][[:space:]]*$' "${DEFECT_LEDGER}"; then
  bash "${SCRIPT_DIR}/render-defect-ledger.sh" "${TARGET_ROOT}" > "${DEFECT_LEDGER}"
else
  echo "preserved existing defect ledger: ${DEFECT_LEDGER}" >&2
fi

if [ ! -s "${SEAM_PROOF}" ] || grep -Eq '^- seam verdict: not-yet-assessed[[:space:]]*$' "${SEAM_PROOF}"; then
  bash "${SCRIPT_DIR}/render-seam-proof.sh" "${TARGET_ROOT}" > "${SEAM_PROOF}"
else
  echo "preserved existing seam proof: ${SEAM_PROOF}" >&2
fi

bash "${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "review-diagnostics:persisted" \
  "Persisted current-slice review, forensics, defect ledger, and seam proof" \
  "info" \
  "persist-review-diagnostics.sh" >/dev/null

echo "persisted local review diagnostics"
