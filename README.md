# Accelerate

`accelerate` is the root orchestration skill for engineering work in the
standalone platform and its supported project distributions.

Use it to decide how work should run before implementation starts, not merely
to narrate that work is happening.

It is the control plane that chooses:

- whether the run is trivial or non-trivial
- whether prompt hardening is required
- which issue topology is honest
- which lanes and skills must be open
- whether delegation is useful at all
- which proof stack is required
- which blockers still control closure

`accelerate` is self-contained. Governed behavior must come from files tracked
in this repository: `SKILL.md`, `README.md`, `core/`, `adapters/`, `profiles/`,
`onboarding/`, `planning/`, `skills/`, and `references/`.

User-home paths such as `~/.claude/skills`, `~/.codex/skills`, or
`~/.codex/agents` may exist as runtime exports or local installations, but they
are not required authority and must not be used as the source for governed
Accelerate behavior. If useful external material is needed, import and adapt it
into this repository first.

The short constitutional entry file is:

- [SKILL.md](./SKILL.md)

This README is the richer, living guide for how `accelerate` is meant to be understood and used in its current default distribution.

## What It Is

`accelerate` is:

- the root workflow orchestrator
- the visible operating system for engineering teamwork
- a specification-first and issue-aware control plane
- a stack-aware but project-agnostic governance layer
- the owner of topology, staffing, risk enforcement, and closure

It is strongest when work is:

- issue-driven
- cross-surface
- architecture-sensitive
- user-facing or runtime-sensitive
- abuse-sensitive
- ambiguous enough to drift without shaping

## What It Is Not

`accelerate` is not:

- an implementation skill
- a replacement for stack-specific skills
- a requirement that agents must exist before the workflow can operate
- a justification for unnecessary ceremony
- a license for bounded agents to inherit orchestration authority

## Relationship To The Root Skill

Keep the split intentional:

- [SKILL.md](./SKILL.md)
  - short constitutional entry skill
- this README
  - richer operational guide, examples, reading map, and doctrine overview
- `references/`
  - inherited deep doctrine that remains readable as supporting context while
    native surfaces continue taking over primary authority

The root skill should stay compact.

The README should stay rich enough for onboarding and maintenance.

The references should stay readable for inherited depth, but when a surface has
already been rehomed into `core/`, the native local file is the primary
authority.

See also:

- [references/README.md](./references/README.md)

for the explicit native-vs-supporting authority map inside the reference layer.


## Pre-Agents Baseline

The standalone repo now has a native pre-agents baseline.

Start here:

