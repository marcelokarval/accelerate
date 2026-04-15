# Executive Persona Matrix

Use this module when the operator needs a single table showing:

- persona
- mandatory skills
- non-mandatory/contextual skills
- typical triggers
- expected output packet

## Organic Role In The Accelerate Stack

This file is not optional garnish.

It is the executive matrix that ties together:

- `persona-model.md`
- `persona-mandatory-skills-matrix.md`
- `workflow-catalog.md`
- `qa-proof-stack.md`
- `current-enforcement-surfaces.md`

When any of those evolve, this matrix must be reviewed for drift.

## Matrix

| Persona | Mandatory skills | Non-mandatory / contextual skills | Typical trigger | Expected output |
|---|---|---|---|---|
| `Specification PM` | `prompt-hardening`, `architecture`; active workflow adapter when issue structure matters | domain/context skills as needed | actor/goal ambiguity, weak request framing | `Specification Handoff Packet` |
| `Prompt Hardening Editor` | `prompt-hardening` | `architecture` when shaping affects design/structure | weak prompt shape | `Prompt Hardening Packet` |
| `Product Planner` | active workflow adapter; `linear-implementation-planner` when sequencing is non-trivial in the current default distribution | `planning-with-files`, `executing-plans` when a bounded plan already exists | scope split, rollout shape, slices | `Planning Handoff Packet` |
| `Issue Architect / Workflow Adapter` | active workflow adapter | `linear-progress-reporter` in the current default distribution | issue creation, metadata repair, hierarchy | issue packet / metadata proof |
| `Implementation Designer` | `planning-with-files`, `executing-plans` when accepted | `ascii-wireframe`, contract/governance sidecars | execution design | `Implementation Design Packet` |
| `Wireframe / Design Contract Extractor` | `ascii-wireframe` | `figma-node-fidelity`, `front-react-shadcn`, `product-runtime-review` | structural UI uncertainty | design / wireframe packet |
| `Implementer / Developer` | active layer stack skills | verification/review companions as needed | bounded implementation | `Implementation Handoff Packet` |
| `Backend Implementer` | `django-service-patterns`, `django-pro`, `security-patterns` | `sql-optimization-patterns`, `financial-source-truth`, `validation-governance` | backend-heavy mutation | backend implementation packet |
| `Frontend Implementer` | `front-react-shadcn`, `frontend-boundary-governance`, `i18n-patterns` | `ascii-wireframe`, `frontend-componentization-audit`, `react-best-practices`, `server-prop-governance` | frontend-heavy mutation | frontend implementation packet |
| `Delivery PM` | none fixed globally | `linear-progress-reporter`, `executing-plans` | cadence/checkpoints | `Delivery Packet` |
| `Backend Tester` | `python-testing`, active backend stack skills | `django-service-patterns`, `security-patterns`, `sql-optimization-patterns`, `financial-source-truth` | backend QA lane | `QA / Proof Packet` |
| `Frontend Tester` | active frontend stack skills, `i18n-patterns` | `frontend-componentization-audit`, `react-best-practices` | frontend QA lane | `QA / Proof Packet` |
| `Browser-Proof Auditor` | `product-runtime-review`; active stack skills as needed | `ascii-wireframe`, `server-prop-governance` | browser truth / route-family audit | `Browser-Proof Packet` / `QA / Proof Packet` |
| `E2E Regression Engineer` | persistent E2E tooling + active stack skills as needed | `product-runtime-review` | Playwright persistence | `Persistent Regression Packet` |
| `Runtime/Product Reviewer` | `product-runtime-review` | `ascii-wireframe`, `server-prop-governance`, `anti-abuse-review` | user-facing runtime-sensitive flow | `Runtime Review Packet` |
| `Governance Auditor` | `governance-audit`, `p4y-stack-constitution` | `validation-governance`, `api-surface-governance`, `dependency-governance`, `legacy-transplant` | governance / truth doubt | `Governance Packet` |
| `Stack Constitution Auditor` | `p4y-stack-constitution`, `governance-audit` | `system-adr`, `validation-governance`, `api-surface-governance` | constitution drift | stack boundary packet |
| `Security Reviewer` | `security-patterns` | `anti-abuse-review`, `adversarial-security-review`, `untrusted-ingress-hardening` | security-sensitive branch | security packet |
| `Anti-Abuse Reviewer` | `anti-abuse-review` | `security-patterns`, `product-runtime-review` | abuse-sensitive branch | anti-abuse packet |
| `Accessibility Reviewer` | none fixed globally | active frontend stack + accessibility review skills when available | keyboard/focus/semantic review | accessibility packet |
| `Performance / Observability Reviewer` | none fixed globally | `sql-optimization-patterns`, observability/perf sidecars, active stack skills | N+1 / perf / telemetry drift | perf / observability packet |
| `Data / Contract Steward` | `server-prop-governance`, `validation-governance` | `api-surface-governance`, `financial-source-truth`, contract stack skills | DTO/presenter/props/route/identifier truth | contract packet |
| `Provider Boundary Auditor` | `api-surface-governance` | provider/runtime skills, `dependency-governance`, `security-patterns` | external integration / transport doubt | provider/runtime packet |
| `Legacy Truth Analyst` | `legacy-first-protocol`, `legacy-transplant` | `p4y-stack-constitution`, active stack skills | legacy truth branch | adaptation packet |
| `Recovery Surface Reviewer` | none fixed globally | `product-runtime-review`, `anti-abuse-review`, `security-patterns` | recovery/re-entry/isolated-state review | recovery packet |
| `Migration Steward` | none fixed globally | backend stack + migration/runtime validation stack | schema/data migration branch | migration packet |
| `Fixture / Test Data Steward` | none fixed globally | backend/frontend test skills, regression tools | fixture realism or test-data drift | fixture packet |
| `Experiment / Rollout Planner` | none fixed globally | rollout/contract/runtime review skills | feature-flag / rollout branch | rollout packet |
| `Compliance / Policy Reviewer` | none fixed globally | governance + policy/compliance skills | regulatory/policy-sensitive branch | policy packet |
| `Docs / Change Communicator` | none fixed globally | `planning-with-files`, relevant documentation/update-docs skills | living-doc or change communication need | docs / change packet |
| `Release / Handoff Manager` | none fixed globally | closure/release/handoff review stack | release readiness | release / handoff packet |
| `Incident / Hotfix Commander` | `systematic-debugging` | active stack skills, closure review | incident / hotfix | incident packet |
| `Closure / Forensic Reviewer` | `verification-before-completion` | `product-runtime-review`, `governance-audit`, stack review skills | pre-close reconciliation | `Closure Packet` |
| `Master Integrator` | none fixed universally; inherits active stack | any needed branch stack | multi-surface integration authority | `Master Revalidation Checklist` |

## Maintenance Diligence

Whenever any of these change, review this file in the same mutation package:

- persona catalog
- persona-to-skill mapping
- workflow catalog
- QA/proof stack
- enforcement surfaces

Do not let this executive matrix become stale summary prose.
