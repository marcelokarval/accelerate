#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { printf 'operational skill trigger truth failed: %s\n' "$1" >&2; exit 1; }

for name in dsh-operations openhands-operations omnirouter-operations; do
  skill="$ROOT/skills/operations/$name/SKILL.md"
  evals="$ROOT/skills/operations/$name/evals/trigger-cases.md"
  runbook="$ROOT/skills/operations/$name/references/runbook.md"
  [[ -f "$skill" ]] || fail "missing $skill"
  [[ -f "$evals" ]] || fail "missing $evals"
  [[ -f "$runbook" ]] || fail "missing $runbook"
  rg -F "name: $name" "$skill" >/dev/null || fail "invalid name for $name"
  rg -F 'should trigger' "$evals" >/dev/null || fail "missing should-trigger cases for $name"
  rg -F 'should not trigger' "$evals" >/dev/null || fail "missing no-trigger cases for $name"
  rg -F "expected: $name" "$evals" >/dev/null || fail "missing expected skill result for $name"
  rg -F 'expected: no-trigger' "$evals" >/dev/null || fail "missing expected no-trigger result for $name"
done

printf 'operational skill trigger truth passed\n'
