#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validator="$ROOT/scripts/validate-codex-v2-delegation-transcript.py"
fixtures="$ROOT/tests/fixtures/codex-v2-delegation"

fail() { printf 'codex-v2-delegation-transcript failed: %s\n' "$1" >&2; exit 1; }

[ -f "$validator" ] || fail "missing parser (expected Red before implementation): $validator"

python3 "$validator" --tier fixture "$fixtures/valid-orchestrated.jsonl"
for fixture in "$fixtures"/valid-*.jsonl; do
  python3 "$validator" --tier fixture "$fixture"
done
for fixture in "$fixtures"/invalid-*.jsonl; do
  if python3 "$validator" --tier fixture "$fixture" >/dev/null 2>&1; then
    fail "accepted invalid fixture $(basename "$fixture")"
  fi
done
for fixture in "$fixtures"/invalid-canonical-fork-*.jsonl; do
  if output="$(python3 "$validator" --tier fixture "$fixture" 2>&1)"; then
    fail "accepted invalid canonical fork: $(basename "$fixture")"
  fi
  grep -Fq 'bounded fork_turns' <<<"$output" || fail "canonical fork rejection was not the fork contract: $(basename "$fixture")"
done
for canonical in "$fixtures/valid-orchestrated.jsonl" "$fixtures/valid-live-envelope.jsonl"; do
  if python3 "$validator" --tier live --expected-route orchestrated "$canonical" >/dev/null 2>&1; then
    fail "canonical transcript was accepted as live evidence: $(basename "$canonical")"
  fi
done
if output="$(python3 "$validator" --tier live --expected-route orchestrated --requested-root-model gpt-5.6-terra --requested-root-effort medium --task-scope 'canary/executor-artifact.txt' --task-scope 'canary/reviewer-evidence.txt' "$fixtures/raw-session-orchestrated.jsonl" 2>&1)"; then
  fail 'raw orchestrated transcript was accepted without API-faithful completion and ordering evidence'
fi
grep -Fq 'completion/reviewer ordering proof unsupported' <<<"$output" || fail 'raw orchestrated transcript did not fail closed on missing completion evidence'
python3 "$validator" --tier live --expected-route luna-leaf --requested-root-model gpt-5.6-luna --requested-root-effort low \
  "$fixtures/raw-luna-no-tool.jsonl" >/dev/null
for fixture in "$fixtures"/invalid-luna-raw-*.jsonl; do
  if python3 "$validator" --tier live --expected-route luna-leaf --requested-root-model gpt-5.6-luna --requested-root-effort low "$fixture" >/dev/null 2>&1; then
    fail "accepted invalid Luna raw transcript: $(basename "$fixture")"
  fi
done
for fixture in "$fixtures"/invalid-raw-fork-*.jsonl; do
  if output="$(python3 "$validator" --tier live --expected-route orchestrated --requested-root-model gpt-5.6-terra --requested-root-effort medium --task-scope 'canary/executor-artifact.txt' --task-scope 'canary/reviewer-evidence.txt' "$fixture" 2>&1)"; then
    fail "accepted invalid raw live fork: $(basename "$fixture")"
  fi
  grep -Fq 'bounded fork_turns' <<<"$output" || fail "raw fork rejection was not the fork contract: $(basename "$fixture")"
done
receipt_output="$(bash "$ROOT/tests/codex-v2-delegation-live-canary.sh" --receipt-self-test)"
python3 -c 'import json,sys; receipt=json.loads(sys.stdin.read())["harness_receipt"]; assert receipt["requested_by_harness"] == {"model":"gpt-5.6-luna","reasoning_effort":"low"}; assert len(receipt["raw_jsonl_sha256"]) == 64; assert receipt["verdict"]["status"] == "passed"' <<<"$receipt_output"

printf 'codex v2 delegation transcript contract passed\n'
