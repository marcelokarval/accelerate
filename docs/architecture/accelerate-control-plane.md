# Accelerate Control Plane

## Purpose

This document is the canonical architecture source for the standalone
`accelerate` control plane.

It exists to stop the full operating model from living only in:

- operator memory
- the root skill body
- Docusaurus pages
- adjacent workflow docs

`accelerate` is the always-on runtime root control plane for engineering work.
It classifies the run, chooses the dominant branch, loads the minimum correct
skill chain, and blocks closure until review and forensic revalidation are
complete.

For non-trivial issue-driven work, this control plane also blocks execution
until a post-issue planning artifact exists. Issue bootstrap alone is not
enough to authorize implementation.

This document does not replace:

- the installed root skill
- adjacent specialized skills
- repo review policy
- current workflow-adapter execution policy

It explains how those pieces fit together as one operating system.

## Canonical Layering

Read the system in this order:

1. repo policy in [AGENTS.md](../../AGENTS.md)
2. this control-plane architecture doc
3. the installed `accelerate` root skill
4. adjacent workflow docs and specialized skills

The corresponding public-facing docs should point back here instead of becoming
their own competing source of truth.

When a new runtime reference module is promoted into the `accelerate`
ecosystem, the public-facing reference inventory must be updated in the same
batch.

Do not allow the runtime reference set and the public module list to drift.

This includes new branch-critical skills. When a new skill becomes part of a
mandatory branch bundle, the public catalog and activation matrix must be
updated in the same batch.

The same rule applies to branch-critical frontend enforcement. When the
frontend branch gains a new mandatory skill, gate, or source-ladder
requirement, both the repo runtime matrix and the public catalog/docs must be
updated in the same batch.

## What Accelerate Is

`accelerate` is:

- the entry classifier for engineering work
- the branch router for non-trivial execution
- the orchestrator of the minimum valid skill stack
- the owner of phase discipline
- the governor of subagent use
- the enforcer of final forensic closure

`accelerate` is not:

- an implementation skill
- a replacement for adjacent domain or stack skills
- an autonomous swarm runtime
- proof that a workflow happened just because the skill was named

## Explicit Aliases

The control plane recognizes these as aliases over the existing model, not as
competing frameworks:

- `SDD` = `Spec Driven Development`
  - maps to the existing `Spec -> Design -> Plan -> Implement -> Verify -> Release or Follow-up` overlay
- `RPI` = `Research -> Plan -> Implement`
  - maps to the operational path where research happens in `Frame` and `Load`,
    execution shape is fixed in `Plan`, and code lands in `Execute`
- `PO`
  - maps to existing personas rather than a separate role class
  - `Specification PM` owns actor/goal/value/spec clarity
  - `Product Planner` owns scope split, task shape, and parent/child decomposition

## Invocation Model

There are two valid invocation shapes.

### Active Invocation

```text
User explicitly names accelerate
  -> accelerate must be loaded
  -> accelerate becomes the visible root
```

### Passive Invocation

```text
Work is engineering
  -> repo policy still requires accelerate classification
  -> accelerate remains the runtime root even if the user did not name it
```

This means:

- trivial work may downshift quickly under the same root
- non-trivial work should still expose a visible `accelerate` manifest
- recurring repo-specific guidance from `napkin` should remain above the chain
  rather than being treated as an optional late-load

## Validation Gate Matrix

Validation in `accelerate` is slice-aware, not memory-based.

For backend schema/runtime-sensitive work, the minimum stack is defined at the
capability level first:

1. backend runtime/config checks
2. model/migration drift checks
3. unapplied migration checks

These prove different things:

- `check`
  - Django system/config/runtime checks
- `makemigrations --check --dry-run`
  - model drift without a generated migration
- `migrate --check`
  - unapplied migrations already present in the codebase

For frontend-bearing or TypeScript contract-bearing work, the minimum frontend
gate is frontend type/contract validation in the active stack profile.

For full-stack work, both gate sets apply.

