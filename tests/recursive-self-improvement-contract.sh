#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

python3 - "${ROOT}" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])

LOOP = root / "core/control-plane/recursive-self-improvement-loop.md"
DASHBOARD = root / "core/control-plane/recursive-improvement-situation-dashboard.md"
PACKET = root / "core/runtime-packets/recursive-improvement-cycle-packet.md"
PACKET_INDEX = root / "core/runtime-packets/README.md"
LEDGER = root / "planning/executive/2026-05-07-recursive-self-improvement-task-ledger.md"
ALL = root / "tests/all.sh"
SELF = root / "tests/recursive-self-improvement-contract.sh"


def fail(message: str) -> None:
    print(f"recursive-self-improvement-contract failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def require_file(path: Path) -> str:
    if not path.is_file():
        fail(f"missing required file: {path.relative_to(root)}")
    return path.read_text()


def require_terms(text: str, terms: list[str], label: str) -> None:
    lowered = text.lower()
    for term in terms:
        if term.lower() not in lowered:
            fail(f"{label} missing required term: {term}")


def lines_containing(text: str, *needles: str) -> list[str]:
    result = []
    for line in text.splitlines():
        lowered = line.lower()
        if all(needle.lower() in lowered for needle in needles):
            result.append(line)
    return result


loop = require_file(LOOP)
require_terms(
    loop,
    [
        "Inventory",
        "Situation Detection",
        "Task Shaping",
        "Delegated Execution",
        "Delegated Task Review",
        "Root Review-of-Review",
        "Persistence",
        "Next-Step Emission",
        "idle-agent",
        "root final review",
    ],
    "recursive self-improvement loop",
)

dashboard = require_file(DASHBOARD)
required_situations = [
    "GitHub land proof",
    "Linear MCP writes",
    ".accelerate/",
    "dogfood",
    "semantic negative gates",
    "runtime adapter maturity",
    "skill sync topology",
    "agent factory promotion pipeline",
]
require_terms(dashboard, required_situations, "recursive improvement dashboard")
require_terms(dashboard, ["status", "evidence", "residual", "next task", "owner lane"], "recursive improvement dashboard")

honest_status_expectations = [
    (("Linear", "MCP"), {"blocked"}),
    ((".accelerate", "dogfood"), {"planned", "blocked"}),
    (("semantic", "negative"), {"planned", "blocked"}),
    (("runtime", "adapter", "maturity"), {"planned", "blocked"}),
    (("skill", "sync", "topology"), {"planned", "blocked"}),
    (("agent", "factory", "promotion", "pipeline"), {"planned", "blocked"}),
]
github_land_proof = "planning/evidence/dated-proof-appendix/github-pr-land-live-validation-2026-05-07.md"
github_land_matches = lines_containing(dashboard, "GitHub", "land")
if not github_land_matches:
    fail("dashboard missing row containing: GitHub / land")
github_land_honest = False
for line in github_land_matches:
    cells = [cell.strip().strip("`").lower() for cell in line.strip().strip("|").split("|")]
    if len(cells) >= 4 and cells[1] == "available" and github_land_proof in line and (root / github_land_proof).is_file():
        github_land_honest = True
if not github_land_honest:
    fail("dashboard GitHub land row must be available only with durable 2026-05-07 live proof locator")

for needles, allowed_statuses in honest_status_expectations:
    matches = lines_containing(dashboard, *needles)
    if not matches:
        fail(f"dashboard missing row containing: {' / '.join(needles)}")

    honest_match = False
    for line in matches:
        cells = [cell.strip().strip("`").lower() for cell in line.strip().strip("|").split("|")]
        if len(cells) < 2:
            continue
        status_cell = cells[1]
        if status_cell in allowed_statuses:
            honest_match = True
        if status_cell in {"native", "available", "done", "implemented", "complete"}:
            fail(
                f"dashboard status for {' / '.join(needles)} must not claim "
                f"{status_cell} without proof"
            )
    if not honest_match:
        fail(
            f"dashboard status for {' / '.join(needles)} must stay honest with "
            f"one of: {', '.join(sorted(allowed_statuses))}"
        )

packet = require_file(PACKET)
require_terms(
    packet,
    [
        "Cycle ID",
        "Trigger",
        "Inventory Scope",
        "Detected Situations",
        "Task Ledger Link",
        "Subagent Assignment Map",
        "Review Map",
        "Proof Map",
        "Closure Verdict",
        "Next-Cycle Queue",
    ],
    "recursive improvement cycle packet",
)

packet_index = require_file(PACKET_INDEX)
if "recursive-improvement-cycle-packet.md" not in packet_index:
    fail("runtime packet index does not include recursive-improvement-cycle-packet.md")
require_terms(packet_index, ["cycle id", "trigger", "inventory scope", "detected situations", "task ledger link", "subagent assignment map", "review map", "proof map", "closure verdict", "next-cycle queue"], "runtime packet index row")

ledger = require_file(LEDGER)
for task_id in [f"RSI-{number}" for number in range(1, 7)]:
    if not re.search(rf"\b{re.escape(task_id)}\b", ledger):
        fail(f"task ledger missing {task_id}")
require_terms(
    ledger,
    ["Assigned role", "Reviewer role", "Requested vs Implemented", "Proof", "Status", "Residual"],
    "recursive self-improvement task ledger",
)

all_text = require_file(ALL)
self_rel = "tests/recursive-self-improvement-contract.sh"
if "find tests -maxdepth 1 -type f -name '*.sh'" not in all_text and self_rel not in all_text:
    fail("tests/all.sh does not appear to run the recursive self-improvement contract")
if not SELF.is_file():
    fail("recursive self-improvement contract test file is missing")

print("recursive self-improvement contract passed")
PY
