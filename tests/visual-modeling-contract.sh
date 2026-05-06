#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="${ROOT}/skills/review/visual-modeling"
SKILL="${SKILL_DIR}/SKILL.md"
META="${SKILL_DIR}/metadata.yaml"
MANIFEST="${ROOT}/skills/_registry/manifest.md"
REVIEW_README="${ROOT}/skills/review/README.md"
ASCII_SKILL="${ROOT}/skills/frontend/ascii-wireframe/SKILL.md"
GATE="${ROOT}/core/control-plane/visual-modeling-gate.md"

fail() {
  echo "visual-modeling contract test failed: $*" >&2
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

require_file "skills/review/visual-modeling/SKILL.md"
require_file "skills/review/visual-modeling/metadata.yaml"
require_file "core/control-plane/visual-modeling-gate.md"

for ref in \
  references/diagram-selection.md \
  references/notation-vocabulary.md \
  references/diagram-quality-bar.md \
  references/stack-trigger-matrix.md; do
  require_file "skills/review/visual-modeling/${ref}"
  require_match "${ref}" "${SKILL}"
  require_match "${ref}" "${META}"
done

for template in \
  erd.md \
  sequence.md \
  state-machine.md \
  swimlane-journey.md \
  agent-communication.md \
  trust-boundary-dataflow.md; do
  require_file "skills/review/visual-modeling/references/templates/${template}"
done

require_match '\| `visual-modeling` \| `review` \| `\.\./review/visual-modeling/` \| `native` \| optional \| `local-authoritative` \|' "${MANIFEST}"
require_match '\| `visual-modeling` \|' "${REVIEW_README}"
require_match 'visual-modeling' "${ASCII_SKILL}"
require_match 'Visual Modeling Packet' "${SKILL}"
require_match 'Visual Modeling Packet' "${GATE}"

for term in \
  'ERD' \
  'ORM lifecycle' \
  'sequence diagram' \
  'state machine' \
  'swimlane' \
  'agent communication' \
  'trust boundary' \
  'source truth' \
  'residual ambiguity'; do
  require_match "${term}" "${SKILL}"
  require_match "${term}" "${GATE}"
done

for stack in \
  'Django \+ Inertia \+ React' \
  'Next\.js \+ AdonisJS \+ AdminJS' \
  'Next\.js \+ Prisma' \
  'Next\.js \+ Drizzle' \
  'Accelerate Control Plane'; do
  require_match "${stack}" "${SKILL_DIR}/references/stack-trigger-matrix.md"
done

echo "visual-modeling contract tests passed"
