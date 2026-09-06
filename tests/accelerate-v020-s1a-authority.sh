#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

RED_FIRST=0
for arg in "$@"; do
  case "$arg" in
    --red-first)
      RED_FIRST=1
      ;;
    *)
      printf 'unknown argument: %s\n' "$arg" >&2
      exit 2
      ;;
  esac
done

FIXTURES_DIR="${ROOT}/tests/fixtures/contract-v1-authority"
VALIDATOR="${ROOT}/scripts/validate-accelerate-v020-s1a-authority.py"

# Preflight: Verify fixture directory and required fixture files exist and are valid JSON
if [ ! -d "$FIXTURES_DIR" ]; then
  printf '[BLOCKED: FIXTURES_DIR_MISSING] Fixtures directory missing: %s\n' "$FIXTURES_DIR" >&2
  exit 2
fi

required_fixtures=(
  "authority-classes-precedence.json"
  "acv1-expected-mapping.json"
  "canonical-authority-positive.json"
  "neg-r01-01-external-authority-override.json"
  "neg-r01-02-generated-export-as-canonical.json"
  "neg-acv1-03-invalid-disposition-or-missing-id.json"
  "neg-seq-04-draft-authorizing-advance.json"
  "neg-seq-05-s1b-started-before-amendment-accepted.json"
  "manifest.json"
)

for f in "${required_fixtures[@]}"; do
  fpath="${FIXTURES_DIR}/${f}"
  if [ ! -f "$fpath" ]; then
    printf '[BLOCKED: FIXTURE_MISSING] Required fixture missing: %s\n' "$fpath" >&2
    exit 2
  fi
  if ! python3 -c 'import json, sys; json.load(open(sys.argv[1]))' "$fpath" 2>/dev/null; then
    printf '[BLOCKED: FIXTURE_CORRUPTED] Corrupted JSON in fixture: %s\n' "$fpath" >&2
    exit 2
  fi
done

# Check validator existence
if [ ! -f "$VALIDATOR" ]; then
  if [ "$RED_FIRST" -eq 1 ]; then
    printf '=== S1A Authority Gate: RED-FIRST Verification ===\n'
    printf 'Target: scripts/validate-accelerate-v020-s1a-authority.py\n'
    printf 'Status: Absent (Phase P05 RED observed)\n'
  fi
  printf '[RED-S1A-00: VALIDATOR_MISSING_OR_NON_COMPLIANT] scripts/validate-accelerate-v020-s1a-authority.py is missing or not implemented\n' >&2
  exit 1
fi

# When validator exists, handle --red-first check
if [ "$RED_FIRST" -eq 1 ]; then
  printf '=== S1A Authority Gate: RED-FIRST Verification ===\n'
  printf 'Target: scripts/validate-accelerate-v020-s1a-authority.py\n'
  set +e
  probe_out=$(python3 "$VALIDATOR" --fixture "${FIXTURES_DIR}/canonical-authority-positive.json" 2>&1)
  probe_code=$?
  set -e
  if [ "$probe_code" -ne 0 ] || grep -Fq "RED-S1A-00" <<< "$probe_out"; then
    printf '[RED-S1A-00: VALIDATOR_MISSING_OR_NON_COMPLIANT] Validator present but non-compliant or reporting RED state:\n%s\n' "$probe_out" >&2
    exit 1
  else
    printf 'Validator is already implemented and passing canonical checks; red-first phase has concluded.\n'
    exit 0
  fi
fi

# Suite Execution Mode
printf '=== Running S1A Contract v1 Authority Suite ===\n'

# 1. Canonical Positive Test
printf '[1/6] Testing canonical positive fixture...\n'
if ! pos_out=$(python3 "$VALIDATOR" --fixture "${FIXTURES_DIR}/canonical-authority-positive.json" 2>&1); then
  printf '[FAIL: CANONICAL_POSITIVE_REJECTED] Canonical positive fixture rejected by validator:\n%s\n' "$pos_out" >&2
  printf '[RED-S1A-00: VALIDATOR_MISSING_OR_NON_COMPLIANT] Validator failed canonical verification\n' >&2
  exit 1
fi

printf '[2/6] Testing default repository amendment validation...\n'
if ! repo_out=$(python3 "$VALIDATOR" 2>&1); then
  printf '[FAIL: REPO_AMENDMENT_REJECTED] Repository amendment validation failed:\n%s\n' "$repo_out" >&2
  printf '[RED-S1A-00: VALIDATOR_MISSING_OR_NON_COMPLIANT] Validator failed repository amendment check\n' >&2
  exit 1
fi

test_negative() {
  local step="$1"
  local test_id="$2"
  local fixture_file="$3"
  local expected_marker="$4"

  printf '[%s] Testing negative fixture %s (%s)...\n' "$step" "$test_id" "$fixture_file"
  set +e
  local out
  out=$(python3 "$VALIDATOR" --fixture "${FIXTURES_DIR}/${fixture_file}" 2>&1)
  local ret=$?
  set -e

  if [ "$ret" -eq 0 ]; then
    printf '[FAIL: %s_ACCEPTED] Negative fixture was unexpectedly accepted by validator! Output:\n%s\n' "$test_id" "$out" >&2
    exit 1
  fi

  if ! grep -Fq "$expected_marker" <<< "$out"; then
    printf '[FAIL: %s_WRONG_MARKER] Negative fixture rejected with exit %d but missing expected marker "%s". Output:\n%s\n' \
      "$test_id" "$ret" "$expected_marker" "$out" >&2
    exit 1
  fi

  printf '  PASS: %s correctly rejected with expected marker %s\n' "$test_id" "$expected_marker"
}

# 2. NEG-R01-01: External authority override
test_negative "3/6" "NEG-R01-01" "neg-r01-01-external-authority-override.json" "[NEG-R01-01: EXTERNAL_AUTHORITY_OVERRIDE_REJECTED]"

# 3. NEG-R01-02: Reverse edge export as canonical
test_negative "4/6" "NEG-R01-02" "neg-r01-02-generated-export-as-canonical.json" "[NEG-R01-02: REVERSE_EDGE_EXPORT_AS_CANONICAL_REJECTED]"

# 4. NEG-ACV1-03: ACV1 mapping non-compliant
test_negative "5/6" "NEG-ACV1-03" "neg-acv1-03-invalid-disposition-or-missing-id.json" "[NEG-ACV1-03: ACV1_MAPPING_NON_COMPLIANT_REJECTED]"

# 5. NEG-SEQ-04: Draft authorizing advance
test_negative "6a/6" "NEG-SEQ-04" "neg-seq-04-draft-authorizing-advance.json" "[NEG-SEQ-04: DRAFT_AUTHORIZATION_OF_ADVANCE_REJECTED]"

# 6. NEG-SEQ-05: S1B premature start
test_negative "6b/6" "NEG-SEQ-05" "neg-seq-05-s1b-started-before-amendment-accepted.json" "[NEG-SEQ-05: S1B_PREMATURE_START_REJECTED]"

printf '\n[PASS: S1A_AUTHORITY_SUITE_COMPLIANT] All positive and negative authority tests passed.\n'
exit 0
