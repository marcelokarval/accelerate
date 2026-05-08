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

HOST_TARGET="$TMPDIR/approved-generated-host-runtime"
scripts/export-skill-proof.sh \
  --output "$TMPDIR/host-proof" \
  --selected prompt-hardening,verification-before-completion \
  --host-runtime-target "$HOST_TARGET" \
  --approve-generated-host-target \
  --cleanup-host-target \
  --check-drift >/tmp/accelerate-skill-export-proof-host.out

HOST_PROOF="$TMPDIR/host-proof/generated-skill-export/host-runtime-proof.json"
[ -f "$HOST_PROOF" ] || fail "missing host runtime proof"
require_match '"artifact_type": "accelerate-generated-host-runtime-export-proof"' "$HOST_PROOF"
require_match '"authority": "repo-local source only; generated host target is not source truth"' "$HOST_PROOF"
require_match '"approved_generated_host_target": true' "$HOST_PROOF"
require_match '"temporary_or_generated_target_only": true' "$HOST_PROOF"
require_match '"host_drift_detected": false' "$HOST_PROOF"
require_match '"cleanup_action": "removed generated host target"' "$HOST_PROOF"
require_match '"target_exists_after_cleanup": false' "$HOST_PROOF"
[ ! -e "$HOST_TARGET" ] || fail "generated host runtime target was not cleaned up"

ROLLBACK_TARGET="$TMPDIR/preexisting-generated-host-runtime"
mkdir -p "$ROLLBACK_TARGET"
printf 'preexisting host marker\n' > "$ROLLBACK_TARGET/preexisting.txt"
scripts/export-skill-proof.sh \
  --output "$TMPDIR/rollback-proof" \
  --selected prompt-hardening \
  --host-runtime-target "$ROLLBACK_TARGET" \
  --approve-generated-host-target \
  --cleanup-host-target \
  --check-drift >/tmp/accelerate-skill-export-proof-rollback.out
ROLLBACK_PROOF="$TMPDIR/rollback-proof/generated-skill-export/host-runtime-proof.json"
[ -f "$ROLLBACK_PROOF" ] || fail "missing rollback host runtime proof"
require_match '"rollback_restored": true' "$ROLLBACK_PROOF"
require_match '"target_exists_after_cleanup": true' "$ROLLBACK_PROOF"
require_match 'restored prior target snapshot' "$ROLLBACK_PROOF"
require_match 'preexisting host marker' "$ROLLBACK_TARGET/preexisting.txt"
[ ! -f "$ROLLBACK_TARGET/provenance.json" ] || fail "generated host files remained after rollback restore"

if scripts/export-skill-proof.sh \
  --output "$TMPDIR/missing-approval" \
  --selected prompt-hardening \
  --host-runtime-target "$TMPDIR/unapproved-generated-host-runtime" \
  --check-drift >/tmp/accelerate-skill-export-proof-unapproved.out 2>&1; then
  fail "unapproved host runtime target unexpectedly passed"
fi
require_match 'requires --approve-generated-host-target' /tmp/accelerate-skill-export-proof-unapproved.out

mkdir -p "$TMPDIR/home/.codex"
if HOME="$TMPDIR/home" scripts/export-skill-proof.sh \
  --output "$TMPDIR/forbidden-home" \
  --selected prompt-hardening \
  --host-runtime-target "$TMPDIR/home/.codex/skills/accelerate" \
  --approve-generated-host-target \
  --check-drift >/tmp/accelerate-skill-export-proof-home.out 2>&1; then
  fail "user-home host runtime catalog unexpectedly accepted"
fi
require_match 'refusing to write generated host proof into a user-home runtime catalog' /tmp/accelerate-skill-export-proof-home.out

printf '\n# stale edit injected by test\n' >> "$TMPDIR/generated-skill-export/skills/prompt-hardening/SKILL.md"
if scripts/export-skill-proof.sh --output "$TMPDIR" --verify-existing --check-drift >/tmp/accelerate-skill-export-proof-drift.out 2>&1; then
  fail "stale export verification unexpectedly passed"
fi
require_match 'content differs from repo source' /tmp/accelerate-skill-export-proof-drift.out

printf 'skill export proof passed\n'
