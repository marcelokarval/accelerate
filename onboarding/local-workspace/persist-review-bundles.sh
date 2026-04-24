#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
REVIEW_DIR="${WORKSPACE}/review"
PRE_REVIEW_FILE="${REVIEW_DIR}/pre-review-bundle.md"
CLOSURE_BUNDLE_FILE="${REVIEW_DIR}/closure-bundle.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${REVIEW_DIR}"

bash "${SCRIPT_DIR}/persist-review-artifacts.sh" "${TARGET_ROOT}" >/dev/null
bash "${SCRIPT_DIR}/render-pre-review-bundle.sh" "${TARGET_ROOT}" > "${PRE_REVIEW_FILE}"
bash "${SCRIPT_DIR}/render-closure-bundle.sh" "${TARGET_ROOT}" > "${CLOSURE_BUNDLE_FILE}"

bash "${SCRIPT_DIR}/append-timeline.sh" \
  "${TARGET_ROOT}" \
  "review-bundles:persisted" \
  "Persisted local pre-review and closure bundles" \
  "info" \
  "persist-review-bundles.sh" >/dev/null

echo "persisted local review bundles"
