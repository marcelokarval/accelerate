#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_file() {
  test -f "${repo_root}/$1" || { echo "FAIL: missing $1" >&2; exit 1; }
}

require_text() {
  local pattern="$1" file="$2"
  rg -q -- "$pattern" "${repo_root}/${file}" || {
    echo "FAIL: ${file} missing ${pattern}" >&2
    exit 1
  }
}

# Point 1: retain the already-approved browser runtime governance.
require_text 'Chrome DevTools MCP' skills/runtime/playwright-patterns/SKILL.md
require_text 'owner-only per-session' skills/runtime/playwright-patterns/SKILL.md
require_text 'receipts' skills/runtime/playwright-patterns/SKILL.md
require_text 'short private sockets' skills/runtime/playwright-patterns/SKILL.md
require_text 'URL userinfo and every query value' skills/runtime/playwright-patterns/SKILL.md

# Point 2: make MCP maturity and stale-session/release diagnosis explicit.
require_file skills/runtime/native-mcp/references/capability-lifecycle.md
for state in defined registered materialized initialized tools-listed callable authenticated; do
  require_text "${state}" skills/runtime/native-mcp/references/capability-lifecycle.md
done
require_text 'session.*cached|cached.*session' skills/runtime/native-mcp/references/capability-lifecycle.md
require_text 'release' skills/runtime/native-mcp/references/capability-lifecycle.md
require_text 'capability-lifecycle.md' skills/runtime/native-mcp/SKILL.md
if rg -q 'npx +-y|@latest' skills/runtime/native-mcp/SKILL.md; then
  echo 'FAIL: native-mcp still recommends floating runtime installation' >&2
  exit 1
fi

# Point 3: repo-owned Codex routing and redacted machine-catalog validation.
require_file skills/runtime/codex/SKILL.md
require_file skills/runtime/codex/metadata.yaml
require_file skills/runtime/codex/references/environment-capability-preflight.md
require_file skills/runtime/codex/scripts/validate_environment_capabilities.py
require_text 'environment-capabilities.json' skills/runtime/codex/SKILL.md
require_text 'PostgreSQL' skills/runtime/codex/references/environment-capability-preflight.md
require_text 'SQLite' skills/runtime/codex/references/environment-capability-preflight.md
require_text 'ManyChat' skills/runtime/codex/references/environment-capability-preflight.md
catalog_fixture="${repo_root}/tests/fixtures/codex-environment-capabilities/valid-redacted.json"
python3 "${repo_root}/skills/runtime/codex/scripts/validate_environment_capabilities.py" "${catalog_fixture}"

invalid_catalog_fixture="$(mktemp)"
trap 'rm -f -- "${invalid_catalog_fixture}"' EXIT
printf '{"schema_version":1,"security":{"contains_values":true},"systems":[]}' >"${invalid_catalog_fixture}"
if python3 "${repo_root}/skills/runtime/codex/scripts/validate_environment_capabilities.py" \
  "${invalid_catalog_fixture}" >/dev/null 2>&1; then
  echo 'FAIL: catalog validator accepted a value-bearing catalog' >&2
  exit 1
fi

# Point 4: runtime-specific forensic closure must be discoverable from root.
require_file skills/root/verification-before-completion/references/runtime-forensic-closure.md
for phrase in 'legacy clients' 'release parity' 'open files' 'quarantine' 'provider readback'; do
  require_text "${phrase}" skills/root/verification-before-completion/references/runtime-forensic-closure.md
done
require_text 'runtime-forensic-closure.md' skills/root/verification-before-completion/SKILL.md

# Registry and category discovery must include the restored Codex skill.
require_text '`codex`' skills/_registry/manifest.md
require_text '`codex`' skills/runtime/README.md

echo 'PASS: runtime capability governance contract'
