#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

python3 - "${ROOT}" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
RUNTIME = root / "core/control-plane/runtime-adapter-maturity-dashboard.md"
SKILL = root / "core/control-plane/skill-sync-topology.md"
AGENT = root / "core/control-plane/agent-factory-promotion-pipeline.md"
DELEGATION_POINTER = root / "core/delegation/agent-factory-promotion-pipeline.md"
SKILLS_README = root / "skills/README.md"
SITUATION = root / "core/control-plane/recursive-improvement-situation-dashboard.md"


def fail(message: str) -> None:
    print(f"control-plane-rc4-rc6 failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def text(path: Path) -> str:
    if not path.is_file():
        fail(f"missing required file: {path.relative_to(root)}")
    return path.read_text()


def require_terms(body: str, terms: list[str], label: str) -> None:
    lowered = body.lower()
    for term in terms:
        if term.lower() not in lowered:
            fail(f"{label} missing required term: {term}")


def table_rows(body: str) -> list[list[str]]:
    rows = []
    for line in body.splitlines():
        stripped = line.strip()
        if not stripped.startswith("|") or "---" in stripped:
            continue
        cells = [cell.strip().strip("`") for cell in stripped.strip("|").split("|")]
        if len(cells) >= 2:
            rows.append(cells)
    return rows

runtime = text(RUNTIME)
require_terms(
    runtime,
    [
        "Status Vocabulary",
        "browser",
        "Playwright",
        "Chrome DevTools",
        "local shell/runtime scripts",
        "remote runtime adapters",
        "proof locator",
        "blocker",
        "promotion condition",
        "demotion condition",
        "cleanup rule",
        "owner lane",
        "browser-proof monitoring improvements",
        "does not claim an autonomous runtime",
    ],
    "runtime adapter maturity dashboard",
)
for required_status in ["native", "available", "substitute", "planned", "blocked", "linked", "deprecated"]:
    if f"`{required_status}`" not in runtime:
        fail(f"runtime dashboard missing status vocabulary value: {required_status}")

runtime_rows = table_rows(runtime)
for adapter in ["Browser proof", "Playwright", "Chrome DevTools", "Local shell", "Remote runtime", "Autonomous agent runtime"]:
    if not any(adapter.lower() in " | ".join(row).lower() for row in runtime_rows):
        fail(f"runtime dashboard missing adapter row for: {adapter}")

optimistic_remote = []
for row in runtime_rows:
    first_cell = row[0].lower() if row else ""
    status = row[1].lower() if len(row) > 1 else ""
    if any(term in first_cell for term in ["remote runtime", "autonomous agent runtime", "playwright", "chrome devtools"]):
        if status in {"available", "native"}:
            optimistic_remote.append(" | ".join(row))
if optimistic_remote:
    fail("unproven runtime posture marked available/native: " + optimistic_remote[0])

skill = text(SKILL)
require_terms(
    skill,
    [
        "repo-local",
        "source of truth",
        "repo -> generated export -> host runtime",
        "user-home",
        "not governing authority",
        "drift detection",
        "sync artifact boundaries",
        "generated skill bundles",
        "promotion criteria",
        "cleanup rules",
    ],
    "skill sync topology",
)
for forbidden_authority in ["~/.claude/skills", "~/.codex/skills", "~/.agents/skills"]:
    if forbidden_authority not in skill:
        fail(f"skill topology missing forbidden authority example: {forbidden_authority}")
if re.search(r"user-home[^\n.]*governing authority", skill, re.IGNORECASE) and "not governing authority" not in skill.lower():
    fail("skill topology appears to treat user-home as authority")

skills_readme = text(SKILLS_README)
require_terms(skills_readme, ["source of truth", "skill-sync-topology.md", "Do not add new global-only governed skills"], "skills README")

agent = text(AGENT)
require_terms(
    agent,
    [
        "candidate role intake",
        "skill envelope",
        "proof replay",
        "runtime binding",
        "cleanup/idle-agent handling",
        "demotion criteria",
        "Promotion Status Vocabulary",
        "does not create an autonomous runtime",
        "does not promote unproven role execution",
        "requested-vs-implemented",
        "self-forensic review",
    ],
    "agent factory promotion pipeline",
)
for lifecycle in ["candidate", "scaffolded", "proof-replay", "runtime-bound", "available", "demoted", "blocked"]:
    if f"`{lifecycle}`" not in agent:
        fail(f"agent pipeline missing lifecycle status: {lifecycle}")

for row in table_rows(agent):
    joined = " | ".join(row).lower()
    status = row[1].lower() if len(row) > 1 else ""
    if "autonomous runtime agent" in joined and status != "blocked":
        fail("autonomous runtime agent must remain blocked without runtime proof")

pointer = text(DELEGATION_POINTER)
require_terms(pointer, ["control-plane/agent-factory-promotion-pipeline.md", "does not claim an autonomous runtime"], "delegation pointer")

situation = text(SITUATION)
for label, target in [
    ("Runtime adapter maturity", "runtime-adapter-maturity-dashboard.md"),
    ("Skill sync topology", "skill-sync-topology.md"),
    ("Agent factory promotion pipeline", "agent-factory-promotion-pipeline.md"),
]:
    matching = [row for row in table_rows(situation) if row and label.lower() in row[0].lower()]
    if not matching:
        fail(f"situation dashboard missing row: {label}")
    if not any(len(row) > 2 and row[1].lower() == "linked" and target in " | ".join(row) for row in matching):
        fail(f"situation dashboard row for {label} must be linked to {target}")

print("control-plane RC4/RC5/RC6 contract passed")
PY
