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

## Validation Gate Matrix

Do not treat `manage.py check` as sufficient backend runtime proof.

Use the validation stack by slice class:

- backend schema/runtime slice
  - `uv run python backend/src/manage.py check`
  - `uv run python backend/src/manage.py makemigrations --check --dry-run`
  - `uv run python backend/src/manage.py migrate --check`
- frontend TypeScript/runtime slice
  - `npm run type-check --prefix frontends/front-react`
- full-stack slice
  - both gate sets apply

These commands prove different things:

- `check`
  - Django system/config/runtime checks
- `makemigrations --check --dry-run`
  - model drift without a generated migration
- `migrate --check`
  - unapplied migrations already present in the codebase

If a run closes with only `check` after backend schema/runtime work, treat that
as a validation failure.

If a frontend-bearing or TS contract-bearing run closes without `type-check`,
also treat that as a validation failure.

## Matrix

| Branch | Mandatory skills | Mandatory gates | Expected artifacts | Expected evidence | Typical closure blockers |
| --- | --- | --- | --- | --- | --- |
| trivial bounded | none beyond the directly relevant stack skill | honest classification; `Issue Bootstrap Gate` when the slice mutates code, workflow seeds, or living docs; validation gate matrix when backend/frontend runtime is in scope | bounded scope statement; governing issue when mutating | direct code/test/runtime proof; required validation commands for the slice class; commit traceability when mutating | hidden cross-surface drift; trivial run attempted without governing issue; validation stack under-run |
| ambiguous / long / epic-like | `prompt-hardening` | `Prompt Hardening Gate`; `Story Framing` when actor/goal/value are still implicit | `Hardened Prompt` or `Execution-Ready Prompt Packet` | visible hardened artifact in the run | ambiguity still unresolved |
| issue-driven delivery | active workflow adapter; `linear-implementation-planner` when sequencing is non-trivial; `executing-plans` for accepted execution | `Issue Bootstrap Gate`; `Post-Issue Planning Gate` for non-trivial work; `Minimal Create Recovery Protocol`; `Metadata Rehydration Check`; `Ready-for-Execution Revalidation`; `AI Review Report` before `Done` | dependency-aware issue body or execution plan; explicit post-issue planning artifact for non-trivial runs | issue bootstrap proof + issue metadata + planning artifact + commit trail + AI Review | issue created but not truly execution-ready; execution started without integrated planning artifact |
| bug / failure / regression | `systematic-debugging` + affected stack skills | `Failure Classification Gate` | repro, failure classification, narrowed hypothesis | repro evidence, validation, regression proof | fix with no repro or no regression confidence |
| adversarial security audit / hostile-path review | `adversarial-security-review`, `anti-abuse-review`, `security-patterns`; `product-runtime-review` when user-facing | `Failure Classification Gate`; `Artifact Sufficiency Check` when the branch depends on attack packets | attack-surface packet, attack-class matrix, variant notes, finding or no-finding report | code/runtime evidence, bounded exploitability judgment, variant-check evidence | speculative exploit theater, no trust boundary, or no actionable finding shape |
| architecture / governance doubt | `architecture`, `governance-audit`; `p4y-stack-constitution` when stack truth is involved | `Truth Ownership Check`; `Stack Adherence` | decision record, boundary matrix, or ADR-oriented conclusion | code/doc evidence and explicit judgment | conclusion still implicit or stack truth unresolved |
| admin / operator / unfold | `django-unfold`, `django-pro` | `Truth Ownership Check` when readonly/admin data ownership is blurry; backend validation gate matrix when Django runtime/schema is in scope | admin surface contract, readonly expectations | admin diff, runtime/admin inspection when needed, required backend validation commands | admin UI changed without ownership clarity |
| runtime / product-heavy flow | `product-runtime-review`; `anti-abuse-review` when sensitive; `security-patterns` when ownership, auth, secret, or race posture is part of the risk | `Product-Correctness`; `Artifact Sufficiency Check` when the branch depends on artifacts; `Containment Policy Check` when hostile behavior is part of the diagnosis | runtime narrative, possible wireframe for complex flow | browser truth before closure | technically correct but poor product behavior |
| untrusted ingress / upload / import / media ingestion | `untrusted-ingress-hardening`; `anti-abuse-review` when user-facing; `security-patterns` when ownership, serving posture, or remote-fetch risk exists; `product-runtime-review` when user-facing | `Untrusted Ingress Gate`; `Artifact Sufficiency Check` when parser/normalization/storage decisions are central | ingress packet covering allowed formats, limits, transformation posture, storage/serving posture | code proof + parser/validation evidence + browser/runtime proof when user-facing | frontend-only validation, weak MIME trust, unbounded imports, metadata/privacy leakage, or unsafe serving posture |
| copy / locale / translation-boundary | `i18n-patterns`; `server-prop-governance` when backend/frontend truth can drift | `i18n Closure Gate`; `Server Prop Copy Ban` | locale key map, contract notes when backend emits flags/codes | non-default locale proof when UX-relevant | mixed-language runtime or backend-owned copy drift |
| product-critical user surface | `product-runtime-review`, `ascii-wireframe`, `server-prop-governance`, `front-react-shadcn`, `tailwind-design-system`; `anti-abuse-review` and domain-truth skills when needed | `Backend Product Contract Protocol`; `Recovery Surface Isolation Rules`; `Wireframe Before UI`; `Artifact Sufficiency Check`; `Product-Critical Closure Protocol` | backend product packet, wireframe/reference ASCII, truth model, action model, query-shape proof when applicable | browser truth + contract evidence + artifact comparison | backend truth too thin, weak isolation, or visually amateur landing |
| visual / artifact-driven frontend | `front-react-shadcn`, `frontend-boundary-governance`, `tailwind-design-system`; `extract-html-design-system-v2` when a URL, local HTML, raw HTML reference, or existing web app should become a reusable local design-system evidence package; `i18n-patterns` when copy changes; `frontend-componentization-audit` when reuse or convergence is part of the work; `product-runtime-review` when runtime-sensitive; `ascii-wireframe` when structure matters; `figma-node-fidelity` or premium references when needed | `Visual Contract Extraction`; `Componentization Discipline`; `TS/TSX Boundary Audit`; `Design-System Fidelity`; `Component Source Ladder`; `Real Data Readiness Gate`; `Sidebar / Public Docs Update Gate` when capability changes navigation or discoverability; frontend validation gate matrix | wireframe, reference ASCII, `docs/reference/design-system.html` and `docs/reference/design-system.contract.md` when HTML reference extraction is active, boundary notes, componentization plan when structural, source-ladder proof when a new component or external pattern is introduced, real-data readiness notes when user-facing | visual/runtime proof + code structure proof + non-default locale proof when copy changes + frontend type-check | `.ts` / `.tsx` drift, raw-markup soup, source ladder skipped, mock-only closure, docs/sidebar drift, reference treated as moodboard, HTML reference used without a local design-system evidence package, contract missing or summary-shaped, source-evidenced components omitted without reason, or omitted frontend type-check |
| query / contract-sensitive backend | `django-service-patterns`, `django-inertia-integration`, `server-prop-governance`; `sql-optimization-patterns` when relational fetch risk exists; `security-patterns` when ownership, secret, or race posture is part of the risk; `financial-source-truth` when money is involved | `Truth Ownership Check`; `Query Shape Proof`; `Backend Product Contract Protocol` for sensitive self-service/recovery surfaces; `Secrets & Config Hygiene Check` when env/provider configuration is touched; `Concurrency Integrity Check` when critical mutable state is involved; backend validation gate matrix | contract packet, query-shape proof, ownership matrix | tests, code inspection, query evidence, `EXPLAIN` when needed, backend validation stack | hidden N+1, weak ownership, unsafe contract drift, unjustified concurrency posture, or omitted backend validation |
| transport / dependency / legacy-adaptation doubt | `api-surface-governance`, `dependency-governance`, `legacy-transplant`, `legacy-first-protocol` when business truth is ported | `Truth Ownership Check`; `Stack Adherence` | transport decision, dependency decision, legacy truth matrix | decision evidence against active stack | unsupported escape hatch or cargo-cult legacy reuse |
| browser-proof broad audit | `product-runtime-review`; `ascii-wireframe` when structure/state truth is part of the audit; active frontend/backend stack skills as needed | `Artifact Sufficiency Check`; `Browser Truth Gate`; `Audit Intensity Disclosure` | route map, browser-proof packet, residual list | Chrome DevTools evidence with explicit intensity (`sampled`, `targeted`, `broad sweep`, `full route-family audit`) | sampled proof presented as broad audit, route-family drift, or no residual list |
| persistent E2E / regression authoring | active stack skills + persistent test tooling; `product-runtime-review` when the scenario is user-facing | `Artifact Sufficiency Check`; `Persistent Regression Gate` | scenario map, persisted test packet, regression target list | Playwright proof and rerun evidence after browser truth is already understood | writing persistence before flow truth is stable, or no scenario packet |
| observability / performance / N+1 audit | active backend/frontend stack skills + `sql-optimization-patterns` when relational risk exists | `Query Shape Proof`; `Artifact Sufficiency Check` | perf packet, query-shape packet, observability gap list | metrics, logs, query evidence, `EXPLAIN` when execution-plan claims matter | generic performance claim with no proof |

## Gate Ownership Model

Promote gates into one of these classes:

### Root-Explicit

These gates should stay visible from `accelerate` itself:

- `Prompt Hardening Gate`
- `Issue Bootstrap Gate`
- `Post-Issue Planning Gate`
- `Truth Ownership Check`
- `Failure Classification Gate`
- `Mandatory vs Optional Language Protocol`
- `Artifact Sufficiency Check`
- `Untrusted Ingress Gate`
- `Secrets & Config Hygiene Check`
- `Concurrency Integrity Check`
- `Containment Policy Check`
- `Component Source Ladder`
- `Real Data Readiness Gate`
- `Sidebar / Public Docs Update Gate`

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
