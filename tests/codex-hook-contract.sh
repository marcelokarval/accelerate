#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS="${ROOT}/adapters/runtime/codex/codex-hooks.json"

test -f "${HOOKS}"
python3 -m json.tool "${HOOKS}" >/dev/null
! rg -n '\.orca|ORCA_|\|\| true|exit 0' "${HOOKS}"
