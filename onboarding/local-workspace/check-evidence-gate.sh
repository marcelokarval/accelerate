#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/target-repo review-ready|closure-ready" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
TARGET_STATE="$2"
WORKSPACE="${TARGET_ROOT}/.accelerate"
EVIDENCE_FILE="${WORKSPACE}/status/evidence-registry.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "${EVIDENCE_FILE}" ]; then
  echo "missing evidence registry: ${EVIDENCE_FILE}" >&2
  exit 1
fi

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

is_present() {
  local key="$1"
  [ "$(yaml_value "${EVIDENCE_FILE}" "${key}")" = "present" ]
}

is_not_applicable_or_present() {
  local key="$1"
  local value
  value="$(yaml_value "${EVIDENCE_FILE}" "${key}")"
  [ "${value}" = "not-applicable" ] || [ "${value}" = "present" ] || [ "${value}" = "clear" ] || [ "${value}" = "not-needed" ]
}

is_present_or_not_applicable() {
  local key="$1"
  local value
  value="$(yaml_value "${EVIDENCE_FILE}" "${key}")"
  [ "${value}" = "present" ] || [ "${value}" = "not-applicable" ]
}

block() {
  local gate="$1"
  local reason="$2"
  echo "evidence gate blocked ${gate}: ${reason}" >&2
  exit 1
}

require_present() {
  local gate="$1"
  local key="$2"
  if ! is_present "${key}"; then
    block "${gate}" "${key} must be present"
  fi
}

require_optional_clean() {
  local gate="$1"
  local key="$2"
  if ! is_not_applicable_or_present "${key}"; then
    block "${gate}" "${key} is not clean or not-applicable"
  fi
}

require_present_or_not_applicable() {
  local gate="$1"
  local key="$2"
  if ! is_present_or_not_applicable "${key}"; then
    block "${gate}" "${key} must be present or not-applicable"
  fi
}

case "${TARGET_STATE}" in
  review-ready)
    require_present "review-ready" "implementation_proof"
    require_present "review-ready" "qa_proof_lane"
    ;;
  closure-ready)
    require_present "closure-ready" "implementation_proof"
    require_present "closure-ready" "qa_proof_lane"
    require_present_or_not_applicable "closure-ready" "backend_qa"
    require_present_or_not_applicable "closure-ready" "frontend_qa"
    require_present_or_not_applicable "closure-ready" "browser_proof"
    require_present_or_not_applicable "closure-ready" "persistent_e2e"
    require_present "closure-ready" "requested_vs_implemented"
    require_present "closure-ready" "ai_review"
    require_optional_clean "closure-ready" "defect_ledger"
    require_optional_clean "closure-ready" "correction_loop"
    require_optional_clean "closure-ready" "seam_proof"
    require_optional_clean "closure-ready" "ux_ui_fullstack_surface"
    require_optional_clean "closure-ready" "design_implementation_proof"
    require_optional_clean "closure-ready" "product_critical_closure"
    ;;
  *)
    echo "invalid target state: ${TARGET_STATE}" >&2
    exit 1
    ;;
esac

bash "${SCRIPT_DIR}/check-evidence-artifacts.sh" "${TARGET_ROOT}" "${TARGET_STATE}" >/dev/null

if [ "${TARGET_STATE}" = "closure-ready" ] && [ -f "${TARGET_ROOT}/docs/reference/design-system.html" ]; then
  bash "${SCRIPT_DIR}/check-design-system-artifact-consistency.sh" "${TARGET_ROOT}" >/dev/null
fi

echo "evidence gate passed ${TARGET_STATE}"
