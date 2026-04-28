# Gate Ownership Index

## Purpose

This index maps branch-matrix gate names to their owning doctrine surface.

The branch matrix may route work, but it must not become the only place where a
blocking gate exists. If a gate is named as mandatory, it must either:

- point to a local owner file
- or be explicitly classified as lightweight inline governance

This prevents invisible gate drift and stale mandatory language.

## Root-Explicit Gates

| Gate | Owner | Notes |
| --- | --- | --- |
| `Prompt Hardening Gate` | `../hardening/prompt-hardening.md` | Required before broad or ambiguous execution. |
| `Response Locale Gate` | `response-locale-gate.md` | Required before user-facing responses so the answer follows the user's conversational language. |
| `Story Framing` | `../hardening/prompt-hardening.md` | Required when actor, goal, value, or acceptance are still implicit. |
| `PRD-lite Gate` | `../../planning/product/README.md` | Required when scope is capability-level or epic-like. |
| `SDD Gate` | `../../planning/architecture/sdd-template.md` | Required when technical ownership, architecture, data, transport, migration, or proof strategy is unresolved. |
| `Task Breakdown Gate` | `../../planning/execution/README.md` | Required before broad work enters bounded execution. |
| `Local Workspace Entry Gate` | `local-workspace-entry-gate.md` | Required before governed target-repo mutation. |
| `Issue Bootstrap Gate` | `../issue-topology/issue-driven-mutation-stack.md` | Required for mutation-bearing work unless explicitly excepted. |
| `Post-Issue Planning Gate` | `../issue-topology/issue-driven-mutation-stack.md` | Required for non-trivial issue-driven work after bootstrap. |
| `Review Readiness Gate` | `review-readiness-gate.md` | Required before review/closure claims on active local workspace runs. |
| `Timeline Continuity Gate` | `timeline-continuity-gate.md` | Required when checkpoint continuity is part of closure. |
| `Durable Learning Registration Gate` | `durable-learning-registration-gate.md` | Required for repeated/high-impact workflow truth. |
| `Truth Ownership Check` | `truth-ownership-check.md` | Required when authority, ownership, or stack truth is unclear. |
| `Failure Classification Gate` | `failure-classification-gate.md` | Required before fixing, auditing, or promoting failure-driven work. |
| `Artifact Sufficiency Check` | `artifact-sufficiency-check.md` | Required when branch decisions depend on docs, packets, captures, specs, or evidence artifacts. |
| `One-Shot Side-By-Side Gate` | `../review/one-shot-side-by-side-protocol.md` | Required when a run explicitly asks for one-shot execution, side-by-side task review, auto-correction, delegated correction handoff, and final forensic reconciliation. |
| `Untrusted Ingress Gate` | `../risk/enforcement-surfaces.md` | Required for uploads, imports, fetched content, and parser/storage risk. |
| `Secrets & Config Hygiene Check` | `../risk/enforcement-surfaces.md` | Required when environment, provider, credential, or config surfaces are touched. |
| `Concurrency Integrity Check` | `../risk/enforcement-surfaces.md` | Required when critical mutable state can race. |
| `Containment Policy Check` | `../risk/enforcement-surfaces.md` | Required when hostile behavior, abuse containment, or quarantine posture is part of diagnosis. |
| `Component Source Ladder` | `ui-mutation-ladder.md` | Required for visual/component source decisions. |
| `Design-System Rollout Entry Gate` | `design-system-rollout-entry-gate.md` | Required before executing design-system rollout plans. |
| `Design Implementation Proof Gate` | `design-implementation-proof-gate.md` | Required when UI implementation is mutated. |
| `Theme / Template Portability Gate` | `theme-template-portability-gate.md` | Required when visual work claims theme/template portability through global CSS, Tailwind, or equivalent config. |
| `Componentization Enforcement Gate` | `componentization-enforcement-gate.md` | Required when UI/template/theme portability work could drift into page-local markup, div soup, or direct class sprawl. |
| `Deep Componentization Audit Gate` | `deep-componentization-audit-gate.md` | Required when componentization quality must be proven page-by-page and across `.tsx`/`.ts` boundaries. |
| `UI Mutation Ladder` | `ui-mutation-ladder.md` | Required for design-system-driven UI mutation order. |
| `Real Data Readiness Gate` | `artifact-sufficiency-check.md` | Required when realistic runtime data is necessary for trustworthy UI/product proof. |
| `Sidebar / Public Docs Update Gate` | `artifact-sufficiency-check.md` | Required when capability changes affect discoverability or docs navigation. |
| `Active Correction / Defect Disposition` | `../review/active-correction-loop.md` | Required when concrete in-scope defects are found. |
| `Seam Proof Requirement` | `../review/seam-proof.md` | Required when layout/state/shell seams are plausible. |