- [accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
- [core/README.md](./core/README.md)
- [adapters/workflow/README.md](./adapters/workflow/README.md)
- [adapters/runtime/README.md](./adapters/runtime/README.md)
- [onboarding/README.md](./onboarding/README.md)
- [planning/README.md](./planning/README.md)

Use `references/` as supporting doctrine while rehoming continues. Branch,
proof, delegation, workflow, calibration, and product-critical doctrine now
have native homes under `core/`.

## Core Operating Model

At a high level, `accelerate` works like this:

1. classify the run
2. decide whether prompt hardening is mandatory
3. when a governed target repository is in scope, decide local `.accelerate/`
   entry state
4. decide the honest issue topology
5. decide which lanes and skills are required
6. decide whether the work should stay root-only or use bounded agents
7. execute with visible runtime packets and active gates
8. keep readiness, timeline, and learning disposition visible when local workspace state is active
9. force proof in the correct order
10. enter root closure mode before `Done`

The control plane should be visible, not implied.

## Current Native Additions

The standalone repository now has additional native surfaces beyond the initial
pre-agents baseline:

- Next.js fullstack stack profiles:
  - `profiles/nextjs-prisma/`
  - `profiles/nextjs-drizzle/`
  - `profiles/nextjs-adonis-adminjs/`
- provider and runtime skills for auth, hosted Postgres, Vercel, jobs, mail,
  storage/uploads, and Playwright regression
- a native one-shot side-by-side execution and review protocol
- a repo-local curated DESIGN.md corpus for premium design examples
- profile and one-shot protocol integrity tests integrated into doctrine checks

These are repo-local authorities. They must not be sourced from user-home skill
catalogs or external design/runtime libraries.

## Prompt Hardening

`accelerate` must decide whether prompt hardening is required before execution
starts.

Hardening is not cosmetic rewriting. It is a blocking gate when the request is:

- long
- ambiguous
- multi-objective
- multi-phase
- architecture-heavy
- likely to drift into issue creation, planning, runtime proof, or multi-surface
  work

When hardening is active, the run should visibly expose:

- `Prompt A`
- `Prompt B`
- material changes
- bounded scope
- explicit non-goals
- next branch or persona route

See:

- [prompt-hardening.md](./core/hardening/prompt-hardening.md)

## Issue-Driven Mutation Stack

When the work mutates code, docs, workflow seeds, or runtime governance, the
issue stack is mandatory.

The minimum mutation path is:

1. `accelerate`
2. `Local Workspace Entry Gate` when a governed target repo is in scope
3. `Issue Bootstrap Gate`
4. active workflow adapter
5. planning artifact
6. execution
7. proof stack
8. local review / closure preparation when `.accelerate/` local status is active
9. `AI Review Report`
10. root closure mode

Mutation must not jump directly from request to implementation.

When the user asks for one-shot execution with task-by-task review,
auto-correction, delegated correction, and final forensic reconciliation, the
mutation path also opens the `One-Shot Side-By-Side Gate`.

See:

- [issue-driven-mutation-stack.md](./core/issue-topology/issue-driven-mutation-stack.md)
- [one-shot-side-by-side-protocol.md](./core/review/one-shot-side-by-side-protocol.md)

## Enforcement And Branching

The native branch and enforcement authorities now live in:

- [branch-enforcement-matrix.md](./core/control-plane/branch-enforcement-matrix.md)
- [local-workspace-entry-gate.md](./core/control-plane/local-workspace-entry-gate.md)
- [review-readiness-gate.md](./core/control-plane/review-readiness-gate.md)
- [timeline-continuity-gate.md](./core/control-plane/timeline-continuity-gate.md)
- [durable-learning-registration-gate.md](./core/control-plane/durable-learning-registration-gate.md)
- [enforcement-surfaces.md](./core/risk/enforcement-surfaces.md)

Use them to decide:

- whether `.accelerate/` is absent, reusable, or requires reentry
- which branch is active
- which mandatory skills must be open
- which gates are blocking
- what readiness state is currently honest
- what checkpoint was crossed last and what comes next
- whether durable learnings must be registered before closure
- whether `prepare-review.sh` or `prepare-closure.sh` is now the canonical local next step
- which proof and artifacts closure requires

The branch matrix also wires the `One-Shot Side-By-Side Gate` for requests that
explicitly ask for a one-shot batch, side-by-side task review, auto-correction,
delegated correction handoff, and final forensic review.

The gate owner is:

- [one-shot-side-by-side-protocol.md](./core/review/one-shot-side-by-side-protocol.md)

## Proof Stack

The native proof-order and lane-ownership authority now lives in:

- [qa-proof-stack.md](./core/runtime-packets/qa-proof-stack.md)

Proof ordering is:

1. implementation proof
2. backend/frontend QA proof
3. browser truth
4. persistent regression proof
5. forensic closure

When the one-shot protocol is active, proof also requires:

- a task ledger
- task-level side-by-side review packets
- requested-vs-implemented comparison
- defect ledger updates when defects exist
- correction loop packets for fixed defects
- fresh reproof after every correction
- final forensic reconciliation before closure

The packet authority is:

- [templates.md](./core/runtime-packets/templates.md)

The reusable task-ledger template is:

- [one-shot-task-ledger-template.md](./planning/execution/one-shot-task-ledger-template.md)

## One-Shot Side-By-Side Protocol

The one-shot side-by-side protocol is a native Accelerate workflow for prompts
that ask the system to plan, execute, review, correct, and forensically close a
batch in one governed run.

It is activated by requests that combine signals such as:

- executive plan
- tasks or task ledger
- one-shot execution
- review 1:1 or side-by-side review
- auto-correction
- subagent correction handoff
- final forensic review

The required chain is:

1. create or identify the executive plan
2. create the task ledger
3. execute bounded tasks in the one-shot batch
4. review each task side by side
5. compare requested vs implemented
6. record defects and drift
7. auto-correct every in-scope defect
8. run reproof after each correction
9. delegate correction only when the fix is bounded and delegation helps
10. perform master review-of-review
11. perform final forensic reconciliation
12. block closure until the ledger, proof, correction, and forensic packets agree

Closure blockers include:

- open in-scope defects
- corrections without reproof
- missing side-by-side task review
- missing final forensic reconciliation
- validation stack under-run
- subagent success accepted without master integration review

Native surfaces:

- [one-shot-side-by-side-protocol.md](./core/review/one-shot-side-by-side-protocol.md)
- [one-shot-task-ledger-template.md](./planning/execution/one-shot-task-ledger-template.md)
- [templates.md](./core/runtime-packets/templates.md)
- [subagent-model.md](./core/delegation/subagent-model.md)

Regression tests:

- `tests/one-shot-protocol-integrity.sh`
- `tests/one-shot-protocol-semantic.sh`
- `tests/one-shot-protocol-delegation.sh`
- `tests/one-shot-protocol-closure.sh`

## Agent Optionality

Agents are a governed capability, not a structural dependency.

`accelerate` must remain fully functional:

- when no exported runtime agents exist
- when the user explicitly disables agents
- when the current pool has no honest fit
- when integration cost is higher than the gain from delegation

`accelerate` may:

- suggest a future agent promotion into the repo-owned agent factory and then an
  optional runtime export
- decide that no agent should be used
- keep the run fully root-owned

`accelerate` must not:

- force delegation because a catalog exists
- force delegation because thread budget exists
- treat gap detection as automatic promotion

The native bounded-delegation authority now lives in:

- [subagent-model.md](./core/delegation/subagent-model.md)

When delegated correction is used under the one-shot protocol, subagents must
return correction/reproof status, self-review, self-forensic review, unresolved
risk, and the bounded scope handled. The root still owns integration,
review-of-review, final forensic closure, and `Done`.

## Stack Profiles

Profiles are stack-specific authority bundles. They own concrete stack posture,
validation expectations, and profile-local parity matrices. Core should remain
capability-oriented and avoid embedding raw framework command strings unless the
command belongs to a runtime adapter or profile.

Active profiles include:

- `profiles/django-inertia-react/`
- `profiles/nextjs-tailwind/`
- `profiles/nextjs-prisma/`
- `profiles/nextjs-drizzle/`
- `profiles/nextjs-adonis-adminjs/`

Use the smallest honest profile:

- simple Next.js data app -> `nextjs-prisma`
- SQL-heavy, tenant/RLS, or query-control-heavy app -> `nextjs-drizzle`
- backend/admin/operator-heavy app -> `nextjs-adonis-adminjs`
- UI-only or marketing-only Next.js work -> `nextjs-tailwind` when no durable
  data authority is needed

Do not combine Prisma and Drizzle as equal baseline data authorities in one
profile. The active profile must choose one schema/migration authority.

Relevant profile artifacts:

- [nextjs-prisma](./profiles/nextjs-prisma/README.md)
- [nextjs-drizzle](./profiles/nextjs-drizzle/README.md)
- [nextjs-adonis-adminjs](./profiles/nextjs-adonis-adminjs/README.md)

## Provider And Runtime Skills

The Next.js fullstack expansion added optional provider skills. These skills
govern provider posture without turning any provider into a universal baseline.

Auth and authorization:

- `skills/security/better-auth-patterns/`
- `skills/security/authjs-patterns/`
- `skills/security/clerk-patterns/`
- `skills/security/authorization-policy-patterns/`

Data and hosted Postgres:

- `skills/data/prisma-patterns/`
- `skills/data/drizzle-patterns/`
- `skills/data/neon-postgres-patterns/`
- `skills/data/supabase-postgres-patterns/`

Deployment:

- `skills/runtime/vercel-deployment-patterns/`

Jobs and queues:

- `skills/runtime/inngest-patterns/`
- `skills/runtime/triggerdev-patterns/`
- `skills/runtime/bullmq-patterns/`
- `skills/runtime/pgboss-patterns/`
- `skills/runtime/qstash-patterns/`

Mail:

- `skills/runtime/resend-patterns/`
- `skills/runtime/postmark-patterns/`
- `skills/runtime/nodemailer-patterns/`

Storage/uploads:

- `skills/runtime/s3-r2-storage-patterns/`
- `skills/runtime/uploadthing-patterns/`

Persistent regression:

- `skills/runtime/playwright-patterns/`

Provider skills must prove ownership, lifecycle, failure behavior, idempotency,
replay posture, validation boundaries, and closure evidence appropriate to the
provider class.

## Workflow Adapter Live Direction

The one-shot protocol and issue-driven stack are currently governed by native
doctrine, planning artifacts, runtime packets, and shell validation. They do not
yet have a complete live workflow adapter that automatically creates, updates,
reviews, corrects, and closes work in an external system.

That is intentional for the current standalone pre-agents phase. The next
platform step is to build live workflow adapters that map the same conceptual
model to concrete backends.

Candidate tools and adapters:

- Linear:
  - best fit for parent/child issue topology, execution-ready issue bodies,
    status transitions, review comments, and delivery workflows
  - recommended first adapter when team execution and issue state matter most
- GitHub Issues + Pull Requests:
  - best fit for open-source or repo-native workflows where code review,
    commits, checks, and PR closure are the primary lifecycle
  - useful for binding `Requested-Vs-Implemented`, `AI Review`, and final
    forensic packets to PR comments
- GitHub Projects:
  - useful when GitHub Issues/PRs are present but board-level prioritization and
    project fields are needed
- Jira:
  - useful for enterprise teams with existing sprint, release, and compliance
    workflows
  - likely higher integration cost than Linear or GitHub
- Notion databases:
  - useful for lightweight planning and artifact indexes, but weaker as a strict
    execution backend unless paired with GitHub or Linear
- Local `.accelerate/` workspace:
  - best for repo-local review/closure bundles, handoff summaries, readiness
    dashboards, and offline continuity
  - should remain a first-class adapter even when an external backend exists

A live adapter should implement these operations without changing core doctrine:

- issue bootstrap
- metadata rehydration
- post-issue planning attachment
- task ledger creation or linking
- per-task side-by-side review comments
- defect ledger updates
- delegated correction handoff packets
- reproof evidence attachment
- final forensic reconciliation comment
- closure blocker detection
- final status transition only after root closure mode

The recommended build order is:

1. local `.accelerate/` adapter hardening for one-shot packets and ledgers
2. Linear live adapter for issue topology and status/comment lifecycle
3. GitHub PR adapter for code-review-bound forensic closure
4. GitHub Issues/Projects adapter for repo-native planning
5. Jira/Notion adapters only after the core live-adapter contract stabilizes

Until a live adapter exists, do not pretend one does. Use the native planning
artifacts, packet templates, and tests as the source of truth.

### Suggestion vs Promotion

These are different actions:

- `suggestion`
  - the root concludes that a repeated missing specialty exists
- `promotion`
  - the governed process later decides to create or sync a real runtime agent

Detecting a gap does not create an agent by itself.

## Root-Only Mode

Root-only mode is a valid operating posture, not a degraded failure state.

Keep work root-only when:

- topology is still unstable
- the dominant need is lane-governor judgment
- the fit for a bounded family is weak
- the user asked for no agents in this run
- the expected integration burden outweighs the delegation gain

## User-Controlled Agent Disable

The user may disable agents explicitly:

- for the whole run
- for one bounded slice

When that happens, `accelerate` still governs the run normally. The only change
is that the execution stays root-owned.

## Recommended Adjacent Skills

`accelerate` should coexist well with these adjacent disciplines:

- `napkin`
  - keeps the recurring runbook and durable tactical guidance fresh
- `using-superpowers`
  - reinforces proper skill discovery and activation discipline

They are recommended operating companions.

They are not the semantic foundation of `accelerate`.

`accelerate` must still make correct control-plane decisions even if the user is
not explicitly talking about those adjacent skills.

## Named Workflows And Calibration

The native workflow and calibration authorities now live in:

- [catalog.md](./core/workflows/catalog.md)
- [operational-calibration.md](./core/workflows/operational-calibration.md)
- [self-evolution.md](./core/workflows/self-evolution.md)
- [maturity-control.md](./core/workflows/maturity-control.md)

Use them when the question is not only what branch is active, but what named
execution family, proportionality, and workflow self-improvement posture should
govern the run.

## Product-Critical And Premium Surfaces

The native review authority for high-stakes user surfaces now lives in:

- [product-critical-surfaces.md](./core/review/product-critical-surfaces.md)
- [ux-ui-fullstack-surface.md](./core/review/ux-ui-fullstack-surface.md)
- [premium-interface-production.md](./core/review/premium-interface-production.md)
- [ui-mutation-ladder.md](./core/control-plane/ui-mutation-ladder.md)
- [design-implementation-proof-gate.md](./core/control-plane/design-implementation-proof-gate.md)

Do not treat these branches as generic frontend work. They require backend
truth sufficiency, stronger artifact discipline, and stricter closure judgment.

Use the UX/UI fullstack surface profile when the risk is not only visual polish
or backend correctness, but the reconciliation of backend truth, frontend state,
UX copy, visual hierarchy, and browser runtime behavior.

For design-system-driven, premium, or broad visual modernization work, default
to the shared-owner UI mutation order:

1. token authority
2. derived token wiring
3. shared primitives
4. shared composites
5. registry / examples / reference package
6. shells / layouts
7. pages / feature consumers

When the work has already produced a `docs/reference/design-system*` package
and later grows an executive rollout plan, do not assume the handoff is
complete. The implementation entrypoint must explicitly name the required
pre-read set, the immutable contract, the primary implementation driver, and
the slicing artifact for bounded execution.

When that package or premium direction mutates real UI, closure also requires
Design Implementation Proof: the owner layer, runtime target, viewport/state
coverage, artifact comparison, defect disposition, and corrected-state browser
evidence must be explicit.

Premium or de-AI design work must also use the repo-local benchmark corpus:

- [premium-design-benchmark-corpus](./skills/design-system/premium-design-benchmark-corpus/SKILL.md)

Accelerate also carries a repo-local curated DESIGN.md corpus:

- [DESIGN.md corpus](./references/design-md/README.md)

That corpus provides concrete premium examples such as Airbnb, Stripe, Linear,
Vercel, and Notion. It is reference material and influence material, not direct
implementation authority. Corpus influence must be mapped into local
`design-system.contract.md`, `design-system.theme.css`, and stable `--ds-*`
tokens before implementation.

Do not depend on external `popular-web-designs` skills or user-home design
libraries. The premium direction must include a `Benchmark Influence Map`, and
every benchmark must change a token, component family, state rule, layout rule,
or forbidden pattern. When light/dark themes are in scope, the product proof must
show one active theme at a time through the same anatomy; split-screen
`Light vs Dark System` product compositions are closure blockers.

## Root Authority

The root owns:

- classification
- prompt-hardening decisions
- issue topology
- lane opening and closing
- staffing shape
- delegation budget
- risk enforcement
- final AI review
- root closure mode
- `Done`

This authority is not delegated by default.

See:

- [root-vs-agent-authority-boundary.md](./references/codex-agents/root-vs-agent-authority-boundary.md)
- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)

