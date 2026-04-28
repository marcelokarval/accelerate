#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'response-locale-gate failed: %s\n' "$1" >&2
  exit 1
}

gate="${ROOT}/core/control-plane/response-locale-gate.md"
[ -f "${gate}" ] || fail "missing response locale gate"

grep -Fq "Brazilian Portuguese" "${gate}" || fail "gate must explicitly cover Brazilian Portuguese"
grep -Fq "pt-BR" "${gate}" || fail "gate must name pt-BR"
grep -Fq "Do not switch to English" "${gate}" || fail "gate must block English drift"
grep -Fq "root must verify" "${gate}" || fail "gate closure rule must be mandatory"
grep -Fq "steps must be in pt-BR" "${gate}" || fail "pt-BR closure must be mandatory"
grep -Fq "response locale" "${ROOT}/SKILL.md" || fail "SKILL.md must mention response locale"
grep -Fq "core/control-plane/response-locale-gate.md" "${ROOT}/SKILL.md" || fail "SKILL.md must link response locale gate"
grep -Fq "response locale matching the user's request language" "${ROOT}/core/control-plane/root-laws.md" || fail "root laws must own response locale"
grep -Fq "final response must be in pt-BR" "${ROOT}/core/control-plane/root-laws.md" || fail "root laws must require pt-BR final response"
grep -Fq "pt-BR" "${ROOT}/README.md" || fail "README must mention pt-BR response behavior"
grep -Fq "Accelerate must answer in pt-BR" "${ROOT}/README.md" || fail "README must use mandatory pt-BR language"
grep -Fq "response-locale-gate.md" "${ROOT}/core/control-plane/README.md" || fail "control plane README must list response locale gate"
grep -Fq "Response Locale Gate" "${ROOT}/core/control-plane/gate-ownership-index.md" || fail "gate ownership index must register response locale gate"

echo "response locale gate tests passed"
