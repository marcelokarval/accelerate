#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/theme-template-portability"
DISCOVER="${ROOT}/onboarding/local-workspace/discover-visual-config.sh"
AUDIT="${ROOT}/onboarding/local-workspace/check-theme-consumption.sh"
COMPONENT_AUDIT="${ROOT}/onboarding/local-workspace/check-componentization-discipline.sh"
DEEP_AUDIT="${ROOT}/onboarding/local-workspace/run-deep-componentization-audit.sh"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if ! printf '%s' "${haystack}" | grep -Fq -- "${needle}"; then
    fail "expected output to contain: ${needle}"
  fi
}

write_good_tailwind_v4_fixture() {
  local target="$1"
  mkdir -p "${target}/app" "${target}/components/ui"
  cat > "${target}/package.json" <<'JSON'
{"dependencies":{"tailwindcss":"^4.0.0","react":"latest"}}
JSON
  cat > "${target}/app/globals.css" <<'CSS'
:root {
  --ds-bg: #ffffff;
  --ds-fg: #111111;
  --ds-primary: #2563eb;
  --ds-radius-md: 0.75rem;
}

@theme {
  --color-background: var(--ds-bg);
  --color-foreground: var(--ds-fg);
  --color-primary: var(--ds-primary);
  --radius-md: var(--ds-radius-md);
}

.card { background: var(--ds-bg); color: var(--ds-fg); }
CSS
  cat > "${target}/components/ui/button.tsx" <<'TSX'
export function Button() {
  return <button className="bg-primary text-background rounded-md">Save</button>
}
TSX
}

write_bad_div_soup_fixture() {
  local target="$1"
  mkdir -p "${target}/app/dashboard" "${target}/components/ui"
  cat > "${target}/app/dashboard/page.tsx" <<'TSX'
export default function Page() {
  return <main>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">1</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">2</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">3</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">4</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">5</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">6</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">7</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">8</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">9</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">10</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">11</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">12</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">13</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">14</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">15</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">16</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">17</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">18</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">19</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">20</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">21</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">22</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">23</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">24</div>
    <div className="bg-white text-black border-gray-200 p-1 m-1 rounded shadow">25</div>
  </main>
}
TSX
}

write_bad_missing_consumption_fixture() {
  local target="$1"
  mkdir -p "${target}/app" "${target}/components/ui"
  cat > "${target}/package.json" <<'JSON'
{"dependencies":{"tailwindcss":"^4.0.0","react":"latest"}}
JSON
  cat > "${target}/app/globals.css" <<'CSS'
:root {
  --ds-bg: #ffffff;
  --ds-fg: #111111;
}
CSS
  cat > "${target}/components/ui/card.tsx" <<'TSX'
export function Card() {
  return <section className="bg-white text-black border-gray-200">Card</section>
}
TSX
}

write_bad_tailwind_raw_fixture() {
  local target="$1"
  mkdir -p "${target}/app"
  cat > "${target}/package.json" <<'JSON'
{"dependencies":{"tailwindcss":"^3.4.0","react":"latest"}}
JSON
  cat > "${target}/tailwind.config.js" <<'JS'
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#7c3aed',
      },
    },
  },
}
JS
  cat > "${target}/app/globals.css" <<'CSS'
:root { --ds-primary: #2563eb; }
.button { color: var(--ds-primary); }
CSS
}

write_legacy_semantic_fixture() {
  local target="$1"
  mkdir -p "${target}/frontends/front-react/src/styles" "${target}/frontends/front-react/src/components/ui"
  cat > "${target}/package.json" <<'JSON'
{"dependencies":{"tailwindcss":"^4.0.0","react":"latest"}}
JSON
  cat > "${target}/frontends/front-react/src/styles/globals.css" <<'CSS'
:root {
  --background: 34 38% 98%;
  --foreground: 24 16% 14%;
  --primary: 24 92% 50%;
}

@theme {
  --color-background: hsl(var(--background));
  --color-foreground: hsl(var(--foreground));
}
CSS
  cat > "${target}/frontends/front-react/src/components/ui/button.tsx" <<'TSX'
export function Button() {
  return <button className="bg-primary text-primary-foreground">Save</button>
}
TSX
}