## Future Bounded Agent Authority

Future bounded agents are subordinate execution or review units.

They may:

- accept a bounded slice
- stay inside their write scope
- run required validations
- perform self-review and self-forensic review
- comment on the issue with evidence
- move an issue to `In Review`
- return correction/reproof status when correcting a delegated one-shot defect

They must not, by default:

- decompose the work further
- create issues
- change issue topology
- restaff or respawn the run
- claim closure authority
- move an issue to `Done`
- treat delegated correction success as integrated closure

### Accelerate Inside A Bounded Agent

A future bounded agent may still carry `accelerate` as local execution
discipline.

Inside that bounded context, `accelerate` means:

- bounded classification of the assigned slice
- visible runtime state
- honest verification

It does not mean:

- executive routing
- staffing authority
- topology control
- closure authority

## Control-Plane Pools

The control plane reasons through explicit pools before selecting a bounded
family:

- manager lane pool
- issue topology pool
- risk detection pool
- closure blocker pool
- evidence pool
- family pool
- future-gap pool

This means the root should think about:

1. which class of decision is active
2. which lane owns that decision
3. which risk is dominant
4. which evidence class is required
5. only then whether a bounded family is useful

See:

- [agent-pooling-model.md](./references/codex-agents/agent-pooling-model.md)

