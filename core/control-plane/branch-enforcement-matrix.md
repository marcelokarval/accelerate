# Branch Enforcement Matrix

## Purpose

This document is the native control-plane matrix for deciding:

- which branch is active
- which skills are mandatory
- which gates are blocking
- which artifacts must exist
- which proof is required before closure

It exists to stop branch behavior from depending on operator memory.

## Reading Rule

Each row defines:

- mandatory skills
- mandatory gates
- expected artifacts
- expected evidence
- typical closure blockers

For any engineering run expected to mutate code, workflow seeds, or living
docs, `Issue Bootstrap Gate` is inherited even when the row is not primarily an
issue-management branch.

That gate is satisfied only when:

- the run is attached to an existing execution-ready issue
- or the run created and revalidated a new governing issue or parent/child
  package before implementation
- or the user explicitly approved a narrow no-issue exception

Creating the issue after implementation already began is workflow failure, not
acceptable cleanup.

For non-trivial issue-driven work, `Post-Issue Planning Gate` is inherited in
addition to `Issue Bootstrap Gate`.

That gate is satisfied only when:

- the governing issue already exists and is execution-ready
- an integrated planning artifact exists after issue bootstrap and before code
  mutation
- the artifact shapes bounded execution order, dependencies, gates, and
  evidence

Starting implementation after issue bootstrap but before this planning artifact
exists is execution drift, not acceptable speed.

When a governed target repository is in scope, `Local Workspace Entry Gate` is
inherited before deeper branch-specific gating for:

- all orchestrated non-trivial runs
- any trivial run that still mutates code, docs, workflow seeds, or runtime
  governance in the target repo

That gate is satisfied only when:

- the root explicitly decided that no local workspace is required yet
- or `.accelerate/` was created through the canonical local-workspace surface
- or existing `.accelerate/` truth was read and found coherent enough
- or reentry / reonboarding was explicitly reconciled before execution

Proceeding as if local workspace state did not matter is enforcement failure,
not a harmless omission.

## Validation Gate Matrix

Do not treat a single framework check as sufficient backend runtime proof.

Use the validation stack by slice class:

- backend schema/runtime slice
  - framework runtime/config checks
  - schema drift checks
  - pending migration checks
- frontend TypeScript/runtime slice
  - TypeScript or equivalent contract checks
  - build/runtime checks when configured
- full-stack slice
  - both gate sets apply

These classes prove different things:

- framework runtime/config checks
  - application wiring and runtime configuration sanity
- schema drift checks
  - model or schema changes that have not been captured in a migration artifact
- pending migration checks
  - migration artifacts that exist but are not applied in the target runtime
- contract checks
  - typed frontend/backend boundaries and runtime-facing API assumptions

Concrete commands belong to stack profiles or runtime adapters, not this core
matrix.

If a run closes with only one runtime/config check after backend schema/runtime
work, treat that as a validation failure.

If a frontend-bearing or typed-contract-bearing run closes without its profile's
contract check, also treat that as a validation failure.

## Matrix

