---
name: accelerate
description: Use as the always-on runtime root for engineering work to classify trivial vs non-trivial execution, then route into the correct bounded or orchestrated workflow.
metadata:
  category: orchestration
  origin: rewritten-from-claude
---
# Accelerate

Codex-native root orchestration skill for standalone engineering work.

Use `accelerate` as the always-on runtime root for engineering work.

It decides how the work should run before implementation starts, then either:

- keeps the run in the trivial bounded branch
- or stays as the master orchestrator for non-trivial work

`accelerate` is project-agnostic, stack-aware, and workflow-opinionated. It
does not promote incubator-specific business context into universal rules, but
it does carry the operating contracts of the active stack and distribution.

This file is intentionally short. Advanced behavior lives in `references/` so the
entry skill stays readable and does not inflate base context.

## Team OS Principle

`accelerate` is not only a branch classifier.

Treat it as the visible operating system for engineering teamwork:

- it decides which branch is active
- it decides which personas are active
- it decides which skills, gates, and references are in force
- it decides issue topology and lane opening order
- it decides staffing shape and delegation budget
- it decides which proof stack is required
- it decides whether bounded agents are useful at all for this run
- it decides which closure reviews must still happen before `Done`

The root should stay compact, but the team model behind it should be explicit.

The governed macro-control-plane for future agents now lives in:

- `references/codex-agents/README.md`

That module is reference authority for the explicit agent ecosystem, but the
root skill remains the constitutional entry point.

## Agent Optionality Rule

`accelerate` must remain fully functional even when no governed global agents
exist.

Treat agent usage as optional, governed control-plane behavior:

- `accelerate` may suggest promotion of a future agent into
  `~/.codex/agents/*.toml`
- `accelerate` may decide that no agent should be used
- `accelerate` must continue operating cleanly in environments with no agent
  catalog at all
- the user may disable agent usage for a run or for a bounded slice
- thread budget and catalog availability never force delegation

Gap detection or agent suggestion is not the same thing as agent promotion.

When no honest fit exists, when topology is still unstable, or when the user
explicitly disables agents, the root should remain in a valid root-only mode
rather than forcing weak delegation.

## Control-Plane Pools

The root now reasons through explicit control-plane pools before choosing any
bounded family:

- manager lane pool
- issue topology pool
- risk detection pool
- closure blocker pool
- evidence pool
- family pool
- future-gap pool

Use the pooling model in `references/codex-agents/agent-pooling-model.md` as
the authority for those layers.

## Terminology Aliases

Treat these as aliases over the existing model, not as competing workflows:

- `SDD` -> the existing specification-first overlay
- `RPI` -> research in `Frame`/`Load`, bounded execution shape in `Plan`,
  implementation in `Execute`
- `PO` -> existing `Specification PM` + `Product Planner` personas

## When to Use

Use this skill as the default entry classifier for engineering work when the
task:

- touches multiple layers or domains
- needs planning before implementation
- is issue-driven or depends on workflow hygiene
- may need quality lenses, review orchestration, or cross-stack checks
- is long, ambiguous, multi-phase, or likely to drift without shaping
- might require subagents, browser truth, or bounded execution sequencing

Do not use this skill for:

- casual conversation
- non-engineering requests
- one-off questions with no workflow implications

## Core Principle
`accelerate` has two jobs:

1. classify engineering work honestly before execution starts
2. remain the runtime root while routing into the proportional branch

In the full model it also has a third job:

3. make the active team operating system visible enough that PM, implementer,
   reviewer, and closure roles are auditable rather than implied

It is not an implementation skill. It controls:

- entry classification
- phase selection
- issue topology
- skill loading
- staffing and delegation budget
- execution discipline
- risk enforcement
- review discipline
- closure discipline

It also owns severity-aligned communication:

- necessary fixes must be framed as necessary
- optional language is reserved for real strategic forks or discretionary scope
- bug, drift, security, contract, or enforcement failures must be described
  with the next correct step and the ROI of fixing them now

## What It Is And Is Not

`accelerate` is:

- the root workflow orchestrator
- a project-agnostic, stack-aware operating model
- a specification-first decision layer
- a persona-driven operating model
- a team-operating-system model for future agent derivation
- a subagent-aware governance layer
- a root-owned issue-topology and staffing authority
- a root-owned risk-enforcement authority
- a quality and closure gatekeeper

`accelerate` is not:

- a replacement for stack-specific implementation skills
- a requirement that agents must exist before the control plane can operate
- a reason to skip `prompt-hardening` when the prompt is weak
- a substitute for runtime evidence
- a substitute for the active workflow adapter on issue-driven work
- a license for bounded agents to inherit orchestration authority
- a license to turn small tasks into ceremony

## Root vs Future Agent Rule

Future bounded agents may carry `accelerate` as local execution discipline.

That does not grant them root authority.

Inside a future bounded agent session, `accelerate` should mean:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It should not mean:

- executive routing
- issue topology control
- staffing authority
- lane-opening authority
- closure authority