## Manager Lanes

The current macro model distinguishes explicit manager lanes:

- executive routing
- technical
- lifecycle
- design-contract
- proof
- trust

These are not runtime worker roles by default.

They are root-owned managerial functions that steer the system.

See:

- [manager-lane-map.md](./references/codex-agents/manager-lane-map.md)
- [lane-governance-model.md](./references/codex-agents/lane-governance-model.md)

## Issue Topology

Issue topology is a root decision, not an implementation convenience.

The root should choose between:

- single issue
- sibling issues
- parent + child
- parent + child + review lane

The question is not "how many tickets feel nice".

The question is "what is the honest execution graph for this work".

See:

- [issue-topology-policy.md](./references/codex-agents/issue-topology-policy.md)

## Risk Enforcement

Risk is an active control-plane function.

Material risk must have:

- detector
- signal
- owner
- blocker condition
- release condition

Do not treat risk as a vague narrative warning.

If a risk becomes dominant, the corresponding lane or blocker must activate.

See:

- [risk-enforcement-model.md](./references/codex-agents/risk-enforcement-model.md)
- [risk-enforcement-matrix.md](./references/codex-agents/risk-enforcement-matrix.md)
- [active-risk-detection-signals.md](./references/codex-agents/active-risk-detection-signals.md)