| Branch | Mandatory skills | Mandatory gates | Expected artifacts | Expected evidence | Typical closure blockers |
| --- | --- | --- | --- | --- | --- |
| trivial bounded | none beyond the directly relevant stack skill | honest classification; `Local Workspace Entry Gate` when a governed target repo is mutated; `Issue Bootstrap Gate` when the slice mutates code, workflow seeds, or living docs; `Review Readiness Gate` and `Timeline Continuity Gate` when the slice stops being a one-shot bounded change; validation gate matrix when backend/frontend runtime is in scope; comparative review posture when the slice ceases to be obviously one-shot | bounded scope statement; governing issue when mutating; local workspace decision when target repo governance applies; readiness dashboard when local workspace status is active; `Requested-Vs-Implemented Packet` when the slice is review-bearing or multi-step; defect disposition when concrete defects were found | direct code/test/runtime proof; required validation commands for the slice class; commit traceability when mutating; corrected-state proof when an in-scope defect was fixed | hidden cross-surface drift; local workspace skipped in a governed target repo; trivial run attempted without governing issue; readiness/timeline ignored after the slice became multi-step; validation stack under-run; slice promoted on recap language with no comparative or defect posture |
| ambiguous / long / epic-like | `prompt-hardening`; product/specification planning artifacts from `planning/product/`, `planning/architecture/sdd-template.md`, and `planning/execution/` when scope requires them | `Local Workspace Entry Gate` when a governed target repo is in scope; `Prompt Hardening Gate`; `Story Framing` when actor/goal/value are still implicit; `PRD-lite Gate` when scope is capability-level or epic-like; `SDD Gate` when technical ownership, architecture, data, transport, migration, or proof strategy is unresolved; `Task Breakdown Gate` before bounded execution; `Timeline Continuity Gate`; `Review Readiness Gate` before closure claims | `Hardened Prompt` or `Execution-Ready Prompt Packet`; local workspace decision when target repo governance applies; user story when actor/value/acceptance are active; PRD-lite when scope is broader than one story; SDD when design decisions block safe execution; task breakdown when implementation can be sliced; readiness dashboard when local workspace status is active | visible hardened artifact in the run; local workspace truth when target repo governance applies; artifact sufficiency decision; source artifact chain in runtime packet; explicit readiness progression and current checkpoint | ambiguity still unresolved; local workspace truth ignored before branch routing; implementation starts without the smallest required product/spec artifact; PRD/SDD/task breakdown treated as optional narration when gates are active; continuity gap across checkpoints |
| issue-driven delivery | active workflow adapter; `linear-implementation-planner` when sequencing is non-trivial; `executing-plans` for accepted execution | `Local Workspace Entry Gate` when a governed target repo is in scope; `Issue Bootstrap Gate`; `Post-Issue Planning Gate` for non-trivial work; `Minimal Create Recovery Protocol`; `Metadata Rehydration Check`; `Ready-for-Execution Revalidation`; `Review Readiness Gate`; `Timeline Continuity Gate`; `Durable Learning Registration Gate` when repeated/high-impact workflow truth emerges; `One-Shot Side-By-Side Gate` when the request explicitly asks for one-shot execution, task-by-task side-by-side review, auto-correction, delegated correction handoff, and final forensic reconciliation; canonical `prepare-review.sh` / `prepare-closure.sh` path when local workspace status is active; `AI Review Report` before `Done`; active correction / defect disposition when concrete defects are found during execution or proof | dependency-aware issue body or execution plan; one-shot task ledger when the one-shot gate is active; local workspace decision when target repo governance applies; explicit post-issue planning artifact for non-trivial runs; readiness dashboard when local workspace status is active; canonical local review/closure prep choice when review or closure is active; `Requested-Vs-Implemented Packet` for bounded execution slices; defect ledger updates when defects were found | local workspace proof when target repo governance applies + issue bootstrap proof + issue metadata + planning artifact + one-shot side-by-side review packets when active + commit trail + AI Review + readiness/timeline state when local workspace status is active + review/closure preparation evidence when local workspace status is active + corrected-state proof when in-scope defects were fixed | local workspace skipped before issue/planning routing; issue created but not truly execution-ready; execution started without integrated planning artifact; one-shot review requested but no side-by-side ledger/reproof; readiness claimed without dashboard state; canonical local review/closure prep skipped in favor of ad hoc sequencing; durable learning left transient; defects described but not dispositioned before promotion |
| bug / failure / regression | `systematic-debugging` + affected stack skills | `Failure Classification Gate`; active correction / corrected-state proof before promotion when the defect is in-scope | repro, failure classification, narrowed hypothesis; `Requested-Vs-Implemented Packet` when a bounded fix slice lands; defect ledger update | repro evidence, validation, regression proof, corrected-state proof | fix with no repro or no regression confidence; defect claimed resolved without fresh proof |
| adversarial security audit / hostile-path review | `adversarial-security-review`, `anti-abuse-review`, `security-patterns`; `product-runtime-review` when user-facing | `Failure Classification Gate`; `Artifact Sufficiency Check` when the branch depends on attack packets | attack-surface packet, attack-class matrix, variant notes, finding or no-finding report | code/runtime evidence, bounded exploitability judgment, variant-check evidence | speculative exploit theater, no trust boundary, or no actionable finding shape |
| architecture / governance doubt | `architecture`, `governance-audit`; add `api-surface-governance`, `dependency-governance`, or `validation-governance` when that stack truth is involved | `Truth Ownership Check`; `Stack Adherence` | decision record, boundary matrix, or ADR-oriented conclusion | code/doc evidence and explicit judgment | conclusion still implicit or stack truth unresolved |
| admin / operator surface | active admin stack skill such as `adminjs-patterns` or `django-unfold`; active backend stack skill such as `adonisjs-patterns` or `django-pro`; `security-patterns`; `anti-abuse-review` when admin actions can be replayed, enumerated, over-broadened, or abused | `Truth Ownership Check` when readonly/admin data ownership is blurry; `Django Backend Safety Gate`, `Django ORM Query Shape Gate`, `Ownership / IDOR Gate`, and `Django Service Layer Contract` when Django admin/operator surfaces are in scope; `Artifact Sufficiency Check` when admin resource/action packets drive implementation; backend validation gate matrix when backend runtime/schema is in scope; `Accessibility Closure Gate` when operator UI changes | admin surface contract, readonly/mutation expectations, resource/action matrix, authorization and masking notes, service-layer notes for Django mutations | admin diff, runtime/admin inspection when needed, required backend validation commands, sensitive-field and destructive-action proof, query-shape proof for admin changelists/inlines | admin UI changed without ownership clarity, broad resource exposure, weak masking, N+1 admin changelist, action access controlled only by visibility, service-layer bypass, or missing runtime/admin proof |
| runtime / product-heavy flow | `product-runtime-review`; `anti-abuse-review` when sensitive; `security-patterns` when ownership, auth, secret, or race posture is part of the risk | `Product-Correctness`; `UX/UI Fullstack Surface Gate` when backend truth, frontend state, and UX/UI runtime behavior all affect closure; `Artifact Sufficiency Check` when the branch depends on artifacts; `Containment Policy Check` when hostile behavior is part of the diagnosis | runtime narrative, possible wireframe for complex flow, UX/UI Fullstack Surface Packet when fullstack state behavior is active | browser truth before closure; backend truth and frontend state evidence when UX/UI fullstack is active | technically correct but poor product behavior; backend truth disconnected from UI state |
| untrusted ingress / upload / import / media ingestion | `untrusted-ingress-hardening`; `anti-abuse-review` when user-facing; `security-patterns` when ownership, serving posture, or remote-fetch risk exists; `product-runtime-review` when user-facing | `Untrusted Ingress Gate`; `Artifact Sufficiency Check` when parser/normalization/storage decisions are central | ingress packet covering allowed formats, limits, transformation posture, storage/serving posture | code proof + parser/validation evidence + browser/runtime proof when user-facing | frontend-only validation, weak MIME trust, unbounded imports, metadata/privacy leakage, or unsafe serving posture |
| source observation / web content reading | `web-content-reader`, `untrusted-ingress-hardening`; `security-patterns` when user-provided URLs, redirects, credentials, or private-network risk are plausible; `extract-html-design-system-v2` when the source feeds a design-system package | `Source Observer Gate`; `Untrusted Ingress Gate`; `External Skill Vetting Gate` when adapting tooling; `Artifact Sufficiency Check` when source evidence drives a decision | Source Observer Packet, Web Content Observation Packet, allowlist/denylist decision, retention policy | bounded source capture evidence, final URL/timestamp, trust limits, downstream-use proof | arbitrary URL ingestion, missing SSRF posture, hidden crawler/scheduler behavior, raw HTML stored without retention, source freshness claimed without packet |
| copy / locale / translation-boundary | `i18n-patterns`; `server-prop-governance` when backend/frontend truth can drift | `i18n Closure Gate`; `Server Prop Copy Ban`; locale-pack parity adapter when locale packs exist | i18n Closure Packet, Locale Pack Parity Packet or project-native parity command, contract notes when backend emits flags/codes | discovered supported locales, parity proof, non-default locale proof when UX-relevant | mixed-language runtime, backend-owned copy drift, assumed locale set, fallback masking missing keys |
| product-critical user surface | `product-runtime-review`, `ascii-wireframe`, `server-prop-governance`, `front-react-shadcn`, `tailwind-design-system`; `anti-abuse-review` and concrete domain authority skills such as `financial-source-truth`, `payment-integration`, or `stripe-integration` when needed | `Backend Product Contract Protocol`; `UX/UI Fullstack Surface Gate` when backend-driven states or actions shape the UI; `Recovery Surface Isolation Rules`; `Wireframe Before UI`; `Artifact Sufficiency Check`; `Accessibility Closure Gate`; `Product-Critical Closure Protocol` | backend product packet, UX/UI Fullstack Surface Packet when state/runtime reconciliation is active, accessibility packet when UI changes, wireframe/reference ASCII, truth model, action model, query-shape proof when applicable | browser truth + contract evidence + artifact comparison + state coverage + accessibility proof | backend truth too thin, weak isolation, visually amateur landing, inaccessible primary flow, or happy-path-only proof |
| visual / artifact-driven frontend | `front-react-shadcn`, `frontend-boundary-governance`, `tailwind-design-system`; `extract-html-design-system-v2` when a URL, local HTML, raw HTML reference, or existing web app should become a reusable local design-system evidence package; `apply-design-system-contract` when an existing `docs/reference/design-system*` package must drive implementation, correction, improvement, proposal, recomposition, or theme generation; `i18n-patterns` when copy changes; `frontend-componentization-audit` when reuse or convergence is part of the work; `product-runtime-review` when runtime-sensitive; `ascii-wireframe` when structure matters; `figma-node-fidelity` or premium references when needed | `Visual Contract Extraction`; `Design-System Application Gate`; `Design-System Rollout Entry Gate` when rollout planning artifacts exist; `Design Implementation Proof Gate` when UI is mutated; `UI Mutation Ladder`; `Componentization Discipline`; `TS/TSX Boundary Audit`; `Design-System Fidelity`; `Premium Direction Gate` when extracted design needs humanization, de-AI cleanup, or premium polish; `Component Source Ladder`; `Real Data Readiness Gate`; `Sidebar / Public Docs Update Gate` when capability changes navigation or discoverability; frontend validation gate matrix; active correction / seam-proof expectations when layout, shell, premium, or state-sibling drift is plausible | wireframe, reference ASCII, `docs/reference/design-system.html` and `docs/reference/design-system.contract.md` when HTML reference extraction is active; `docs/reference/design-system.slop-audit.md`, `docs/reference/design-system.premium-direction.md`, and `docs/reference/design-system.premium-direction.html` when premium improvement is active; design-system application packet when implementation/correction/proposal uses existing artifacts; Design Implementation Proof Packet when UI is mutated; rollout entry declaration when an executive plan exists, naming required pre-read artifacts, contract authority, primary implementation driver, secondary macro direction when active, and execution slicing artifact; source-observed / code-available / premium-proposed / not-approved-yet component map; anatomy-vs-token split; UI owner ladder decision (`token`, `ui`, `ui-enhanced`, `registry`, `shell`, `page`); `Requested-Vs-Implemented Packet`; defect ledger update when concrete defects are found; seam proof when shell/layout/state joins are likely defect hotspots; component coverage matrix, broad component gallery, light/dark token-sibling proof, and theme-generator readiness when the stack exposes themes or a broad primitive catalog; boundary notes, componentization plan when structural, source-ladder proof when a new component or external pattern is introduced, real-data readiness notes when user-facing | visual/runtime proof + artifact comparison against `design-system.html` and premium HTML when active + code structure proof + non-default locale proof when copy changes + frontend type-check + viewport/state coverage when design proof is active + corrected-state captures rooted under `project-root/.tmp/` when temporary screenshots or seam captures are used | `.ts` / `.tsx` drift, raw-markup soup, source ladder skipped, mock-only closure, docs/sidebar drift, reference treated as moodboard, HTML reference used without a local design-system evidence package, contract missing or summary-shaped, source-evidenced components omitted without reason, existing design-system artifacts ignored during implementation/correction, missing component map, missing Design Implementation Proof Packet after UI mutation, missing rollout entry declaration, executive plan treated as self-sufficient entrypoint, missing UI owner ladder decision, anatomy and token changes mixed without explanation, premium direction skipped after AI/generic design smell, premium HTML not rendered, premium component gallery too thin, dark mode as unrelated skin, missing theme-generator contract, page-first premium drift, omitted frontend type-check, no `Requested-Vs-Implemented Packet`, defects described without disposition, fixed visual defects lacking corrected-state proof, seam drift left unproved, or temporary captures left outside `project-root/.tmp/` |
| query / contract-sensitive backend | active backend/data stack skill such as `adonisjs-patterns`, `django-service-patterns`, `prisma-patterns`, or `drizzle-patterns`; active integration skill such as `django-inertia-integration` when relevant; `server-prop-governance`; `sql-optimization-patterns` when relational fetch risk exists; `security-patterns` when ownership, secret, or race posture is part of the risk; `financial-source-truth` when money is involved | `Truth Ownership Check`; `Query Shape Proof`; `Django Backend Safety Gate` and `Django ORM Query Shape Gate` when Django ORM/runtime is in scope; `Ownership / IDOR Gate` when scoped objects are read or mutated; `Django Service Layer Contract` when Django business logic, mutations, tasks, or admin actions change; `Backend Subagent Readiness Contract` before creating or promoting Django/backend subagents; `Backend Product Contract Protocol` for sensitive self-service/recovery surfaces; `Secrets & Config Hygiene Check` when env/provider configuration is touched; `Concurrency Integrity Check` when critical mutable state is involved; backend validation gate matrix | contract packet, query-shape proof, ownership matrix, service-layer proof when Django is active, backend subagent readiness packet when subagents are in scope | tests, code inspection, query evidence, `EXPLAIN` when needed, backend validation stack, negative ownership tests for scoped Django surfaces | hidden N+1, weak ownership, unsafe contract drift, unjustified concurrency posture, omitted backend validation, Django service-layer bypass, or backend subagent promoted before rails are enforceable |
| transport / dependency / legacy-adaptation doubt | `api-surface-governance`, `dependency-governance`, `legacy-transplant`, `legacy-first-protocol` when business truth is ported | `Truth Ownership Check`; `Stack Adherence` | transport decision, dependency decision, legacy truth matrix | decision evidence against active stack | unsupported escape hatch or cargo-cult legacy reuse |
| browser-proof broad audit | `product-runtime-review`; `ascii-wireframe` when structure/state truth is part of the audit; active frontend/backend stack skills as needed | `Artifact Sufficiency Check`; `Browser Truth Gate`; `Audit Intensity Disclosure` | route map, browser-proof packet, residual list | Chrome DevTools evidence with explicit intensity (`sampled`, `targeted`, `broad sweep`, `full route-family audit`) | sampled proof presented as broad audit, route-family drift, or no residual list |
| persistent E2E / regression authoring | active stack skills + persistent test tooling; `product-runtime-review` when the scenario is user-facing | `Artifact Sufficiency Check`; `Persistent Regression Gate` | scenario map, persisted test packet, regression target list | Playwright proof and rerun evidence after browser truth is already understood | writing persistence before flow truth is stable, or no scenario packet |
| observability / performance / N+1 audit | active backend/frontend stack skills + `sql-optimization-patterns` when relational risk exists | `Query Shape Proof`; `Artifact Sufficiency Check`; `Observability / Performance Packet` | observability/performance packet, query-shape packet, observability gap list | metrics, logs, query evidence, execution-plan evidence when execution-plan claims matter | generic performance claim with no proof |

