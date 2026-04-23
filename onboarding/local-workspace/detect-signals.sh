#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/target-repo" >&2
  exit 1
fi

TARGET_ROOT="$(cd "$1" && pwd)"
WORKSPACE="${TARGET_ROOT}/.accelerate"
DISCOVERY_FILE="${WORKSPACE}/onboarding/discovery.yaml"

if [ ! -d "${TARGET_ROOT}" ]; then
  echo "target repo does not exist: ${TARGET_ROOT}" >&2
  exit 1
fi

if [ ! -f "${DISCOVERY_FILE}" ]; then
  echo "missing discovery file: ${DISCOVERY_FILE}" >&2
  exit 1
fi

join_by() {
  local sep="$1"
  shift
  local out=""
  local item
  for item in "$@"; do
    if [ -z "${out}" ]; then
      out="${item}"
    else
      out="${out}${sep}${item}"
    fi
  done
  printf '%s' "${out}"
}

yaml_inline_list() {
  if [ "$#" -eq 0 ]; then
    printf '[]'
    return
  fi

  local rendered=()
  local item
  for item in "$@"; do
    rendered+=("'${item}'")
  done
  printf '[%s]' "$(join_by ', ' "${rendered[@]}")"
}

contains_item() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [ "${item}" = "${needle}" ]; then
      return 0
    fi
  done
  return 1
}

append_unique() {
  local var_name="$1"
  local value="$2"
  declare -n ref="${var_name}"
  if ! contains_item "${value}" "${ref[@]:-}"; then
    ref+=("${value}")
  fi
}

has_path() {
  local rel="$1"
  [ -e "${TARGET_ROOT}/${rel}" ]
}

has_glob() {
  local pattern="$1"
  find "${TARGET_ROOT}" \
    -path "${TARGET_ROOT}/.git" -prune -o \
    -path "${TARGET_ROOT}/node_modules" -prune -o \
    -path "${TARGET_ROOT}/.venv" -prune -o \
    -path "${TARGET_ROOT}/dist" -prune -o \
    -path "${TARGET_ROOT}/build" -prune -o \
    -path "${TARGET_ROOT}/coverage" -prune -o \
    -name "${pattern}" -print -quit | grep -q .
}

file_contains() {
  local rel="$1"
  local pattern="$2"
  if [ ! -f "${TARGET_ROOT}/${rel}" ]; then
    return 1
  fi
  rg -n "${pattern}" "${TARGET_ROOT}/${rel}" >/dev/null 2>&1
}

languages=()
framework_signals=()
workflow_tool_signals=()
docs_posture_signals=()
proof_runtime_signals=()
package_manager_signals=()
repo_notes=()

if has_path "package.json"; then
  append_unique languages "javascript"
  append_unique repo_notes "node-manifest"
fi

if has_path "tsconfig.json" || has_glob "*.ts" || has_glob "*.tsx"; then
  append_unique languages "typescript"
fi

if has_path "pyproject.toml" || has_path "requirements.txt" || has_path "manage.py"; then
  append_unique languages "python"
fi

if has_path "go.mod"; then
  append_unique languages "go"
fi

if has_path "Cargo.toml"; then
  append_unique languages "rust"
fi

if has_path "composer.json"; then
  append_unique languages "php"
fi

if has_path "package.json"; then
  if has_path "next.config.js" || has_path "next.config.mjs" || has_path "next.config.ts"; then
    append_unique framework_signals "nextjs"
  fi
  if has_path "vite.config.js" || has_path "vite.config.ts" || has_path "vite.config.mjs"; then
    append_unique framework_signals "vite"
  fi
  if file_contains "package.json" '"react"' || file_contains "package.json" '@types/react'; then
    append_unique framework_signals "react"
  fi
  if file_contains "package.json" '"tailwindcss"' || has_path "tailwind.config.js" || has_path "tailwind.config.ts"; then
    append_unique framework_signals "tailwind"
  fi
  if file_contains "package.json" '"inertia"' || file_contains "package.json" '@inertiajs/'; then
    append_unique framework_signals "inertia"
  fi