Treat closure without the applicable gate set as workflow failure, not as
acceptable operator discretion.

## Root-Owned Closure Mode

The current control plane now treats closure as a root-owned mode instead of
relying on vague "review later" language or a delegable closure lane.

Use these roles and skills distinctly:

- `requesting-code-review`
  - local pre-commit verification for unmerged diffs
- `github-code-review`
  - review of already-published PR diffs
- `dogfood`
  - exploratory browser QA and issue capture when runtime truth is the main need
- `product-runtime-review`
  - judgment of runtime-facing product correctness
- `verification-before-completion`
  - final closure-verdict gate when the question is whether the work can
    honestly be called done

Do not collapse these into a single generic "tested/reviewed" claim.
These are review and verification surfaces, not substitutes for root closure
authority.

## Concrete MCP / Integration Lane

The current control plane also has a clearer integration-discovery lane.

Use these roles and skills distinctly:

- `native-mcp`
  - durable Codex-native MCP configuration in `~/.codex/config.toml`
- `mcporter`
  - ad-hoc MCP inspection, auth, and direct tool calls without committing to
    runtime config first
- `github-auth`
  - choose and verify the real GitHub access path
- `github-issues`, `github-pr-workflow`, `github-code-review`,
  `github-repo-management`
  - operational GitHub task lanes after the auth/config posture is clear

This lane matters because access-path choice is part of execution truth, not a
mere setup footnote.

## Local Smoke Credential Lookup

For this repo, when browser smoke or MCP runtime validation needs the local
test login and the shell does not already expose it, the canonical lookup path
is:

- `backend/envs/.env.development`

Read the variables from that file instead of guessing or concluding the login
is missing.

Do not copy the credential value into docs or workflow summaries. Record the
file path and variable names, then read the secret from the env source only
when the active validation step actually needs it.

## Classification Contract

Every engineering run should be classified explicitly.

```text
if small + bounded + low-risk + no real orchestration need
  -> trivial
else
  -> non-trivial
```

### Trivial

Use the bounded direct path when:

- the slice is narrow
- the implementation is local
- review needs are light
- orchestration overhead would be waste

### Non-Trivial

Use the full root orchestration path when:

- multiple surfaces or layers are involved
- planning or issue structure matters
- stack-sensitive review lenses apply
- product/runtime proof is needed
- abuse, contract, or governance drift is plausible

Trivial and non-trivial are both branches beneath the same runtime root.

For the minimum required stack in trivial execution, see:

- `docs/codex-skill-seeds/skills/accelerate/references/trivial-branch-contract.md`

## Control Plane Flow

```text
┌──────────────────────────────────────────────────────────────┐
│ Request arrives                                             │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 1. Classification                                            │
│ trivial vs non-trivial                                       │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 1.5 Napkin re-anchor                                          │
│ recurring repo guidance above chain                           │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 2. Prompt hardening gate                                     │
│ required when the request is ambiguous, long, epic-like,     │
│ architectural, or otherwise not execution-ready              │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 3. Branch Entry Packet                                       │
│ classification + branch + stack + gates + artifacts          │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 4. Branch routing                                            │
│ choose dominant workflow and minimum skill stack             │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 5. Post-issue planning gate                                  │
│ required for non-trivial issue-driven work                   │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 6. Bounded execution                                         │
│ batches + micro-review + follow-ups for residuals            │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 7. Verification and forensic review                          │
│ quality lenses + recursive scan + review-of-review           │
└──────────────────────────────────────────────────────────────┘
                              |
                              v
┌──────────────────────────────────────────────────────────────┐
│ 8. AI Review / close / follow-up                             │
└──────────────────────────────────────────────────────────────┘
```

## Phase Model

Operationally, the root behaves in these phases:

1. `Frame`
2. `Load`
3. `Classify`
4. `Plan`
5. `Execute`
6. `Gate`
7. `Final Forensic Review`
8. `Deliver`

## Post-Issue Planning Gate

