#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'host-export-contract failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

contract="adapters/runtime/host-export-contract.md"
script="scripts/export-runtime-host.sh"
out_dir=".tmp/host-export-contract/codex"

[ -f "$contract" ] || fail "missing host export contract"
[ -x "$script" ] || fail "export script is missing or not executable"

for field in \
  schema_version \
  export_identity \
  source_repository \
  source_artifacts \
  target_host \
  target_path \
  generated_files \
  authority \
  privacy_classification \
  suppressed_capabilities \
  rewritten_tools \
  validation_command; do
  require_match "$field" "$contract"
done

rm -rf ".tmp/host-export-contract"
output="$(bash "$script" codex "$out_dir")"
manifest_path="${ROOT}/${out_dir}/accelerate-codex-export-manifest.yaml"
export_path="${ROOT}/${out_dir}/accelerate-codex-export.md"

[ -f "$manifest_path" ] || fail "missing generated export manifest"
[ -f "$export_path" ] || fail "missing generated export markdown"
printf '%s\n' "$output" | rg -n 'accelerate-codex-export-manifest.yaml' >/dev/null || fail "script did not print manifest path"

for field in \
  'schema_version: 1' \
  'export_identity: accelerate-runtime-host-export' \
  'source_repository: accelerate' \
  'source_artifacts:' \
  'target_host: codex' \
  'target_path:' \
  'generated_files:' \
  'authority: generated-export; repository remains source of truth' \
  'privacy_classification: public-repo-derived' \
  'suppressed_capabilities:' \
  'rewritten_tools:' \
  'validation_command:'; do
  require_match "$field" "$manifest_path"
done

require_match 'generated outward' "$export_path"
require_match 'Do not treat this export as canonical doctrine' "$export_path"
require_match 'do not treat it as proof of promoted physical agents' "$export_path"
validation_command="$(python3 - "${manifest_path}" <<'PY'
from pathlib import Path
import re
import sys
text = Path(sys.argv[1]).read_text()
match = re.search(r"(?m)^validation_command: (.+)$", text)
if not match:
    raise SystemExit(1)
print(match.group(1))
PY
)"
(cd /tmp && sh -c "${validation_command}") || fail "validation command is not self-contained from neutral cwd"

if bash "$script" codex ../bad-export >/tmp/accelerate-host-export-traversal.out 2>&1; then
  fail "path traversal output dir was accepted"
fi
require_match 'invalid output dir traversal' /tmp/accelerate-host-export-traversal.out

if bash "$script" 'bad/host' "$out_dir" >/tmp/accelerate-host-export-host.out 2>&1; then
  fail "invalid host was accepted"
fi
require_match 'invalid host' /tmp/accelerate-host-export-host.out

printf 'host export contract passed\n'
