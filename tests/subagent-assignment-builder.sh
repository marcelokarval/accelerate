#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'subagent-assignment-builder failed: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local output="$1"
  local expected="$2"
  printf '%s\n' "$output" | rg -F -- "$expected" >/dev/null || fail "missing expected text: $expected"
}

render() {
  bash onboarding/local-workspace/render-subagent-assignment.sh "$1" "TASK-1" "assigned scope" "write scope" "required evidence"
}

assert_common_packet() {
  local output="$1"
  local role_family="$2"

  assert_contains "$output" "Virtual Subagent Assignment Packet"
  assert_contains "$output" "- task id: TASK-1"
  assert_contains "$output" "- selected role family: ${role_family}"
  assert_contains "$output" "- assigned scope: assigned scope"
  assert_contains "$output" "- write scope: write scope"
  assert_contains "$output" "- required evidence: required evidence"
  assert_contains "$output" "final closure"
  assert_contains "$output" "Done"
  assert_contains "$output" "issue topology"
  assert_contains "$output" "scope expansion"
  assert_contains "$output" "review-of-review"
  assert_contains "$output" "- required return fields:"
  assert_contains "$output" "- cleanup expectation after return: complete"
}

backend_output="$(render backend)"
assert_common_packet "$backend_output" "backend"
assert_contains "$backend_output" "- virtual role: executor"
assert_contains "$backend_output" "active backend stack profile"
assert_contains "$backend_output" "security-patterns"
assert_contains "$backend_output" "acceptance review of own implementation"
assert_contains "$backend_output" "- return contract: Task Execution Return Packet"

frontend_output="$(render frontend)"
assert_common_packet "$frontend_output" "frontend"
assert_contains "$frontend_output" "- virtual role: executor"
assert_contains "$frontend_output" "active frontend stack profile"
assert_contains "$frontend_output" "frontend-boundary-governance"
assert_contains "$frontend_output" "acceptance review of own implementation"
assert_contains "$frontend_output" "- return contract: Task Execution Return Packet"

qa_output="$(render qa-regression)"
assert_common_packet "$qa_output" "qa-regression"
assert_contains "$qa_output" "- virtual role: skeptical-reviewer"
assert_contains "$qa_output" "active test stack profile"
assert_contains "$qa_output" "playwright-patterns"
assert_contains "$qa_output" "- return contract: Skeptical Review Packet"

security_output="$(render security)"
assert_common_packet "$security_output" "security"
assert_contains "$security_output" "- virtual role: skeptical-reviewer"
assert_contains "$security_output" "security-patterns"
assert_contains "$security_output" "anti-abuse-review"
assert_contains "$security_output" "- return contract: Skeptical Review Packet"

architecture_output="$(render architecture)"
assert_common_packet "$architecture_output" "architecture"
assert_contains "$architecture_output" "- virtual role: skeptical-reviewer"
assert_contains "$architecture_output" "architecture"
assert_contains "$architecture_output" "governance-audit"
assert_contains "$architecture_output" "- return contract: Skeptical Review Packet"
assert_contains "$architecture_output" "options, tradeoffs, recommendation, uncertainty"

research_output="$(render research)"
assert_common_packet "$research_output" "research"
assert_contains "$research_output" "- virtual role: skeptical-reviewer"
assert_contains "$research_output" "codebase-inspection"
assert_contains "$research_output" "openai-docs"
assert_contains "$research_output" "sources, source version, official-vs-community, conclusion, uncertainty"
assert_contains "$research_output" "- return contract: Agent Return Packet"

governance_output="$(render governance)"
assert_common_packet "$governance_output" "governance"
assert_contains "$governance_output" "- virtual role: skeptical-reviewer"
assert_contains "$governance_output" "governance-audit"
assert_contains "$governance_output" "active adapter/profile docs"
assert_contains "$governance_output" "- return contract: Skeptical Review Packet"

provider_output="$(render provider-boundary)"
assert_common_packet "$provider_output" "provider-boundary"
assert_contains "$provider_output" "- virtual role: skeptical-reviewer"
assert_contains "$provider_output" "api-surface-governance"
assert_contains "$provider_output" "provider/domain skill"
assert_contains "$provider_output" "- return contract: Skeptical Review Packet"

product_output="$(render product-runtime)"
assert_common_packet "$product_output" "product-runtime"
assert_contains "$product_output" "- virtual role: skeptical-reviewer"
assert_contains "$product_output" "product-runtime-review"
assert_contains "$product_output" "server-prop-governance"
assert_contains "$product_output" "- return contract: Skeptical Review Packet"
assert_contains "$product_output" "evidence, findings, severity, blockers"

other_output="$(render other)"
assert_common_packet "$other_output" "other"
assert_contains "$other_output" "- virtual role: executor"
assert_contains "$other_output" "accelerate"
assert_contains "$other_output" "active profile selected by the orchestrator"
assert_contains "$other_output" "acceptance review of own implementation"
assert_contains "$other_output" "- return contract: Task Execution Return Packet"

invalid_stderr="$(mktemp)"
if bash onboarding/local-workspace/render-subagent-assignment.sh invalid TASK-1 scope writes evidence 2>"$invalid_stderr"; then
  fail "invalid role family unexpectedly succeeded"
fi
assert_contains "$(<"$invalid_stderr")" "invalid role family: invalid"
assert_contains "$(<"$invalid_stderr")" "valid role families:"
rm -f "$invalid_stderr"

too_few_stderr="$(mktemp)"
if bash onboarding/local-workspace/render-subagent-assignment.sh backend TASK-1 scope writes 2>"$too_few_stderr"; then
  fail "too few arguments unexpectedly succeeded"
fi
assert_contains "$(<"$too_few_stderr")" "usage:"
assert_contains "$(<"$too_few_stderr")" "role-family task-id assigned-scope write-scope required-evidence"
rm -f "$too_few_stderr"

too_many_stderr="$(mktemp)"
if bash onboarding/local-workspace/render-subagent-assignment.sh backend TASK-1 scope writes evidence extra 2>"$too_many_stderr"; then
  fail "too many arguments unexpectedly succeeded"
fi
assert_contains "$(<"$too_many_stderr")" "usage:"
assert_contains "$(<"$too_many_stderr")" "role-family task-id assigned-scope write-scope required-evidence"
rm -f "$too_many_stderr"

printf 'subagent assignment builder passed\n'