## Root Closure Mode

Final closure is root-owned.

That means:

- bounded agents may return work
- bounded agents may set `In Review`
- only the root performs final revalidation
- only the root enters root closure mode
- only the root can move the issue to `Done`

The final closure question is not "did something happen".

It is "does the requested vs implemented comparison, evidence stack, issue
lifecycle, and residual-risk posture support real closure".

## Examples

### Example 1. Trivial bounded read

User asks a small engineering question with no mutation.

Expected behavior:

- `accelerate` classifies trivial
- no issue bootstrap
- no agents required
- root answers directly with honest evidence

### Example 2. Non-trivial work with no agents available

The repo has no governed `*.toml` catalog yet, but the work is still
cross-surface and issue-driven.

Expected behavior:

- `accelerate` still operates normally
- root chooses topology, lanes, and proof stack
- root executes or coordinates bounded slices locally
- no delegation is forced

### Example 3. User disables agents explicitly

The user says not to use agents for this run.

Expected behavior:

- `accelerate` respects the instruction
- root-only mode becomes active
- issue bootstrap, planning, proof, and closure still happen normally

### Example 4. No honest fit in the current pool

The work repeatedly needs a specialty not covered by the current families.

Expected behavior:

- `accelerate` does not force the least-wrong family
- root keeps the run honest
- gap detection may suggest a future agent
- no promotion happens automatically

