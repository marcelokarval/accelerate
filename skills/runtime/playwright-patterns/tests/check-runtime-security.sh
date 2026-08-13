#!/usr/bin/env bash

set -euo pipefail

skill_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
checker="$skill_root/scripts/check-runtime.sh"
test_root=$(mktemp -d "${TMPDIR:-/tmp}/playwright-runtime-check.XXXXXX")

cleanup() {
  chmod -R u+rwx "$test_root" 2>/dev/null || true
  rm -rf -- "$test_root"
}

trap cleanup EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

make_fixture() {
  local label=$1

  fixture_codex="$test_root/$label/codex"
  fixture_runtime="$fixture_codex/vendor/playwright-runtime"
  fixture_launcher="$fixture_codex/bin/playwright-mcp-launcher.sh"

  mkdir -p \
    "$fixture_codex/bin" \
    "$fixture_runtime/node_modules/@playwright/mcp" \
    "$fixture_runtime/node_modules/playwright" \
    "$fixture_runtime/node_modules/.bin" \
    "$fixture_runtime/browsers/firefox-1539/firefox"

  printf '{"dependencies":{"@playwright/mcp":"0.0.79","playwright":"1.63.0-alpha-2026-08-05"}}\n' >"$fixture_runtime/package.json"
  printf '{"version":"0.0.79"}\n' >"$fixture_runtime/node_modules/@playwright/mcp/package.json"
  printf '{"version":"1.63.0-alpha-2026-08-05"}\n' >"$fixture_runtime/node_modules/playwright/package.json"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$fixture_launcher"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$fixture_runtime/node_modules/.bin/playwright"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$fixture_runtime/browsers/firefox-1539/firefox/firefox"

  find "$fixture_codex" -type d -exec chmod 0700 {} +
  find "$fixture_codex" -type f -exec chmod 0600 {} +
  chmod 0700 \
    "$fixture_launcher" \
    "$fixture_runtime/node_modules/.bin/playwright" \
    "$fixture_runtime/browsers/firefox-1539/firefox/firefox"
}

expect_failure() {
  local label=$1
  local expected=$2
  shift 2

  local output
  if output=$(env \
    PLAYWRIGHT_MCP_CODEX_ROOT="$fixture_codex" \
    PLAYWRIGHT_MCP_RUNTIME_ROOT="$fixture_runtime" \
    PLAYWRIGHT_MCP_BROWSERS_PATH="$fixture_runtime/browsers" \
    PLAYWRIGHT_MCP_LAUNCHER="$fixture_launcher" \
    "$@" \
    bash "$checker" 2>&1); then
    fail "$label unexpectedly succeeded"
  fi

  [[ $output == *"$expected"* ]] || fail "$label did not report the expected failure"
  printf 'PASS: %s\n' "$label"
}

make_fixture inaccessible-tree
mkdir "$fixture_runtime/inaccessible"
ln -s /etc/passwd "$fixture_runtime/inaccessible/outside"
chmod 000 "$fixture_runtime/inaccessible"
expect_failure inaccessible-tree 'unable to traverse the complete Playwright runtime tree'
chmod 0700 "$fixture_runtime/inaccessible"

make_fixture dangling-symlink
ln -s "$fixture_runtime/missing-target" "$fixture_runtime/dangling"
expect_failure dangling-symlink 'unresolved symbolic link'

make_fixture outside-symlink
ln -s /etc/passwd "$fixture_runtime/outside"
expect_failure outside-symlink 'symbolic link outside the owned runtime tree'

make_fixture cross-filesystem
mkdir "$fixture_runtime/injected-mount"
fake_findmnt="$test_root/fake-findmnt"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'printf "/\\n%s\\n" "$PLAYWRIGHT_MCP_TEST_MOUNT_TARGET"' \
  >"$fake_findmnt"
chmod 0700 "$fake_findmnt"
expect_failure cross-filesystem 'Playwright runtime contains a mount point' \
  PLAYWRIGHT_MCP_FINDMNT_OVERRIDE="$fake_findmnt" \
  PLAYWRIGHT_MCP_TEST_MOUNT_TARGET="$fixture_runtime/injected-mount"

bash "$checker"
printf 'PASS: positive real runtime\n'
printf 'PASS: checker security regression suite\n'
