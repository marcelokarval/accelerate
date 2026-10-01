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
grep -Fq "response-locale-gate.md" "${ROOT}/core/control-plane/README.md" || fail "control plane README must list response locale gate"
grep -Fq "Response Locale Gate" "${ROOT}/core/control-plane/gate-ownership-index.md" || fail "gate ownership index must register response locale gate"

echo "response locale gate tests passed"
grep -Fq "preserve the user's language" "${ROOT}/SKILL.md" || fail "entry must preserve user language"
