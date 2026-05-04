#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'agent-template-integrity failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

templates=(
  agents/templates/base-agent.md
  agents/templates/architecture-reviewer.md
  agents/templates/qa-regression-reviewer.md
  agents/templates/security-reviewer.md
  agents/templates/backend-worker.md
  agents/templates/frontend-worker.md
  agents/templates/governance-auditor.md
)

for template in "${templates[@]}"; do
  [ -f "$template" ] || fail "missing template: $template"
  require_match '../base-agent-contract.md' "$template"
  require_match 'selected role family:' "$template"
  require_match 'Required Skills / Profiles' "$template"
  require_match 'Prohibited Authority' "$template"
  require_match 'Return Contract' "$template"
  require_match 'Cleanup Behavior' "$template"
  require_match 'cleanup expectation after return:' "$template"
done

for template in "${templates[@]}"; do
  if rg -n 'final closure[^\n]*(allowed|owned by agent)|`Done`[^\n]*(allowed|owned by agent)' "$template" >/dev/null; then
    fail "template claims forbidden closure authority: $template"
  fi
done

require_match 'architecture-reviewer.md' agents/templates/README.md
require_match 'qa-regression-reviewer.md' agents/templates/README.md
require_match 'security-reviewer.md' agents/templates/README.md
require_match 'backend-worker.md' agents/templates/README.md
require_match 'frontend-worker.md' agents/templates/README.md
require_match 'governance-auditor.md' agents/templates/README.md

printf 'agent template integrity passed\n'
