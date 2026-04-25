#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo-or-docs-reference" >&2
  exit 1
fi

INPUT="$(cd "$1" && pwd)"
if [ -d "${INPUT}/docs/reference" ]; then
  REFERENCE_DIR="${INPUT}/docs/reference"
else
  REFERENCE_DIR="${INPUT}"
fi

SOURCE_HTML="${REFERENCE_DIR}/design-system.html"
SOURCE_CONTRACT="${REFERENCE_DIR}/design-system.contract.md"
SOURCE_THEME_CSS="${REFERENCE_DIR}/design-system.theme.css"
SLOP_AUDIT="${REFERENCE_DIR}/design-system.slop-audit.md"
PREMIUM_HTML="${REFERENCE_DIR}/design-system.premium-direction.html"
PREMIUM_MD="${REFERENCE_DIR}/design-system.premium-direction.md"
PREMIUM_THEME_CSS="${REFERENCE_DIR}/design-system.premium-theme.css"

failures=0

report() {
  echo "design-system artifact consistency blocked: $*" >&2
  failures=$((failures + 1))
}

require_file() {
  local path="$1"
  local label="$2"
  if [ ! -f "${path}" ]; then
    report "missing ${label}: ${path}"
    return 1
  fi
}

extract_css_declared_tokens() {
  local path="$1"
  perl -ne 'while (/(--[A-Za-z0-9_-]+)\s*:/g) { print "$1\n"; }' "${path}" | sort -u
}

is_theme_alias_to_ds_token() {
  local path="$1"
  local token="$2"
  grep -Eq -- "${token}[[:space:]]*:[^;]*var\(--ds-" "${path}"
}

extract_html_tokens() {
  local path="$1"
  perl -0ne '
    while (m{<style\b[^>]*>(.*?)</style>}sg) {
      my $css = $1;
      while ($css =~ /(--[A-Za-z0-9_-]+)(?:\s*:|\))/g) {
        print "$1\n";
      }
    }
  ' "${path}" | sort -u
}

extract_html_declared_classes() {
  local path="$1"
  perl -0ne '
    while (m{<style\b[^>]*>(.*?)</style>}sg) {
      my $css = $1;
      while ($css =~ /\.([A-Za-z_][A-Za-z0-9_-]*)/g) {
        print ".$1\n";
      }
    }
  ' "${path}" | sort -u
}

extract_md_tokens() {
  local path="$1"
  perl -ne 'while (/`(--[A-Za-z0-9_-]+)`/g) { print "$1\n"; }' "${path}" | sort -u
}

contains_literal() {
  local path="$1"
  local literal="$2"
  grep -Fq -- "${literal}" "${path}"
}

require_literal() {
  local path="$1"
  local literal="$2"
  local label="$3"
  if ! contains_literal "${path}" "${literal}"; then
    report "${label} missing required marker: ${literal}"
  fi
}

