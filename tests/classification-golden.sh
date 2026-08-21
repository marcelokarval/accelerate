#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
grep -Fq "runtime-adapter" "${ROOT}/tests/fixtures/classification/golden.tsv"
grep -Fq "design-system-review" "${ROOT}/tests/fixtures/classification/golden.tsv"

require() {
  local path="$1"
  local expected="$2"
  grep -Fq "$expected" "$path" || {
    printf 'classification golden tests failed: missing %s in %s\n' "$expected" "$path" >&2
    exit 1
  }
}

require "${ROOT}/AGENTS.md" "Standing Multi-Agent V2 Delegation Request"
require "${ROOT}/AGENTS.md" 'MUST call `collaboration.spawn_agent` before any task-owned mutation'
require "${ROOT}/SKILL.md" "Standing Multi-Agent V2 Delegation Request"
require "${ROOT}/SKILL.md" "blocking exception receipt, not permission"
require "${ROOT}/global-runtime/accelerate/SKILL.md" "Standing Multi-Agent V2 Delegation Request"
require "${ROOT}/global-runtime/accelerate/SKILL.md" "MUST NOT execute task-owned scopes"

python3 - "${ROOT}/global-runtime/accelerate/evals/evals.json" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as stream:
    evals = {entry["id"]: entry for entry in json.load(stream)}

required = {
    "orchestrated-execution-physical-dispatch",
    "direct-fast-path-no-dispatch",
    "planning-only-stops-at-tasks-ready",
    "orchestrated-explicit-user-opt-out",
    "prescribed-mechanical-luna-dispatch",
}
missing = required - set(evals)
if missing:
    raise SystemExit(f"missing delegation evals: {sorted(missing)}")

if "collaboration.spawn_agent" not in evals["orchestrated-execution-physical-dispatch"]["expected_behavior"]:
    raise SystemExit("orchestrated dispatch eval does not require physical spawn")
if "gpt-5.6-luna" not in evals["prescribed-mechanical-luna-dispatch"]["expected_behavior"]:
    raise SystemExit("mechanical dispatch eval does not prescribe Luna")
PY

echo "classification golden tests passed"
