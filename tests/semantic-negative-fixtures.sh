#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD="${ROOT}/core/control-plane/recursive-improvement-situation-dashboard.md"
DOGFOOD_DASHBOARD="${ROOT}/.accelerate/status/readiness-dashboard.yaml"
ACTIVE_WORK_ITEM="${ROOT}/.accelerate/workflow/active-work-item.yaml"

python3 - "${DASHBOARD}" "${DOGFOOD_DASHBOARD}" "${ACTIVE_WORK_ITEM}" <<'PY'
from pathlib import Path
import sys

dashboard = Path(sys.argv[1])
dogfood_dashboard = Path(sys.argv[2])
active_work_item = Path(sys.argv[3])
text = dashboard.read_text()
dogfood_text = dogfood_dashboard.read_text()
active_text = active_work_item.read_text()

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
    "capture-failed",
    "runtime unavailable",
    "browser automation is missing",
    "persistent e2e remains unpromoted",
}
STRONG_TERMS = {
    "contract test",
    "contract tests",
    "fixture proof",
    "validated",
    "passed",
    "proof:",
    "proof locator",
    "bash tests/",
}
NEGATED_PROOF_TERMS = {
    "without proof locator",
    "without separate proof locator",
    "proof is missing",
    "proof missing",
    "missing proof",
    "live proof is missing",
    "absent proof",
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


def reject_markdown_optimistic_promotion(source: str) -> list[str]:
    errors: list[str] = []
    for cells in markdown_rows(source):
        status = status_of(cells)
        row_text = " ".join(cells).lower()
        evidence_text = cells[2].lower() if len(cells) > 2 else ""
        if status in PROMOTED and any(term in row_text for term in WEAK_TERMS):
            has_strong_evidence = any(term in evidence_text for term in STRONG_TERMS)
            has_negated_proof = any(term in row_text for term in NEGATED_PROOF_TERMS)
            if not has_strong_evidence or has_negated_proof:
                errors.append(f"{cells[0]} promoted to {status} while row still contains weak status language")
    return errors


def reject_yaml_optimistic_promotion(source: str) -> list[str]:
    errors: list[str] = []
    lines = source.splitlines()
    for index, raw in enumerate(lines):
        stripped = raw.strip()
        if not stripped.startswith("status:"):
            continue
        status = stripped.split(":", 1)[1].strip().strip('`"').lower()
        if status not in PROMOTED:
            continue
        status_indent = len(raw) - len(raw.lstrip())
        item_indent = None
        for back in range(index - 1, -1, -1):
            candidate = lines[back]
            candidate_stripped = candidate.strip()
            if not candidate_stripped:
                continue
            candidate_indent = len(candidate) - len(candidate.lstrip())
            if candidate_indent < status_indent and candidate_stripped.endswith(":"):
                item_indent = candidate_indent
                start = back
                break
        else:
            start = max(0, index - 1)
        end = len(lines)
        if item_indent is not None:
            for forward in range(index + 1, len(lines)):
                candidate = lines[forward]
                candidate_stripped = candidate.strip()
                if not candidate_stripped:
                    continue
                candidate_indent = len(candidate) - len(candidate.lstrip())
                if candidate_indent <= item_indent:
                    end = forward
                    break
        else:
            end = min(len(lines), index + 4)
        block = "\n".join(lines[start:end]).lower()
        if any(term in block for term in WEAK_TERMS):
            has_strong_evidence = any(term in block for term in STRONG_TERMS)
            has_negated_proof = any(term in block for term in NEGATED_PROOF_TERMS)
            if not has_strong_evidence or has_negated_proof:
                errors.append(f"YAML promoted status near line {index + 1} contains weak status language without proof locator")
    return errors


def reject_optimistic_promotion(source: str) -> list[str]:
    return reject_markdown_optimistic_promotion(source) + reject_yaml_optimistic_promotion(source)

real_errors = reject_optimistic_promotion(text) + reject_optimistic_promotion(dogfood_text)
if real_errors:
    fail("current dashboards violate semantic promotion gate: " + "; ".join(real_errors))

required_cycle_markers = [
    "recursive-cycle-2026-05-08-18-22",
    "planning/executive/2026-05-08-recursive-cycle-18-22-executive-plan.md",
    "planning/executive/2026-05-08-recursive-cycle-18-22-task-ledger.md",
    "root-orchestrator-with-bounded-subagents",
]
combined_dogfood = dogfood_text + "\n" + active_text
for marker in required_cycle_markers:
    if marker not in combined_dogfood:
        fail(f"dogfood cycle marker missing from semantic gate inputs: {marker}")

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
    "capture-failed-promoted": """
entries:
  browser_proof_capture:
    status: available
    evidence: capture-failed packet from missing browser automation is present but proof is missing.
    residual: browser automation is missing.
""",
    "persistent-regression-promoted": """
entries:
  persistent_regression:
    status: implemented
    evidence: browser-capture exists, but persistent E2E remains unpromoted and proof is missing.
    residual: planned Playwright handoff.
""",
    "persistent-regression-handoff-disabled-promoted": """
entries:
  persistent_regression_handoff:
    status: available
    required_before_persistent_e2e_claim: false
    evidence: browser-capture exists without separate proof locator.
    residual: persistent E2E remains unpromoted.
""",
    "linear-live-fixture-promoted-without-live-proof": """
entries:
  linear_live_fixture:
    status: available
    evidence: planned preflight exists, but provider mutation is missing and not yet verified.
    residual: absent credential-safe live fixture.
""",
    "provider-live-linear-promoted-without-proof-locator": """
entries:
  provider_live_linear_mcp_writes:
    status: available
    evidence: planned helper shape exists, but provider mutation evidence is missing and provider mutation is absent.
    residual: without proof locator for non-sensitive Linear fixture.
""",
    "generated-host-user-home-promoted-without-approved-proof": """
entries:
  skill_generated_host_runtime_export:
    status: available
    evidence: generated export exists, but approved generated host proof is missing and user-home runtime catalog authority is absent.
    residual: without proof locator for approved non-user-home generated target.
""",
    "agent-runtime-promoted-from-replay": """
entries:
  bounded_proof_auditor_candidate:
    status: native
    evidence: replay fixture exists, but runtime unavailable and autonomous availability is unsupported.
    residual: blocked runtime binding.
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

entries:
  browser_proof_server_monitoring:
    status: available
    proof: bash tests/browser-proof-monitoring.sh
    boundary: readiness failures write correction packets before browser launch
"""
if reject_optimistic_promotion(positive_fixture):
    fail("positive contract-test-backed fixture was rejected")

print("semantic negative fixtures passed")
PY