fi

if has_path "manage.py"; then
  append_unique framework_signals "django"
fi

if has_path "pnpm-workspace.yaml" || has_path "turbo.json" || has_path "nx.json"; then
  append_unique framework_signals "monorepo"
  append_unique repo_notes "monorepo-shape"
fi

if has_path ".github"; then
  append_unique workflow_tool_signals "github"
fi

if has_path ".git"; then
  append_unique workflow_tool_signals "git"
fi

if rg -n "linear" "${TARGET_ROOT}" \
  -g 'README.md' \
  -g 'AGENTS.md' \
  -g '.env*' \
  -g '.github/*' >/dev/null 2>&1; then
  append_unique workflow_tool_signals "linear-signal"
fi

if has_path "AGENTS.md"; then
  append_unique workflow_tool_signals "agents-md"
fi

if has_path ".codex/config.toml"; then
  append_unique workflow_tool_signals "codex-config"
fi

if has_path "docs"; then
  append_unique docs_posture_signals "docs-dir"
fi

if has_path "README.md"; then
  append_unique docs_posture_signals "readme"
fi

if has_path "mkdocs.yml"; then
  append_unique docs_posture_signals "mkdocs"
fi

if has_path "docusaurus.config.js" || has_path "docusaurus.config.ts"; then
  append_unique docs_posture_signals "docusaurus"
fi

if has_path "playwright.config.ts" || has_path "playwright.config.js"; then
  append_unique proof_runtime_signals "playwright"
fi

if has_path "cypress.config.ts" || has_path "cypress.config.js"; then
  append_unique proof_runtime_signals "cypress"
fi

if has_path "pytest.ini" || has_path "conftest.py"; then
  append_unique proof_runtime_signals "pytest"
fi

if has_path "vitest.config.ts" || has_path "vitest.config.js"; then
  append_unique proof_runtime_signals "vitest"
fi

if has_path "pnpm-lock.yaml"; then
  append_unique package_manager_signals "pnpm"
fi

if has_path "package-lock.json"; then
  append_unique package_manager_signals "npm"
fi

if has_path "yarn.lock"; then
  append_unique package_manager_signals "yarn"
fi

if has_path "uv.lock"; then
  append_unique package_manager_signals "uv"
fi

if has_path "poetry.lock"; then
  append_unique package_manager_signals "poetry"
fi

if [ -d "${TARGET_ROOT}/src" ]; then
  append_unique repo_notes "src-dir"
fi

if [ -d "${TARGET_ROOT}/apps" ] || [ -d "${TARGET_ROOT}/packages" ]; then
  append_unique repo_notes "multi-package-layout"
fi

if [ -d "${TARGET_ROOT}/backend" ] || [ -d "${TARGET_ROOT}/api" ]; then
  append_unique repo_notes "backend-surface"
fi

if [ -d "${TARGET_ROOT}/frontend" ] || [ -d "${TARGET_ROOT}/web" ] || [ -d "${TARGET_ROOT}/app" ]; then
  append_unique repo_notes "frontend-surface"
fi

cat > "${DISCOVERY_FILE}" <<EOF
schema_version: 1
languages: $(yaml_inline_list "${languages[@]}")
framework_signals: $(yaml_inline_list "${framework_signals[@]}")
workflow_tool_signals: $(yaml_inline_list "${workflow_tool_signals[@]}")
docs_posture_signals: $(yaml_inline_list "${docs_posture_signals[@]}")
proof_runtime_signals: $(yaml_inline_list "${proof_runtime_signals[@]}")
package_manager_signals: $(yaml_inline_list "${package_manager_signals[@]}")
repo_notes: $(yaml_inline_list "${repo_notes[@]}")
EOF

echo "updated discovery signals at ${DISCOVERY_FILE}"
