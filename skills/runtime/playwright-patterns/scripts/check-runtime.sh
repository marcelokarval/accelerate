#!/usr/bin/env bash

set -euo pipefail

expected_mcp=0.0.79
expected_playwright=1.63.0-alpha-2026-08-05
expected_firefox_build=1539

runtime_root=${PLAYWRIGHT_MCP_RUNTIME_ROOT:-/home/marcelo-karval/.codex/vendor/playwright-runtime}
launcher=${PLAYWRIGHT_MCP_LAUNCHER:-/home/marcelo-karval/.codex/bin/playwright-mcp-launcher.sh}
browsers_path=${PLAYWRIGHT_MCP_BROWSERS_PATH:-$runtime_root/browsers}
node_binary=${PLAYWRIGHT_MCP_NODE_OVERRIDE:-}
codex_root=${PLAYWRIGHT_MCP_CODEX_ROOT:-/home/marcelo-karval/.codex}
findmnt_binary=${PLAYWRIGHT_MCP_FINDMNT_OVERRIDE:-}
scan_file=
scan_error_file=
mount_file=
mount_error_file=

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

cleanup() {
  [[ -z $scan_file ]] || rm -f -- "$scan_file"
  [[ -z $scan_error_file ]] || rm -f -- "$scan_error_file"
  [[ -z $mount_file ]] || rm -f -- "$mount_file"
  [[ -z $mount_error_file ]] || rm -f -- "$mount_error_file"
}

trap cleanup EXIT

if [[ -z $node_binary ]]; then
  node_binary=$(command -v node || true)
fi
if [[ -z $findmnt_binary ]]; then
  findmnt_binary=$(command -v findmnt || true)
fi

[[ -n $node_binary && -x $node_binary ]] || fail 'Node executable is unavailable'
[[ -n $findmnt_binary && -x $findmnt_binary ]] || fail 'findmnt executable is unavailable'
[[ -x $launcher ]] || fail "Playwright MCP launcher is missing or not executable: $launcher"

root_manifest="$runtime_root/package.json"
mcp_manifest="$runtime_root/node_modules/@playwright/mcp/package.json"
playwright_manifest="$runtime_root/node_modules/playwright/package.json"
cli="$runtime_root/node_modules/.bin/playwright"
firefox="$browsers_path/firefox-$expected_firefox_build/firefox/firefox"

[[ -f $root_manifest ]] || fail "runtime manifest is missing: $root_manifest"
[[ -f $mcp_manifest ]] || fail "installed MCP manifest is missing: $mcp_manifest"
[[ -f $playwright_manifest ]] || fail "installed Playwright manifest is missing: $playwright_manifest"
[[ -x $cli ]] || fail "Playwright CLI is missing or not executable: $cli"
[[ -x $firefox ]] || fail "Firefox build v$expected_firefox_build is missing: $firefox"