count_benchmark_influence_rows() {
  local path="$1"
  perl -ne '
    if (/^## Benchmark Influence Map\s*$/) { $in = 1; next; }
    if ($in && /^##\s+/) { $in = 0; }
    next unless $in;
    next unless /^\|/;
    next if /Benchmark\s*\|\s*Relevant Quality/;
    next if /^\|\s*-+\s*\|/;
    $count++;
    END { print $count || 0; }
  ' "${path}"
}

check_html_tokens_documented() {
  local html="$1"
  local md="$2"
  local label="$3"
  local authority="$4"
  local token
  while IFS= read -r token; do
    [ -n "${token}" ] || continue
    if ! contains_literal "${md}" "${token}"; then
      report "${label} HTML token not documented in ${authority}: ${token}"
    fi
  done < <(extract_html_tokens "${html}")
}

check_html_tokens_declared_in_theme() {
  local html="$1"
  local theme_css="$2"
  local label="$3"
  local theme_label="$4"
  local token
  while IFS= read -r token; do
    [ -n "${token}" ] || continue
    if ! extract_css_declared_tokens "${theme_css}" | grep -Fxq -- "${token}"; then
      report "${label} HTML token not declared in ${theme_label}: ${token}"
    fi
  done < <(extract_html_tokens "${html}")
}

check_md_tokens_declared_in_theme() {
  local md="$1"
  local theme_css="$2"
  local label="$3"
  local theme_label="$4"
  local token
  while IFS= read -r token; do
    [ -n "${token}" ] || continue
    if ! extract_css_declared_tokens "${theme_css}" | grep -Fxq -- "${token}"; then
      report "${label} token not declared in ${theme_label}: ${token}"
    fi
  done < <(extract_md_tokens "${md}")
}

check_theme_tokens_documented() {
  local theme_css="$1"
  local md="$2"
  local label="$3"
  local token
  while IFS= read -r token; do
    [ -n "${token}" ] || continue
    if ! contains_literal "${md}" "${token}"; then
      report "${label} theme CSS token not documented: ${token}"
    fi
  done < <(extract_css_declared_tokens "${theme_css}")
}

check_theme_namespace() {
  local theme_css="$1"
  local label="$2"
  local token
  while IFS= read -r token; do
    [ -n "${token}" ] || continue
    case "${token}" in
      --ds-*)
        ;;
      *)
        if ! is_theme_alias_to_ds_token "${theme_css}" "${token}"; then
          report "${label} theme CSS token must use --ds-* namespace or alias to --ds-*: ${token}"
        fi
        ;;
    esac
  done < <(extract_css_declared_tokens "${theme_css}")
}

check_theme_ds_token_api_same() {
  local source_theme="$1"
  local premium_theme="$2"
  local source_token
  local premium_token

  while IFS= read -r source_token; do
    [ -n "${source_token}" ] || continue
    if ! extract_css_declared_tokens "${premium_theme}" | grep -Fxq -- "${source_token}"; then
      report "premium theme CSS missing source --ds-* token API: ${source_token}"
    fi
  done < <(extract_css_declared_tokens "${source_theme}" | grep '^--ds-')

  while IFS= read -r premium_token; do
    [ -n "${premium_token}" ] || continue
    if ! extract_css_declared_tokens "${source_theme}" | grep -Fxq -- "${premium_token}"; then
      report "premium theme CSS adds renamed --ds-* token outside source API: ${premium_token}"
    fi
  done < <(extract_css_declared_tokens "${premium_theme}" | grep '^--ds-')
}

check_slop_audit_structure() {
  local audit="$1"
  require_literal "${audit}" "AI/Genericity Score" "slop audit"
  require_literal "${audit}" "Detection Matrix" "slop audit"
  require_literal "${audit}" "Priority Corrections" "slop audit"
}

check_premium_benchmark_map() {
  local md="$1"
  local row_count

  require_literal "${md}" "## Benchmark Influence Map" "premium direction"
  row_count="$(count_benchmark_influence_rows "${md}")"
  if [ "${row_count}" -lt 2 ]; then
    report "premium direction Benchmark Influence Map must include at least 2 benchmark rows"
  fi
}

check_single_active_theme_model() {
  local html="$1"
  local md="$2"

  require_literal "${md}" "## Single Active Theme Model" "premium direction"
  if contains_literal "${html}" "Light vs Dark System"; then
    report "premium HTML must not present Light vs Dark System as simultaneous product composition; use one active theme with selector/toggle proof"
  fi
}

check_source_classes_documented() {
  local html="$1"
  local md="$2"
  local class_name
  while IFS= read -r class_name; do
    [ -n "${class_name}" ] || continue
    case "${class_name}" in
      .ds-doc-*)
        continue
        ;;
    esac
    if ! contains_literal "${md}" "${class_name}"; then
      report "source-truth HTML class not documented in contract: ${class_name}"
    fi
  done < <(extract_html_declared_classes "${html}")
}

