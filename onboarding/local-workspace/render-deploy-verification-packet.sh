#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 8 ]; then
  echo "usage: $0 /path/to/target-repo [--persist] [provider-adapter] [deploy-target] [ci-check-status] [deployment-action] [canary-evidence] [rollback-posture]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
shift
PERSIST="false"
if [ "${1:-}" = "--persist" ]; then
  PERSIST="true"
  shift
fi

provider_adapter="${1:-local-manual}"
deploy_target="${2:-production}"
ci_check_status="${3:-passed}"
deployment_action="${4:-manual adapter handoff}"
canary_evidence="${5:-not-applicable with rationale}"
rollback_posture="${6:-rollback path documented}"
result="ready"

case "${provider_adapter}${deploy_target}${ci_check_status}${deployment_action}${canary_evidence}${rollback_posture}" in
  *'<'*|*'>'*)
    echo "deploy verification packet input cannot contain placeholder markers '<' or '>'" >&2
    exit 1
    ;;
esac

case "${ci_check_status}" in
  passed|green|success|not-applicable-with-rationale)
    ;;
  *)
    result="blocked"
    ;;
esac

case "${deployment_action}" in
  not-requested|none|placeholder|todo|tbd|unknown|"")
    result="blocked"
    ;;
esac

case "${canary_evidence}" in
  ""|none|placeholder|todo|tbd|unknown|not-applicable)
    result="blocked"
    ;;
esac

case "${rollback_posture}" in
  ""|none|placeholder|todo|tbd|unknown|not-documented)
    result="blocked"
    ;;
esac

packet="$(cat <<EOF
# Deploy Verification Packet

- provider adapter: ${provider_adapter}
- deploy target: ${deploy_target}
- CI/check status: ${ci_check_status}
- deployment action: ${deployment_action}
- canary evidence: ${canary_evidence}
- rollback posture: ${rollback_posture}
- production readiness result: ${result}
EOF
)"

if [ "${PERSIST}" = "true" ]; then
  mkdir -p "${TARGET_ROOT}/.accelerate/review"
  printf '%s\n' "${packet}" > "${TARGET_ROOT}/.accelerate/review/deploy-verification-packet.md"
  echo "persisted deploy verification packet: .accelerate/review/deploy-verification-packet.md"
else
  printf '%s\n' "${packet}"
fi
