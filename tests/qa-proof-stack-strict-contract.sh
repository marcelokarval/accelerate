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
  "Test Data"
  "Contracts"
  "Negative Path"
  "Security/Auth/Ownership"
  "Concurrency/Idempotency"
  "Performance Minimum"
  "Observability"
  "Compatibility"
  "Deep Accessibility"
  "Internationalization"
  "External Resilience"
  "Migration/Rollback"
  "Dependency Audit"
  "Snapshot/Golden Master"
  "Clean State/Cleanup"
  "Observability Correlation"
  "test-data-drift"
  "contract-blind-closure"
  "happy-path-only-qa"
  "auth-ownership-blind-closure"
  "idempotency-race-blind-closure"
  "resilience-blind-closure"
  "compatibility-blind-closure"
  "shallow-a11y-closure"
  "i18n-blind-closure"
  "migration-rollback-blind-closure"
  "dependency-audit-blind-closure"
  "golden-master-blind-closure"
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
  'Test Data=<present|missing|not-applicable|blocked>' \
  'Contracts=<present|missing|not-applicable|blocked>' \
  'Negative Path=<present|missing|not-applicable|blocked>' \
  'Security/Auth/Ownership=<present|missing|not-applicable|blocked>' \
  'Concurrency/Idempotency=<present|missing|not-applicable|blocked>' \
  'Performance Minimum=<present|missing|not-applicable|blocked>' \
  'Observability=<present|missing|not-applicable|blocked>' \
  'Compatibility=<present|missing|not-applicable|blocked>' \
  'Deep Accessibility=<present|missing|not-applicable|blocked>' \
  'Internationalization=<present|missing|not-applicable|blocked>' \
  'External Resilience=<present|missing|not-applicable|blocked>' \
  'Migration/Rollback=<present|missing|not-applicable|blocked>' \
  'Dependency Audit=<present|missing|not-applicable|blocked>' \
  'Snapshot/Golden Master=<present|missing|not-applicable|blocked>' \
  'Clean State/Cleanup=<present|missing|blocked>' \
  'Observability Correlation=<present|missing|not-applicable|blocked>'
do
  if ! grep -Fq "$state" core/runtime-packets/qa-proof-stack.md; then
    printf 'missing QA closure state: %s\n' "$state" >&2
    exit 1
  fi
done

printf 'qa proof stack strict contract passed\n'