## Classification Contract

Every engineering task must be classified explicitly in commentary before work
continues.

Before execution starts, `accelerate` should judge whether the prompt shape is
already safe enough to execute.

If the wording is still ambiguous, under-bounded, multi-objective, or likely to
drift during execution, the run should pass through `prompt-hardening` before
normal execution continues.

Use a short visible line such as:

- `Usando accelerate: classificado como trivial ...`
- `Usando accelerate + [skills] ...`

### Trivial

Work is only trivial when all of these are true:

- one-off answer or tiny bounded edit
- no cross-surface coordination
- no planning or decomposition needed
- no meaningful architectural, workflow, or product drift risk

In trivial mode:

- keep the skill stack minimal
- do the bounded task directly
- still verify honestly before closing

Small scope does not automatically waive prompt hardening.

If the request still allows material interpretation drift, route through
`prompt-hardening` first even when the branch remains trivial.

Use `references/trivial-branch-contract.md` as the authority for:

- trivial read-only vs trivial mutation
- minimum mandatory gates for trivial work
- the compact packet shape that still remains required

### Non-Trivial

Everything else stays inside `accelerate` as the root orchestrator.

Common non-trivial cases:

- backend + frontend slices
- issue-driven implementation
- capability or story work that still needs specification
- architecture-sensitive or stack-sensitive work
- user-facing runtime changes
- billing, auth, ownership, or abuse-sensitive work
- work likely to drift without bounded phases and reviews

For non-trivial issue-driven work, execution is blocked until a post-issue
planning artifact exists.

The allowed sequence is:

1. governing issue bootstrap
2. integrated planning artifact
3. execution

Going from issue bootstrap directly into implementation is workflow failure,
not operator style.

Non-trivial routing also requires the root to choose an honest issue topology:

- single issue
- sibling issues
- parent + child
- parent + child + review lane

Treat issue topology as a root control-plane decision, not as an execution-time
convenience.

## Branch Entry Packet

Engineering work must make the active branch visible before meaningful
implementation begins.

For branch-enforcement authority, treat
`references/branch-enforcement-matrix.md` as the primary source.

The root file is the entry control plane. The matrix is the primary authority
for:

- mandatory branch skills
- mandatory gates
- expected artifacts
- expected evidence
- closure blockers

The first technical update should leave a compact `Branch Entry Packet`
containing at least:

- `classification`
  - `trivial` or `non-trivial`
- `active branch`
  - the dominant workflow branch being assumed
- `active persona`
  - the currently blocking or dominant team posture in force for the batch
- `active stack`
  - the main layers or stack surfaces involved
- `mandatory gates`
  - the gates that are already known to be blocking
- `required artifacts`
  - wireframe, reference ASCII, boundary matrix, prop matrix, contract packet,
    browser truth, or equivalent proof expected for this branch
- `closure blockers`
  - what still has to exist before the work can honestly close
- `active skills`
  - the child skills actually activated for the current branch, not merely the
    candidate skills considered during discovery
- `active ADRs / references`
  - the architecture docs, ADRs, constitutions, or reference modules currently
    governing the branch
  - use concrete clickable file paths, not summary labels or narrative shorthand
- `gate ledger`
  - the current gate state using compact truth such as `open`, `passed`,
    `failed`, or `blocked`
- `phase / SDLC`
  - the current `accelerate` phase and the SDLC overlay in force for the batch
- `persona handoff artifact`
  - the concrete packet or decision artifact left by the active persona when the
    run is moving from framing/planning into implementation or review

For issue-driven work, the packet must also make visible:

- `issue lifecycle state`
  - current real status in the execution chain
- `next lifecycle gate`
  - the next required status or review gate before closure
- `metadata completeness`
  - whether labels, assignee, project, priority, and hierarchy are already
    execution-ready
- `planning gate`
  - `blocked`, `present`, or `approved exception`
- `planning artifact`
  - the execution-shaping artifact that exists after issue bootstrap and before
    code mutation

For engineering runs that are expected to mutate the repo, workflow seeds, or
living docs, the packet must also make visible:

- `issue bootstrap`
  - `complete`, `missing`, or `approved exception`
- `governing issue`
  - the governing issue key when bootstrap is complete
- `bootstrap exception reason`
  - only when the user explicitly approved a narrow no-issue exception

This is not ceremonial narration. It is visible proof that the selected branch
was actually operationalized instead of only named.

Use the exact packet shape from `references/runtime-packet-templates.md` unless a
strictly equivalent packet format is already active.

If `prompt-hardening` is required, the packet or the immediately following
technical update must also expose:

- `hardened artifact`
  - `present` or `missing`
- one visible `Hardened Prompt`, `Execution-Ready Prompt`, or
  `Execution-Ready Prompt Packet`

That artifact must expose an explicit transformation:

- `Prompt A`
  - the raw or minimally normalized user prompt being hardened
- `Prompt B`
  - the bounded execution-ready prompt actually being executed