This gate applies when all of these are true:

- the run is non-trivial
- the run is issue-driven
- the run is expected to mutate code, workflow, or living docs

The gate requires an integrated planning artifact created after issue bootstrap
and before execution.

That artifact must make visible at least:

- bounded slices
- dependency order
- blocking gates
- required evidence
- expected validations
- closure blockers

Moving from issue bootstrap directly into implementation without this artifact
is workflow failure and must be named as `execution-drift`.

### Phase Meanings

#### `Frame`

- understand the real request
- detect stack, product, contract, runtime, and abuse sensitivity
- re-anchor recurring repo-specific guidance from `napkin`
- gather the minimum context that makes routing defensible

#### `Load`

- discover candidate skills broadly, then activate the minimum useful adjacent
  skills
- do not inflate context with unrelated playbooks

#### `Classify`

- choose trivial vs non-trivial
- choose the dominant entry branch
- decide whether delegation is justified

#### `Plan`

- define bounded slices
- map dependencies
- define expected evidence
- keep issue shape and execution shape aligned

#### `Execute`

- implement in bounded batches
- keep review checkpoints active
- create follow-ups for real residuals instead of hiding them

#### `Gate`

- apply the required quality lenses
- re-check contracts, metadata, runtime promises, and branch obligations
- if `prompt-hardening` was required, verify the run surfaced the hardened
  artifact rather than only mentioning the gate

## Prompt-Hardening Satisfaction Rule

When `prompt-hardening` is active, the gate is not satisfied by commentary such
as "using prompt-hardening" alone.

The run must visibly expose one bounded artifact:

- `Hardened Prompt`
- `Execution-Ready Prompt`
- `Execution-Ready Prompt Packet`

At minimum, that artifact should make explicit:

- `Prompt A`
- `Prompt B`
- the actual problem being solved
- bounded in-scope work
- explicit non-goals
- the next workflow branch or active skill chain
- mandatory quality lenses already known

`Prompt A` is the raw or minimally normalized prompt being hardened.

`Prompt B` is the bounded execution-ready prompt actually governing the run.

A summary-only artifact is insufficient. The control plane should treat missing
transformation proof as an unsatisfied `Prompt Hardening Gate`.

Missing this artifact is a workflow defect and should be reviewable as a gate
failure.

## Sandbox Bootstrap Failure Classification

`accelerate` must distinguish sandbox bootstrap failure from command-specific
denial.

Known concrete example:

- Ubuntu 24.04 with `kernel.apparmor_restrict_unprivileged_userns=1`
- AppArmor denies `bwrap` or the Codex vendored sandbox binary under the
  `unprivileged_userns` profile
- sandboxed shell commands then fail before execution with
  `bwrap: setting up uid map: Permission denied`

In that state, `accelerate` should classify the event as a host/runtime
sandbox bootstrap failure and stop narrating it as if each individual command
had been denied on sensitivity grounds.

The canonical host remediation lives in
[codex-sandbox-bootstrap-apparmor-playbook.md](/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/docs/operations/codex-sandbox-bootstrap-apparmor-playbook.md).

## Repeatable Issue Hygiene Audits

When issue-driven drift appears to be recurring rather than local, the control
plane should stop relying on anecdotal cleanup and switch to the repo protocol
in the current-default workflow hygiene protocol, still documented through
`linear-execution.md` until dedicated workflow adapters are fully rehomed.

That protocol is the repeatable path for:

- recent date-window audits
- parent/child package audits
- post-run closure hygiene checks

#### `Final Forensic Review`

- verify with fresh evidence
- compare requested vs implemented
- compare promised vs delivered
- compare issue scope vs actual landing
- review prior reviews instead of trusting them blindly

#### `Deliver`

- summarize what landed
- state what was validated
- state residual risk or follow-up truthfully

## SDLC Overlay

The root also carries a specification-driven overlay:

```text
Spec
  -> Design
  -> Plan
  -> Implement
  -> Verify
  -> Release or Follow-up
```

