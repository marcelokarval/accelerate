#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'skill-export-proof failed: %s\n' "$1" >&2
  exit 1
}

require_match() {
  local pattern="$1"
  local path="$2"
  rg -n "$pattern" "$path" >/dev/null || fail "missing pattern '$pattern' in $path"
}

for path in \
  scripts/export-skill-proof.sh \
  core/control-plane/skill-sync-topology.md \
  skills/README.md \
  skills/_registry/manifest.md \
  planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md; do
  [ -f "$path" ] || fail "missing $path"
done

require_match 'repo -> generated export -> host runtime' core/control-plane/skill-sync-topology.md
require_match 'skill-export-proof-2026-05-08.md' core/control-plane/skill-sync-topology.md
require_match 'generated export is not source truth|generated bundles are deployment artifacts' core/control-plane/skill-sync-topology.md
require_match 'user-home.*non-authoritative|user-home catalogs remain non-authoritative' skills/README.md
require_match 'source_commit' planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md
require_match 'drift_detected.*false' planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md
require_match 'scripts/export-skill-proof.sh --output' planning/evidence/dated-proof-appendix/skill-export-proof-2026-05-08.md

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

scripts/export-skill-proof.sh --output "$TMPDIR" --selected prompt-hardening,verification-before-completion --check-drift >/tmp/accelerate-skill-export-proof.out

PROVENANCE="$TMPDIR/generated-skill-export/provenance.json"
DRIFT="$TMPDIR/generated-skill-export/drift-report.json"
[ -f "$PROVENANCE" ] || fail "missing generated provenance"
[ -f "$DRIFT" ] || fail "missing generated drift report"

require_match '"authority": "repo-local source only; generated export is not source truth"' "$PROVENANCE"
require_match '"user_home_catalogs_authoritative": false' "$PROVENANCE"
require_match '"selected_skill_set"' "$PROVENANCE"
require_match '"prompt-hardening"' "$PROVENANCE"
require_match '"verification-before-completion"' "$PROVENANCE"
require_match '"drift_detected": false' "$DRIFT"

printf '\n# stale edit injected by test\n' >> "$TMPDIR/generated-skill-export/skills/prompt-hardening/SKILL.md"
if scripts/export-skill-proof.sh --output "$TMPDIR" --verify-existing --check-drift >/tmp/accelerate-skill-export-proof-drift.out 2>&1; then
  fail "stale export verification unexpectedly passed"
fi
require_match 'content differs from repo source' /tmp/accelerate-skill-export-proof-drift.out

printf 'skill export proof passed\n'
