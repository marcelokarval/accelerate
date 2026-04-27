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

artifact_path() {
  local artifact="$1"
  case "${artifact}" in
    http://*|https://*|external:*|manual:*)
      printf '\n'
      ;;
    /*)
      printf '%s\n' "${artifact}"
      ;;
    *)
      printf '%s\n' "${TARGET_ROOT}/${artifact}"
      ;;
  esac
}

require_local_artifact() {
  local key="$1"
  local artifact="$2"
  local resolved
  resolved="$(artifact_path "${artifact}")"
  if [ -z "${resolved}" ]; then
    echo "artifact gate blocked: ${key}_artifact must be a local inspectable proof packet" >&2
    exit 1
  fi
  printf '%s\n' "${resolved}"
}

require_marker() {
  local label="$1"
  local path="$2"
  local marker="$3"
  if ! grep -Fq -- "${marker}" "${path}"; then
    echo "artifact gate blocked: ${label} missing required marker: ${marker}" >&2
    exit 1
  fi
}

field_value() {
  local path="$1"
  local field="$2"
  sed -n "s#^- ${field}:[[:space:]]*##p" "${path}" | head -n 1
}

validate_capture_paths() {
  local label="$1"
  local path="$2"
  local field="$3"
  local value
  value="$(field_value "${path}" "${field}")"

  case "${value}" in
    ""|blocked|n/a|none|not-applicable|manual:*|external:*|http://*|https://*)
      return 0
      ;;
  esac

  value="${value//,/ }"
  for capture in ${value}; do
    case "${capture}" in
      blocked|n/a|none|not-applicable|manual:*|external:*|http://*|https://*)
        continue
        ;;
    esac

    if [[ "${capture}" != .tmp/* ]]; then
      echo "artifact gate blocked: ${label} capture path must be under project .tmp/: ${capture}" >&2
      exit 1
    fi

    if [ ! -e "${TARGET_ROOT}/${capture}" ]; then
      echo "artifact gate blocked: ${label} capture path does not exist: ${capture}" >&2
      exit 1
    fi
  done
}

validate_browser_proof_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "browser_proof" "${artifact}")"

  for marker in \
    "Browser-Proof Packet" \
    "- surface / route family:" \
    "- runtime target:" \
    "- browser tool:" \
    "- intensity:" \
    "- viewport coverage:" \
    "- state coverage:" \
    "- console/runtime errors:" \
    "- console evidence:" \
    "- network/server truth:" \
    "- network evidence:" \
    "- screenshots/captures:" \
    "- residual route-family gaps:" \
    "- readiness impact:"; do
    require_marker "browser_proof_artifact" "${path}" "${marker}"
  done

  if [ "${TARGET_STATE}" = "closure-ready" ]; then
    require_marker "browser_proof_artifact" "${path}" "- readiness impact: supports-closure"
  fi

  validate_capture_paths "browser_proof_artifact" "${path}" "screenshots/captures"
  validate_capture_paths "browser_proof_artifact" "${path}" "console evidence"
  validate_capture_paths "browser_proof_artifact" "${path}" "network evidence"
}

validate_design_implementation_proof_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "design_implementation_proof" "${artifact}")"

  for marker in \
    "Design Implementation Proof Packet" \
    "- target surface:" \
    "- contract authority:" \
    "- source visual evidence:" \
    "- rollout / task driver:" \
    "- owner layer:" \
    "- component mapping:" \
    "- viewport coverage:" \
    "- state coverage:" \
    "- runtime adapter used:" \
    "- captures:" \
    "- artifact comparison result:" \
    "- residual drift:" \
    "- promotion posture:"; do
    require_marker "design_implementation_proof_artifact" "${path}" "${marker}"
  done

  if [ "${TARGET_STATE}" = "closure-ready" ]; then
    require_marker "design_implementation_proof_artifact" "${path}" "- artifact comparison result: aligned"
    require_marker "design_implementation_proof_artifact" "${path}" "- residual drift: none"
    require_marker "design_implementation_proof_artifact" "${path}" "- promotion posture: promotable"
  fi

  validate_capture_paths "design_implementation_proof_artifact" "${path}" "captures"
}

validate_theme_template_portability_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "theme_template_portability" "${artifact}")"

  for marker in \
    "Theme / Template Portability Packet" \
    "- target stack:" \
    "- visual config discovery artifact:" \
    "- token authority file:" \
    "- derived token config:" \
    "- Tailwind mode:" \
    "- desired change class:" \
    "- minimum honest owner layer:" \
    "- theme consumption audit:" \
    "- swap proof packet:" \
    "- residual non-portable surfaces:"; do
    require_marker "theme_template_portability_artifact" "${path}" "${marker}"
  done
}

validate_theme_swap_proof_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "theme_swap_proof" "${artifact}")"

  for marker in \
    "Theme Swap Proof Packet" \
    "- target route/state:" \
    "- token authority file:" \
    "- baseline capture:" \
    "- swapped capture:" \
    "- console evidence:" \
    "- network evidence:" \
    "- expected changed values:" \
    "- expected unchanged anatomy/data/state:" \
    "- primitive token consumption proof:" \
    "- readiness impact:"; do
    require_marker "theme_swap_proof_artifact" "${path}" "${marker}"
  done

  if [ "${TARGET_STATE}" = "closure-ready" ]; then
    require_marker "theme_swap_proof_artifact" "${path}" "- readiness impact: supports-closure"
  fi

  validate_capture_paths "theme_swap_proof_artifact" "${path}" "baseline capture"
  validate_capture_paths "theme_swap_proof_artifact" "${path}" "swapped capture"
  validate_capture_paths "theme_swap_proof_artifact" "${path}" "console evidence"
  validate_capture_paths "theme_swap_proof_artifact" "${path}" "network evidence"
}

validate_template_swap_proof_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "template_swap_proof" "${artifact}")"

  for marker in \
    "Template Swap Proof Packet" \
    "- target route family:" \
    "- template authority artifact:" \
    "- minimum owner layer:" \
    "- anatomy changed:" \
    "- primitives affected:" \
    "- composites affected:" \
    "- shells/layouts affected:" \
    "- baseline capture:" \
    "- swapped capture:" \
    "- console evidence:" \
    "- network evidence:" \
    "- theme-token compatibility:" \
    "- readiness impact:"; do
    require_marker "template_swap_proof_artifact" "${path}" "${marker}"
  done

  if [ "${TARGET_STATE}" = "closure-ready" ]; then
    require_marker "template_swap_proof_artifact" "${path}" "- readiness impact: supports-closure"
  fi

  validate_capture_paths "template_swap_proof_artifact" "${path}" "baseline capture"
  validate_capture_paths "template_swap_proof_artifact" "${path}" "swapped capture"
  validate_capture_paths "template_swap_proof_artifact" "${path}" "console evidence"
  validate_capture_paths "template_swap_proof_artifact" "${path}" "network evidence"
}

validate_componentization_audit_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "componentization_audit" "${artifact}")"

  for marker in \
    "Componentization Enforcement Packet" \
    "- central component owners:" \
    "- ui primitives reused/adapted:" \
    "- second-layer primitives reused/adapted:" \
    "- enhanced/composites reused/adapted:" \
    "- third-party/adapt-first search:" \
    "- page-local exceptions:" \
    "- div/className/direct-class audit:" \
    "- readiness impact:"; do
    require_marker "componentization_audit_artifact" "${path}" "${marker}"
  done

  if [ "${TARGET_STATE}" = "closure-ready" ]; then
    require_marker "componentization_audit_artifact" "${path}" "- readiness impact: supports-closure"
  fi
}

validate_deep_componentization_audit_artifact() {
  local artifact="$1"
  local path
  path="$(require_local_artifact "deep_componentization_audit" "${artifact}")"

  for marker in \
    "Deep Componentization Executive Summary" \
    "- pages scanned:" \
    "- components scanned:" \
    "- TypeScript modules scanned:" \
    "## Related Reports" \
    "## Highest-Risk Pages" \
    "## Report -> Executive Plan"; do
    require_marker "deep_componentization_audit_artifact" "${path}" "${marker}"
  done
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
      theme_template_portability
      visual_config_discovery
      theme_consumption_audit
      theme_swap_proof
      template_swap_proof
      componentization_audit
      deep_componentization_audit
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

  case "${key}" in
    browser_proof)
      validate_browser_proof_artifact "${artifact}"
      ;;
    design_implementation_proof)
      validate_design_implementation_proof_artifact "${artifact}"
      ;;
    theme_template_portability)
      validate_theme_template_portability_artifact "${artifact}"
      ;;
    theme_swap_proof)
      validate_theme_swap_proof_artifact "${artifact}"
      ;;
    template_swap_proof)
      validate_template_swap_proof_artifact "${artifact}"
      ;;
    componentization_audit)
      validate_componentization_audit_artifact "${artifact}"
      ;;
    deep_componentization_audit)
      validate_deep_componentization_audit_artifact "${artifact}"
      ;;
  esac
done

echo "evidence artifact gate passed"
