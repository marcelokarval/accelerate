#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_ROOT="${ROOT}/.tmp/local-workspace-scenario-matrix"
SCRIPTS="${ROOT}/onboarding/local-workspace"

fail() {
  printf 'local-workspace-scenario-matrix failed: %s\n' "$1" >&2
  exit 1
}

assert_file_contains() {
  local path="$1"
  local expected="$2"
  if ! grep -Fq -- "$expected" "$path"; then
    printf 'file did not contain expected text: %s\n' "$expected" >&2
    printf 'file: %s\n' "$path" >&2
    exit 1
  fi
}

reset_case() {
  local name="$1"
  local target="${WORK_ROOT}/${name}"
  rm -rf "$target"
  mkdir -p "$target"
  bash "${SCRIPTS}/emit-v2.sh" "$target" greenfield >/dev/null
  printf '%s\n' "$target"
}

classify_case() {
  local target="$1"
  bash "${SCRIPTS}/detect-signals.sh" "$target" >/dev/null
  bash "${SCRIPTS}/classify-project.sh" "$target" >/dev/null
}

mkdir -p "$WORK_ROOT"

django_target="$(reset_case django-inertia-react)"
cat > "${django_target}/manage.py" <<'PY'
#!/usr/bin/env python
PY
cat > "${django_target}/package.json" <<'JSON'
{"dependencies":{"react":"latest","@inertiajs/react":"latest"}}
JSON
classify_case "$django_target"
assert_file_contains "${django_target}/.accelerate/state.yaml" "active_profile: django-inertia-react"
assert_file_contains "${django_target}/.accelerate/state.yaml" "active_runtime_adapters: ['node','python-uv','chrome-devtools']"

prisma_target="$(reset_case nextjs-prisma-stripe-redis)"
cat > "${prisma_target}/package.json" <<'JSON'
{"dependencies":{"next":"latest","react":"latest","tailwindcss":"latest","prisma":"latest","@prisma/client":"latest","stripe":"latest","redis":"latest"}}
JSON
touch "${prisma_target}/next.config.ts"
mkdir -p "${prisma_target}/prisma"
touch "${prisma_target}/prisma/schema.prisma"
classify_case "$prisma_target"
assert_file_contains "${prisma_target}/.accelerate/state.yaml" "active_profile: nextjs-prisma"
assert_file_contains "${prisma_target}/.accelerate/onboarding/discovery.yaml" "provider_signals: ['stripe']"
assert_file_contains "${prisma_target}/.accelerate/onboarding/discovery.yaml" "runtime_overlay_signals: ['redis']"

drizzle_target="$(reset_case nextjs-drizzle-bullmq-qstash)"
cat > "${drizzle_target}/package.json" <<'JSON'
{"dependencies":{"next":"latest","react":"latest","tailwindcss":"latest","drizzle-orm":"latest","bullmq":"latest","@upstash/qstash":"latest"}}
JSON
touch "${drizzle_target}/next.config.mjs" "${drizzle_target}/drizzle.config.ts"
classify_case "$drizzle_target"
assert_file_contains "${drizzle_target}/.accelerate/state.yaml" "active_profile: nextjs-drizzle"
assert_file_contains "${drizzle_target}/.accelerate/onboarding/discovery.yaml" "runtime_overlay_signals: ['bullmq', 'qstash']"

adonis_target="$(reset_case nextjs-adonis-adminjs)"
cat > "${adonis_target}/package.json" <<'JSON'
{"dependencies":{"next":"latest","react":"latest","@adonisjs/core":"latest","adminjs":"latest","@adminjs/express":"latest"}}
JSON
touch "${adonis_target}/next.config.js" "${adonis_target}/adonisrc.ts"
classify_case "$adonis_target"
assert_file_contains "${adonis_target}/.accelerate/state.yaml" "active_profile: nextjs-adonis-adminjs"

tailwind_target="$(reset_case nextjs-tailwind-fallback)"
cat > "${tailwind_target}/package.json" <<'JSON'
{"dependencies":{"next":"latest","react":"latest","tailwindcss":"latest"}}
JSON
touch "${tailwind_target}/next.config.js"
classify_case "$tailwind_target"
assert_file_contains "${tailwind_target}/.accelerate/state.yaml" "active_profile: nextjs-tailwind"

unknown_target="$(reset_case unknown-go-rust)"
touch "${unknown_target}/go.mod" "${unknown_target}/Cargo.toml"
classify_case "$unknown_target"
assert_file_contains "${unknown_target}/.accelerate/state.yaml" "active_profile: unknown"

printf 'local workspace scenario matrix passed\n'