write_shadcn_alias_map_fixture() {
  local target="$1"
  mkdir -p "${target}/frontends/front-react/src/styles" "${target}/frontends/front-react/src/components/ui"
  cat > "${target}/package.json" <<'JSON'
{"dependencies":{"tailwindcss":"^4.0.0","react":"latest"}}
JSON
  cat > "${target}/frontends/front-react/src/styles/globals.css" <<'CSS'
/* Token Alias Map
 * --ds-bg => --background
 * --ds-fg => --foreground
 * --ds-primary => --primary
 */
:root {
  --background: 34 38% 98%;
  --foreground: 24 16% 14%;
  --primary: 24 92% 50%;
}

@theme {
  --color-background: hsl(var(--background));
  --color-foreground: hsl(var(--foreground));
  --color-primary: hsl(var(--primary));
}
CSS
  cat > "${target}/frontends/front-react/src/components/ui/button.tsx" <<'TSX'
export function Button() {
  return <button className="bg-primary text-foreground">Save</button>
}
TSX
}

write_brand_icon_fixture() {
  local target="$1"
  mkdir -p "${target}/src/components/icons" "${target}/src/components/ui"
  cat > "${target}/src/components/icons/card-brand-icons.tsx" <<'TSX'
export function CardBrandIcon() {
  return <svg viewBox="0 0 10 10">
    <rect fill="#FFFFFF" width="10" height="10" />
    <path fill="#1A1F71" d="M0 0h10v2H0z" />
    <path fill="#F9A533" d="M0 2h10v2H0z" />
    <path fill="#EB001B" d="M0 4h10v2H0z" />
    <path fill="#F79E1B" d="M0 6h10v2H0z" />
    <path fill="#FF5F00" d="M0 8h10v2H0z" />
    <path fill="#006FCF" d="M1 0h1v10H1z" />
    <path fill="#F27712" d="M2 0h1v10H2z" />
    <path fill="#231F20" d="M3 0h1v10H3z" />
    <path fill="#0079BE" d="M4 0h1v10H4z" />
    <path fill="#58B03A" d="M5 0h1v10H5z" />
    <path fill="#0F56A2" d="M6 0h1v10H6z" />
    <path fill="#ED1C2E" d="M7 0h1v10H7z" />
    <path fill="#00447C" d="M8 0h1v10H8z" />
    <path fill="#E21836" d="M9 0h1v10H9z" />
    <path fill="#007B84" d="M0 9h10v1H0z" />
    <path fill="#E5E7EB" d="M0 8h10v1H0z" />
    <path fill="#9CA3AF" d="M0 7h10v1H0z" />
    <path fill="#D1D5DB" d="M0 6h10v1H0z" />
    <path fill="#111111" d="M0 5h10v1H0z" />
  </svg>
}
TSX
}

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}"

good="${WORK_ROOT}/good-tailwind-v4"
write_good_tailwind_v4_fixture "${good}"
bash "${DISCOVER}" "${good}" >/dev/null
grep -Fq 'tailwind_mode: v4' "${good}/.accelerate/onboarding/visual-config.yaml" || fail "expected Tailwind v4 detection"
bash "${AUDIT}" "${good}" >/dev/null
bash "${COMPONENT_AUDIT}" "${good}" >/dev/null

bad_consumption="${WORK_ROOT}/bad-missing-consumption"
write_bad_missing_consumption_fixture "${bad_consumption}"
bash "${DISCOVER}" "${bad_consumption}" >/dev/null
bad_consumption_output="${WORK_ROOT}/bad-consumption.out"
if bash "${AUDIT}" "${bad_consumption}" >"${bad_consumption_output}" 2>&1; then
  fail "missing token consumption passed audit"
