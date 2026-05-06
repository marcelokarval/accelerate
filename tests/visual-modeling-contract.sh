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
GATE_INDEX="${ROOT}/core/control-plane/gate-ownership-index.md"
BRANCH_MATRIX="${ROOT}/core/control-plane/branch-enforcement-matrix.md"
PACKET="${ROOT}/core/runtime-packets/visual-modeling-packet.md"
CORE_MANDATORY="${ROOT}/core/personas/mandatory-skills.md"
CORE_EXECUTIVE="${ROOT}/core/personas/executive-matrix.md"
REF_MANDATORY="${ROOT}/references/persona-mandatory-skills-matrix.md"
REF_EXECUTIVE="${ROOT}/references/executive-persona-matrix.md"
CORE_REVIEW="${ROOT}/core/review/architecture.md"
REF_REVIEW="${ROOT}/references/review-architecture.md"
EXAMPLES_DIR="${ROOT}/examples/visual-modeling"

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
require_file "core/control-plane/gate-ownership-index.md"
require_file "core/runtime-packets/visual-modeling-packet.md"
require_file "examples/visual-modeling/README.md"

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
  orm-lifecycle.md \
  class-module.md \
  sequence.md \
  state-machine.md \
  swimlane-journey.md \
  agent-communication.md \
  c4-topology.md \
  deployment-topology.md \
  queue-topology.md \
  trust-boundary-dataflow.md \
  governance-topology.md; do
  require_file "skills/review/visual-modeling/references/templates/${template}"
  require_match "references/templates/${template}" "${META}"
done

for example in \
  erd-lead-domain.md \
  orm-lifecycle-django-service-inertia.md \
  class-module-service-boundary.md \
  sequence-stripe-webhook.md \
  state-machine-lead-lifecycle.md \
  swimlane-lead-journey.md \
  agent-communication-proof-lane.md \
  c4-next-adonis-container.md \
  deployment-next-adonis-postgres.md \
  queue-retry-dlq.md \
  trust-boundary-upload.md \
  governance-issue-topology.md; do
  require_file "examples/visual-modeling/${example}"
  require_match 'source truth:' "${EXAMPLES_DIR}/${example}"
  require_match '```text' "${EXAMPLES_DIR}/${example}"
done

require_match '\| `visual-modeling` \| `review` \| `\.\./review/visual-modeling/` \| `native` \| optional \| `local-authoritative` \|' "${MANIFEST}"
require_match '\| `visual-modeling` \|' "${REVIEW_README}"
require_match 'visual-modeling' "${ASCII_SKILL}"
require_match 'Visual Modeling Packet' "${SKILL}"
require_match 'Visual Modeling Packet' "${GATE}"
require_match 'Visual Modeling Packet' "${PACKET}"
require_match 'Visual Modeling Gate' "${GATE_INDEX}"
require_match 'visual-modeling' "${BRANCH_MATRIX}"
require_match 'Visual Modeling Gate' "${BRANCH_MATRIX}"
require_match '`Visual Modeler`' "${CORE_MANDATORY}"
require_match '`Visual Modeler`' "${CORE_EXECUTIVE}"
require_match '`Visual Modeler`' "${REF_MANDATORY}"
require_match '`Visual Modeler`' "${REF_EXECUTIVE}"
require_match 'Visual Modeling Reconciliation' "${CORE_REVIEW}"
require_match 'Visual Modeling Reconciliation' "${REF_REVIEW}"

for term in \
  'ERD' \
  'ORM lifecycle' \
  'class/module' \
  'sequence diagram' \
  'state machine' \
  'swimlane' \
  'agent communication' \
  'deployment/runtime topology' \
  'queue topology' \
  'trust boundary' \
  'governance topology' \
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
