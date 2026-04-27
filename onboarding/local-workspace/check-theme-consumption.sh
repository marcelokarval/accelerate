#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 /path/to/target-repo [visual-config.yaml]" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
VISUAL_CONFIG="${2:-${TARGET_ROOT}/.accelerate/onboarding/visual-config.yaml}"
failures=0

report() {
  echo "theme consumption audit blocked: $*" >&2
  failures=$((failures + 1))
}

yaml_scalar() {
  local key="$1"
  if [ -f "${VISUAL_CONFIG}" ]; then
    sed -n "s/^${key}:[[:space:]]*//p" "${VISUAL_CONFIG}" | head -n 1
  fi
}

has_ds_token_definition() {
  rg -n \
    --glob '*.css' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- '--ds-[A-Za-z0-9_-]+[[:space:]]*:' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_legacy_semantic_token_definition() {
  rg -n \
    --glob '*.css' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- '--(background|foreground|card|card-foreground|popover|popover-foreground|primary|primary-foreground|secondary|secondary-foreground|muted|muted-foreground|accent|accent-foreground|border|input|ring|brand|brand-orange|radius)[[:space:]]*:' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_ds_token_consumption() {
  rg -n \
    --glob '*.css' \
    --glob '*.tsx' \
    --glob '*.jsx' \
    --glob '*.ts' \
    --glob '*.js' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- 'var\(--ds-[A-Za-z0-9_-]+\)' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_legacy_semantic_token_consumption() {
  rg -n \
    --glob '*.css' \
    --glob '*.tsx' \
    --glob '*.jsx' \
    --glob '*.ts' \
    --glob '*.js' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- 'var\(--(background|foreground|card|card-foreground|popover|popover-foreground|primary|primary-foreground|secondary|secondary-foreground|muted|muted-foreground|accent|accent-foreground|border|input|ring|brand|brand-orange|radius)\)' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_tailwind_raw_visual_values() {
  rg -n \
    --glob 'tailwind.config.*' \
    --glob '!node_modules/**' \
    'colors[[:space:]]*:[[:space:]]*\{|#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_tailwind_config_ds_mapping() {
  rg -n \
    --glob 'tailwind.config.*' \
    --glob '!node_modules/**' \
    -- 'var\(--ds-' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_tailwind_config_local_token_mapping() {
  rg -n \
    --glob 'tailwind.config.*' \
    --glob '!node_modules/**' \
    -- 'hsl\(var\(--|var\(--' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_tailwind_css_theme_mapping() {
  rg -n \
    --glob '*.css' \
    --glob '!node_modules/**' \
    -- '@theme|var\(--ds-' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_tailwind_css_local_token_mapping() {
  rg -n \
    --glob '*.css' \
    --glob '!node_modules/**' \
    -- '@theme|hsl\(var\(--|var\(--' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_token_alias_map() {
  rg -n \
    --glob '*.css' \
    --glob '*.md' \
    --glob '*.ts' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- 'Token Alias Map|--ds-[A-Za-z0-9_-]+[[:space:]]*(=>|:|=)|maps?[[:space:]].*--ds-' "${TARGET_ROOT}" >/dev/null 2>&1
}

has_shared_visual_bypass() {
  rg -n \
    --glob '*.tsx' \
    --glob '*.jsx' \
    --glob '*.ts' \
    --glob '*.js' \
    --glob '!node_modules/**' \
    --glob '!.git/**' \
    -- '#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(|bg-white|text-black|text-white|border-gray-|bg-gray-|text-gray-|from-purple-|to-purple-|from-violet-|to-violet-|style=\{\{[^}]*\b(color|background|borderColor)' "${TARGET_ROOT}" >/dev/null 2>&1
}

token_authority="$(yaml_scalar token_authority)"
tailwind_mode="$(yaml_scalar tailwind_mode)"

if [ -z "${token_authority}" ] || [ "${token_authority}" = "unknown" ]; then
  report "missing token authority file; run discover-visual-config.sh and identify global/theme/tokens CSS"
fi

if ! has_ds_token_definition; then
  if has_legacy_semantic_token_definition; then
    if ! has_token_alias_map; then
      report "semantic tokens exist but no Token Alias Map or --ds-* compatibility aliases were found"
    fi
  else
    report "no --ds-* token definitions found in CSS"
  fi
fi

if ! has_ds_token_consumption; then
  if has_legacy_semantic_token_consumption; then
    if ! has_token_alias_map; then
      report "semantic token consumption exists but no Token Alias Map or --ds-* consumption/alias path was found"
    fi
  else
    report "no --ds-* token consumption found in app styles or components"
  fi
fi

case "${tailwind_mode}" in
  v3)
    if has_tailwind_raw_visual_values && ! has_tailwind_config_ds_mapping && ! has_tailwind_config_local_token_mapping; then
      report "Tailwind visual config appears to use raw values without token mapping"
    fi
    ;;
  v4)
    if ! has_tailwind_css_theme_mapping && ! has_tailwind_css_local_token_mapping; then
      report "Tailwind v4 mode needs CSS @theme or token mapping"
    fi
    ;;
  mixed)
    if has_tailwind_raw_visual_values && ! has_tailwind_config_ds_mapping && ! has_tailwind_config_local_token_mapping; then
      report "Tailwind visual config appears to use raw values without token mapping"
    fi
    ;;
esac

if has_shared_visual_bypass && ! has_ds_token_consumption && ! has_legacy_semantic_token_consumption; then
  report "shared/frontend files contain hardcoded visual values and no visible token consumption"
fi

if [ "${failures}" -gt 0 ]; then
  exit 1
fi

echo "theme consumption audit passed"
