#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
grep -Fq "runtime-adapter" "${ROOT}/tests/fixtures/classification/golden.tsv"
grep -Fq "design-system-review" "${ROOT}/tests/fixtures/classification/golden.tsv"

echo "classification golden tests passed"
