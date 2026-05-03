#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash tests/doctrine-integrity.sh
bash tests/profile-integrity.sh
bash tests/i18n-doctrine.sh
bash tests/design-system-artifact-consistency.sh
bash tests/local-workspace-proof-gates.sh
bash tests/core-command-boundary.sh
bash tests/linear-helper-python-parse.sh
bash tests/markdown-link-integrity.sh

echo "all tests passed"