Treat a missing hardened artifact as a gate failure, not as a presentational
defect.

When the hardened prompt is too large to repeat in full on every turn, the run
must still expose a visible transformation packet containing:

- a compact `Prompt A`
- a compact `Prompt B`
- the location of the full hardened artifact when it lives in a planning file,
  issue body, or equivalent execution packet

Do not collapse the hardening proof into vague narration such as "prompt was
improved".

## Runtime Observability Contract

`accelerate` is not allowed to operate as an invisible classifier.

For engineering work, the run must leave visible runtime evidence of what
`accelerate` actually put into force.

### Initial Runtime Packet

The opening technical update should make visible, in compact form:

- `classification`
- `active branch`
- `active persona`
- `active stack`
- `active skills`
- `active ADRs / references`
- `gate ledger`
- `phase / SDLC`
- `hardened artifact`
- `QA / proof lane`
- `issue stack status`
- `browser-proof intensity` when runtime/browser validation is active

### Runtime Delta Packet

Emit a `Runtime Delta Packet` whenever any of these change:

- `active branch`
- `active persona`
- `active skills`
- `active ADRs / references`
- `gate ledger`
- `phase / SDLC`

The next technical update should expose a `Runtime Delta Packet` containing at
least:

- `skills added`
- `skills removed`
- `ADRs / references added`
- `ADRs / references removed`
- `gates opened`
- `gates passed`
- `gates failed`
- `persona transition`
- `phase transition`
- `QA / proof lane transition`
- `browser-proof intensity transition` when applicable

Do not treat hidden context mutation as good operator style. If the branch
changed materially, the visible packet must change too.

Use the exact delta shape from `references/runtime-packet-templates.md`.

### Long-Run Progress Updates

For longer tasks, every meaningful technical progress update should keep the
current runtime state visible in compact form.

At minimum, the update should make clear:

- the active `phase`
- the active `skills`
- the active `gates`
- the current `hardened artifact` status when prompt-hardening is in force

Opaque progress lines that only say work is happening are insufficient when the
workflow stack changed or when gates are still controlling execution.

Cadence rules live in `references/runtime-observability-cadence.md`.

## Risk Enforcement Rule

Relevant risk must be operationalized, not merely narrated.

Risk that materially matters to execution or closure must always have:

- detector
- signal
- owner
- blocker condition
- release condition

Use `references/codex-agents/risk-enforcement-matrix.md` as the single
operational table for macro risk enforcement.

When a risk class becomes dominant, the corresponding lane or blocker must
activate. Do not merely mention the risk and continue normally.

## Core Entry Model

Use this baseline sequence:

1. frame the request and classify `trivial` vs `non-trivial`
2. decide whether `prompt-hardening` is mandatory
3. detect which higher-level branch is needed
4. load only the minimum relevant skills
5. satisfy issue bootstrap when the run mutates code, workflow, or living docs
6. produce the post-issue planning artifact for non-trivial work
7. run bounded execution with review checkpoints
8. perform fresh verification and enter root closure mode before `Done`

The intended activation rule is:

- discover broadly
- activate minimally

That means:

- if a skill might materially matter, inspect it
- once the branch is clear, keep only the minimum valid active skill stack
- do not confuse aggressive discovery with loading half the catalog

## Common Entry Recipes

Use these recipes as the short routing table.

These recipes are intentionally summary-level.

When there is any doubt, the branch-enforcement matrix wins over the summary in
this root file.

### Ambiguous, Long, Or Epic-Like Request

Load:

- `prompt-hardening`
- then `accelerate` continues routing

Do not continue into normal non-trivial execution after this branch unless the
run already surfaced the hardened artifact.

### Weakly-Bounded Request

If the request is small but the wording is still weak enough that two competent
operators could execute materially different work, use:

- `prompt-hardening`
- then `accelerate` continues routing

### Trivial Bounded Execution

Trivial engineering work still stays under `accelerate`.

It may route quickly and stay light-touch, but it does not bypass the root.

If trivial work mutates code, workflow seeds, or living docs, it still requires:

- governing issue bootstrap before execution
- metadata completeness
- truthful lifecycle progression
- commit traceability before `Done`
- proportional closure review

Trivial issue-governed work may close without a heavy `In Review` phase when no
real review gate remains, but it does not become issue-optional.

### Issue-Driven Delivery

- active workflow adapter
- `linear-implementation-planner` when sequencing is non-trivial
- `executing-plans` for bounded execution

Engineering mutation must not begin without issue bootstrap.

That means the run must do one of these first:

- attach to an existing governing issue
- create the governing issue or parent/child package first
- surface an explicit, narrow, user-approved no-issue exception

Absent one of those, the run is under-routed and implementation is blocked.

Issue-driven execution must keep lifecycle truth visible:

- active implementation -> `In Progress`
- implementation complete with real review gate remaining -> `In Review`
- `Done` only after verification, `AI Review Report`, and root closure mode

