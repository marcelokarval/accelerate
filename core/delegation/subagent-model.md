# Subagent Model

## Purpose

Use this module when deciding whether delegation should happen and how it must
be governed.

## Core Rule

Subagents are bounded collaborators. They do not replace the master
orchestrator.

For non-trivial execution, the default posture is orchestrator-first: the root
hardens, owns SDD/PRD and the task graph, dispatches, fans in, integrates,
reviews the review, and owns closure. Root does not execute task-owned scopes.
Operationally, root does not execute task-owned scopes after dispatch.
After `DISPATCH_REQUIRED`, physical execution is mandatory when collaboration is
available; see the [Post-Spec Delegation Dispatch Gate](../control-plane/post-spec-delegation-dispatch-gate.md)
and its `delegation-dispatch-receipt.schema.json` receipt.

The master always owns:

- the global plan
- integration correctness
- final review
- final forensic closure

The master also owns review isolation: an implementation worker's self-review is
not an acceptance review, and a reviewer sidecar's conclusion is not final
closure.

## Safe Role Catalog

Useful subagent shapes:

- architecture / design reviewer
- implementation worker
- decomposition or planner sidecar
- governance auditor
- trust / anti-abuse reviewer
- runtime or browser reviewer
- verification sidecar
- QA / regression reviewer
- provider-boundary implementation worker

## Orchestrator Routing Flow

When Accelerate is called as an orchestrator, it does not hand work to generic
agents first. It routes each task from the executive plan or task ledger through
this sequence:

1. classify the task surface: architecture, backend, frontend, data, security,
   QA/proof, docs, workflow, product/runtime, or provider-boundary
2. classify the task phase: planning, implementation, review, correction,
   reproof, or closure
3. classify the dominant risk: integration, runtime correctness, security,
   performance/query shape, UX/product, governance, or release safety
4. choose the smallest honest role family that owns that surface, phase, and risk
5. when the host is Codex collaboration, resolve the explicit model/effort and
   assignment allowlists through
   `adapters/runtime/codex-collaboration/role-policy.json`; do not inherit the
   root model by omission
6. bind the role to a physical subagent only when a matching promoted agent or
   runtime adapter exists
7. use virtual delegation only with `collaboration_unavailable` or
   `spawn_failed_operator_authorized`; it never substitutes for available
   physical dispatch
8. keep master-owned architecture and closure decisions out of delegated
   acceptance authority

The routing output must name:

- task id
- selected role family
- physical agent, virtual role, or root-owned exception
- required skills or profile surfaces
- write scope or read-only scope
- return contract
- review counterpart
- cleanup expectation after return

For Codex collaboration, tools, skills, and MCPs remain assignment-contract
allowlists because the host does not enforce a per-subagent tool boundary. Do
not represent this as technical isolation. `direct-fast-path` never reaches a
physical binding. Root execution after `DISPATCH_REQUIRED` is prohibited;
`single-threaded exception is a blocker`, not a route permission.

Do not route by title alone. For example, a task named "review dashboard" may be
QA/proof, product/runtime, accessibility, or architecture depending on the proof
needed.

## Role Family Routing Matrix

Use this matrix as the default routing policy:

| Task signal | Preferred role family | Typical authority | Review counterpart |
| --- | --- | --- | --- |
| architecture boundary, ADR, migration shape, dependency direction | architecture / design reviewer | read-only analysis or design packet | governance auditor or master review-of-review |
| backend behavior, services, data contracts, migrations, query shape | backend implementation worker or backend reviewer | bounded code change or backend proof | QA/proof or security reviewer |
| frontend UI, state, component hierarchy, visual contract | frontend implementation worker or frontend reviewer | bounded code change or visual proof | QA/browser reviewer or product/runtime reviewer |
| tests, regression, validation commands, browser proof, closure evidence | QA / regression reviewer | read-only or test-only proof | master review-of-review |
| auth, billing, ownership, abuse, untrusted ingress, secrets | security / anti-abuse reviewer | read-only skeptical review unless correction is explicitly bounded | master plus affected stack reviewer |
| docs, workflow seeds, runtime packets, local workspace gates | governance auditor | bounded docs/workflow edit or audit | master review-of-review |
| external provider, source observation, runtime adapter change | provider-boundary implementation worker | bounded Terra/medium change or observation proof | architecture/governance reviewer |

If two role families are plausible, prefer the one that owns the dominant risk,
not the one that matches the file extension. If no role owns the dominant risk,
use the `No-Honest-Family Rule` instead of inventing an agent.

## Persona-To-Subagent Mapping

