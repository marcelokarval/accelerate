#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/design-system-artifact-consistency"
SCRIPT="${ROOT}/onboarding/local-workspace/check-design-system-artifact-consistency.sh"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if ! printf '%s' "${haystack}" | grep -Fq "${needle}"; then
    fail "expected output to contain: ${needle}"
  fi
}

write_bad_source_truth_fixture() {
  local target="$1"
  mkdir -p "${target}/docs/reference"
  cat > "${target}/docs/reference/design-system.theme.css" <<'CSS'
:root { --ds-bg: #fff; }
CSS
  cat > "${target}/docs/reference/design-system.html" <<'HTML'
<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="./design-system.theme.css">
    <style>
      :root { --bg: #fff; }
      .card { color: var(--bg); }
      .ds-doc-shell { padding: 1rem; }
    </style>
  </head>
  <body><div class="card">Card</div></body>
</html>
HTML
  cat > "${target}/docs/reference/design-system.contract.md" <<'MD'
# Contract

## Token Contract

- `--background` is the canvas token.

## Component Recipes

- `.source-card` is the card recipe.
MD
}

write_good_source_truth_fixture() {
  local target="$1"
  mkdir -p "${target}/docs/reference"
  cat > "${target}/docs/reference/design-system.theme.css" <<'CSS'
:root {
  --ds-bg: #fff;
  --ds-surface: #fff;
}
CSS
  cat > "${target}/docs/reference/design-system.html" <<'HTML'
<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="./design-system.theme.css">
    <style>
      .source-card { color: var(--ds-bg); background: var(--ds-surface); }
      .ds-doc-shell { padding: 1rem; }
    </style>
  </head>
  <body><div class="source-card">Card</div></body>
</html>
HTML
  cat > "${target}/docs/reference/design-system.contract.md" <<'MD'
# Contract

## Token Contract

- `--ds-bg` is the canvas token.
- `--ds-surface` is the card surface token.

## Component Recipes

- `.source-card` is the card recipe.
MD
}

write_bad_premium_fixture() {
  local target="$1"
  write_good_source_truth_fixture "${target}"
  cat > "${target}/docs/reference/design-system.premium-direction.html" <<'HTML'
<!doctype html>
<html>
  <head><link rel="stylesheet" href="./design-system.premium-theme.css"><style>:root { --premium-bg: #f7f0df; }</style></head>
  <body>Premium</body>
</html>
HTML
  cat > "${target}/docs/reference/design-system.premium-theme.css" <<'CSS'
:root { --ds-bg: #f7f0df; }
CSS
  cat > "${target}/docs/reference/design-system.premium-direction.md" <<'MD'
# Premium Direction

- `--ledger-bg` is the proposed premium canvas.
MD
}

write_good_premium_fixture() {
  local target="$1"
  write_good_source_truth_fixture "${target}"
  cat > "${target}/docs/reference/design-system.slop-audit.md" <<'MD'
# Slop Audit

## AI/Genericity Score

Score: 4/24.

## Detection Matrix

| Signal | Score | Evidence | Correction |
| --- | --- | --- | --- |
| Card soup | 1 | Baseline repeats panels. | Increase table density. |

## Priority Corrections

- Improve dense hierarchy and trust cues.
MD
  cat > "${target}/docs/reference/design-system.premium-direction.html" <<'HTML'
<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="./design-system.premium-theme.css">
    <style>.source-card { color: var(--ds-bg); background: var(--ds-surface); }</style>
  </head>
  <body data-theme="light"><div class="source-card">Premium</div></body>
</html>
HTML
  cat > "${target}/docs/reference/design-system.premium-theme.css" <<'CSS'
:root {
  --ds-bg: #fbfaf6;
  --ds-surface: #ffffff;
}
CSS
  cat > "${target}/docs/reference/design-system.premium-direction.md" <<'MD'
# Premium Direction

## Token Contract

- `--ds-bg` is the premium canvas token.
- `--ds-surface` is the premium card surface token.

## Benchmark Influence Map

| Benchmark | Relevant Quality | Adopted Principle | Token/Component Impact | Non-Copy Boundary |
| --- | --- | --- | --- | --- |
| Wise | money clarity | calmer trusted canvas | `--ds-bg` | no Wise green clone |
| Linear | hierarchy restraint | quieter panels | `--ds-surface` | no Linear purple clone |

## Single Active Theme Model

One theme is active at a time through `data-theme`, using the same component anatomy.
MD
}

write_bad_dual_theme_fixture() {
  local target="$1"
  write_good_premium_fixture "${target}"
  cat > "${target}/docs/reference/design-system.premium-direction.html" <<'HTML'
<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="./design-system.premium-theme.css">
    <style>.source-card { color: var(--ds-bg); background: var(--ds-surface); }</style>
  </head>
  <body><section><h2>Light vs Dark System</h2><div class="source-card">Split themes</div></section></body>
</html>
HTML
}

rm -rf "${WORK_ROOT}"
mkdir -p "${WORK_ROOT}"

bad_source="${WORK_ROOT}/bad-source-truth"
write_bad_source_truth_fixture "${bad_source}"
bad_source_output="${WORK_ROOT}/bad-source.out"
if bash "${SCRIPT}" "${bad_source}" >"${bad_source_output}" 2>&1; then
  fail "source-truth mismatch passed consistency gate"
fi
assert_contains "$(cat "${bad_source_output}")" "source-truth HTML token not declared in theme CSS: --bg"
assert_contains "$(cat "${bad_source_output}")" "source-truth HTML class not documented in contract: .card"

good_source="${WORK_ROOT}/good-source-truth"
write_good_source_truth_fixture "${good_source}"
bash "${SCRIPT}" "${good_source}" >/dev/null

bad_premium="${WORK_ROOT}/bad-premium"
write_bad_premium_fixture "${bad_premium}"
bad_premium_output="${WORK_ROOT}/bad-premium.out"
if bash "${SCRIPT}" "${bad_premium}" >"${bad_premium_output}" 2>&1; then
  fail "premium mismatch passed consistency gate"
fi
assert_contains "$(cat "${bad_premium_output}")" "premium HTML token not documented in premium direction: --premium-bg"
assert_contains "$(cat "${bad_premium_output}")" "premium HTML token not declared in premium theme CSS: --premium-bg"
assert_contains "$(cat "${bad_premium_output}")" "premium direction token not declared in premium theme CSS: --ledger-bg"
assert_contains "$(cat "${bad_premium_output}")" "missing premium slop audit"
assert_contains "$(cat "${bad_premium_output}")" "premium direction missing required marker: ## Benchmark Influence Map"

good_premium="${WORK_ROOT}/good-premium"
write_good_premium_fixture "${good_premium}"
bash "${SCRIPT}" "${good_premium}" >/dev/null

bad_dual_theme="${WORK_ROOT}/bad-dual-theme"
write_bad_dual_theme_fixture "${bad_dual_theme}"
bad_dual_theme_output="${WORK_ROOT}/bad-dual-theme.out"
if bash "${SCRIPT}" "${bad_dual_theme}" >"${bad_dual_theme_output}" 2>&1; then
  fail "dual light/dark product composition passed consistency gate"
fi
assert_contains "$(cat "${bad_dual_theme_output}")" "premium HTML must not present Light vs Dark System as simultaneous product composition"

echo "design-system artifact consistency tests passed"