fi
assert_contains "$(cat "${bad_consumption_output}")" "no --ds-* token consumption found"

bad_tailwind="${WORK_ROOT}/bad-tailwind-raw"
write_bad_tailwind_raw_fixture "${bad_tailwind}"
bash "${DISCOVER}" "${bad_tailwind}" >/dev/null
bad_tailwind_output="${WORK_ROOT}/bad-tailwind.out"
if bash "${AUDIT}" "${bad_tailwind}" >"${bad_tailwind_output}" 2>&1; then
  fail "raw Tailwind values passed audit"
fi
assert_contains "$(cat "${bad_tailwind_output}")" "Tailwind visual config appears to use raw values"

legacy_semantic="${WORK_ROOT}/legacy-semantic"
write_legacy_semantic_fixture "${legacy_semantic}"
bash "${DISCOVER}" "${legacy_semantic}" >/dev/null
grep -Fq 'token_authority: frontends/front-react/src/styles/globals.css' "${legacy_semantic}/.accelerate/onboarding/visual-config.yaml" || fail "expected nested front-react globals.css token authority"
legacy_output="${WORK_ROOT}/legacy-semantic.out"
if bash "${AUDIT}" "${legacy_semantic}" >"${legacy_output}" 2>&1; then
  fail "legacy semantic tokens without --ds aliases passed audit"
fi
assert_contains "$(cat "${legacy_output}")" "semantic tokens exist but no Token Alias Map or --ds-* compatibility aliases were found"

shadcn_alias="${WORK_ROOT}/shadcn-alias-map"
write_shadcn_alias_map_fixture "${shadcn_alias}"
bash "${DISCOVER}" "${shadcn_alias}" >/dev/null
bash "${AUDIT}" "${shadcn_alias}" >/dev/null

bad_div_soup="${WORK_ROOT}/bad-div-soup"
write_bad_div_soup_fixture "${bad_div_soup}"
bad_div_output="${WORK_ROOT}/bad-div-soup.out"
if bash "${COMPONENT_AUDIT}" "${bad_div_soup}" >"${bad_div_output}" 2>&1; then
  fail "div soup passed componentization audit"
fi
assert_contains "$(cat "${bad_div_output}")" "possible div soup"

brand_icon="${WORK_ROOT}/brand-icon"
write_brand_icon_fixture "${brand_icon}"
bash "${COMPONENT_AUDIT}" "${brand_icon}" >/dev/null

deep_audit="${WORK_ROOT}/deep-audit"
write_bad_div_soup_fixture "${deep_audit}"
mkdir -p "${deep_audit}/src/components/ui" "${deep_audit}/src/shared/lib"
cat > "${deep_audit}/src/components/ui/card.tsx" <<'TSX'
export function Card() {
  return <div className="rounded border bg-card p-4 text-card-foreground">Card</div>
}
TSX
cat > "${deep_audit}/src/shared/lib/formatters.ts" <<'TS'
export const formatCurrency = (value: number) => `$${value.toFixed(2)}`;
export const formatStatus = (value: string) => value.toUpperCase();
TS
bash "${DEEP_AUDIT}" "${deep_audit}" >/dev/null
[ -f "${deep_audit}/.accelerate/review/componentization/executive-summary.md" ] || fail "missing deep audit executive summary"
[ -f "${deep_audit}/.accelerate/review/componentization/components-report.md" ] || fail "missing component report"
[ -f "${deep_audit}/.accelerate/review/componentization/typescript-report.md" ] || fail "missing TypeScript report"
assert_contains "$(cat "${deep_audit}/.accelerate/review/componentization/executive-summary.md")" "## Report -> Executive Plan"
assert_contains "$(cat "${deep_audit}/.accelerate/review/componentization/typescript-report.md")" "# TypeScript Responsibility Report"

echo "theme template portability tests passed"
