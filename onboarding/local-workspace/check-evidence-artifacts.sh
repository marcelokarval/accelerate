#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [review-ready|closure-ready]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
TARGET_STATE="${2:-closure-ready}"
WORKSPACE="${TARGET_ROOT}/.accelerate"
EVIDENCE_FILE="${WORKSPACE}/status/evidence-registry.yaml"

if [ ! -f "${EVIDENCE_FILE}" ]; then
  echo "missing evidence registry: ${EVIDENCE_FILE}" >&2
  exit 1
fi

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

artifact_exists() {
  local artifact="$1"
  case "${artifact}" in
    http://*|https://*|external:*|manual:*)
      return 0
      ;;
    /*)
      [ -e "${artifact}" ]
      ;;
    *)
      [ -e "${TARGET_ROOT}/${artifact}" ]
      ;;
  esac
}

case "${TARGET_STATE}" in
  review-ready)
    keys=(implementation_proof qa_proof_lane)
    ;;
  closure-ready)
    keys=(
      implementation_proof
      qa_proof_lane
      backend_qa
      frontend_qa
      browser_proof
      persistent_e2e
      ux_ui_fullstack_surface
      design_implementation_proof
      product_critical_closure
      requested_vs_implemented
      ai_review
    )
    ;;
  *)
    echo "invalid target state: ${TARGET_STATE}" >&2
    exit 1
    ;;
esac

for key in "${keys[@]}"; do
  status="$(yaml_value "${EVIDENCE_FILE}" "${key}")"
  if [ "${status}" != "present" ]; then
    continue
  fi

  artifact="$(yaml_value "${EVIDENCE_FILE}" "${key}_artifact")"
  if [ -z "${artifact}" ]; then
    echo "artifact gate blocked: ${key}_artifact must be set when ${key}=present" >&2
    exit 1
  fi

  if ! artifact_exists "${artifact}"; then
    echo "artifact gate blocked: ${key}_artifact does not exist: ${artifact}" >&2
    exit 1
  fi
done

echo "evidence artifact gate passed"
