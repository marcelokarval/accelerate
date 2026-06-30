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

printf 'qa proof stack strict contract passed\n'
