#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if grep -RIn "~/.gstack\|~/.claude/skills/gstack" \
  "${ROOT}/core" "${ROOT}/adapters" "${ROOT}/onboarding" "${ROOT}/planning" \
  --exclude-dir=.git --exclude='2026-04-27-gstack-pattern-adoption-executive-plan.md' >/tmp/accelerate-generated-docs-gstack-authority.out 2>/dev/null; then
  echo "gstack user-home path referenced outside source-analysis context" >&2
  cat /tmp/accelerate-generated-docs-gstack-authority.out >&2
  exit 1
fi

echo "generated docs integrity passed"
