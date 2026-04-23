#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [greenfield|adoption]" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$1"
TARGET_WORKSPACE="${TARGET_ROOT}/.accelerate"
TEMPLATE_ROOT="${SCRIPT_DIR}/v2-template/.accelerate"
MODE="${2:-}"

infer_mode() {
  local target_root="$1"
  if find "${target_root}" -mindepth 1 -maxdepth 1 \
    ! -name '.git' \
    ! -name '.accelerate' \
    | grep -q .; then
    echo "adoption"
  else
    echo "greenfield"
  fi
}

if [ ! -d "${TARGET_ROOT}" ]; then
  echo "target repo does not exist: ${TARGET_ROOT}" >&2
  exit 1
fi

if [ -e "${TARGET_WORKSPACE}" ]; then
  echo "target already has .accelerate: ${TARGET_WORKSPACE}" >&2
  exit 1
fi

if [ -z "${MODE}" ]; then
  MODE="$(infer_mode "${TARGET_ROOT}")"
fi

case "${MODE}" in
  greenfield)
    REPO_MATURITY="empty"
    ;;
  adoption)
    REPO_MATURITY="existing"
    ;;
  *)
    echo "invalid mode: ${MODE}. expected greenfield or adoption" >&2
    exit 1
    ;;
esac

cp -R "${TEMPLATE_ROOT}" "${TARGET_WORKSPACE}"

perl -0pi -e "s/^installation_mode:.*/installation_mode: ${MODE}/m" "${TARGET_WORKSPACE}/state.yaml"
perl -0pi -e "s/^repo_maturity:.*/repo_maturity: ${REPO_MATURITY}/m" "${TARGET_WORKSPACE}/state.yaml"
perl -0pi -e "s/^last_bootstrap_update:.*/last_bootstrap_update: $(date +%F)/m" "${TARGET_WORKSPACE}/state.yaml"
perl -0pi -e "s/^last_updated:.*/last_updated: $(date +%F)/m" "${TARGET_WORKSPACE}/onboarding/status.yaml"

"${SCRIPT_DIR}/validate-v2.sh" "${TARGET_ROOT}" >/dev/null

echo "emitted V2 local workspace at:"
echo "  ${TARGET_WORKSPACE}"
echo "mode: ${MODE}"
echo
echo "next steps:"
echo "  1. fill onboarding discovery and decisions"
echo "  2. write the first executive bootstrap plan"
echo "  3. mark story / PRD-lite / SDD / executive-plan / task-breakdown as active or not-required-yet"
echo "  4. update current-plan.md and state.yaml honestly"
