# Recursive Self-Improvement Loop

This is the native control-plane contract for Accelerate inspecting and improving
itself. It is an internal recursive audit and improvement mode, not a substitute
for product delivery, runtime proof, or root closure.

The root acts as orchestrator and final reviewer. It may delegate bounded
implementation and review slices, but it does not outsource global judgment,
capability promotion, or closure authority.

## Purpose

The loop exists to make Accelerate periodically look inward at its own purpose,
implementation state, doctrine, adapters, skills, runtime packets, proof
coverage, duplication, drift, and next-step sequence.

A recursive improvement cycle is successful only when findings become durable
artifacts, bounded tasks, reviewable proof, and next-cycle inputs. Vague
retrospective prose is not enough.

## Scope

In scope:

- core control-plane law and review architecture
- workflow adapter manifests, helpers, registries, and proof appendices
- runtime adapter manifests and runtime packet contracts
- repo-local skills, profiles, onboarding surfaces, and sync topology
- planning artifacts, task ledgers, dashboards, and closure records
- local `.accelerate/` workspace dogfood status when present
- test contracts, negative gates, substitute-evidence boundaries, and CI truth

Out of scope unless explicitly planned:

- implementing blocked remote writes merely because the loop detected them
- landing or merging real GitHub pull requests without a separate proof task
- creating persistent `.accelerate/` dogfood state without its own guarded task
- promoting a planned agent, runtime adapter, skill export, or workflow backend
  without live or durable proof

## Recursive Trigger Conditions

Run a recursive self-improvement cycle when one or more of these signals appears:

- root asks Accelerate to audit or improve Accelerate itself
- a release, migration, or platform milestone depends on internal capability truth
- a dashboard, capability manifest, runtime packet, or task ledger is stale
- tests pass but proof coverage is semantically weak or only positive-path
- a blocked or planned capability keeps appearing in follow-up queues
- adapter claims and evidence appendices disagree
- skill registry, runtime exports, or user-home/runtime copies may have drifted
- `.accelerate/` local workspace behavior is needed but not dogfooded here
- subagent surfaces exist architecturally but lack promotion pipeline proof
- a previous recursive cycle emitted a next-step queue that has not been triaged

Do not trigger the loop for isolated typos, disposable scratch cleanup, or local
noise that does not change control-plane truth.

## Cycle Phases

Contract term map: inventory, situation detection, task shaping, delegated
execution, delegated task review, root review-of-review, persistence,
next-step emission, idle-agent/process cleanup.

Every recursive cycle must perform these phases in order, with explicit evidence
or an explicit exception for skipped surfaces.

1. **Inventory**
   - read `git status --short --branch`
   - inspect relevant tests, CI status, manifests, dashboards, skills, adapters,
     runtime packets, planning artifacts, and recent proof appendices
   - identify existing ledgers before creating new task surfaces
2. **Situation Detection**
   - classify internal situations using the taxonomy below
   - preserve current statuses honestly: `blocked` stays blocked, `planned` stays
     planned, and `substitute` stays substitute until proof changes
3. **Task Shaping**
   - convert each situation into bounded tasks with task id, owner lane, write
     scope, read scope, stop rules, proof, reviewer, residual, and next action
   - avoid omnibus tasks that mix unrelated adapter, runtime, skill, and test work
4. **Delegated Execution**
   - assign implementation slices to bounded subagents where safe and useful
   - keep root as orchestrator, integrator, and final reviewer
   - record root-owned exceptions when delegation would be dishonest or wasteful
5. **Delegated Task Review**
   - every non-trivial task receives independent task review or a named review
     isolation exception
   - the review must compare requested-vs-implemented, files touched, proof,
     residuals, and status honesty
6. **Root Review-of-Review**
   - root verifies reviewer quality, not only implementer claims
   - root checks whether reviewers missed scope drift, status promotion, weak
     proof, forbidden files, or unresolved blockers
7. **Persistence**
   - update durable dashboards, task ledgers, packets, proof appendices, or
     architecture docs as appropriate for the completed slice
   - do not treat chat memory, scratch notes, or untracked temp files as closure
     proof
8. **Next-Step Emission**
   - emit completed work, blocked work, residual defects, and the next
     prioritized improvement queue
   - include owner lane and first proof command or proof artifact for each next
     task
9. **Idle-Agent/Process Cleanup**
   - close or release returned subagents when the runtime supports it
   - kill or account for background processes spawned during the cycle
   - record any retained agent/process with a reason and next owner

## Situation Taxonomy

Use the smallest truthful classification that explains the internal condition.
Multiple classifications may apply, but the task shape must name the dominant
risk.

