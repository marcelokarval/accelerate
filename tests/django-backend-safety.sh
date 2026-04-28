#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'django-backend-safety failed: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [ -f "${ROOT}/$1" ] || fail "missing file: $1"
}

require_contains() {
  local file="${ROOT}/$1"
  local text="$2"
  grep -Fq "${text}" "${file}" || fail "$1 missing required text: ${text}"
}

require_file core/control-plane/django-backend-safety-gate.md
require_file core/control-plane/django-orm-query-shape-gate.md
require_file core/control-plane/ownership-idor-gate.md
require_file core/review/django-service-layer-contract.md
require_file core/control-plane/backend-subagent-readiness-contract.md

require_contains core/control-plane/django-backend-safety-gate.md "Ownership / IDOR proof"
require_contains core/control-plane/django-backend-safety-gate.md "Model.objects.get(id=...)"
require_contains core/control-plane/django-backend-safety-gate.md "Querying related objects inside loops"
require_contains core/control-plane/django-orm-query-shape-gate.md "select_related"
require_contains core/control-plane/django-orm-query-shape-gate.md "prefetch_related"
require_contains core/control-plane/django-orm-query-shape-gate.md "assertNumQueries"
require_contains core/control-plane/ownership-idor-gate.md "User A cannot read User B's object"
require_contains core/control-plane/ownership-idor-gate.md "Public IDs"
require_contains core/review/django-service-layer-contract.md "Services own business mutations"
require_contains core/review/django-service-layer-contract.md "Tasks are thin orchestration wrappers"
require_contains core/review/django-service-layer-contract.md "service-layer proof is mandatory"
require_contains core/control-plane/backend-subagent-readiness-contract.md "Backend subagents are not ready"
require_contains core/control-plane/backend-subagent-readiness-contract.md "forbidden patterns"

require_contains core/control-plane/gate-ownership-index.md "Django Backend Safety Gate"
require_contains core/control-plane/gate-ownership-index.md "Django ORM Query Shape Gate"
require_contains core/control-plane/gate-ownership-index.md "Ownership / IDOR Gate"
require_contains core/control-plane/gate-ownership-index.md "Backend Subagent Readiness Contract"
require_contains core/control-plane/gate-ownership-index.md "Django Service Layer Contract"
require_contains core/control-plane/branch-enforcement-matrix.md "Django Backend Safety Gate"
require_contains core/control-plane/branch-enforcement-matrix.md "Django ORM Query Shape Gate"
require_contains core/control-plane/branch-enforcement-matrix.md "Ownership / IDOR Gate"
require_contains core/control-plane/branch-enforcement-matrix.md "Backend Subagent Readiness Contract"
require_contains core/control-plane/branch-enforcement-matrix.md "Django Service Layer Contract"
require_contains core/control-plane/branch-enforcement-matrix.md "N+1 admin changelist"

echo "django backend safety tests passed"