`Done` remains root-owned even when bounded agents participate.

Do not allow the issue-driven branch to collapse into `Todo -> Done` merely
because the narrative says the work happened.

If rich issue creation fails and a minimal fallback issue is created, do not
treat the issue as execution-ready yet. The fallback must enter a blocking
recovery path:

- run `Minimal Create Recovery Protocol`
- pass `Metadata Rehydration Check`
- pass `Ready-for-Execution Revalidation`
- only then continue into real execution

Do not silently treat "we started coding and created the issue later" as
acceptable cleanup. That is a workflow failure that review must name
explicitly.

### Bug, Failure, Or Regression

- `systematic-debugging`
- then the relevant stack and review skills for the affected surface

### Architecture Or Governance Doubt

- `architecture`
- `governance-audit`
- `p4y-stack-constitution` when stack truth is at stake

### Adversarial Security Audit Or Hostile-Path Review

- `adversarial-security-review`
- `anti-abuse-review`
- `security-patterns`
- `product-runtime-review` when the flow is user-facing
- `systematic-debugging` when reproducing the hostile path is part of the work

### Admin, Operator, Or Unfold Surface

- `django-unfold`
- `django-pro`
- the relevant query or readonly review skills

### Runtime-Or Product-Heavy User Flow

- `product-runtime-review`
- `anti-abuse-review` when the flow is sensitive
- `security-patterns` when ownership, auth, IDOR, secret, or race-sensitive
  backend behavior is part of the risk
- browser truth before narrative closure

### Untrusted Ingress, Upload, Import, Or Media Ingestion

- `untrusted-ingress-hardening`
- `anti-abuse-review` when the flow is user-facing or self-service
- `security-patterns` when ownership, serving posture, remote-fetch risk, or
  SSRF-adjacent behavior is part of the risk
- `product-runtime-review` when the ingress flow is user-facing
- `django-service-patterns` when normalization, transformation, or persistence
  is service-owned

### Copy, Locale, Or Translation-Boundary Work

- `i18n-patterns`
- `server-prop-governance` when backend display data or presenter fields may
  drift into frontend-owned copy
- runtime proof in at least one non-default locale when the surface is
  user-facing and the change is relevant to UX

### Product-Critical User Surface

Use this branch for billing recovery, auth recovery, onboarding-critical,
sensitive self-service, and financial user-facing flows where backend truth and
visual product quality are closure-critical.

Load `references/product-critical-surfaces.md`, then at least
`product-runtime-review`, `server-prop-governance`, `ascii-wireframe`, and the
relevant sensitive-flow or domain-truth skills.

### Visual Or Artifact-Driven Frontend Work

- `front-react-shadcn`
- `frontend-boundary-governance` when `.ts` vs `.tsx`, view-model, selector,
  formatter, or page-controller boundaries are part of the risk
- `i18n-patterns` when user-facing copy changes
- `product-runtime-review` when the surface is runtime-sensitive or
  user-goal-sensitive beyond static visual composition
- `tailwind-design-system`
- `ascii-wireframe` when structure needs visual framing
- `figma-node-fidelity` when exact node composition matters
- `references/premium-interface-production.md` when the page must land at a
  premium product standard, not only a safe implementation

If the change introduces, restructures, or extends a subroute inside an
existing `private/<domain>/...` route family, require a visible
`Private Route Family Audit` before implementation settles.

That audit must prove at least:

- the existing local layout or shell for the route family was inspected
- comparable `private/` route families were inspected for precedent
- the target surface is correctly classified as:
  - standalone page
  - subview inside an existing shell
  - tab within the same domain hub
- the navigation model is justified:
  - page transition
  - shared-shell subroute
  - tab navigation
- the implementation does not replace an existing hub with a sibling landing
  page unless that fork is explicitly justified

When this audit is missing, treat the work as structurally under-specified even
if the individual page implementation is technically correct.

### Query-Or Contract-Sensitive Backend Work

Load:

- `django-service-patterns`
- `django-inertia-integration`
- `server-prop-governance`
- `validation-governance` when local validation, parsing, or UX-only validation
  boundaries are part of the risk
- `security-patterns` when ownership, auth, IDOR, secret handling, or
  concurrency safety are part of the risk
- `sql-optimization-patterns` when relational fetch strategy, app queries,
  presenters, dashboards, list/detail surfaces, or N+1 risk are in play
- `financial-source-truth` when money or balance truth is involved

Treat `Backend Query Correctness` as an execution trigger here, not only a
closure lens.

If the owning surface aggregates related entities through services, app
queries, presenters, dashboards, or report builders, require a visible
`Query Shape Proof` artifact before closure.

### Transport, Dependency, Or Legacy-Adaptation Doubt

Load:

- `api-surface-governance` when the surface boundary is the question
- `dependency-governance` when overlap, removal, or stack drift is the question
- `legacy-transplant` and `legacy-first-protocol` when business truth is being
  ported from `_projeto-antigo/`

## Mandatory Gates