### Example 5. Parent + child + review lane

The outcome is one coherent feature, but rollout or proof deserves separate
visibility.

Expected behavior:

- root chooses `parent + child + review lane`
- lifecycle and technical lanes open first
- review lane exists as explicit surface, not an afterthought

### Example 6. Bounded agent returns successfully

A future bounded agent completes a slice.

Expected behavior:

- it returns requested vs implemented
- it returns self-review and self-forensic review
- it comments on the issue
- it moves the issue to `In Review`
- the root still performs final AI review and closure

### Example 7. Ambiguous prompt triggers hardening first

The request is long, multi-phase, and still allows several honest execution
interpretations.

Expected behavior:

- `accelerate` does not jump into implementation
- prompt hardening runs first
- the hardened prompt exposes bounded scope and explicit non-goals
- only then does the root classify topology and staffing

### Example 8. Mutating work cannot skip the issue stack

The request mutates workflow docs, code, or living governance docs.

Expected behavior:

- `accelerate` opens the issue lane first
- issue bootstrap and planning artifact gates become visible
- execution only starts after issue and plan hygiene are satisfied
- closure still requires `AI Review Report` and root closure mode

### Example 9. Agents exist, but root-only is still the cleaner path

Agents are available, but the fit is weak and the dominant need is still root
judgment.

Expected behavior:

- `accelerate` does not delegate by habit
- root-only mode remains active
- `single-threaded exception` is emitted honestly when the run is non-trivial
- the work still follows the same proof and closure standards

### Example 10. Local workspace review preparation should not fragment

A governed target repo already has `.accelerate/`, proof is complete, and the
run is entering review or closure.

Expected behavior:

- `accelerate` does not improvise a loose sequence of readiness/artifact steps
- it prefers `prepare-review.sh` for the review handoff lane
- it prefers `prepare-closure.sh` for the closure handoff lane
- ad hoc manual sequencing is reserved for debugging the local workspace layer

### Example 11. One-shot side-by-side execution

The user asks to create a plan, create tasks, execute them in one shot, review
each task side by side, auto-correct gaps, delegate bounded correction when
useful, and perform a final forensic review.

Expected behavior:

- `accelerate` classifies the run as orchestrated non-trivial work
- `One-Shot Side-By-Side Gate` opens
- an executive plan and one-shot task ledger are created or identified
- each task receives a side-by-side requested-vs-implemented review
- in-scope defects are corrected and reproved
- delegated corrections return self-review, self-forensic review, and
  correction/reproof status