## Visual Artifact Theme Layer Rule

When the visual / artifact-driven frontend row is active, extracted design-system
packages must include an implementable theme layer:

Visual / artifact-driven frontend work that mutates user-facing UI also inherits
`Accessibility Closure Gate`; design fidelity does not substitute for keyboard,
focus, semantic, contrast, and state-feedback proof.

- `docs/reference/design-system.theme.css` for source-truth extraction
- `docs/reference/design-system.premium-theme.css` when premium direction exists

Both files must preserve stable `--ds-*` token names. Premium direction may
change values, not rename the token API. UI implementation should first apply or
map that generated CSS into the project token layer before resorting to
component anatomy changes.

When the work claims theme or template portability through `global.css`,
`globals.css`, Tailwind config, CSS-first `@theme`, or equivalent visual config,
it also inherits `Theme / Template Portability Gate` and `Componentization
Enforcement Gate`. Closure must include visual config discovery, theme
consumption audit, componentization audit, a Theme / Template Portability Packet,
and either a Theme Swap Proof Packet or Template Swap Proof Packet according to
the minimum honest owner layer. Page-local `div` soup, excessive `className`, and
direct visual classes require extraction to central owners or explicit bounded
exceptions.

When the user asks to prove extreme componentization, audit every page, compare
components against shared-owner rules, or analyze `.tsx` and `.ts` responsibility
separation, the work also inherits `Deep Componentization Audit Gate`. Closure
must include per-page reports, component inventory report, TypeScript
responsibility report, and a condensed executive summary with report-to-plan
recommendations.

