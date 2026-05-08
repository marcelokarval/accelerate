#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD="${ROOT}/core/control-plane/recursive-improvement-situation-dashboard.md"

python3 - "${DASHBOARD}" <<'PY'
from pathlib import Path
import sys

dashboard = Path(sys.argv[1])
text = dashboard.read_text()

PROMOTED = {"available", "native", "done", "implemented"}
WEAK_TERMS = {
    "blocked",
    "planned",
    "substitute",
    "dry-run",
    "fallback",
    "not equivalent",
    "missing",
    "absent",
    "without proof",
    "not yet",
}
STRONG_TERMS = {
    "contract test",
    "contract tests",
    "fixture proof",
    "live proof",
    "validated",
    "passed",
    "proof:",
    "bash tests/",
}


def fail(message: str) -> None:
    print(f"semantic-negative-fixtures failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def markdown_rows(source: str):
    for raw in source.splitlines():
        line = raw.strip()
        if not line.startswith("|") or line.startswith("| ---"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) >= 6 and cells[0].lower() != "situation":
            yield cells


def status_of(cells):
    return cells[1].strip("`").strip().lower()


def reject_optimistic_promotion(source: str) -> list[str]:
    errors: list[str] = []
    for cells in markdown_rows(source):
        status = status_of(cells)
        row_text = " ".join(cells).lower()
        evidence_text = cells[2].lower() if len(cells) > 2 else ""
        if status in PROMOTED and any(term in row_text for term in WEAK_TERMS):
            if not any(term in evidence_text for term in STRONG_TERMS):
                errors.append(f"{cells[0]} promoted to {status} while row still contains weak status language")
    return errors

real_errors = reject_optimistic_promotion(text)
if real_errors:
    fail("current dashboard violates semantic promotion gate: " + "; ".join(real_errors))

negative_fixtures = {
    "blocked-promoted": """
| Situation | Status | Evidence | Residual | Next task | Owner lane |
| --- | --- | --- | --- | --- | --- |
| Linear MCP writes | `available` | Existing evidence says blocked by structured_non_llm_mcp_write_binding_required. | still blocked | Prove live non-sensitive fixture. | workflow |
""",
    "planned-promoted": """
| Situation | Status | Evidence | Residual | Next task | Owner lane |
| --- | --- | --- | --- | --- | --- |
| Runtime adapter maturity | `native` | Planned dashboard is absent and proof is missing. | not yet implemented | Build dashboard. | runtime |
""",
    "substitute-promoted": """
| Situation | Status | Evidence | Residual | Next task | Owner lane |
| --- | --- | --- | --- | --- | --- |
| Browser provider truth | `implemented` | Substitute dry-run evidence exists but is not equivalent to browser/runtime truth. | live proof missing | Run real browser proof. | qa |
""",
}

for name, fixture in negative_fixtures.items():
    errors = reject_optimistic_promotion(fixture)
    if not errors:
        fail(f"negative fixture was not rejected: {name}")

positive_fixture = """
| Situation | Status | Evidence | Residual | Next task | Owner lane |
| --- | --- | --- | --- | --- | --- |
| Semantic negative gates | `available` | Contract tests passed: bash tests/semantic-negative-fixtures.sh. | Coverage is bounded to status rows. | Keep fixtures current. | qa |
"""
if reject_optimistic_promotion(positive_fixture):
    fail("positive contract-test-backed fixture was rejected")

print("semantic negative fixtures passed")
PY
