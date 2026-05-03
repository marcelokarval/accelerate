#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'base-agent-contract failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

contract="agents/base-agent-contract.md"
execution="agents/promotion/execution-contract.md"
agents_readme="agents/README.md"

[ -f "$contract" ] || fail "missing agents/base-agent-contract.md"

require_match 'The base agent is not an orchestrator' "$contract"
require_match 'Accelerate remains the master orchestrator' "$contract"
require_match 'selected role family' "$contract"
require_match 'required skills / profiles' "$contract"
require_match 'write scope or read-only scope' "$contract"
require_match 'prohibited authority' "$contract"
require_match 'Task Execution Return Packet' "$contract"
require_match 'Skeptical Review Packet' "$contract"
require_match 'Self-review is disclosure only' "$contract"
require_match 'final closure remains root-owned' "$contract"
require_match 'closed' "$contract"
require_match 'completed' "$contract"
require_match 'retained-with-reason' "$contract"
require_match 'base-agent-claims-closure' "$contract"
require_match 'base-agent-left-idle' "$contract"

require_match '../base-agent-contract.md' "$execution"
require_match 'base-agent-contract.md' "$agents_readme"

printf 'base agent contract passed\n'
