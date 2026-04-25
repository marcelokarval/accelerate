#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'doctrine-integrity failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local path="$1"
  [ -f "$path" ] || fail "missing required file: $path"
}

require_no_match() {
  local pattern="$1"
  local path="$2"
  if rg -n "$pattern" "$path" >/tmp/accelerate-doctrine-integrity-match.txt; then
    printf '%s\n' "unexpected match for pattern: $pattern" >&2
    cat /tmp/accelerate-doctrine-integrity-match.txt >&2
    exit 1
  fi
}

require_file "core/control-plane/gate-ownership-index.md"
require_file "core/control-plane/failure-classification-gate.md"
require_file "core/control-plane/truth-ownership-check.md"
require_file "core/control-plane/artifact-sufficiency-check.md"

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
manifest = root / "skills/_registry/manifest.md"
index = root / "core/control-plane/gate-ownership-index.md"
matrix = root / "core/control-plane/branch-enforcement-matrix.md"

def fail(message: str) -> None:
    print(f"doctrine-integrity failed: {message}", file=sys.stderr)
    raise SystemExit(1)

registered_skills: set[str] = set()
for line in manifest.read_text().splitlines():
    match = re.match(r"\| `([^`]+)` \|", line)
    if match:
        registered_skills.add(match.group(1))

if not registered_skills:
    fail("skill registry has no registered local skills")

allowed_external_related = {
    "accelerate",
    "active-backend-stack",
    "active-frontend-stack",
    "active-test-stack",
}
for skill_file in (root / "skills").glob("**/SKILL.md"):
    text = skill_file.read_text()
    frontmatter = text.split("---", 2)
    if len(frontmatter) < 3:
        continue
    for line in frontmatter[1].splitlines():
        if not line.startswith("related-skills:"):
            continue
        raw = line.split(":", 1)[1]
        refs = [part.strip() for part in re.split(r"[,\s]+", raw) if part.strip()]
        for ref in refs:
            if ref not in registered_skills and ref not in allowed_external_related:
                fail(f"{skill_file.relative_to(root)} references unregistered related skill `{ref}`")

index_text = index.read_text()
matrix_text = matrix.read_text()

known_non_gate_terms = {
    # These backticked terms appear in the mandatory-gates column but are
    # artifacts, commands, or status labels rather than gates. Keep this list
    # intentionally small; new mandatory gates belong in the ownership index.
    "Hardened Prompt",
    "Execution-Ready Prompt Packet",
    "Requested-Vs-Implemented Packet",
    "AI Review Report",
    "EXPLAIN",
    "prepare-review.sh",
    "prepare-closure.sh",
    "Done",
}

matrix_rows = []
in_matrix = False
for line in matrix_text.splitlines():
    if line.startswith("| Branch |"):
        in_matrix = True
        continue
    if in_matrix and line.startswith("## "):
        break
    if in_matrix and line.startswith("|") and not line.startswith("| ---"):
        matrix_rows.append(line)

for row in matrix_rows:
    columns = [column.strip() for column in row.strip().strip("|").split("|")]
    if len(columns) < 3:
        continue
    mandatory_gates_column = columns[2]
    for gate in re.findall(r"`([^`]+)`", mandatory_gates_column):
        if gate in known_non_gate_terms:
            continue
        if f"`{gate}`" not in index_text:
            fail(f"branch matrix cites `{gate}` without gate ownership index entry")

owner_pattern = re.compile(r"\| `([^`]+)` \| `([^`]+\.md)` \|")
for gate, owner in owner_pattern.findall(index_text):
    if owner == "branch-enforcement-matrix.md":
        candidate = index.parent / owner
    elif owner.startswith("../"):
        candidate = index.parent / owner
    else:
        candidate = index.parent / owner
    if not candidate.resolve().is_file():
        fail(f"gate `{gate}` owner path does not exist: {owner}")

control_readme = root / "core/control-plane/README.md"
control_text = control_readme.read_text()
for required_doc in [
    "gate-ownership-index.md",
    "truth-ownership-check.md",
    "failure-classification-gate.md",
    "artifact-sufficiency-check.md",
]:
    if required_doc not in control_text:
        fail(f"core/control-plane/README.md missing `{required_doc}`")

for profile_dir in (root / "profiles").iterdir():
    if profile_dir.is_dir() and not (profile_dir / "validation-bundle.md").is_file():
        fail(f"active profile missing validation bundle: {profile_dir.relative_to(root)}")

print("doctrine integrity structure passed")
PY

require_no_match 'source: ~/' 'skills'
require_no_match 'runtime_mirror:' 'skills'
require_no_match 'popular-web-designs.*authority|authority.*popular-web-designs' 'README.md' 'AGENTS.md' 'core' 'skills' 'onboarding' 'planning'

printf 'doctrine integrity passed\n'
