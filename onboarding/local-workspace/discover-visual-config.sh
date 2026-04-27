#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [output-file]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
OUTPUT_FILE="${2:-${TARGET_ROOT}/.accelerate/onboarding/visual-config.yaml}"

mkdir -p "$(dirname "${OUTPUT_FILE}")"

rel_exists() {
  [ -f "${TARGET_ROOT}/$1" ] || [ -d "${TARGET_ROOT}/$1" ]
}

has_file() {
  [ -f "${TARGET_ROOT}/$1" ]
}

yaml_list() {
  local label="$1"
  shift
  printf '%s:\n' "${label}"
  if [ "$#" -eq 0 ]; then
    printf '  []\n'
    return
  fi
  local item
  for item in "$@"; do
    printf '  - %s\n' "${item}"
  done
}

visual_files=()
for candidate in \
  "app/globals.css" \
  "src/app/globals.css" \
  "pages/_app.css" \
  "src/index.css" \
  "src/main.css" \
  "src/styles/global.css" \
  "src/styles/globals.css" \
  "styles/global.css" \
  "styles/globals.css" \
  "styles/theme.css" \
  "styles/tokens.css" \
  "assets/css/main.css" \
  "resources/css/app.css" \
  "frontend/src/index.css" \
  "frontends/front-react/src/index.css" \
  "frontends/front-react/src/styles/globals.css" \
  "docs/reference/design-system.theme.css" \
  "docs/reference/design-system.premium-theme.css"; do
  if has_file "${candidate}"; then
    visual_files+=("${candidate}")
  fi
done

tailwind_configs=()
for candidate in \
  "tailwind.config.js" \
  "tailwind.config.cjs" \
  "tailwind.config.mjs" \
  "tailwind.config.ts" \
  "config/tailwind.config.js" \
  "frontends/front-react/tailwind.config.js" \
  "frontends/front-react/tailwind.config.ts"; do
  if has_file "${candidate}"; then
    tailwind_configs+=("${candidate}")
  fi
done

postcss_configs=()
for candidate in "postcss.config.js" "postcss.config.cjs" "postcss.config.mjs" "postcss.config.ts"; do
  if has_file "${candidate}"; then
    postcss_configs+=("${candidate}")
  fi
done

component_theme_files=()
for candidate in \
  "components.json" \
  "src/components.json" \
  "frontends/front-react/components.json" \
  "theme.config.ts" \
  "src/theme.ts" \
  "src/theme/index.ts"; do
  if has_file "${candidate}"; then
    component_theme_files+=("${candidate}")
  fi
done

tailwind_mode="none"
if [ "${#tailwind_configs[@]}" -gt 0 ]; then
  tailwind_mode="v3"
fi
if rg -n '@theme\b' "${TARGET_ROOT}" -g '*.css' >/dev/null 2>&1; then
  if [ "${tailwind_mode}" = "v3" ]; then
    tailwind_mode="mixed"
  else
    tailwind_mode="v4"
  fi
fi

theme_selectors=()
if rg -n '\[data-theme=' "${TARGET_ROOT}" -g '*.css' -g '*.tsx' -g '*.jsx' -g '*.ts' -g '*.js' >/dev/null 2>&1; then
  theme_selectors+=("data-theme")
fi
if rg -n '\.dark\b|darkMode' "${TARGET_ROOT}" -g '*.css' -g '*.tsx' -g '*.jsx' -g '*.ts' -g '*.js' >/dev/null 2>&1; then
  theme_selectors+=("dark-class")
fi

token_authority="unknown"
for candidate in \
  "docs/reference/design-system.theme.css" \
  "src/styles/tokens.css" \
  "styles/tokens.css" \
  "styles/theme.css" \
  "app/globals.css" \
  "src/app/globals.css" \
  "src/styles/globals.css" \
  "src/styles/global.css" \
  "styles/globals.css" \
  "src/index.css" \
  "frontends/front-react/src/styles/globals.css" \
  "frontends/front-react/src/styles/global.css" \
  "frontends/front-react/src/index.css" \
  "frontend/src/index.css"; do
  if has_file "${candidate}"; then
    token_authority="${candidate}"
    break
  fi
done

{
  printf 'target_root: %s\n' "${TARGET_ROOT}"
  printf 'token_authority: %s\n' "${token_authority}"
  printf 'tailwind_mode: %s\n' "${tailwind_mode}"
  yaml_list "visual_config_files" "${visual_files[@]}"
  yaml_list "tailwind_config_files" "${tailwind_configs[@]}"
  yaml_list "postcss_config_files" "${postcss_configs[@]}"
  yaml_list "component_theme_files" "${component_theme_files[@]}"
  yaml_list "theme_selectors" "${theme_selectors[@]}"
} > "${OUTPUT_FILE}"

printf 'visual config discovery written: %s\n' "${OUTPUT_FILE}"
