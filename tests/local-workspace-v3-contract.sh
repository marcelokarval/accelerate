#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_TEMPLATE="${REPO_ROOT}/onboarding/local-workspace/v3-template/.accelerate"
VALIDATOR="${REPO_ROOT}/onboarding/local-workspace/v3-validate-template.py"
DESIGN="${REPO_ROOT}/planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md"

fail() {
  echo "local-workspace-v3-contract: $*" >&2
  exit 1
}

validate() {
  python3 "${VALIDATOR}" "$1" "${2:-${DESIGN}}"
}

template_manifest_digest() {
  (cd "$1" && find . -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | awk '{print $1}')
}

new_fixture() {
  local fixture
  fixture="$(mktemp -d)"
  cp -a "${SOURCE_TEMPLATE}" "${fixture}/.accelerate"
  printf '%s\n' "${fixture}"
}

assert_rejected() {
  local label="$1"
  local fixture="$2"
  local design_path="${3:-${DESIGN}}"
  if validate "${fixture}/.accelerate" "${design_path}" >/dev/null 2>&1; then
    fail "self-attack was accepted: ${label}"
  fi
  rm -rf "${fixture}"
}

[ -f "${VALIDATOR}" ] || fail "missing structured v3 validator"
[ -f "${DESIGN}" ] || fail "missing governing design"
source_before="$(template_manifest_digest "${SOURCE_TEMPLATE}")"
validate "${SOURCE_TEMPLATE}"

fixture="$(new_fixture)"
mkdir -p "${fixture}/.accelerate/openspec"
printf '%s\n' copied > "${fixture}/.accelerate/openspec/spec.md"
assert_rejected 'copied OpenSpec tree' "${fixture}"

fixture="$(new_fixture)"
mkdir -p "${fixture}/.accelerate/harness/provider_payloads"
printf '%s\n' generated > "${fixture}/.accelerate/harness/provider_payloads/event.json"
assert_rejected 'provider payload with underscore' "${fixture}"

fixture="$(new_fixture)"
printf '%s\n' 'github_pat_ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890' > "${fixture}/.accelerate/harness/receipt-note.md"
assert_rejected 'raw GitHub PAT' "${fixture}"

fixture="$(new_fixture)"
printf '%s\n' 'api_key: "ABCDEFGHIJKLMNOPQRSTUVWX"' >> "${fixture}/.accelerate/README.md"
assert_rejected 'quoted API key in allowlisted README' "${fixture}"

fixture="$(new_fixture)"
printf '%s\n' 'Authorization: Bearer "ABCDEFGHIJKLMNOPQRSTUVWX"' >> "${fixture}/.accelerate/README.md"
assert_rejected 'quoted Bearer token in allowlisted README' "${fixture}"

fixture="$(new_fixture)"
printf 'SQLite format 3\000malicious' > "${fixture}/.accelerate/harness/ledger.bin"
assert_rejected 'SQLite bytes in non-database filename' "${fixture}"

fixture="$(new_fixture)"
printf '%s\n' 'authority: attacker' > "${fixture}/.accelerate/harness/unexpected-authority.yaml"
assert_rejected 'unexpected authority file' "${fixture}"

fixture="$(new_fixture)"
sed -i 's|governing_design_path: .*|governing_design_path: planning/attacker.md|' "${fixture}/.accelerate/planning-pointer.yaml"
assert_rejected 'governing design path replacement' "${fixture}"

fixture="$(new_fixture)"
cp "${DESIGN}" "${fixture}/identical-design-copy.md"
assert_rejected 'identical governing-design copy outside repo-owned path' "${fixture}" "${fixture}/identical-design-copy.md"

fixture="$(new_fixture)"
printf '%s\n' 'writer: attacker-store' >> "${fixture}/.accelerate/planning-pointer.yaml"
assert_rejected 'duplicate pointer key' "${fixture}"

fixture="$(new_fixture)"
printf '%s\n' 'runtime_enabled: true' 'secrets_present: true' >> "${fixture}/.accelerate/state.yaml"
assert_rejected 'duplicate active state keys' "${fixture}"

source_after="$(template_manifest_digest "${SOURCE_TEMPLATE}")"
[ "${source_before}" = "${source_after}" ] || fail "self-attacks changed source template"
validate "${SOURCE_TEMPLATE}"
echo 'local-workspace-v3-contract: ok'
