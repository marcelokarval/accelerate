#!/usr/bin/env bash
set -euo pipefail
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=. python3 -B -m unittest discover -s tests/phase1 -v
PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=. python3 -B scripts/phase1/generate_receipts.py
find core/phase1 adapters/openspec planning/openspec scripts/phase1 tests/phase1 -type d -name __pycache__ -prune -exec rm -rf {} +
find core/phase1 adapters/openspec planning/openspec scripts/phase1 tests/phase1 -type f -name '*.pyc' -delete