The following gates are part of the workflow when applicable:

- `prompt-hardening` for ambiguous, long, multi-phase, or epic-like prompts
  - this gate does not count as passed until a visible `Hardened Prompt`,
    `Execution-Ready Prompt`, or `Execution-Ready Prompt Packet` exists in the
    run
- `Story Framing` when actor, goal, value, or acceptance are still implicit
- `PRD-lite` when scope is underdefined or capability-level
- `Implementation Design` when bounded slices and rollout order are missing
- `Spec Feedback Loop` when implementation reveals ambiguity in the spec
- `Product Planner` when the real problem is decomposition or scoping
- `Truth Ownership Check` when one concept may drift across layers
- `Minimal Create Recovery Protocol` when issue creation had to fall back to a
  minimal payload after a richer create/update attempt failed
- `Issue Bootstrap Gate` before engineering mutation, workflow mutation, or
  repo mutation begins unless a narrow explicit no-issue exception was approved
  by the user
- `Post-Issue Planning Gate` for non-trivial issue-driven work before execution
  begins
- `Metadata Rehydration Check` before `In Progress` or closure if a minimal
  workflow-adapter create fallback occurred
- `Ready-for-Execution Revalidation` before execution continues after metadata
  rehydration so a merely created issue is not mistaken for an execution-ready
  issue
- `i18n Closure Gate` when user-facing copy or labels change
- `Server Prop Copy Ban` when a backend/frontend contract might serialize
  localized copy instead of truth, codes, or translation keys
- `Backend Product Contract Protocol` for critical recovery/auth/billing or
  self-service surfaces before UI implementation starts
- `Query Shape Proof` when backend work aggregates related entities, crosses
  service/query/presenter boundaries, or makes N+1, lazy cascade, weak
  `select_related`, or weak `prefetch_related` plausible
- `Recovery Surface Isolation Rules` when special user states must not leak into
  generic private hubs
- `Mandatory vs Optional Language Protocol` when the work exposes bugs,
  regressions, security issues, contract drift, enforcement failures, or other
  non-optional corrections that should not be described as discretionary
- `Failure Classification Gate` when serious misses, recurring drift, or
  workflow corrections are involved and the root cause must be classified as
  rule, enforcement, routing, review, closure, or execution failure
- `Secrets & Config Hygiene Check` when a slice touches provider credentials,
  security-sensitive settings, environment-backed config, or code that could
  drift into hardcoded secrets
- `Concurrency Integrity Check` when the slice mutates money, quotas, defaults,
  seats, counters, or other race-prone critical state and the choice between
  `F()`, `select_for_update()`, or optimistic locking must be justified
- `Containment Policy Check` when attacker behavior, abuse signals, or hostile
  automation is part of the diagnosis and the response posture must be bounded
  and fail-closed rather than hand-waved
- `Component Source Ladder` when frontend work creates, adopts, or recommends a
  component or visual interaction pattern and must prove internal reuse was
  exhausted before invention
- `Real Data Readiness Gate` when a user-facing frontend surface could still be
  valid only for mock, happy-path, or static-density data
- `Sidebar / Public Docs Update Gate` when a frontend change affects
  navigation, discoverability, visible route families, or public AI/runtime
  documentation
- `Workflow Change Approval Gate` when the proposed change mutates
  `accelerate`, adjacent workflow skills, workflow enforcement docs, or
  constitution-level workflow truth
- `Visual Contract Extraction` when references are composition-bearing rather
  than inspirational
- `Wireframe Before UI` for new product-critical pages
- `Design-System Fidelity` and `Componentization Discipline` for shared UI work
- `TS/TSX Boundary Audit` when structural frontend work risks page-controller
  drift, copy leakage, or blurred view-model ownership
- `Design-System Adherence Review` for product-critical user-facing pages
- `Product-Critical Closure Protocol` when technical correctness alone is not a
  valid definition of done
- `Visual Contract Implementation` for Stitch, Figma, or screenshot contracts
- `Artifact Sufficiency Check` when a branch depends on artifacts such as
  wireframes, reference ASCII, boundary matrices, prop matrices, or backend
  product packets and shallow artifacts would still leave execution unsafe
- `Repo Hygiene / Platform Hygiene` when repo layout or tracked artifacts matter
- `Living Docs Obligation` when durable project behavior changes

The `Issue Bootstrap Gate` is satisfied only when:

- a governing issue already exists and is execution-ready
- or a new governing issue/package was created and revalidated before
  implementation
- or the user explicitly approved a narrow no-issue exception and that
  exception is visible in the run

Beginning engineering mutation without satisfying this gate is a reviewable
workflow failure.

The `Post-Issue Planning Gate` is satisfied only when:

- the run is non-trivial
- the governing issue already exists
- an integrated planning artifact exists after issue bootstrap and before code
  mutation
- that artifact shapes bounded execution, dependencies, gates, and evidence

Missing this artifact is a blocking workflow failure, not a presentation nit.