The intended mapping is:

| Operational phase | SDLC overlay |
| --- | --- |
| `Frame` | `Spec` |
| `Load` + `Classify` | `Design` |
| `Plan` | `Plan` |
| `Execute` | `Implement` |
| `Gate` + `Final Forensic Review` | `Verify` |
| `Deliver` | `Release or Follow-up` |

This mapping matters because the same run can be operationally fast but still
fail at specification maturity.

## Entry Branches

The root currently recognizes these 12 main branches:

1. trivial bounded
2. ambiguous / long / epic-like
3. issue-driven delivery
4. bug / failure / regression
5. architecture / governance doubt
6. admin / operator / unfold surface
7. runtime / product-heavy flow
8. copy / locale / translation-boundary
9. product-critical user surface
10. visual / artifact-driven frontend
11. query / contract-sensitive backend
12. transport / dependency / legacy-adaptation doubt

## Branch Authority

The root skill is the control-plane entrypoint.

The primary authority for branch enforcement is:

- [Accelerate Branch Enforcement Matrix](accelerate-branch-enforcement-matrix.md)

Use the matrix as the source of truth for:

- mandatory branch skills
- mandatory gates
- expected artifacts
- expected evidence
- closure blockers

The root skill may summarize branch bundles, but it should not compete with the
matrix for enforcement authority.

### Branch Router

```text
accelerate
├── trivial bounded path
├── ambiguous / long / epic-like
│   └── prompt-hardening
├── issue-driven delivery
│   ├── active workflow adapter
│   ├── linear-implementation-planner
│   └── executing-plans
├── bug / failure / regression
│   └── systematic-debugging + stack lenses
├── architecture / governance doubt
│   ├── architecture
│   ├── governance-audit
│   └── p4y-stack-constitution
├── admin / operator / unfold surface
│   ├── django-unfold
│   └── django-pro
├── runtime / product-heavy flow
│   ├── product-runtime-review
│   └── anti-abuse-review when needed
├── copy / locale / translation-boundary
│   ├── i18n-patterns
│   └── server-prop-governance
├── product-critical user surface
│   ├── product-runtime-review
│   ├── server-prop-governance
│   ├── ascii-wireframe
│   └── domain-sensitive skills
├── visual / artifact-driven frontend
│   ├── front-react-shadcn
│   ├── frontend-boundary-governance
│   ├── tailwind-design-system
│   ├── ascii-wireframe
│   └── premium-interface-production when needed
├── query / contract-sensitive backend
│   ├── django-service-patterns
│   ├── django-inertia-integration
│   ├── server-prop-governance
│   ├── sql-optimization-patterns
│   └── financial-source-truth when needed
└── transport / dependency / legacy-adaptation doubt
    ├── api-surface-governance
    ├── dependency-governance
    ├── legacy-transplant
    └── legacy-first-protocol
```

The selected branch defines:

- mandatory child skills
- mandatory gates
- evidence expectations
- likely quality lenses

When there is any conflict between a summary and the matrix, the matrix wins.

## Branch Entry Packet

Non-trivial runs should make the selected path visible early.

Minimum packet:

- `classification`
- `active branch`
- `active persona`
- `active stack`
- `active skills`
- `active ADRs / references`
- `gate ledger`
- `phase / SDLC`
- `persona handoff artifact`
- `mandatory gates`
- `required artifacts`
- `closure blockers`

For engineering runs that are expected to mutate code, workflow seeds, or
living docs, the packet must also include:

- `issue bootstrap`
- `governing issue`
- `bootstrap exception reason` when applicable

When `prompt-hardening` is triggered, the required artifacts must also include
one visible hardened artifact:

- `Hardened Prompt`
- `Execution-Ready Prompt`
- `Execution-Ready Prompt Packet`

That artifact must expose a visible `Prompt A -> Prompt B` transformation.

When the hardened prompt is too large for full inline repetition, the visible
packet must still expose:

