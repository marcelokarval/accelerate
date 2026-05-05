#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'workflow-backend-neutrality failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

core_issue="core/issue-topology/issue-driven-mutation-stack.md"
adapter_contract="adapters/workflow/adapter-contract.md"
linear_readme="adapters/workflow/linear/README.md"

require_match 'Backend-Neutral Lifecycle' "$core_issue"
require_match 'backend-neutral' "$adapter_contract"
require_match 'There is no unqualified default remote workflow backend in core' "$adapter_contract"
require_match 'Linear Lifecycle Mapping' "$linear_readme"

for state in shaping planned ready-for-execution in-progress ready-for-review changes-requested ready-for-closure closed blocked; do
  require_match "$state" "$core_issue"
  require_match "$state" "$adapter_contract"
  require_match "$state" "$linear_readme"
done

if rg -n 'default workflow backend is still Linear-shaped|preferred first remote target is still Linear-shaped|current default-shaped doctrine|Linear-shaped default|current default distribution' \
  core/ adapters/workflow/ >/tmp/accelerate-linear-leakage.out; then
  cat /tmp/accelerate-linear-leakage.out >&2
  fail "Linear-shaped default leakage remains in core/workflow contracts"
fi

printf 'workflow backend neutrality passed\n'
