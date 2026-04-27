#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
EXCEPTIONS_FILE="${TARGET_ROOT}/.accelerate/componentization-exceptions.txt"
failures=0

report() {
  echo "componentization audit blocked: $*" >&2
  failures=$((failures + 1))
}

is_exception() {
  local rel="$1"
  [ -f "${EXCEPTIONS_FILE}" ] && grep -Fxq -- "${rel}" "${EXCEPTIONS_FILE}"
}

is_brand_asset_file() {
  local rel="$1"
  case "${rel}" in
    *icons/*|*icon*|*logo*|*brand*|*Brand*)
      return 0
      ;;
  esac
  return 1
}

has_svg_brand_asset_markers() {
  local file="$1"
  rg -n '<svg|<path|<rect|<circle|linearGradient|stopColor|fill=|stroke=' "${file}" >/dev/null 2>&1
}

has_frontend_files() {
  rg -l '<[A-Za-z][A-Za-z0-9.:-]*|className=' "${TARGET_ROOT}" \
    --glob '*.tsx' \
    --glob '*.jsx' \
    --glob '!node_modules/**' \
    --glob '!.git/**' >/dev/null 2>&1
}

has_central_component_owner() {
  for candidate in \
    "components/ui" \
    "src/components/ui" \
    "components/foundation" \
    "src/components/foundation" \
    "components/enhanced" \
    "src/components/enhanced" \
    "components/shared" \
    "src/components/shared" \
    "frontends/front-react/src/components/ui" \
    "frontends/front-react/src/components/shared"; do
    if [ -d "${TARGET_ROOT}/${candidate}" ]; then
      return 0
    fi
  done
  return 1
}

scan_file() {
  local file="$1"
  local rel="${file#${TARGET_ROOT}/}"

  if is_exception "${rel}"; then
    return 0
  fi

  local div_count class_count long_class_count direct_visual_count
  div_count="$( (rg -o '<div\b' "${file}" || true) | wc -l | tr -d ' ')"
  class_count="$( (rg -o 'className=' "${file}" || true) | wc -l | tr -d ' ')"
  long_class_count="$(perl -0ne 'while (/className="([^"]+)"/g) { @u = split /\s+/, $1; print "$ARGV\n" if @u > 14; }' "${file}" | wc -l | tr -d ' ')"
  direct_visual_count="$( (rg -o 'bg-white|text-black|text-white|border-gray-|bg-gray-|text-gray-|from-purple-|to-purple-|from-violet-|to-violet-|#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(' "${file}" || true) | wc -l | tr -d ' ')"

  case "${rel}" in
    app/*|src/app/*|pages/*|src/pages/*|routes/*|src/routes/*)
      if [ "${div_count}" -gt 24 ]; then
        report "possible div soup in page/route file ${rel} (${div_count} <div> tags); extract central components or add justified exception"
      fi
      if [ "${class_count}" -gt 18 ]; then
        report "excessive page-local className in ${rel} (${class_count}); extract variants/components or add justified exception"
      fi
      ;;
  esac

  if [ "${long_class_count}" -gt 8 ]; then
    report "too many long className strings in ${rel} (${long_class_count}); prefer variants or central components"
  fi

  if [ "${direct_visual_count}" -gt 18 ] && is_brand_asset_file "${rel}" && has_svg_brand_asset_markers "${file}"; then
    return 0
  fi

  if [ "${direct_visual_count}" -gt 18 ]; then
    report "too many direct visual classes/values in ${rel} (${direct_visual_count}); move visual decisions into central tokens/variants"
  fi
}

if has_frontend_files && ! has_central_component_owner; then
  report "frontend UI files exist but no central component owner directory was found"
fi

while IFS= read -r file; do
  [ -n "${file}" ] || continue
  scan_file "${file}"
done < <(rg -l '<div\b|className=' "${TARGET_ROOT}" \
  --glob '*.tsx' \
  --glob '*.jsx' \
  --glob '!node_modules/**' \
  --glob '!.git/**')

if [ "${failures}" -gt 0 ]; then
  exit 1
fi

echo "componentization audit passed"