Premium/de-AI design-system work must also use the repo-local
`premium-design-benchmark-corpus`, include a Benchmark Influence Map, and prove
one active theme at a time when light/dark or theme variants are in scope.
Split-screen light/dark product composition is a closure blocker.

## Gate Ownership Model

The canonical owner map for named gates is
`core/control-plane/gate-ownership-index.md`. Update that index whenever this
matrix adds or removes a mandatory gate.

Promote gates into one of these classes:

### Root-Explicit

These gates should stay visible from `accelerate` itself:

- `Prompt Hardening Gate`
- `Local Workspace Entry Gate`
- `Issue Bootstrap Gate`
- `Post-Issue Planning Gate`
- `Review Readiness Gate`
- `Timeline Continuity Gate`
- `Durable Learning Registration Gate`
- `Truth Ownership Check`
- `Failure Classification Gate`
- `Mandatory vs Optional Language Protocol`
- `Artifact Sufficiency Check`
- `One-Shot Side-By-Side Gate`
- `Untrusted Ingress Gate`
- `Secrets & Config Hygiene Check`
- `Concurrency Integrity Check`
- `Containment Policy Check`
- `Component Source Ladder`
- `Design-System Rollout Entry Gate`
- `Design Implementation Proof Gate`
- `Theme / Template Portability Gate`
- `Componentization Enforcement Gate`
- `Deep Componentization Audit Gate`
- `UI Mutation Ladder`
- `Real Data Readiness Gate`
- `Sidebar / Public Docs Update Gate`
- `Active Correction / Defect Disposition`
- `Seam Proof Requirement`

