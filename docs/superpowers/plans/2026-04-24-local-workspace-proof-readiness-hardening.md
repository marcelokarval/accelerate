# Local Workspace Proof Readiness Hardening Plan

## Purpose

Prevent `.accelerate/` local workspace scripts from promoting review, closure,
or `Done` posture from summary state alone.

## Problem

The current V2 local workspace can render `present`, `ready`, or `Done` from
readiness fields without checking proof artifacts. That creates false closure
risk: the packet looks operationally complete even when backend QA, frontend QA,
browser proof, Design Implementation Proof, or AI review evidence is absent.

## Scope

Implement one bounded hardening slice:

- add a local evidence registry under `.accelerate/status/`
- require evidence registry state before review/closure reconciliation
- render closure and AI review recommendations from evidence, not only readiness
- keep blocked local branches non-trivial
- separate detected workflow backend from enforced workflow backend
- add packet docs for browser proof and product-critical closure

## Non-Goals

- Do not implement a real Linear or GitHub workflow backend.
- Do not add a full runtime command registry.
- Do not promote agents.
- Do not require every repo to have every QA lane; unsupported lanes may be
  `not-applicable`, but closure must say that explicitly.

## Execution Plan

1. Add failing regression tests for false readiness and false closure.
2. Add `.accelerate/status/evidence-registry.yaml` to the V2 template.
3. Add evidence gate checks for `review-ready` and `closure-ready`.
4. Update closure and AI review renderers to read the evidence registry.
5. Update branch entry classification so `blocked` cannot become trivial.
6. Split `workflow_backend_detected` from `workflow_backend` in local state.
7. Update validation and local workspace docs for the new registry.
8. Add Browser-Proof and Product-Critical Closure packet docs.
9. Run regression tests and whitespace validation.

## Closure Criteria

- `reconcile-readiness.sh review-ready` fails without implementation and QA
  evidence.
- `reconcile-readiness.sh closure-ready` fails without AI review evidence.
- `render-closure-packet.sh` reports missing lanes as missing, not present.
- blocked local workspace state remains non-trivial.
- workflow backend detection does not claim enforced backend truth.
