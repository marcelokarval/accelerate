#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_DIR="${ROOT}/core"

for forbidden in \
  "backend/src/manage.py" \
  "frontends/front-react" \
  "npm run type-check --prefix" \
  "uv run python backend"; do
  if grep -R -n -F "${forbidden}" "${CORE_DIR}" >/tmp/accelerate-core-command-boundary.out 2>&1; then
    echo "core command boundary violation: ${forbidden}" >&2
    cat /tmp/accelerate-core-command-boundary.out >&2
    exit 1
  fi
done

echo "core command boundary passed"