## Adjacent-Skill-Owned Gates

| Gate | Owner | Notes |
| --- | --- | --- |
| `Backend Product Contract Protocol` | `../review/product-critical-surfaces.md` | Governs sensitive backend-driven product contracts. |
| `Recovery Surface Isolation Rules` | `../review/product-critical-surfaces.md` | Governs high-risk recovery/self-service surfaces. |
| `Wireframe Before UI` | `../review/ux-ui-fullstack-surface.md` | Required when structure/state needs explicit visual reasoning. |
| `Visual Contract Extraction` | `../review/html-design-system-extraction.md` | Governs HTML/reference-to-design-system extraction. |
| `Query Shape Proof` | `../runtime-packets/qa-proof-stack.md` | Governs query/runtime proof expectations. |
| `Server Prop Copy Ban` | `../review/i18n-closure-gate.md` | Prevents backend-owned localized copy drift. |
| `i18n Closure Gate` | `../review/i18n-closure-gate.md` | Governs locale parity and runtime locale proof. |
| `Componentization Discipline` | `../review/design-system-contract-application.md` | Governs reuse/extraction pressure during visual work. |
| `TS/TSX Boundary Audit` | `../review/design-system-contract-application.md` | Governs visual vs non-visual frontend boundary drift. |
| `Design-System Fidelity` | `../review/design-system-contract-application.md` | Governs implementation against local design-system artifacts. |
| `Design-System Application Gate` | `../review/design-system-contract-application.md` | Required when existing design-system artifacts drive work. |
| `Premium Direction Gate` | `../review/premium-interface-production.md` | Required for premium/de-AI design direction. |
| `Product-Critical Closure Protocol` | `../runtime-packets/product-critical-closure-packet.md` | Governs closure on product-critical surfaces. |
| `UX/UI Fullstack Surface Gate` | `../review/ux-ui-fullstack-surface.md` | Governs backend truth + frontend state + UX/UI runtime behavior. |
| `Accessibility Closure Gate` | `../review/accessibility-closure-gate.md` | Governs accessibility proof for user-facing UI changes. |
| `Source Observer Gate` | `../review/source-observer.md` | Governs source/web content observation packets. |
| `External Skill Vetting Gate` | `../risk/external-skill-vetting-gate.md` | Required before adapting external skills/tooling. |
| `Browser Truth Gate` | `../runtime-packets/browser-proof-packet.md` | Required when browser runtime is a closure condition. |
| `Audit Intensity Disclosure` | `../runtime-packets/browser-proof-packet.md` | Required when browser audit breadth could be overstated. |
| `Persistent Regression Gate` | `../runtime-packets/qa-proof-stack.md` | Required for persisted E2E/regression authoring. |
| `Product-Correctness` | `../review/product-critical-surfaces.md` | Governs product behavior beyond technical correctness. |
| `Observability / Performance Packet` | `../runtime-packets/observability-performance-packet.md` | Governs metrics, logs, query-shape, cache, and performance proof. |
| `Django Backend Safety Gate` | `django-backend-safety-gate.md` | Governs Django ownership, query-shape, validation, and service-boundary proof. |
| `Django ORM Query Shape Gate` | `django-orm-query-shape-gate.md` | Blocks N+1 and unbounded ORM promotion. |
| `Ownership / IDOR Gate` | `ownership-idor-gate.md` | Requires scoped object access and negative cross-owner tests. |
| `Backend Subagent Readiness Contract` | `backend-subagent-readiness-contract.md` | Blocks backend subagent promotion until backend rails are enforceable. |
| `Django Service Layer Contract` | `../review/django-service-layer-contract.md` | Requires Django business logic and mutations to stay behind service/query boundaries. |

## Lightweight Inline Gates

These gates may remain defined inline because their behavior is narrow and local
to issue/workflow hygiene.

| Gate | Inline owner |
| --- | --- |
| `Minimal Create Recovery Protocol` | `branch-enforcement-matrix.md` |
| `Metadata Rehydration Check` | `branch-enforcement-matrix.md` |
| `Ready-for-Execution Revalidation` | `branch-enforcement-matrix.md` |
| `Repo Hygiene / Platform Hygiene` | `branch-enforcement-matrix.md` |
| `Living Docs Obligation` | `branch-enforcement-matrix.md` |
| `Stack Adherence` | `branch-enforcement-matrix.md` |

## Change Rule

When adding a mandatory gate to `branch-enforcement-matrix.md`, update this file
in the same change unless the gate is removed before closure.