Safe defaults:

- master-only
  - `Master Integrator`
  - `Closure / Forensic Reviewer`
  - `Delivery PM`
- delegate-possible
  - `Implementation Designer`
  - `Runtime/Product Reviewer`
  - `Governance Auditor`
  - trust / anti-abuse reviewer
  - runtime proof auditor
- master-preferred
  - `Specification PM`
  - `Product Planner`

## Fit Scoring

Before assigning a subagent, score the fit across:

- surface fit
- phase fit
- risk fit
- profile/skill fit
- write-scope fit
- integration cost

A role is valid only when it fits the dominant surface and risk. A weak role
name must not be used to hide missing ownership.

## No-Honest-Family Rule

If the dominant risk has no honest current owner, do not choose the least-wrong
subagent.

Instead:

- keep the risk master-owned
- emit the explicit gap in the runtime packet
- route the correction through architecture, governance, self-evolution, or a
  future-agent/family proposal
- avoid treating gap discovery as proof that a new agent already exists

This is especially important for source-observer, provider-boundary,
scheduled-runtime, rollout, and migration-stewardship risks.

## Spawn Criteria

## Execution Route Budget

Choose the route before assigning a role:

- Direct Fast Path: `0` physical or virtual subagents. The root executes known,
  low-risk, focal work directly; a sidecar always escalates the route to Scoped.
- Scoped: at most `1` sidecar for bounded discovery, current research, or
  independent proof whose value exceeds its handoff cost. The root may perform
  the bounded task-owned implementation; the read-only sidecar must not hide or
  perform it.
- Orchestrated: require `2-3` physical executor/reviewer bindings, a dispatch
  receipt, non-overlapping write scopes, and an explicit fork per child before
  task-owned execution.

Orchestrated: use `2-3` subagents only when there are two or more independent
lanes, write scopes do not overlap, and the dispatch receipt confirms physical
binding availability. Once selected for execution, this is a requirement rather
than a discretionary target.

Routes do not follow file count, UI presence, or agent availability. A task may
touch multiple files and remain direct when the target, risk, and proof stay
bounded.

For non-trivial work, prefer bounded delegation when it creates honest value.
When collaboration is unavailable, or a spawn fails with operator authorization,
use virtual delegation packets rather than collapse execution and acceptance.
The only exceptions are `explicit_user_opt_out`, `collaboration_unavailable`,
and `spawn_failed_operator_authorized`, each with evidence and compensation.

Delegation should trace back to the `Reasoning Effort Gate`:

- `low`: direct-fast-path or scoped may be root-owned
- `medium`: direct-fast-path or scoped may be root-owned or use one bounded
  sidecar when it improves proof or latency
- `high`: consider specialized implementation, review, governance, security, or
  browser/proof sidecars when slices are independent
- `xhigh`: keep root orchestration explicit and use specialists only for bounded
  evidence gathering or review

Agent count is not reasoning effort. Do not spawn agents merely because effort is
high, and do not use a vague agent to compensate for unclear criteria. These
effort defaults never waive orchestrated physical dispatch after `TASKS_READY`.

Default expectation:

- if there is an independent implementation slice with clear bounded value ->
  spawn an implementation worker
- if there is no safe implementation split but there is clear proof/review value
  -> spawn a review, browser, governance, or verification sidecar
- if neither physical nor virtual separation is honest -> use direct-fast-path
  or scoped root ownership when their route conditions hold; orchestrated work
  instead remains blocked behind its explicit exception receipt

## Virtual Subagent Rule

A virtual subagent is not a claim that a live agent exists. It is a packeted role
pass used to preserve review isolation in standalone or pre-agents runtime.

It is legitimate only for direct-fast-path/scoped work or as blocked
compensation under an allowed exception. It never lets orchestrated execution
after `TASKS_READY` and available collaboration replace physical dispatch.

Virtual executor passes must include:

- assigned task scope
- write scope or read-only scope
- implementation evidence
- self-review
- self-forensic review
- residual risks

Virtual reviewer passes must include:

- reviewed task scope
- executor evidence inspected
- independent skeptical checks
- findings or no-finding rationale
- `met|partial|missed|blocked` judgment

The master must still review the virtual review quality before closure.

## Physical Binding and Nested Dispatch

Every physical child declares model, effort, and fork. `none` is the default;
only an integer from `1..5` may override it, and `all` is forbidden with an
override. A child never inherits the root binding implicitly.

