# Persona Mandatory Skills

This document is the native core home of persona-level mandatory-skill
exposure.

If a blocking persona is active, its mandatory skills should appear in the
runtime packet unless an explicit branch exception is recorded.

## Matrix

| Persona | Mandatory skills | Typical trigger |
|---|---|---|
| `Specification PM` | `prompt-hardening`, `architecture` | framing, ambiguity, scope definition |
| `Prompt Hardening Editor` | `prompt-hardening` | weak prompt shape |
| `Product Planner` | active workflow adapter or planning surface | issue tree, rollout, slices |
| `Implementation Designer` | `planning-with-files`, `executing-plans` when accepted | execution design |
| `Implementer / Developer` | concrete active profile skills from `skills/_registry/manifest.md` | generic code mutation |
| `Backend Implementer` | backend profile bundle: `django-pro`, `django-service-patterns`, `django-inertia-integration`, `python-pro`, plus data/test skills as needed | backend mutation |
| `Frontend Implementer` | frontend profile bundle: `front-react-shadcn`, `react-best-practices`, `typescript-pro`, `frontend-boundary-governance`, `tailwind-patterns`, plus profile-specific skills | frontend mutation |
| `Browser-Proof Auditor` | `product-runtime-review`, `dogfood`, plus active profile skills as needed | browser truth |
| `Runtime/Product Reviewer` | `product-runtime-review` | runtime-sensitive user surface |
| `Governance Auditor` | governance / constitution / contract skills relevant to the branch | governance doubt |
| `Data / Contract Steward` | contract / schema / validation governance skills relevant to the branch | DTO, persistence, identifier, vocabulary, or contract truth doubt |
| `Provider Boundary Auditor` | provider / boundary governance skills relevant to the branch | external integration, ownership seam, or upstream/downstream ambiguity |
| `Closure / Forensic Reviewer` | `verification-before-completion` | pre-close forensic lane |

## Backend Modeling Review Envelope

For backend modeling review, the minimum mandatory set should normally be:

- `architecture`
- concrete backend profile skills from `skills/backend/`, `skills/data/`, and the active profile
- contract/schema governance skills relevant to the branch
- `verification-before-completion` when closure language is being used

When provider or ownership seams are part of the review, add a boundary-governor
skill explicitly rather than treating seam inspection as optional.

## Display Rule

The `active skills` line should reflect the blocking persona's mandatory set,
not only the operator's preferred minimum.
