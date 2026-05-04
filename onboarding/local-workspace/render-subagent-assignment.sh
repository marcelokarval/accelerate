#!/usr/bin/env bash
set -euo pipefail

valid_role_families="architecture, backend, frontend, qa-regression, security, governance, provider-boundary, product-runtime, other"

if [ "$#" -ne 5 ]; then
  printf 'usage: %s role-family task-id assigned-scope write-scope required-evidence\n' "$0" >&2
  exit 1
fi

role_family="$1"
task_id="$2"
assigned_scope="$3"
write_scope="$4"
required_evidence="$5"

virtual_role=""
required_skills=""
prohibited_authority="final closure, Done, issue topology, scope expansion, review-of-review"
return_contract=""

case "${role_family}" in
  architecture)
    virtual_role="skeptical-reviewer"
    required_skills="architecture, governance-audit, api-surface-governance when transport boundaries are active, dependency-governance when dependency posture is active"
    return_contract="Skeptical Review Packet"
    ;;
  backend)
    virtual_role="executor"
    required_skills="active backend stack profile, validation-governance when validation changes, security-patterns when ownership or auth boundaries are active, sql-optimization-patterns when query shape is active"
    prohibited_authority="${prohibited_authority}, acceptance review of own implementation"
    return_contract="Task Execution Return Packet"
    ;;
  frontend)
    virtual_role="executor"
    required_skills="active frontend stack profile, frontend-boundary-governance, tailwind-design-system when visual systems are active, i18n-patterns when copy changes"
    prohibited_authority="${prohibited_authority}, acceptance review of own implementation"
    return_contract="Task Execution Return Packet"
    ;;
  qa-regression)
    virtual_role="skeptical-reviewer"
    required_skills="active test stack profile, playwright-patterns when persistent E2E is active, product-runtime-review when user-facing runtime behavior is active"
    return_contract="Skeptical Review Packet"
    ;;
  security)
    virtual_role="skeptical-reviewer"
    required_skills="security-patterns, anti-abuse-review when user-driven flows can be misused, domain skill selected for billing, storage, auth, or ingress"
    return_contract="Skeptical Review Packet"
    ;;
  governance)
    virtual_role="skeptical-reviewer"
    required_skills="governance-audit, architecture when ownership boundaries are active, active adapter/profile docs selected by the orchestrator"
    return_contract="Skeptical Review Packet"
    ;;
  provider-boundary)
    virtual_role="skeptical-reviewer"
    required_skills="api-surface-governance, governance-audit, provider/domain skill selected by the orchestrator"
    return_contract="Skeptical Review Packet"
    ;;
  product-runtime)
    virtual_role="skeptical-reviewer"
    required_skills="product-runtime-review, server-prop-governance when server-driven state is active, anti-abuse-review when sensitive user actions are active"
    return_contract="Skeptical Review Packet"
    ;;
  other)
    virtual_role="executor"
    required_skills="accelerate, active profile selected by the orchestrator, adjacent skill named by assignment when applicable"
    prohibited_authority="${prohibited_authority}, acceptance review of own implementation"
    return_contract="Task Execution Return Packet"
    ;;
  *)
    printf 'invalid role family: %s\n' "${role_family}" >&2
    printf 'valid role families: %s\n' "${valid_role_families}" >&2
    exit 1
    ;;
esac

cat <<EOF
Virtual Subagent Assignment Packet

- task id: ${task_id}
- virtual role: ${virtual_role}
- selected role family: ${role_family}
- assigned scope: ${assigned_scope}
- required skills / profiles: ${required_skills}
- write scope: ${write_scope}
- required evidence: ${required_evidence}
- prohibited authority: ${prohibited_authority}
- return contract: ${return_contract}
- cleanup expectation after return: complete
EOF