Use `references/branch-enforcement-matrix.md` when branch selection, gate
ownership, mandatory skills, expected artifacts, or closure blockers need to be
made explicit instead of being reconstructed from memory.

## Context Minimum

Before acting, make sure you know at least:

- the current goal
- the current source of scope
- the affected domains or layers
- the key constraints
- the desired end state
- recurring repo-specific guidance from `napkin`
- the exact target workspace/repo path you are analyzing or mutating

If this minimum is missing, do not fake certainty. Shape the request or inspect
the missing truth first.

### Repo Target Verification

When more than one similar repository, backup, or stack clone exists on disk,
or when injected project context could plausibly bias you toward the wrong repo,
perform an explicit target verification before substantive analysis.

Minimum proof:

- read or print the exact working directory
- inspect that repo's `git status`
- anchor claims to files from that repo before synthesizing conclusions

Do not let loaded memory, prior sessions, or similarly named projects stand in
for repo truth. If you realize analysis began in the wrong repo, stop, correct
course openly, and restart the inspection on the verified target.

## Runtime Guardrail

- In the default Python distribution, commands use `uv run ...`.
- Do not use `python`, `pytest`, `pip`, or `source .venv/bin/activate`
  directly.
- Do not let convenience commands override the repo runtime contract.

## Sandbox Bootstrap Fallback

Treat sandbox bootstrap failures differently from real sensitive-access events.

- If a low-risk local read fails because the sandboxed process cannot start
  (for example `bwrap: setting up uid map: Permission denied`), do not treat
  that as evidence that the file is sensitive.
- For repo files, local docs, `napkin`, and installed skills under `~/.codex`,
  prefer a narrow retry outside the sandbox.
- Do not confuse runtime skill sync with shell execution policy.
- Keep the retry proportional; this is a setup fallback, not broad elevation.

## Operating Phases

Use these phases for engineering work once `accelerate` has classified the run.

### Phase 1: Frame

- read the prompt and relevant local truth
- re-anchor recurring repo-specific guidance from `napkin`
- detect stack sensitivity, runtime sensitivity, and ownership drift risk
- classify the request honestly

### Phase 2: Load

- discover candidate skills broadly, then activate only the skills required for
  the current branch
- decide whether specification work is missing
- decide whether runtime proof or governance proof is needed
- leave the first visible `active skills` and `active ADRs / references`
  packet once the branch-level stack is no longer tentative

### Phase 2.5: Classify

- route into the dominant branch, including trivial bounded when applicable
- choose the active persona posture
- decide whether delegation is helpful or wasteful
- emit the compact visible packet that proves the selected branch is now in
  force

### Phase 3: Plan

- define bounded slices
- define blockers, dependencies, and verification expectations
- produce the persona handoff artifact required for the next active owner of the
  work, especially before code mutation or formal review
- if the work is issue-driven, make sure workflow metadata is complete before
  active execution
- for non-trivial issue-driven work, produce the explicit post-issue planning
  artifact here; execution must not begin before it exists
- if prompt-hardening was required, keep the `Prompt A -> Prompt B`
  transformation visible or visibly linked from the active planning artifact

### Phase 4: Execute

- work in bounded batches
- treat `Implementer / Developer` as the explicit owner of code mutation,
  bounded implementation decisions, and implementation-side verification
- if the work is non-trivial, assume subagent-capable execution and evaluate
  bounded sidecars or parallel slices explicitly instead of defaulting to a
  single-threaded run by inertia
- do micro-reviews during execution
- keep runtime and contract truth aligned
- create follow-up issues instead of silently absorbing out-of-scope residuals
- when child skills, ADRs, or gates change during execution, emit a visible
  `Runtime Delta Packet` instead of silently mutating the context stack

### Phase 5: Gate

- run quality lenses that apply
- re-check scope, contract, runtime, and metadata hygiene
- do not promote narrative confidence over evidence
- make the active quality lenses and remaining closure gates visible before
  claiming the gate is passing

### Phase 5.5: Final Forensic Review

- run fresh verification
- reconcile requested vs implemented
- reconcile promised vs delivered
- reconcile issue scope vs actual landing
- review previous reviews when delegation or staged review happened

### Phase 6: Deliver

- summarize what landed
- state what was verified
- state residual risk honestly
- update docs or follow-ups when durable behavior changed

## Phase To SDLC Mapping

The operational phases intentionally map to the specification-layer SDLC
overlay:

| Operational phase | SDLC overlay |
| --- | --- |
| `Frame` | `Spec` |
| `Load` + `Classify` | `Design` |
| `Plan` | `Plan` |
| `Execute` | `Implement` |
| `Gate` + `Final Forensic Review` | `Verify` |
| `Deliver` | `Release or Follow-up` |

When commentary names the active phase, it should also be clear which SDLC
phase is actually in force for the current batch.

## Failure Handling And Re-Entry

When the work does not cleanly pass a gate, do not drift forward optimistically.

