#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "${path}" ]] || fail "missing file: ${path}"
}

require_contains() {
  local path="$1"
  local needle="$2"
  grep -Fq -- "${needle}" "${path}" || fail "${path} missing: ${needle}"
}

I18N_GATE="${ROOT}/core/review/i18n-closure-gate.md"
PARITY_ADAPTER="${ROOT}/adapters/runtime/locale-pack-parity/README.md"
I18N_SKILL="${ROOT}/skills/frontend/i18n-patterns/SKILL.md"
BRANCH_MATRIX="${ROOT}/core/control-plane/branch-enforcement-matrix.md"
PROFILE="${ROOT}/profiles/nextjs-tailwind/validation-bundle.md"

require_file "${I18N_GATE}"
require_file "${PARITY_ADAPTER}"

require_contains "${I18N_GATE}" "supported locales were discovered"
require_contains "${I18N_GATE}" "i18n Closure Packet"
require_contains "${I18N_GATE}" "Backend owns"
require_contains "${I18N_GATE}" "Frontend owns"
require_contains "${I18N_GATE}" "non-default locale proof"

require_contains "${PARITY_ADAPTER}" "Locale Pack Parity Packet"
require_contains "${PARITY_ADAPTER}" "discovering locale roots"
require_contains "${PARITY_ADAPTER}" "project-native commands"

require_contains "${I18N_SKILL}" "Discover and name the active supported locales"
require_contains "${I18N_SKILL}" "core/review/i18n-closure-gate.md"
require_contains "${I18N_SKILL}" "adapters/runtime/locale-pack-parity/README.md"

if grep -Fq "all supported locales: \`en\`, \`pt\`, \`es\`" "${I18N_SKILL}"; then
  fail "i18n skill still hardcodes en/pt/es as universal closure law"
fi

require_contains "${BRANCH_MATRIX}" "Locale Pack Parity Packet"
require_contains "${PROFILE}" "Do not assume a universal locale list"

echo "i18n doctrine tests passed"