- the root performs review-of-review and final forensic reconciliation
- closure is blocked until all required packets, proof, and defect dispositions
  agree

## Common Usage Guidance

Use `accelerate` whenever the request may involve:

- repository analysis
- planning
- debugging
- implementation
- review
- workflow mutation
- documentation mutation
- issue lifecycle work
- engineering command execution

Do not bypass it merely because the task looks small.

## Reading Map

Start here:

- [SKILL.md](./SKILL.md)

Then use the local architecture docs when you want the current standalone
forward path:

- [accelerate-control-plane.md](./docs/architecture/accelerate-control-plane.md)
- [accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)

Then use the governed reference tree for supporting authority:

- [team-operating-model.md](./references/team-operating-model.md)
- [executive-operating-matrix.md](./references/executive-operating-matrix.md)
- [subagent-model.md](./references/subagent-model.md)
- [runtime-packet-templates.md](./references/runtime-packet-templates.md)
- [runtime-observability-cadence.md](./references/runtime-observability-cadence.md)
- [branch-enforcement-matrix.md](./references/branch-enforcement-matrix.md)
- [issue-stack.md](./references/issue-stack.md)
- [qa-proof-stack.md](./references/qa-proof-stack.md)

Current native execution/review protocol additions:

- [one-shot-side-by-side-protocol.md](./core/review/one-shot-side-by-side-protocol.md)
- [one-shot-task-ledger-template.md](./planning/execution/one-shot-task-ledger-template.md)

Current native fullstack profile additions:

- [nextjs-prisma](./profiles/nextjs-prisma/README.md)
- [nextjs-drizzle](./profiles/nextjs-drizzle/README.md)
- [nextjs-adonis-adminjs](./profiles/nextjs-adonis-adminjs/README.md)

For the governed future-agent ecosystem:

- [codex-agents/README.md](./references/codex-agents/README.md)

## Platform Source Of Truth

For this standalone repository:

- repo source of truth:
  - the files tracked here
- runtime export:
  - optional generated copies created from this repository when a runtime needs
    them

This README describes the standalone product model first.

Runtime export remains a separate deployment step.

Do not treat any runtime export or user-home path as the authoring source for
governed `accelerate` behavior.

## Current Distribution Reality

The current default distribution is still strongly shaped by the incubator
stack that matured `accelerate` first.

That is a distribution and migration fact, not the permanent boundary of the
platform core.

Treat:

- workflow backend assumptions
- stack assumptions
- runtime command assumptions
- project-specific docs posture

as material that will progressively move into adapters, profiles, and overlays.

## Current Repository Shape

The repository is no longer only a transitional import tree.

The first standalone shell of the target architecture now exists:

- `core/`
- `adapters/`
- `profiles/`
- `agents/`
- `onboarding/`
- `overlays/`
- `planning/`
- `skills/`
- `tests/`

These directories currently act as contract-bearing shells while the inherited
doctrine is still being rehomed out of `references/`.

The repository also now carries executable doctrine checks for profile and
one-shot protocol integrity. Run the relevant suite before claiming closure on
governance changes:

- `bash tests/doctrine-integrity.sh`
- `bash tests/profile-integrity.sh`
- `bash tests/one-shot-protocol-integrity.sh`
- `bash tests/one-shot-protocol-semantic.sh`
- `bash tests/one-shot-protocol-delegation.sh`
- `bash tests/one-shot-protocol-closure.sh`

## Repository Bootstrap Context

This repository also carries standalone bootstrap and architecture context for
the extraction and early platform build-out:

- [docs/bootstrap/context-and-origin.md](./docs/bootstrap/context-and-origin.md)
- [docs/bootstrap/decisions-and-final-state.md](./docs/bootstrap/decisions-and-final-state.md)
- [docs/bootstrap/prd-initial-platform-foundation.md](./docs/bootstrap/prd-initial-platform-foundation.md)
- [docs/architecture/accelerate-sdd-v1.md](./docs/architecture/accelerate-sdd-v1.md)
- [docs/architecture/accelerate-classification-matrix.md](./docs/architecture/accelerate-classification-matrix.md)
- [docs/architecture/accelerate-migration-plan.md](./docs/architecture/accelerate-migration-plan.md)
- [docs/architecture/accelerate-onboarding-model.md](./docs/architecture/accelerate-onboarding-model.md)
- [docs/architecture/accelerate-pre-agents-baseline.md](./docs/architecture/accelerate-pre-agents-baseline.md)
