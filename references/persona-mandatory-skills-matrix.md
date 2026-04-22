# Persona Mandatory Skills Matrix

## Local Authority Status

Primary local authority lives in:

- `../core/personas/mandatory-skills.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when the active persona must expose its non-optional skill set
instead of relying on informal judgment.

## Rule

If a persona is active and blocking, its mandatory skills should appear in the
runtime packet unless an explicit branch exception is recorded.

## Matrix

| Persona | Mandatory skills | Branch / trigger |
|---|---|---|
| `Specification PM` | `prompt-hardening`, `architecture`; active workflow adapter when issue structure matters | framing, ambiguity, scope definition |
| `Prompt Hardening Editor` | `prompt-hardening` | weak prompt shape |
| `Product Planner` | active workflow adapter; `linear-implementation-planner` when sequencing is non-trivial in the current default distribution | issue tree, rollout, slices |
| `Issue Architect / Workflow Adapter` | active workflow adapter | issue creation or issue repair |
| `Implementation Designer` | `planning-with-files`, `executing-plans` when execution packet is accepted | execution design |
| `Wireframe / Design Contract Extractor` | `ascii-wireframe` | structural UI uncertainty |
| `Implementer / Developer` | concrete active profile skills from `skills/_registry/manifest.md` | generic code mutation |
| `Backend Implementer` | `django-service-patterns`, `django-pro`, `security-patterns` | backend mutation |
| `Frontend Implementer` | `front-react-shadcn`, `frontend-boundary-governance`, `i18n-patterns` | frontend mutation |
| `Backend Tester` | `python-testing`, backend profile bundle, data/query skills as needed | backend QA |
| `Frontend Tester` | frontend profile bundle, `i18n-patterns` | frontend QA |
| `Browser-Proof Auditor` | `product-runtime-review`; active stack skills as needed | browser truth |
| `E2E Regression Engineer` | `dogfood`, `product-runtime-review`, active profile skills, and local Playwright fixture when available | Playwright persistence |
| `Runtime/Product Reviewer` | `product-runtime-review` | runtime-sensitive user surface |
| `Governance Auditor` | `governance-audit`, `architecture`, and branch-specific governance skills | governance doubt |
| `Stack Constitution Auditor` | `governance-audit`, `architecture`, `api-surface-governance`, `dependency-governance` | constitution drift |
| `Security Reviewer` | `security-patterns`; branch-specific security skills when needed | security-sensitive branch |
| `Anti-Abuse Reviewer` | `anti-abuse-review` | abuse-sensitive branch |
| `Legacy Truth Analyst` | `legacy-first-protocol`, `legacy-transplant` | legacy truth branch |
| `Closure / Forensic Reviewer` | `verification-before-completion` | pre-close forensic lane |

## Display Rule

The `active skills` line should reflect the active persona's mandatory set, not
only the operator's preferred minimum.
