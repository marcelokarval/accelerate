#!/usr/bin/env bash
# Canonical v1 acceptance: routing, source authority and retained capability regressions.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
export PYTHONDONTWRITEBYTECODE=1
python3 tests/run-suite.py