- a compact `Prompt A`
- a compact `Prompt B`
- a visible pointer to the full hardened artifact location

## Runtime Observability

`accelerate` should not operate as an invisible root.

The active runtime stack must stay visible to the operator.

### Opening Packet

The first technical update should make visible:

- `active skills`
- `active ADRs / references`
- `gate ledger`
- `phase / SDLC`

### Runtime Delta

Whenever the active runtime stack changes, the next update should expose a
compact delta containing:

- `skills added` / `skills removed`
- `ADRs / references added` / `ADRs / references removed`
- `gates opened` / `gates passed` / `gates failed`
- `phase transition`

Long-running work should not degrade into opaque progress lines that hide the
active stack or current gates.

If subagents participate, also declare:

- `subagents`
- `parallelism budget`
- `subagent scopes`
- `write scope` or `read-only scope`
- `nested delegation`
- `subagent completion contracts`
- `master revalidation`

See also:

- [Accelerate Branch Enforcement Matrix](accelerate-branch-enforcement-matrix.md)
- [Workflow Execution Chain Manifest](workflow-execution-chain-manifest.md)
- [Subagent Delegation and Master Revalidation](subagent-delegation-and-master-revalidation.md)

## Issue Bootstrap Gate

The control plane now treats issue bootstrap as a blocking gate for engineering
mutation.

If the run is going to mutate code, workflow seeds, or living docs, it must do
one of these before implementation begins:

- attach to an existing execution-ready governing issue
- create the governing issue or parent/child package first
- expose an explicit, narrow, user-approved no-issue exception

What is no longer acceptable:

- starting implementation and creating the issue later
- treating lifecycle, commit traceability, and review as optional because the
  issue did not exist yet
- retroactively naming the run "issue-driven" after work already happened

This gate is enforced through:

- the root `accelerate` skill
- the branch enforcement matrix
- active workflow adapter
- `linear-execution`
- the workflow execution manifest

## Private Route Family Audit

For visual/frontend work that introduces, restructures, or extends subroutes
inside an existing `private/<domain>/...` route family, require a visible
`Private Route Family Audit`.

The audit should answer:

- what local layout or shell already exists for the route family
- whether the family already behaves like a hub, shell, or tabbed surface
- which comparable `private/` route families were inspected as precedents
- whether the target surface is correctly classified as:
  - standalone page
  - shared-shell subroute
  - tab inside the same hub
- whether the implementation preserves the existing domain entry surface instead
  of replacing it with a sibling landing page

This is an enforcement rule, not a styling preference.

## Persona Model

The formal persona catalog is:

1. `Specification PM`
2. `Product Planner`
3. `Implementation Designer`
4. `Implementer / Developer`
5. `Delivery PM`
6. `Runtime/Product Reviewer`
7. `Governance Auditor`
8. `Closure / Forensic Reviewer`
9. `Master Integrator`

These are operating roles, not proof that separate agents exist.

The full model also supports specialist personas such as backend/frontend QA,
browser-proof, persistent E2E, anti-abuse, observability, contract stewardship,
legacy truth extraction, and release/handoff management when the branch demands
them.

For the one-page executive summary view of the entire operating model, see:

- `docs/codex-skill-seeds/skills/accelerate/references/executive-operating-matrix.md`

Additional specialist roles also include backend/frontend implementers,
constitution auditing, recovery-surface review, migration stewardship,
compliance/policy review, fixture stewardship, and incident/hotfix command when
the branch needs them.

### Practical Read

```text
Specification PM
  -> clarify actor / goal / acceptance

Product Planner
  -> scope shape, parent/child, rollout order

Implementation Designer
  -> bounded slices and execution design

Implementer / Developer
  -> code mutation, bounded implementation trade-offs, implementation proof

Delivery PM
  -> checkpoint discipline, issue lifecycle hygiene

Runtime/Product Reviewer
  -> browser truth, product correctness

Governance Auditor
  -> stack adherence, contract and truth drift

Closure / Forensic Reviewer
  -> side-by-side reconciliation, residual classification

Master Integrator
  -> global authority and final judgment
```

