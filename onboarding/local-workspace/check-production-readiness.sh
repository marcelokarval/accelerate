#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -gt 4 ] || [ "$#" -lt 1 ]; then
  echo "usage: $0 /path/to/target-repo [ship-readiness-json] [deploy-verification-packet] [production-risk-approval]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
SHIP_READINESS_PATH="${2:-.accelerate/review/ship-readiness.json}"
DEPLOY_PACKET_PATH="${3:-.accelerate/review/deploy-verification-packet.md}"
APPROVAL_PATH="${4:-.accelerate/review/production-risk-approval.md}"
WORKSPACE="${TARGET_ROOT}/.accelerate"
READINESS_FILE="${WORKSPACE}/status/readiness-dashboard.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

safe_relative_path() {
  local label="$1"
  local path="$2"
  case "${path}" in
    /*|*..*) echo "${label} path must be relative and cannot contain '..': ${path}" >&2; exit 1 ;;
  esac
}

yaml_value() {
  local path="$1"
  local key="$2"
  sed -n "s/^${key}:[[:space:]]*//p" "${path}" | head -n 1
}

block() {
  echo "production readiness blocked: $1" >&2
  exit 1
}

require_file() {
  local label="$1"
  local path="$2"
  [ -f "${path}" ] || block "missing ${label}: ${path}"
}

require_packet_marker() {
  local marker="$1"
  if ! rg -i -F -- "${marker}" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}" >/dev/null; then
    block "deploy verification packet missing marker: ${marker}"
  fi
}

reject_packet_marker() {
  local marker="$1"
  if rg -i -F -- "${marker}" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}" >/dev/null; then
    block "deploy verification packet contains blocked marker: ${marker}"
  fi
}

safe_relative_path "ship readiness" "${SHIP_READINESS_PATH}"
safe_relative_path "deploy verification" "${DEPLOY_PACKET_PATH}"
safe_relative_path "production risk approval" "${APPROVAL_PATH}"

require_file "readiness dashboard" "${READINESS_FILE}"

closure_readiness="$(yaml_value "${READINESS_FILE}" "closure_readiness")"
[ "${closure_readiness}" = "ready" ] || block "closure_readiness must be ready"

bash "${SCRIPT_DIR}/check-evidence-gate.sh" "${TARGET_ROOT}" closure-ready >/dev/null || block "closure-ready evidence gate failed"

require_file "ship readiness packet" "${TARGET_ROOT}/${SHIP_READINESS_PATH}"

SHIP_READINESS_PATH_ABS="${TARGET_ROOT}/${SHIP_READINESS_PATH}" python3 - <<'PY' || exit 1
import json
import os
import sys

path = os.environ["SHIP_READINESS_PATH_ABS"]
with open(path) as handle:
    data = json.load(handle)

if data.get("mode") == "dry-run":
    print("production readiness blocked: ship readiness cannot be dry-run", file=sys.stderr)
    raise SystemExit(1)
if data.get("ready") is not True:
    print("production readiness blocked: ship readiness ready must be true", file=sys.stderr)
    raise SystemExit(1)
PY

require_file "deploy verification packet" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}"
for marker in \
  "provider adapter" \
  "deploy target" \
  "CI/check status" \
  "deployment action" \
  "canary evidence" \
  "rollback posture" \
  "production readiness result"; do
  require_packet_marker "${marker}"
done
reject_packet_marker "<"
reject_packet_marker "deployment action: not-requested"
require_packet_field() {
  local label="$1"
  local expected="$2"
  if ! grep -i -F -x -- "- ${label}: ${expected}" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}" >/dev/null; then
    block "deploy verification packet must contain: ${label}: ${expected}"
  fi
}

require_any_packet_field() {
  local label="$1"
  shift
  local expected
  for expected in "$@"; do
    if grep -i -F -x -- "- ${label}: ${expected}" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}" >/dev/null; then
      return 0
    fi
  done
  block "deploy verification packet ${label} must be one of: $*"
}

reject_any_packet_field() {
  local label="$1"
  shift
  local blocked
  for blocked in "$@"; do
    if grep -i -F -x -- "- ${label}: ${blocked}" "${TARGET_ROOT}/${DEPLOY_PACKET_PATH}" >/dev/null; then
      block "deploy verification packet contains blocked ${label}: ${blocked}"
    fi
  done
}

require_any_packet_field "CI/check status" passed green success not-applicable-with-rationale
reject_any_packet_field "deployment action" not-requested none placeholder todo tbd unknown
reject_any_packet_field "canary evidence" none placeholder todo tbd unknown not-applicable
reject_any_packet_field "rollback posture" none placeholder todo tbd unknown not-documented
require_packet_field "production readiness result" ready

require_file "production risk approval" "${TARGET_ROOT}/${APPROVAL_PATH}"
if ! rg -i -F -- "production-risk approval: approved" "${TARGET_ROOT}/${APPROVAL_PATH}" >/dev/null; then
  block "production risk approval must contain: production-risk approval: approved"
fi

perl -0pi -e "s#^production_readiness:.*#production_readiness: present#m; s#^production_readiness_artifact:.*#production_readiness_artifact: ${SHIP_READINESS_PATH}#m; s#^deploy_verification:.*#deploy_verification: present#m; s#^deploy_verification_artifact:.*#deploy_verification_artifact: ${DEPLOY_PACKET_PATH}#m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${WORKSPACE}/status/evidence-registry.yaml"
if grep -q '^production_readiness:' "${READINESS_FILE}"; then
  perl -0pi -e "s#^production_readiness:.*#production_readiness: ready#m; s#^deploy_verification:.*#deploy_verification: ready#m; s/^last_updated:.*/last_updated: $(date +%F)/m" "${READINESS_FILE}"
fi

echo "production readiness passed"