- ambiguous request after framing -> re-enter `prompt-hardening`
- missing scope truth -> return to context gathering or issue review
- verification failure -> return to execution with the failure as the new
  bounded target
- runtime or contract drift -> re-open the relevant branch instead of closing on
  narrative confidence
- adjacent real debt outside scope -> create or reuse a follow-up issue
- subagent conflict at integration time -> master resolves before claiming
  completion

Re-entry is part of the model, not a sign that the workflow failed.

## Quality And Closure Rules

These are always binding when applicable:

- `product-runtime-review`
- `anti-abuse-review`
- `Contract Correctness`
- `Frontend Structure Correctness`
- `Backend Query Correctness`
- `Stack Adherence`
- `Design-System Adherence Review`
- `Product-Critical Closure Protocol`

For issue-driven work:

- `AI Review Report` is mandatory before `Done`
- the report must be forensic, not ceremonial
- issue-driven execution must leave a real commit trail before `Done`
- the governing issue key must be visible in the commit trail, preferably in
  the commit subject of the bounded implementation commit
- parent/child hierarchy must exist as real `parentId` links before dependency
  edges are used as complements

## Workflow Adapter Rule
When work is issue-driven:

1. parent/child means real sub-issue hierarchy in the active workflow backend,
   not just loose related links
2. if tool capability is unclear, verify hierarchy and lifecycle support before
   writing
3. labels, priority, assignee, and project linkage must be correct before
   active execution
4. relation hygiene is rechecked during closure, not trusted from commentary

Also remember:

- the governing issue is the source of scope, not just a status container
- adapter-specific label constraints are real; choose the correct home label
  rather than forcing invalid combinations
- duplicate/canceled states are reserved for true duplicate or discard
  decisions, not as status shortcuts

The full issue lane and its mandatory packets live in
`references/issue-stack.md`.

Detailed current-default workflow governance still lives in
`references/linear-execution.md` until the dedicated workflow adapters are
fully rehomed under `adapters/workflow/`.
## Subagent Rule

Subagents are bounded collaborators, not replacements for the master.

For non-trivial work, `accelerate` must default to multi-agent execution.

At least one bounded subagent must be spawned for a non-trivial run.
If no independent implementation slice exists, spawn a proof, review,
governance, or verification sidecar instead.

Remaining fully single-threaded on non-trivial work requires an explicit
`single-threaded exception` note in the runtime packet.

The master always owns:

- the global plan
- integration correctness
- final review
- final forensic closure

Every spawned subagent should:

- load `accelerate` first as its own entry classifier before taking layer- or
  branch-specific actions
- stay inside its bounded scope
- leave a self-review packet
- leave a self-forensic review packet
- hand back explicit evidence, not summary-only claims

Detailed delegation rules live in `references/subagent-model.md`.
## Reference Modules

Load only the module you need.

- `references/specification-layer.md`
  - use when story framing, PRD-lite, implementation design, or spec feedback is
    needed
- `references/persona-model.md`
  - use when persona activation, transition, precedence, or role contracts are
    relevant
- `references/persona-mandatory-skills-matrix.md`
  - use when the active persona must expose its non-optional skill set instead
    of relying on informal judgment
- `references/team-operating-model.md`
  - use when the full PM -> planner -> implementer -> QA -> closure model needs
    to be made explicit, especially for future agent derivation
- `references/executive-operating-matrix.md`
  - use when a one-page executive summary of the full team OS is needed
- `references/executive-persona-matrix.md`
  - use when a single matrix of persona -> mandatory skills -> contextual skills
    -> triggers -> outputs is needed
  - this reference is organic to the Team OS, not optional garnish; when persona
    catalogs, mandatory skills, workflows, or proof lanes change, update this
    matrix in the same mutation package or explicitly record the defer reason
- `references/subagent-model.md`
  - use when deciding whether to delegate, how to bound subagents, and how to
    integrate their outputs
- `references/review-architecture.md`
  - use when review type, review depth, reconciliation, or review-of-review is in
    play
- `references/trivial-branch-contract.md`
  - use when the run is trivial or when the question is how much workflow must
    still remain active in a bounded trivial branch
- `references/runtime-packet-templates.md`
  - use when packet and delta output must follow an exact visible schema
- `references/runtime-observability-cadence.md`
  - use when update timing and packet cadence must be explicit rather than left
    to operator style
- `references/qa-proof-stack.md`
  - use when backend QA, frontend QA, browser-proof, Chrome DevTools truth, or
    Playwright persistence need an explicit lane model
- `references/issue-stack.md`
  - use when issue bootstrap, workflow metadata, planning artifacts, or AI Review
    lifecycle enforcement need to be made explicit
- `references/current-enforcement-surfaces.md`
  - use when the run must enforce current-stack constraints such as IDOR,
    anti-abuse, N+1, Inertia-first, source ladder, DRY, i18n, mixins, or race
    condition review
- `references/full-invocation-map.md`
  - use when the operator needs the richer N+1 invocation map, branch families,
  and visual wireframes of the full workflow system