| Situation type | Meaning | Typical follow-up |
| --- | --- | --- |
| `blocked-capability` | A desired capability exists in doctrine or manifests but cannot be used because a named blocker remains. | Preserve `blocked`; define unblocker task and proof fixture. |
| `planned-without-proof` | A command, adapter, packet, or design exists but lacks decisive proof. | Preserve `planned`; create proof task before promotion. |
| `substitute-evidence-only` | Local substitute or dry-run evidence exists but does not prove provider/runtime truth. | Keep substitute boundary visible; design live proof path. |
| `manifest-proof-drift` | Manifests, registries, dashboards, and evidence appendices disagree. | Reconcile source of truth and add/repair tests. |
| `weak-negative-gate` | Positive tests exist but semantic negative fixtures are missing. | Add negative fixtures or contract tests in a separate task. |
| `stale-supporting-reference` | Imported or supporting docs remain useful but no longer represent authority. | Link, migrate, or retire without blind mirroring. |
| `duplicate-doctrine` | Multiple docs describe the same rule with unclear ownership. | Pick authority home, leave references as supporting detail. |
| `skill-sync-drift` | Repo-local skill truth may differ from runtime/user-home exports. | Define one-way sync topology and proof. |
| `idle-agent-surface` | Agent roles or factory surfaces exist but lack promotion criteria or cleanup. | Shape promotion pipeline or mark as future/blocked. |
| `dogfood-gap` | Accelerate can create local workspace state but is not persistently dogfooding itself. | Create `.accelerate/` dogfood task with guardrails. |
| `runtime-adapter-maturity-gap` | Runtime adapter manifests expose many `planned`/`substitute` states. | Build maturity dashboard or adapter proof tasks. |

## Bounded Task Shaping Rules

Each task emitted by the loop must include:

- task id and short title
- situation type and current status
- owner lane: root, implementation subagent, reviewer subagent, proof sidecar,
  governance auditor, or future adapter owner
- exact write scope and forbidden scope
- prerequisite discovery
- requested output artifacts
- proof command, proof artifact, or explicit blocker
- reviewer role and root review-of-review requirement
- stop rules and rollback/deferral conditions
- residual if not fully complete

Task shaping must prefer small, independently reviewable slices. It must not
combine live remote writes, runtime packet schema changes, dashboard updates,
agent factory design, and test integration unless a root plan explicitly binds
those surfaces into one integration task.

## Subagent Execution Rules

Subagents are bounded executors or reviewers, not autonomous owners of
Accelerate. A delegated execution packet must include:

- repository path and branch/status evidence
- assigned task ids
- allowed files and forbidden files
- implementation goal and non-goals
- required proof or proof limitation
- required return sections: requested-vs-implemented, files touched, validation,
  self-review, self-forensic review, defects/residuals

A subagent must not promote a capability status by assertion. Promotion requires
proof named in the relevant dashboard or manifest and root review-of-review.

## Delegated Task Review Rules

Independent task review must answer:

1. Was the assigned scope implemented?
2. Were any files outside scope edited?
3. Does the result preserve Accelerate as root control plane and orchestrator?
4. Does it avoid promoting planned, blocked, or substitute capabilities without
   proof?
5. Is there a durable proof path?
6. Are residuals and next steps named?

When independent review is skipped, the root must record a review isolation
exception and carry the residual risk into closure.

## Root Final Review Rule

Root final review must verify:

- initial and final `git status --short --branch`
- actual file contents, not only subagent summaries
- diff scope against the task ledger
- contract tests and relevant full-suite proof when in scope
- `git diff --check`
- dashboard status honesty
- proof artifacts for every promoted state
- quality of delegated reviews
- idle-agent/process cleanup status

Root may close the cycle only after reconciling requested-vs-implemented,
self-review, self-forensic review, independent review, defects/residuals, and
next-step queue.

## Persistence Contract

Every cycle must persist at least one durable artifact unless it is a pure
read-only audit with an explicit no-change verdict. Valid persistence targets
include:

- recursive improvement dashboard rows
- executive task ledger updates
- recursive improvement cycle packet
- capability maturity dashboard updates
- evidence appendices
- core control-plane or runtime-packet contracts
- tests or negative fixtures when assigned

Persistence must preserve blocked/planned/substitute statuses until proof changes
and must link to the proof that justifies any promotion.

## Next-Step Emission Contract

The cycle output must include:

- completed tasks and proof
- partial tasks and residuals
- blocked tasks with blocker name
- planned tasks with first proof step
- next prioritized improvement queue
- owner lane for each next item
- cleanup performed or retained-process reason

The next queue is an input to the following recursive cycle. It is not closure
unless the tasks are either done, explicitly deferred, or blocked with a named
blocker.
