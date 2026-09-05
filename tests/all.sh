#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_tests=(
  "tests/recursive-self-improvement-contract.sh"
  "tests/semantic-implication-python-contract.sh"
  "tests/test_semantic_implication.py"
  "tests/test_harness_catalog.py"
  "tests/test_phase1_entry_currentness.py"
  "tests/test_assignment_ontology.py"
  "tests/test_task_graph_heartbeat.py"
)

for required_test in "${required_tests[@]}"; do
  if [ ! -f "${required_test}" ]; then
    printf 'missing required test: %s\n' "${required_test}" >&2
    exit 1
  fi
done

python3 -m pytest -q \
  tests/test_assignment_ontology.py \
  tests/test_task_graph_heartbeat.py \
  tests/test_phase1_entry_currentness.py

printf '%s\n' 'running required offline Phase-1 regression lane'
PHASE1_REAL_OPENSPEC=0 bash tests/phase1/run.sh
printf '%s\n' 'real OpenSpec is separately opt-in: PHASE1_REAL_OPENSPEC=1 bash tests/phase1/run.sh'

while IFS= read -r test_script; do
  case "${test_script}" in
    tests/all.sh|tests/direct-fast-path-routing.sh|tests/runtime-sync-direct-fast-path.sh) continue ;;
  esac
  bash "${test_script}"
done < <(find tests -maxdepth 1 -type f -name '*.sh' | sort)

echo "all tests passed"