- `references/workflow-catalog.md`
  - use when the full named workflow set must be explicit for current execution
    or future agent derivation
- `references/prompt-hardening-gate.md`
  - use when the main question is whether execution should be blocked until the
    prompt is properly bounded and the `Prompt A -> Prompt B` transformation is
    visible
- `references/operational-calibration.md`
  - use when proportionality, exit criteria, evidence normalization, artifacts,
    or long-running work need calibration
- `references/branch-enforcement-matrix.md`
  - use when branch-level mandatory skills, gates, expected artifacts, evidence,
    or closure blockers need to be made explicit
- `references/workflow-change-approval-gate.md`
  - use when a run is proposing workflow-level mutation and explicit HITL
    approval plus evidence packet rules are needed
- `references/adjacent-skill-trigger-audit.md`
  - use when adjacent-skill sufficiency or branch trigger hardening is the
    question
- `references/product-critical-surfaces.md`
  - use when backend-first product rigor, recovery surface isolation, visual
    contracts, wireframes, or product-critical closure rules are in play
- `references/premium-interface-production.md`
  - use when premium interface direction, rich ASCII comparison, and visual
    reconciliation are closure-critical
- `references/maturity-control.md`
  - use when telemetry, simplification, durable memory, domain playbooks,
    evidence precedence, or scope control matter
- `references/autoresearch-and-self-evolution.md`
  - use when repeated failures or structural misses should be promoted into skill,
    gate, or workflow evolution instead of staying as one-off fixes
- `references/linear-execution.md`
  - use when the work is governed by the current workflow backend and relation
    hygiene, AI Review, or
    metadata completeness matter

## Recommended Skill Stack

Primary companions:

- `prompt-hardening`
- current workflow adapter
- `verification-before-completion`
- `architecture`
- `napkin`

Contextual companions:

- stack skills for the active surface
- runtime or abuse review skills when user-facing or sensitive
- domain skills when business truth is specialized
- product-critical surfaces default to `product-runtime-review`, `ascii-wireframe`,
  `server-prop-governance`, the active frontend stack skills, and relevant
  sensitive-flow or domain-truth skills

For the full team OS model, the runtime stack should also make visible:

- the active issue lane
- the active QA/proof lane
- whether browser-proof is interactive-only or already persisted into Playwright
- whether wireframe extraction is a blocking design gate for the branch

## Handoff And Escalation

`accelerate` stays as the root orchestrator, but it should hand off the active
working posture when another skill becomes the main owner of the next step.

Typical handoffs:

- to the active workflow adapter when the main deliverable is issue
  architecture or execution governance
- to stack skills when the next step is implementation-heavy in a specific
  layer
- to `ascii-wireframe` when structure, composition, or state design must be
  made explicit before UI mutation
- to `qa-proof-stack`-aligned roles when runtime proof becomes the critical path
- to `verification-before-completion` when closure evidence is the main
  remaining task
- to domain skills when business truth is specialized enough that generic
  orchestration is no longer the bottleneck

Escalate to deeper references when the root file is no longer enough to make a
safe decision.

## Anti-Patterns
Do not:

- skip classification because the task "looks easy"
- let `relatedTo` or dependency links substitute for parent/child hierarchy
- keep loading more skills when a bounded stack is enough
- spawn subagents for work that does not benefit from delegation
- treat review as ceremonial after implementation is already "basically done"
- trust prior summaries without rechecking evidence before closure
- close work on narrative confidence alone
- let browser-proof and Playwright swap roles; Chrome DevTools truth comes
  first, Playwright persistence comes after the flow is understood
- let implementation happen without an explicit owner persona and handoff packet
- let issue-driven mutation proceed without the issue stack lane being visible
- let frontend structure mutate without wireframe/source-ladder reasoning when
  structural uncertainty is present

## Verification
Before considering the modularization complete:

- keep this `SKILL.md` below the local authoring threshold
- make sure every referenced module exists
- keep seed and installed runtime skill aligned
- ensure the short file still points operators to the right advanced module
Before considering orchestrated work complete:

- confirm trivial vs non-trivial entry was judged honestly
- confirm `prompt-hardening` was used when the request shape required it
- confirm the chosen skill stack was appropriate for the active branch
- confirm the scope stayed bounded
- confirm execution used bounded batches and micro-review checkpoints
- confirm relevant runtime or contract evidence was actually collected
- confirm product-critical backend modeling happened before final UI work when the
  branch applied
- confirm references were treated as contracts and not moodboards when visual
  artifacts were in play
- confirm subagent use, if any, respected bounded scope and master revalidation
- confirm applicable quality lenses were addressed
- confirm final forensic closure actually happened before `Done`
- confirm issue-driven execution is not closing from an uncommitted worktree,
  detached local state, or narrative-only implementation claim
- confirm at least one real commit exists for the executed issue slice
- confirm the governing issue key is visible in the commit trail or classify
  the gap as workflow drift instead of closing cleanly
