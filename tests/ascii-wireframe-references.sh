#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="${ROOT}/skills/frontend/ascii-wireframe"
SKILL="${SKILL_DIR}/SKILL.md"
META="${SKILL_DIR}/metadata.yaml"
FRONTEND_README="${ROOT}/skills/frontend/README.md"

fail() {
  echo "ascii-wireframe references test failed: $*" >&2
  exit 1
}

require_file() {
  [ -f "${ROOT}/$1" ] || fail "missing required file: $1"
}

require_match() {
  local pattern="$1"
  local file="$2"
  grep -Eq "$pattern" "${file}" || fail "${file#${ROOT}/} missing pattern: ${pattern}"
}

for ref in \
  skills/frontend/ascii-wireframe/references/visual-modeling-boundary.md \
  skills/frontend/ascii-wireframe/references/diagram-pattern-catalog.md \
  skills/frontend/ascii-wireframe/references/stack-diagram-selection.md; do
  require_file "${ref}"
  require_match "${ref#skills/frontend/ascii-wireframe/}" "${SKILL}"
  require_match "${ref#skills/frontend/ascii-wireframe/}" "${META}"
done

require_match 'ERD' "${SKILL}"
require_match 'ORM lifecycle' "${SKILL}"
require_match 'sequence diagram' "${SKILL}"
require_match 'state machine' "${SKILL}"
require_match 'swimlane/journey' "${SKILL}"
require_match 'agent communication' "${SKILL}"
require_match 'trust boundary' "${SKILL}"
require_match 'broader visual modeling' "${FRONTEND_README}"

require_match 'ERD / data model' "${SKILL_DIR}/references/diagram-pattern-catalog.md"
require_match 'Agent / team topology' "${SKILL_DIR}/references/diagram-pattern-catalog.md"
require_match 'Governance / issue topology' "${SKILL_DIR}/references/diagram-pattern-catalog.md"
require_match 'Django \+ Inertia \+ React' "${SKILL_DIR}/references/stack-diagram-selection.md"
require_match 'Next\.js \+ AdonisJS \+ AdminJS' "${SKILL_DIR}/references/stack-diagram-selection.md"
require_match 'Next\.js \+ Prisma' "${SKILL_DIR}/references/stack-diagram-selection.md"
require_match 'Next\.js \+ Drizzle' "${SKILL_DIR}/references/stack-diagram-selection.md"
require_match 'Accelerate Control Plane' "${SKILL_DIR}/references/stack-diagram-selection.md"

echo "ascii-wireframe references tests passed"