## Subagent And Parallelism Model

`accelerate` is subagent-aware and the governed seed now treats multi-agent
execution as the default posture for non-trivial work.

Subagents are bounded collaborators for:

- implementation slices
- planning sidecars
- governance audits
- runtime/browser reviews
- verification sidecars

For non-trivial work:

- prefer bounded subagents when they create honest value
- if there is no safe implementation split, prefer a proof, review,
  governance, browser, or verification sidecar
- if no delegation shape is honest, keep the run root-owned
- if the run still remains fully single-threaded, emit an explicit
  `single-threaded exception` in the runtime packet

Every spawned subagent should start by loading `accelerate` again as the entry
classifier for its own slice, then leave self-review and self-forensic review
output before returning.

### Default Rules

- the master owns the global plan
- the master owns final integration correctness
- the master owns final forensic closure
- nested delegation is forbidden unless explicitly approved

### Parallelism Budget

```text
0 subagents
  -> only for trivial bounded work or explicit single-threaded exception

1 subagent
  -> one meaningful sidecar or the minimum valid non-trivial delegation

2-3 subagents
  -> independent bounded slices with real integration value

>3
  -> requires strong explicit justification
```

### Delegated Run

```text
Master run
  -> decide branch
  -> define Subagent Delegation Manifest
  -> spawn bounded subagents
       -> each executes assigned slice
       -> each self-reviews
       -> each self-forensic-reviews
  -> master reviews child outputs
  -> master integrates
  -> master performs final closure
```

See also:

- [Subagent Delegation and Master Revalidation](subagent-delegation-and-master-revalidation.md)

## Skill Activation Rule

The current intended rule is:

```text
discover broadly
  -> activate minimally
```

That means:

- if a skill might matter, it should be inspected
- after inspection, only the minimum valid skill stack should remain active for
  the chosen branch

This resolves the apparent tension between broad skill discovery and minimal
active orchestration.

This avoids two opposite failures:

- missing a necessary playbook
- loading half the catalog with no operational reason

## Transversal Workflows

The control plane also carries transversal workflows that cut across the entry
branches:

### Specification Workflow

```text
Spec
  -> Design
  -> Plan
  -> Implement
  -> Verify
  -> Release or Follow-up
```

### Review Workflow

```text
micro-review
  -> branch review
  -> integration review
  -> forensic review
  -> closure review
  -> review-of-review
```

### Autoresearch / Self-Evolution

```text
Failure capture
  -> root cause
  -> pattern test
  -> promotion decision
  -> insertion plan
```

### Subagent Workflow

```text
Decide spawn
  -> bound scope
  -> subagent execution
  -> subagent self-review
  -> master review
  -> integration
  -> final forensic closure
```

## Quality Lenses And Review Architecture

`accelerate` does not close work on technical correctness alone.

Depending on the branch and surface, the run may require:

- `Product Correctness`
- `Anti-Abuse`
- `Contract Correctness`
- `Frontend Structure Correctness`
- `Backend Query Correctness`
- `Stack Adherence`

The relevant review architecture is:

```text
micro-review
  -> branch review
  -> integration review
  -> forensic review
  -> closure review
  -> review-of-review
```

The final reconciliation must compare:

- requested vs implemented
- promised vs delivered
- issue scope vs actual landing
- review claim vs reality

See also:

- [AI Review Recursive Scan Protocol](ai-review-recursive-scan-protocol.md)
- [Quality Stack and Runtime Review](quality-stack-and-runtime-review.md)

## Product-Critical And Runtime-Sensitive Work

When the surface is user-facing and the cost of being merely "technically
correct" is high, the branch must treat product/runtime proof as first-class.

Typical examples:

- auth
- onboarding
- billing
- settings
- staged forms
- premium visual surfaces

In those cases:

