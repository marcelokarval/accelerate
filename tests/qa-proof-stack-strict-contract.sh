#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

files=(
  "core/runtime-packets/qa-proof-stack.md"
  "references/qa-proof-stack.md"
  "global-runtime/accelerate/SKILL.md"
  "SKILL.md"
)

terms=(
  "coverage"
  "backend logs"
  "Chrome DevTools console"
  "Chrome DevTools network"
  "screenshots"
  "ARIA/accessibility"
  "Responsive 3x3"
  "Mobile"
  "Tablet"
  "Desktop"
  "detect -> fix -> rerun"
  "Negative Path"
  "Security/Auth/Ownership"
  "Concurrency/Idempotency"
  "Performance Minimum"
  "External Resilience"
  "Clean State/Cleanup"
  "Observability Correlation"
  "happy-path-only-qa"
  "auth-ownership-blind-closure"
  "idempotency-race-blind-closure"
  "resilience-blind-closure"
  "dirty-state-qa"
  "correlation-blind-closure"
)

for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then
    printf 'missing QA contract file: %s\n' "$file" >&2
    exit 1
  fi
done

for term in "${terms[@]}"; do
  if ! grep -RFiq -- "$term" \
    core/runtime-packets/qa-proof-stack.md \
    references/qa-proof-stack.md \
    global-runtime/accelerate/SKILL.md \
    SKILL.md; then
    printf 'missing QA contract term: %s\n' "$term" >&2
    exit 1
  fi
done

if ! grep -Fq 'Backend Coverage=<present|missing|not-configured|blocked>' core/runtime-packets/qa-proof-stack.md; then
  printf 'missing backend coverage closure state\n' >&2
  exit 1
fi

if ! grep -Fq 'Responsive 3x3=<present|reduced|missing|not-applicable|blocked>' core/runtime-packets/qa-proof-stack.md; then
  printf 'missing responsive 3x3 closure state\n' >&2
  exit 1
fi

for state in \
  'Negative Path=<present|missing|not-applicable|blocked>' \
  'Security/Auth/Ownership=<present|missing|not-applicable|blocked>' \
  'Concurrency/Idempotency=<present|missing|not-applicable|blocked>' \
  'Performance Minimum=<present|missing|not-applicable|blocked>' \
  'External Resilience=<present|missing|not-applicable|blocked>' \
  'Clean State/Cleanup=<present|missing|blocked>' \
  'Observability Correlation=<present|missing|not-applicable|blocked>'
do
  if ! grep -Fq "$state" core/runtime-packets/qa-proof-stack.md; then
    printf 'missing QA closure state: %s\n' "$state" >&2
    exit 1
  fi
done

printf 'qa proof stack strict contract passed\n'
