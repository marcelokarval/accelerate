# Executive Persona Matrix

This document is the native executive matrix for:

- persona
- mandatory skills
- typical trigger
- expected output packet

It is not optional garnish. When persona catalogs, mandatory skills, workflow
catalogs, or review architecture change, this matrix should be reviewed in the
same mutation package or the defer reason should be explicit.

## Matrix

| Persona | Mandatory skills | Typical trigger | Expected output |
|---|---|---|---|
| `Specification PM` | `prompt-hardening`, `architecture` | actor/goal ambiguity, weak request framing | `Specification Handoff Packet` |
| `Product Planner` | active workflow adapter or planning surface | scope split, rollout shape, slices | `Planning Handoff Packet` |
| `Implementation Designer` | `planning-with-files`, `executing-plans` when accepted | execution design | `Implementation Design Packet` |
| `Implementer / Developer` | active layer stack skills | bounded implementation | `Implementation Handoff Packet` |
| `Backend Implementer` | active backend stack skills | backend-heavy mutation | backend implementation packet |
| `Frontend Implementer` | active frontend stack skills | frontend-heavy mutation | frontend implementation packet |
| `Runtime/Product Reviewer` | runtime/product review skill | user-facing runtime-sensitive flow | `Runtime Review Packet` |
| `Governance Auditor` | governance / constitution / contract skills relevant to the branch | governance / truth doubt | `Governance Packet` |
| `Data / Contract Steward` | contract / schema / validation governance skills relevant to the branch | DTO, persistence, identifier, or contract truth doubt | contract packet |
| `Provider Boundary Auditor` | provider / boundary governance skills relevant to the branch | external integration or upstream/downstream seam doubt | provider/runtime packet |
| `Closure / Forensic Reviewer` | `verification-before-completion` | pre-close reconciliation | `Closure Packet` |
| `Master Integrator` | active stack as needed | multi-surface integration authority | `Master Revalidation Checklist` |

## Backend Modeling Review Profile

For backend modeling review, the default posture is:

- blocking personas:
  - `Data / Contract Steward`
  - `Closure / Forensic Reviewer`
- conditional personas:
  - `Provider Boundary Auditor`
  - `Governance Auditor`

Expected output should include:

- findings ordered by severity
- explicit evidence surfaces inspected
- a relation map or UML when multiple persisted models interact
- a compact table of key fields and relations
- a side-by-side reconciliation of doctrine vs persistence vs runtime use