nested Terra-to-Luna is forbidden by default. The root may authorize exactly one
Luna/medium prescribed-mechanical leaf only when scopes are disjoint, the total
physical budget is exactly three (Terra parent, Luna child, independent
reviewer), and the Terra parent remains accountable. Luna is a leaf and cannot
delegate.

Prefer bounded delegation when all are true:

- the subtask is bounded and explicit
- there is meaningful parallel value
- the write scope is clear or read-only
- the master is not blocked on immediate local action
- the integration burden is lower than the expected gain

## Non-Spawn Criteria

Do not spawn when:

- the task is on the critical path right now
- the scope is vague
- the output would mostly duplicate master reasoning
- the work is too small to justify coordination overhead
- the task requires global judgment the master cannot delegate

If these conditions block all delegation on a non-trivial run, emit an explicit
`single-threaded exception` in the runtime packet.

## Scenario Routing Matrix

Use these examples as bounded teaching cases:

| Scenario | Delegation decision | Valid shape | Master-owned boundary |
| --- | --- | --- | --- |
| separable backend/frontend feature with runtime proof value | spawn when slices are independent | implementation worker plus runtime/browser or verification sidecar | integration correctness, contract truth, final closure |
| governance-only benchmark or parity judgment | do not spawn by default | root-owned with explicit `single-threaded exception` | all comparative judgment and promotion authority |
| auth recovery UI regression with misuse risk | spawn only if both mutation and review are bounded | implementation worker plus trust/anti-abuse or runtime/product reviewer | security posture, release blocker, final product judgment |
| external provider or source-observer idea with no native owner | do not force-fit generic governance | master-owned gap, optionally read-only source observer candidate | provider-boundary risk, family-gap registration, self-evolution decision |
| small doc-only corrections | do not spawn unless independent review value exceeds overhead | root-owned bounded edit | scope restraint and final verification |

If a scenario needs three or more unrelated families to make sense, treat that
as a gap signal before treating it as a parallelization opportunity.

## Output Contract

Every subagent must return:

- scope handled
- files changed or surfaces inspected
- evidence used
- tests or verification run
- self-review
- self-forensic review
- correction/reproof status when performing delegated correction
- unresolved risks

After a subagent returns, the master must actively close or complete the agent
when the runtime supports it. If the agent remains open because further work is
intended, record the retained-agent reason. Idle returned agents are runtime
leaks, not harmless background state.

Role-specific returns should add the missing proof, not restate the global
plan:

- implementation worker: exact write scope, behavior changed, local tests
- proof sidecar: proof lane exercised, blockers found, evidence location
- trust / anti-abuse reviewer: abuse path, signal, blocker, release condition
- provider-boundary implementation worker: bounded provider scope, explicit
  Terra/medium binding, source/proof evidence, and no external authority claim
- governance auditor: violated rule, governing artifact, correction target

## Review Hierarchy

1. subagent executes
2. subagent self-reviews
3. subagent self-forensic-reviews
4. independent skeptical reviewer inspects the returned slice when the task is
   non-trivial or closure-sensitive
5. master reviews the returned slice
6. master reviews the skeptical review quality
7. master closes/completes returned idle agents or records why they are retained
8. master integrates the combined result
9. master performs final forensic closure

## Master Integration Protocol

When multiple outputs come back, the master must check:

- complementarity
- conflict
- overlap
- hidden scope drift
- local correctness vs global correctness

Never trust subagent-local success as proof of integrated correctness.

Never treat an executor subagent's self-review as acceptance. If no independent
review sidecar exists, packet a review isolation exception and keep residual risk
visible through closure.

## One-Shot Correction Handoff

When the `One-Shot Side-By-Side Gate` is active, delegated correction is allowed
only for bounded defects with clear evidence and write scope.

The subagent return must include correction/reproof status, self-review,
self-forensic review, and unresolved risks. The master owns integration,
review-of-review, and final forensic closure.

## Parallelism Budget

Use explicit budgets:

- `0` physical subagents for trivial bounded work, with no virtual separation
  required unless review-bearing
- `0` physical subagents plus virtual executor/reviewer passes only for
  direct-fast-path/scoped non-trivial work, or as a blocking exception; never
  as executable fallback after `TASKS_READY` on an orchestrated route with
  collaboration available
- `1` subagent for a single meaningful sidecar
- `2-3` subagents for independent bounded slices

More than this requires strong justification because integration cost rises
quickly.

## Operational Hand-Off

Use `subagent-governance` as the concrete policy skill when the question is how
to shape bounded subagent packets, review ordering, or master-level
integration.

Use `parallel-agents` when the decision is whether concurrency is actually safe
before any write-bearing delegation begins.