- browser truth comes before narrative
- product-runtime review is not optional
- anti-abuse review becomes mandatory when the flow is abuse-sensitive

## Failure Taxonomy

Serious misses should be classified instead of hand-waved.

Useful classes include:

- `missing-rule`
- `enforcement-failure`
- `routing-failure`
- `review-failure`
- `closure-failure`
- `execution-drift`

This classification is especially important when deciding whether a miss should
stay local or be promoted into workflow hardening.

## Audit Judgment Vocabulary

Workflow audits must label conclusions according to evidence strength.

- `exact`: use only when the claim is backed by operational proof, executed
  validation, runtime behavior, or other direct evidence from real runs
- `documentarily-strong`: use when the skill, docs, and declared contracts are
  strong and aligned, but the claim was not proven through operational
  execution in the audit slice
- `partial`: use when important parts remain unproven or materially soft
- `stale`: use when the judgment or references no longer match live workflow
  truth

Documentary review alone does not justify `exact`.

## Workflow Change Approval

When the proposed change would mutate workflow truth itself, the run should use
an explicit `Workflow Change Approval Gate`.

This applies to changes in:

- `accelerate`
- adjacent workflow skills
- workflow enforcement docs
- stack-level workflow constitutions

The gate requires:

- a visible evidence packet
- explicit human approval in the session or in already-approved governing issue
  policy that itself has prior explicit human authorization
- runtime/seed synchronization proof when repo-managed skills were changed

Agent-authored issue detail is not approval by itself.

## Living-Docs And Seed Sync

The control plane lives across:

- repo docs
- repo-managed skill seeds
- installed global skills under `~/.codex/skills/`

When a hardening package changes repo-managed skills, final closure should
verify both:

1. repo seeds are updated
2. the installed global mirror in `~/.codex/skills/` was synchronized

This check belongs in the final parent review when the package affects the
global skill runtime.

## Related Docs

- [Accelerate Adjacent Skill Trigger Audit](accelerate-adjacent-skill-trigger-audit.md)
- [Accelerate Branch Enforcement Matrix](accelerate-branch-enforcement-matrix.md)
- [Accelerate Workflow Change Approval Gate](accelerate-workflow-change-approval-gate.md)
- [Workflow Execution Chain Manifest](workflow-execution-chain-manifest.md)
- [Subagent Delegation and Master Revalidation](subagent-delegation-and-master-revalidation.md)
- [AI Review Recursive Scan Protocol](ai-review-recursive-scan-protocol.md)
- [Quality Stack and Runtime Review](quality-stack-and-runtime-review.md)
- [Accelerate Operational Model](../../frontends/docusaurus/docs/ai/accelerate-operational-model.md)
- [Accelerate-Based Codex Agents](../../frontends/docusaurus/docs/ai/accelerate-based-codex-agents.md)
### Issue Stack Workflow

```text
accelerate
  -> Issue Bootstrap Gate
  -> active workflow adapter
  -> planning artifact gate
  -> executing-plans
  -> QA / browser-proof / E2E
  -> AI Review Report
  -> Done
```

### QA / Proof Workflow

```text
Implement
  -> Backend QA
  -> Frontend QA
  -> Browser-Proof (Chrome DevTools)
  -> Persistent E2E (Playwright)
  -> Forensic closure
```

### Runtime Observability Workflow

```text
Branch Entry Packet
  -> Runtime Delta Packet(s) on stack change
  -> Prompt Hardening Packet when active
  -> Subagent Return Packet(s)
  -> QA / Proof Packet(s)
  -> Closure Packet
```

Templates and cadence live in:

- `docs/codex-skill-seeds/skills/accelerate/references/runtime-packet-templates.md`
- `docs/codex-skill-seeds/skills/accelerate/references/runtime-observability-cadence.md`

### Full Workflow Catalog

The richer catalog for future agent derivation lives in:

- `docs/codex-skill-seeds/skills/accelerate/references/workflow-catalog.md`
