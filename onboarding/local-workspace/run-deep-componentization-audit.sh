#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
OUT_DIR="${TARGET_ROOT}/.accelerate/review/componentization"
PAGES_DIR="${OUT_DIR}/pages"
mkdir -p "${PAGES_DIR}"

slugify() {
  printf '%s' "$1" | tr '/ ' '__' | tr -cd 'A-Za-z0-9._-'
}

count_rg() {
  local pattern="$1"
  local file="$2"
  (rg -o -- "${pattern}" "${file}" || true) | wc -l | tr -d ' '
}

is_page_file() {
  local rel="$1"
  case "${rel}" in
    *src/pages/*.tsx|*src/app/**/page.tsx|*pages/*.tsx|*app/**/page.tsx)
      return 0
      ;;
  esac
  return 1
}

is_component_file() {
  local rel="$1"
  case "${rel}" in
    *components/*.tsx|*components/**/*.tsx)
      return 0
      ;;
  esac
  return 1
}

layer_judgment() {
  local div_count="$1"
  local class_count="$2"
  local long_class_count="$3"
  local direct_visual_count="$4"
  local central_import_count="$5"
  if [ "${div_count}" -gt 28 ] || [ "${class_count}" -gt 22 ] || [ "${long_class_count}" -gt 8 ] || [ "${direct_visual_count}" -gt 18 ]; then
    printf 'refactor-candidate'
  elif [ "${div_count}" -gt 14 ] || [ "${class_count}" -gt 12 ] || [ "${long_class_count}" -gt 3 ] || [ "${central_import_count}" -eq 0 ]; then
    printf 'watch'
  else
    printf 'healthy'
  fi
}

central_import_count() {
  local file="$1"
  (rg -n "from ['\"]@/components/(ui|ui-enhanced|shared|foundation)|from ['\"].*/components/(ui|ui-enhanced|shared|foundation)" "${file}" || true) | wc -l | tr -d ' '
}

write_page_report() {
  local file="$1"
  local rel="${file#${TARGET_ROOT}/}"
  local out="${PAGES_DIR}/$(slugify "${rel}").md"
  local div_count class_count long_class_count direct_visual_count import_count judgment
  div_count="$(count_rg '<div\b' "${file}")"
  class_count="$(count_rg 'className=' "${file}")"
  long_class_count="$(perl -0ne 'while (/className="([^"]+)"/g) { @u = split /\s+/, $1; print "$ARGV\n" if @u > 14; }' "${file}" | wc -l | tr -d ' ')"
  direct_visual_count="$(count_rg 'bg-white|text-black|text-white|border-gray-|bg-gray-|text-gray-|from-purple-|to-purple-|from-violet-|to-violet-|#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(' "${file}")"
  import_count="$(central_import_count "${file}")"
  judgment="$(layer_judgment "${div_count}" "${class_count}" "${long_class_count}" "${direct_visual_count}" "${import_count}")"

  {
    printf '# Page Componentization Report\n\n'
    printf -- '- file: `%s`\n' "${rel}"
    printf -- '- layer judgment: `%s`\n' "${judgment}"
    printf -- '- div count: %s\n' "${div_count}"
    printf -- '- className count: %s\n' "${class_count}"
    printf -- '- long className strings: %s\n' "${long_class_count}"
    printf -- '- direct visual classes/values: %s\n' "${direct_visual_count}"
    printf -- '- central component imports: %s\n\n' "${import_count}"
    printf '## Findings\n\n'
    if [ "${judgment}" = "healthy" ]; then
      printf -- '- No page-level componentization blocker detected by static audit.\n'
    else
      [ "${div_count}" -gt 14 ] && printf -- '- High inline structure density; inspect for extracted layout/composite components.\n'
      [ "${class_count}" -gt 12 ] && printf -- '- High `className` density; inspect for variant extraction or central component APIs.\n'
      [ "${long_class_count}" -gt 3 ] && printf -- '- Long class strings indicate missing variants or wrappers.\n'
      [ "${direct_visual_count}" -gt 0 ] && printf -- '- Direct visual values/classes should move toward tokens, variants, or recorded exceptions.\n'
      [ "${import_count}" -eq 0 ] && printf -- '- No central component imports detected; page may be recreating UI locally.\n'
    fi
    printf '\n## Recommended Action\n\n'
    case "${judgment}" in
      healthy) printf -- '- Keep page as consumer; no extraction required unless runtime/product review finds duplication.\n' ;;
      watch) printf -- '- Review for second-layer primitive or enhanced composite extraction before further visual work.\n' ;;
      refactor-candidate) printf -- '- Create/refine central primitives/composites, move repeated anatomy out of page, then rerun audit.\n' ;;
    esac
  } > "${out}"

  printf '%s|%s|%s|%s|%s|%s|%s\n' "${judgment}" "${rel}" "${div_count}" "${class_count}" "${long_class_count}" "${direct_visual_count}" "${import_count}"
}