require_file "${SOURCE_HTML}" "source-truth HTML" || true
require_file "${SOURCE_CONTRACT}" "source-truth contract" || true
require_file "${SOURCE_THEME_CSS}" "source-truth theme CSS" || true

if [ -f "${SOURCE_HTML}" ] && [ -f "${SOURCE_CONTRACT}" ] && [ -f "${SOURCE_THEME_CSS}" ]; then
  check_html_tokens_documented "${SOURCE_HTML}" "${SOURCE_CONTRACT}" "source-truth" "contract"
  check_html_tokens_declared_in_theme "${SOURCE_HTML}" "${SOURCE_THEME_CSS}" "source-truth" "theme CSS"
  check_md_tokens_declared_in_theme "${SOURCE_CONTRACT}" "${SOURCE_THEME_CSS}" "source-truth contract" "theme CSS"
  check_theme_tokens_documented "${SOURCE_THEME_CSS}" "${SOURCE_CONTRACT}" "source-truth"
  check_theme_namespace "${SOURCE_THEME_CSS}" "source-truth"
  check_source_classes_documented "${SOURCE_HTML}" "${SOURCE_CONTRACT}"
elif [ -f "${SOURCE_HTML}" ] && [ -f "${SOURCE_CONTRACT}" ]; then
  check_html_tokens_documented "${SOURCE_HTML}" "${SOURCE_CONTRACT}" "source-truth" "contract"
  check_source_classes_documented "${SOURCE_HTML}" "${SOURCE_CONTRACT}"
fi

if [ -f "${PREMIUM_HTML}" ] || [ -f "${PREMIUM_MD}" ]; then
  require_file "${SLOP_AUDIT}" "premium slop audit" || true
  require_file "${PREMIUM_HTML}" "premium direction HTML" || true
  require_file "${PREMIUM_MD}" "premium direction markdown" || true
  require_file "${PREMIUM_THEME_CSS}" "premium theme CSS" || true
  if [ -f "${SLOP_AUDIT}" ]; then
    check_slop_audit_structure "${SLOP_AUDIT}"
  fi
  if [ -f "${PREMIUM_MD}" ]; then
    check_premium_benchmark_map "${PREMIUM_MD}"
  fi
  if [ -f "${PREMIUM_HTML}" ] && [ -f "${PREMIUM_MD}" ]; then
    check_single_active_theme_model "${PREMIUM_HTML}" "${PREMIUM_MD}"
  fi
  if [ -f "${PREMIUM_HTML}" ] && [ -f "${PREMIUM_MD}" ] && [ -f "${PREMIUM_THEME_CSS}" ]; then
    check_html_tokens_documented "${PREMIUM_HTML}" "${PREMIUM_MD}" "premium" "premium direction"
    check_html_tokens_declared_in_theme "${PREMIUM_HTML}" "${PREMIUM_THEME_CSS}" "premium" "premium theme CSS"
    check_md_tokens_declared_in_theme "${PREMIUM_MD}" "${PREMIUM_THEME_CSS}" "premium direction" "premium theme CSS"
    check_theme_tokens_documented "${PREMIUM_THEME_CSS}" "${PREMIUM_MD}" "premium"
    check_theme_namespace "${PREMIUM_THEME_CSS}" "premium"
    if [ -f "${SOURCE_THEME_CSS}" ]; then
      check_theme_ds_token_api_same "${SOURCE_THEME_CSS}" "${PREMIUM_THEME_CSS}"
    fi
  elif [ -f "${PREMIUM_HTML}" ] && [ -f "${PREMIUM_MD}" ]; then
    check_html_tokens_documented "${PREMIUM_HTML}" "${PREMIUM_MD}" "premium" "premium direction"
  fi
fi

if [ "${failures}" -gt 0 ]; then
  exit 1
fi

echo "design-system artifact consistency passed"
