#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 adapters/runtime/dsh/validate-adapter.py
pytest -q tests/test_hardened_execution_packet.py tests/test_dsh_runtime_adapter.py tests/test_dsh_preset_bootstrap.py
python3 scripts/validate-hardened-execution-packet.py \
  global-runtime/accelerate/assets/hardened-execution-packet.template.json
bash tests/skill-export-proof.sh
rg -F '"status": "planned"' adapters/runtime/dsh/adapter-policy.json >/dev/null
! rg -F '"status": "available"' adapters/runtime/dsh/adapter-policy.json >/dev/null

printf 'dsh accelerate bootstrap truth passed\n'