tmp_pages="${OUT_DIR}/.pages.tsv"
tmp_components="${OUT_DIR}/.components.tsv"
tmp_ts="${OUT_DIR}/.ts.tsv"
: > "${tmp_pages}"
: > "${tmp_components}"
: > "${tmp_ts}"

while IFS= read -r file; do
  rel="${file#${TARGET_ROOT}/}"
  if is_page_file "${rel}"; then
    write_page_report "${file}" >> "${tmp_pages}"
  elif is_component_file "${rel}"; then
    div_count="$(count_rg '<div\b' "${file}")"
    class_count="$(count_rg 'className=' "${file}")"
    long_class_count="$(perl -0ne 'while (/className="([^"]+)"/g) { @u = split /\s+/, $1; print "$ARGV\n" if @u > 14; }' "${file}" | wc -l | tr -d ' ')"
    direct_visual_count="$(count_rg 'bg-white|text-black|text-white|border-gray-|bg-gray-|text-gray-|from-purple-|to-purple-|from-violet-|to-violet-|#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(' "${file}")"
    printf '%s|%s|%s|%s|%s\n' "${rel}" "${div_count}" "${class_count}" "${long_class_count}" "${direct_visual_count}" >> "${tmp_components}"
  fi
done < <(rg -l '<[A-Za-z][A-Za-z0-9.:-]*|className=' "${TARGET_ROOT}" --glob '*.tsx' --glob '!node_modules/**' --glob '!.git/**')

while IFS= read -r file; do
  rel="${file#${TARGET_ROOT}/}"
  export_count="$(count_rg '^export (function|const|class|type|interface)|export \{' "${file}")"
  function_count="$(count_rg 'function [A-Za-z0-9_]+|const [A-Za-z0-9_]+[[:space:]]*=' "${file}")"
  class_string_count="$(count_rg 'className|bg-white|text-black|border-gray-|#[0-9A-Fa-f]{3,8}|rgb\(|hsl\(' "${file}")"
  line_count="$(wc -l < "${file}" | tr -d ' ')"
  printf '%s|%s|%s|%s|%s\n' "${rel}" "${line_count}" "${export_count}" "${function_count}" "${class_string_count}" >> "${tmp_ts}"
done < <(rg -l 'export |function |const |className|#[0-9A-Fa-f]{3,8}' "${TARGET_ROOT}" --glob '*.ts' --glob '!*.d.ts' --glob '!node_modules/**' --glob '!.git/**')

{
  printf '# Component Inventory Report\n\n'
  printf '| File | div | className | long className | direct visual |\n'
  printf '| --- | ---: | ---: | ---: | ---: |\n'
  sort -t '|' -k5,5nr -k3,3nr "${tmp_components}" | while IFS='|' read -r rel div_count class_count long_class_count direct_visual_count; do
    printf '| `%s` | %s | %s | %s | %s |\n' "${rel}" "${div_count}" "${class_count}" "${long_class_count}" "${direct_visual_count}"
  done
} > "${OUT_DIR}/components-report.md"

{
  printf '# TypeScript Responsibility Report\n\n'
  printf '| File | lines | exports | functions/constants | visual leakage |\n'
  printf '| --- | ---: | ---: | ---: | ---: |\n'
  sort -t '|' -k5,5nr -k2,2nr "${tmp_ts}" | while IFS='|' read -r rel line_count export_count function_count class_string_count; do
    printf '| `%s` | %s | %s | %s | %s |\n' "${rel}" "${line_count}" "${export_count}" "${function_count}" "${class_string_count}"
  done
  printf '\n## Clean-Code Signals\n\n'
  printf -- '- High line count suggests splitting by responsibility.\n'
  printf -- '- High export/function count suggests utility-bag growth.\n'
  printf -- '- Visual leakage in `.ts` should move to `.tsx`, variants, or explicit config modules.\n'
} > "${OUT_DIR}/typescript-report.md"

page_count="$(wc -l < "${tmp_pages}" | tr -d ' ')"
component_count="$(wc -l < "${tmp_components}" | tr -d ' ')"
ts_count="$(wc -l < "${tmp_ts}" | tr -d ' ')"
refactor_count="$(awk -F'|' '$1=="refactor-candidate" { c++ } END { print c+0 }' "${tmp_pages}")"
watch_count="$(awk -F'|' '$1=="watch" { c++ } END { print c+0 }' "${tmp_pages}")"

{
  printf '# Deep Componentization Executive Summary\n\n'
  printf -- '- pages scanned: %s\n' "${page_count}"
  printf -- '- components scanned: %s\n' "${component_count}"
  printf -- '- TypeScript modules scanned: %s\n' "${ts_count}"
  printf -- '- refactor-candidate pages: %s\n' "${refactor_count}"
  printf -- '- watch pages: %s\n\n' "${watch_count}"
  printf '## Related Reports\n\n'
  printf -- '- Page reports: `.accelerate/review/componentization/pages/`\n'
  printf -- '- Components: `.accelerate/review/componentization/components-report.md`\n'
  printf -- '- TypeScript: `.accelerate/review/componentization/typescript-report.md`\n\n'
  printf '## Highest-Risk Pages\n\n'
  if [ "${page_count}" -eq 0 ]; then
    printf -- '- No page-like `.tsx` files found.\n'
  else
    sort -t '|' -k1,1r -k4,4nr "${tmp_pages}" | sed -n '1,10p' | while IFS='|' read -r judgment rel div_count class_count long_class_count direct_visual_count import_count; do
      printf -- '- `%s` (%s): div=%s, className=%s, longClass=%s, directVisual=%s, centralImports=%s -> pages/%s.md\n' \
        "${rel}" "${judgment}" "${div_count}" "${class_count}" "${long_class_count}" "${direct_visual_count}" "${import_count}" "$(slugify "${rel}")"
    done
  fi
  printf '\n## Report -> Executive Plan\n\n'
  if [ "${refactor_count}" -gt 0 ]; then
    printf '1. Extract central components for `refactor-candidate` pages before further visual/theme work.\n'
  fi
  if [ "${watch_count}" -gt 0 ]; then
    printf '2. Review `watch` pages for second-layer primitives or enhanced composites.\n'
  fi
  printf '3. Inspect `components-report.md` for primitives/composites with high direct visual count and move repeated classes into variants.\n'
  printf '4. Inspect `typescript-report.md` for large utility modules, duplicate helper shapes, and visual leakage in `.ts`.\n'
  printf '5. Rerun this audit after component extraction and TypeScript cleanup.\n'
} > "${OUT_DIR}/executive-summary.md"

rm -f "${tmp_pages}" "${tmp_components}" "${tmp_ts}"

echo "deep componentization audit written: ${OUT_DIR}/executive-summary.md"