current_uid=$(id -u)
for protected_path in \
  "$codex_root" \
  "$codex_root/bin" \
  "$codex_root/vendor" \
  "$runtime_root" \
  "$launcher"; do
  [[ -e $protected_path ]] || fail "required Codex path is missing: $protected_path"
  [[ ! -L $protected_path ]] || fail 'Codex executable chain contains a symbolic-link path component'
  protected_uid=$(stat -c '%u' "$protected_path") || fail 'unable to inspect Codex executable-chain ownership'
  [[ $protected_uid == "$current_uid" ]] || fail 'Codex executable chain has an unexpected owner'
  protected_mode=$(stat -c '%a' "$protected_path") || fail 'unable to inspect Codex executable-chain permissions'
  (( (8#$protected_mode & 8#022) == 0 )) || fail 'Codex executable chain is writable by group or others'
done

runtime_real=$(readlink -e "$runtime_root") || fail 'unable to resolve the Playwright runtime root'
runtime_device=$(stat -c '%d' "$runtime_real") || fail 'unable to inspect the Playwright runtime filesystem'

scan_file=$(mktemp "${TMPDIR:-/tmp}/playwright-runtime-scan.XXXXXX") || fail 'unable to create the runtime scan receipt'
scan_error_file=$(mktemp "${TMPDIR:-/tmp}/playwright-runtime-scan-error.XXXXXX") || fail 'unable to create the runtime scan error receipt'
mount_file=$(mktemp "${TMPDIR:-/tmp}/playwright-runtime-mounts.XXXXXX") || fail 'unable to create the mount scan receipt'
mount_error_file=$(mktemp "${TMPDIR:-/tmp}/playwright-runtime-mount-errors.XXXXXX") || fail 'unable to create the mount scan error receipt'

assert_no_runtime_mounts() {
  local mount_target
  local mount_count=0

  : >"$mount_file"
  : >"$mount_error_file"
  if ! "$findmnt_binary" -rn -R -o TARGET --target "$runtime_real" >"$mount_file" 2>"$mount_error_file"; then
    fail 'unable to inspect mount boundaries below the Playwright runtime'
  fi

  while IFS= read -r mount_target; do
    [[ -n $mount_target ]] || continue
    (( mount_count += 1 ))
    if [[ $mount_target == "$runtime_real" || $mount_target == "$runtime_real"/* ]]; then
      fail 'Playwright runtime contains a mount point'
    fi
  done <"$mount_file"

  (( mount_count > 0 )) || fail 'mount-boundary scan returned no filesystem records'
}

assert_no_runtime_mounts

: >"$scan_file"
: >"$scan_error_file"
if ! find -P "$runtime_real" -xdev -printf '%y\0%U\0%m\0%D\0%p\0' >"$scan_file" 2>"$scan_error_file"; then
  fail 'unable to traverse the complete Playwright runtime tree'
fi

scan_count=0
while IFS= read -r -d '' entry_type &&
      IFS= read -r -d '' entry_uid &&
      IFS= read -r -d '' entry_mode &&
      IFS= read -r -d '' entry_device &&
      IFS= read -r -d '' entry_path; do
  (( scan_count += 1 ))
  [[ $entry_uid == "$current_uid" ]] || fail 'Playwright runtime tree contains an unexpected owner'
  [[ $entry_device == "$runtime_device" ]] || fail 'Playwright runtime crosses a filesystem boundary'

  if [[ $entry_type != l ]]; then
    (( (8#$entry_mode & 8#022) == 0 )) || fail 'Playwright runtime contains a group/other-writable entry'
    continue
  fi

  link_target=$(readlink -e "$entry_path") || fail 'Playwright runtime contains an unresolved symbolic link'
  if [[ $link_target != "$runtime_real" && $link_target != "$runtime_real"/* ]]; then
    fail 'Playwright runtime contains a symbolic link outside the owned runtime tree'
  fi
done <"$scan_file"

(( scan_count > 0 )) || fail 'runtime traversal returned no entries'

assert_no_runtime_mounts
printf 'PASS: current-user ownership and owner-only write permissions\n'

json_value() {
  local manifest=$1
  local key=$2

  "$node_binary" -e '
    const fs = require("node:fs");
    const value = process.argv[2].split(".").reduce((item, part) => item?.[part], JSON.parse(fs.readFileSync(process.argv[1], "utf8")));
    if (typeof value !== "string") process.exit(2);
    process.stdout.write(value);
  ' "$manifest" "$key"
}

declared_mcp=$(json_value "$root_manifest" 'dependencies.@playwright/mcp')
declared_playwright=$(json_value "$root_manifest" 'dependencies.playwright')
installed_mcp=$(json_value "$mcp_manifest" 'version')
installed_playwright=$(json_value "$playwright_manifest" 'version')

[[ $declared_mcp == "$expected_mcp" ]] || fail "declared @playwright/mcp version differs from $expected_mcp"
[[ $installed_mcp == "$expected_mcp" ]] || fail "installed @playwright/mcp version differs from $expected_mcp"
[[ $declared_playwright == "$expected_playwright" ]] || fail "declared Playwright version differs from $expected_playwright"
[[ $installed_playwright == "$expected_playwright" ]] || fail "installed Playwright version differs from $expected_playwright"
printf 'PASS: exact package versions (%s, %s)\n' "$expected_mcp" "$expected_playwright"

mcp_version=$(PLAYWRIGHT_MCP_RUNTIME_ROOT="$runtime_root" \
  PLAYWRIGHT_MCP_BROWSERS_PATH="$browsers_path" \
  PLAYWRIGHT_MCP_NODE_OVERRIDE="$node_binary" \
  "$launcher" --version)
[[ $mcp_version == "Version $expected_mcp" ]] || fail 'launcher version output does not match the pinned MCP package'

cli_version=$(PLAYWRIGHT_BROWSERS_PATH="$browsers_path" "$cli" --version)
[[ $cli_version == "Version $expected_playwright" ]] || fail 'CLI version output does not match the pinned Playwright runtime'
printf 'PASS: launcher and CLI version output\n'
printf 'PASS: dedicated Firefox build v%s\n' "$expected_firefox_build"

PLAYWRIGHT_BROWSERS_PATH="$browsers_path" \
PLAYWRIGHT_RUNTIME_ROOT="$runtime_root" \
  "$node_binary" <<'JS'
const path = require('node:path');
const { firefox } = require(path.join(process.env.PLAYWRIGHT_RUNTIME_ROOT, 'node_modules', 'playwright'));

(async () => {
  const browser = await firefox.launch({ headless: true });
  const page = await browser.newPage();
  await page.goto('about:blank');
  if (page.url() !== 'about:blank') throw new Error('unexpected smoke-test URL');
  await browser.close();
})().catch((error) => {
  console.error(`Firefox smoke failed: ${error.message}`);
  process.exit(1);
});
JS

printf 'PASS: headless Firefox about:blank smoke\n'
printf 'PASS: Codex-owned Playwright runtime contract\n'