### Adjacent-Skill-Owned

These gates are branch-critical but are best owned by specialized docs or
skills:

- `Backend Product Contract Protocol`
- `Recovery Surface Isolation Rules`
- `Wireframe Before UI`
- `Visual Contract Extraction`
- `Query Shape Proof`
- `Server Prop Copy Ban`
- `i18n Closure Gate`
- `Componentization Discipline`
- `TS/TSX Boundary Audit`
- `Design-System Fidelity`
- `Product-Critical Closure Protocol`

### Lightweight Inline

These can stay inline in root/control-plane docs:

- `Minimal Create Recovery Protocol`
- `Metadata Rehydration Check`
- `Ready-for-Execution Revalidation`
- `Repo Hygiene / Platform Hygiene`
- `Living Docs Obligation`

## Enforcement Note

Additional adjacent-skill discipline:

- frontend structural work should not omit `frontend-boundary-governance`
  whenever `.ts` vs `.tsx`, view-model ownership, or backend/frontend truth
  boundaries are part of the risk
- backend relational or presenter-heavy work should not omit
  `sql-optimization-patterns` when query shape is plausibly part of correctness
- abuse-sensitive user flows should not omit `anti-abuse-review`
- user-facing runtime-sensitive flows should not omit `product-runtime-review`

When the branch cannot justify the omission of a mandatory skill, treat the run
as under-routed rather than merely imperfect.
