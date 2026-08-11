#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq -- "$expected" "$file"; then
    printf 'missing %q in %s\n' "$expected" "$file" >&2
    exit 1
  fi
}

require "$ROOT/SKILL.md" "## Execution Routes"
require "$ROOT/SKILL.md" '`direct-fast-path`'
require "$ROOT/SKILL.md" '`scoped`'
require "$ROOT/SKILL.md" '`orchestrated`'
require "$ROOT/SKILL.md" "are an execution route, not a"
require "$ROOT/SKILL.md" "classification or execution mode"

require "$ROOT/references/trivial-branch-contract.md" "## Direct Fast Path"
require "$ROOT/references/trivial-branch-contract.md" "physical or virtual subagents"
require "$ROOT/references/trivial-branch-contract.md" "Auth, billing, permissions"
require "$ROOT/references/trivial-branch-contract.md" 'Escalate to `scoped`'

require "$ROOT/core/delegation/subagent-model.md" 'Direct Fast Path: `0` physical or virtual subagents'
require "$ROOT/core/delegation/subagent-model.md" 'Scoped: at most `1` sidecar'
require "$ROOT/core/delegation/subagent-model.md" 'Orchestrated: use `2-3` subagents only when there are two or more'
require "$ROOT/core/delegation/subagent-model.md" "lanes, write scopes do not overlap"
require "$ROOT/core/delegation/subagent-model.md" "a sidecar always escalates the route to Scoped"

require "$ROOT/core/runtime-packets/templates.md" "- execution route: <direct-fast-path|scoped|orchestrated>"
require "$ROOT/core/runtime-packets/templates.md" "- delegation budget: <0|1|2-3>"
require "$ROOT/core/runtime-packets/templates.md" "## Direct Fast Path Packet"
require "$ROOT/core/runtime-packets/templates.md" "- route / delegation budget: direct-fast-path / 0"
require "$ROOT/core/runtime-packets/templates.md" "Use this instead of expanding the full Branch Entry Packet"
require "$ROOT/core/control-plane/quick-invocation-map.md" "direct-fast-path -> direct root execution"
require "$ROOT/global-runtime/accelerate/SKILL.md" "## Execution Routes"
require "$ROOT/global-runtime/accelerate/SKILL.md" "zero physical or"
require "$ROOT/global-runtime/accelerate/SKILL.md" "virtual subagents"
require "$ROOT/global-runtime/accelerate/SKILL.md" 'Escalate out of `direct-fast-path`'

printf 'direct fast path routing policy passed\n'
