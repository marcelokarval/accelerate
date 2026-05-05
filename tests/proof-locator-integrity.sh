#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

python3 - "${ROOT}" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])

CONTROL_VALUES = {
    "none",
    "planned",
    "blocked",
    "local-substitute",
    "dry-run-only",
    "dry-run-and-live-read-normalizer",
    "local-readiness-artifact",
    "blocked-without-linear-api-key",
    "blocked-structured-non-llm-mcp-write-binding-required",
}

PROOF_KEYS = re.compile(r"(^|_)(proof|evidence|target)$|live_test_target")


def fail(message: str) -> None:
    print(f"proof-locator-integrity failed: {message}", file=sys.stderr)
    raise SystemExit(1)

for path in sorted((root / "adapters").glob("**/*.yaml")):
    for line_number, line in enumerate(path.read_text().splitlines(), start=1):
        match = re.match(r"^\s*([a-zA-Z0-9_]+):\s*(.*?)\s*$", line)
        if not match:
            continue
        key, value = match.groups()
        if not PROOF_KEYS.search(key):
            continue
        if not value or value in CONTROL_VALUES:
            continue
        if value.startswith("dated-proof-appendix"):
            fail(f"{path.relative_to(root)}:{line_number} uses bare dated-proof-appendix locator; use a repo-relative evidence file")
        if value.startswith("planning/evidence/"):
            target = root / value
            if not target.is_file():
                fail(f"{path.relative_to(root)}:{line_number} points to missing evidence file: {value}")

print("proof locator integrity passed")
PY
