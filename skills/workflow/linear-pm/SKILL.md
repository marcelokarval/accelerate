---
name: linear-pm
description: Codex-native operating skill for creating, structuring, reviewing, and executing Linear issues with rich execution guides and dependency awareness.
metadata:
  category: orchestration
  origin: standalone-adapted-from-global
---

# Linear PM

Codex-native skill for working with Linear as the execution backbone of complex
work.

## When to Use

- creating new issues or epics
- decomposing large work into child issues
- enriching issues with execution context
- reviewing blockers and dependency chains
- using an issue as the source of scope for implementation

## Core Principle

Linear issues must be implementation-ready, not placeholders.

For engineering execution, `linear-pm` is a branch under `accelerate`, not the
root orchestration model by itself.

This skill owns issue governance and lifecycle hygiene. It does not own
cross-stack implementation routing, bounded execution, or multi-issue critical
path orchestration.

## Context Minimum

Before creating or restructuring an issue, gather:

- issue or epic identifier if one exists
- objective and delivery scope
- blockers, dependencies, and sequencing concerns
- required assignee and project constraints
- intended label set
- fallback label strategy when mutually exclusive groups collide

## Runtime Guardrail

- When issue execution includes Python commands, use `uv run ...`.
- Do not record or recommend raw `python`, `pytest`, `pip`, or manual venv
  activation for this repo.

## Accelerate Governance

Always enforce:

- assignee/project/workspace conventions declared by the active repository or
  workflow adapter
- rich issue body with diagnosis, evidence, scope, risks, acceptance
- labels and priority set before or at the start of execution
- engineering mutation, workflow-seed mutation, or living-doc mutation must
  not begin before a governing issue exists unless the user explicitly approved
  a narrow no-issue exception
- labels are blocking metadata before active execution and before `Done`
- if the intended label pair conflicts because of mutually exclusive groups:
  - keep the narrowest valid label that still reflects the issue home
  - prefer a smaller valid set over a richer invalid set
  - stop retrying an invalid pair and make the best valid fallback visible in
    the issue
- when decomposing a parent into bounded child slices, create or confirm the
  parent first and set `parentId` on every child issue explicitly
- if there is any uncertainty about the MCP/tool capability, verify the tool
  schema or real `parentId` support before creating or restructuring issues
- do not substitute `relatedTo`, `blocks`, `blockedBy`, chronology, or title
  similarity for missing parent/child hierarchy
- execution dependencies are complementary metadata only after the structural
  parent/child tree already exists
- do not rely on title similarity, chronology, or comments as a substitute for
  real parent/child linkage
- execution tasks/checklists kept in sync when present
- real session ID when available; never fabricate one
- mutually exclusive label groups respected
- honest status usage:
  - `Backlog`: not ready or not selected
  - `Todo`: execution-ready
  - `In Progress`: implementation started
  - `In Review`: waiting on real gate
  - `Done`: implementation + verification + execution review complete
  - `Duplicate` / `Canceled`: only for true duplicate/discard outcomes
- lifecycle progression is enforcement, not etiquette:
  - if real implementation starts, the issue must enter `In Progress`
  - if implementation is complete but review/verification gates remain, the
    issue must enter `In Review`
  - `Done` is invalid when real execution happened but `In Progress` or
    `In Review` were silently skipped
- cycle usage when the team has cycles:
  - `current`: active committed window
  - `next`: next prioritized window
  - `previous`: retrospective/carry-over
  - if cycles do not exist, do not fabricate sprint assignment
- every issue leaving `In Review` needs an `AI Review Report` with:
  - requested vs implemented, side by side and specific
  - evidence
  - commit traceability: at least one real commit and the governing issue key
    visible in the commit trail, ideally in the subject of the implementation
    commit
  - classification: `exact`, `drifted-but-complete`, `partial`, `stale`, `superseded`
  - status recommendation
  - `Product Correctness` when the work is user-facing or runtime-flow-sensitive
  - `Anti-Abuse` when the work touches auth, session, OTP, billing, export, deletion, uploads, resend flows, or ownership-sensitive list/search surfaces
  - `Contract Correctness` when the work touches presenters, contracts, route links, identifiers, page-name paths, or backend/frontend payload shape
  - explicit residuals/omissions found during review
  - follow-up issue creation when bounded work is complete but adjacent drift was uncovered
  - if a global verification command fails outside the issue scope, record it and open a follow-up issue unless it is already tracked
  - recursive review depth appropriate to the change, using the mandatory levels:
    - Level 0: promised-claim revalidation against real files/results
    - Level 1: recursive scan of the containing subtree/package
    - Level 2: adjacent ownership/docs/tests/contracts scan
    - Level 3: targeted repo-wide stale-path/compat scan
    - Level 4: generated/runtime/build/migration/browser evidence when applicable
  - for backend organization, compat cleanup, contract placement, or export
    normalization, the review must recurse through the owning backend tree and
    explicitly check stale artifacts, empty runtime dirs, app-layer filenames
    leaking into interface layers, and documented base-model exceptions

## Workflow: Create an Issue

1. identify the real problem
2. gather evidence from code/docs
3. define scope, non-goals, acceptance, dependencies
4. create the issue with enough context for direct execution

If the rich create fails and a minimal fallback issue is used:

1. treat the issue as `created but not execution-ready`
2. immediately rehydrate mandatory metadata:
   - assignee
   - project linkage if needed
   - labels
   - priority
   - parentId when applicable
3. re-read the issue from Linear
4. confirm the metadata is now complete
5. only then allow execution to continue

Do not normalize a minimal fallback issue as if it had already passed issue
bootstrap hygiene.

When the work is a one-sprint parent/child package:

1. create or confirm the parent issue first
2. if the tool capability is unclear, verify that `parentId` is actually
   writable before creating the children
3. create each child with explicit `parentId`
4. set labels and priority on the child at creation time
5. verify the child appears under the parent before execution begins
6. only then add `relatedTo` / `blocks` / `blockedBy` when the execution DAG
   also needs to be expressed

## Workflow: Execute From an Issue

1. fetch the issue with relations
2. check blockers first
3. every engineering run is classified through `accelerate`; when the run is
   issue-driven, let `accelerate` load `linear-pm` as the governing branch
4. if no governing issue exists yet and the run is about to enter non-trivial
   implementation:
   - stop implementation
   - create or confirm the governing issue or parent/child package first
   - re-read the issue after metadata hydration
5. if the issue was created through a minimal fallback path, run:
   - `Metadata Rehydration Check`
   - `Ready-for-Execution Revalidation`
6. set lifecycle metadata:
  - `In Progress`
  - labels
  - priority
  - `current` or `next` cycle when applicable
7. treat the issue as scope source
8. let `accelerate` choose the implementation and review stack for the active
   issue surface
9. implement, verify, and sync issue checklists
10. if a real gate remains, move to `In Review`
11. before `Done`, publish `AI Review Report`, verify commit traceability, and
    decide status from it

Do not treat missing labels as a cosmetic defect:

- active execution is blocked until the issue has a valid label set
- `Done` is blocked until labels, assignee, project, and hierarchy are
  rechecked

Do not compress this into `Todo -> Done` when execution actually happened.

Do not normalize "issue created after coding already started" as acceptable
catch-up. Review must name it as workflow failure and the root control plane
should be hardened when the pattern repeats.

If the issue was materially executed, the lifecycle truth must be visible:

- active work -> `In Progress`
- completed implementation with remaining review gate -> `In Review`
- only then `Done`

If the issue belongs to a parent/child sprint package, also:

- verify `parentId` is present and points at the intended parent
- verify no child is using dependency edges as a substitute for missing
  structural hierarchy
- verify the parent still reflects the child set actually executed
- verify labels are present before the issue leaves `In Progress`
- verify labels are still present and valid before the issue leaves `In Review`

## Relationship to Accelerate

- trivial and non-trivial engineering issue execution are both rooted in
  `accelerate`
- `linear-pm` owns issue structure, lifecycle, AI review hygiene, and issue
  truth once that branch is selected

## Boundary Against Adjacent Skills

- `linear-workflow-orchestrator`
  - use when the main problem is sequencing multiple issues or exposing the
    critical path
- `linear-implementation-planner`
  - use when issue scope is valid but execution still needs phased batches
- `executing-plans`
  - use when the plan already exists and the real job is disciplined
    batch-by-batch execution

## Execution Guide Contract

For complex issues, include:

- execution lens/skills
- key context files
- verification commands
- blockers/downstream impact

Do not invent session identifiers. If one is required and unavailable, ask the
user.

## Dependency Rules

- use live issue relations when available
- if you intentionally decomposed a parent into children, missing `parentId`
  is workflow drift, not a cosmetic metadata omission
- treat tool-capability assumptions as unsafe; if parent/child matters, prove
  the tool can write `parentId` before relying on dependency links
- document the intended order of execution
- do not start blocked work unless the task is only exploratory

## Quality Standard

Weak issue: generic, no evidence, no verification, no decomposition.

Strong issue: concrete diagnosis, explicit boundaries, roadmap, verification,
metadata set before work starts.

A minimally created fallback issue is not strong yet. It becomes strong only
after metadata rehydration and a fresh read proves it is execution-ready.

For label hygiene, "present" is not enough. The label set must be:

- non-empty
- valid under Linear's mutually exclusive label-group rules
- narrow enough to reflect the issue home instead of being a generic bucket

When recurring hygiene drift is suspected across a recent window or a
parent/child package, use the active repo's Linear hygiene protocol or create a
bounded audit artifact instead of relying on ad hoc cleanup memory.

## MCP Guidance

When Linear MCP is available:

- prefer MCP tools over external CLIs or SDKs
- fetch full issue details when dependency accuracy matters
- use relations as the source of truth for blockers
- if a create/update payload fails validation and you recover with a smaller
  payload, do not trust the issue state from memory; re-read the issue after
  metadata rehydration before execution continues

## Recommended Dependencies

- `architecture`
- `planning-with-files` for large issue-driven execution

Optional:

- stack skills based on issue domain

## Handoff And Escalation

- hand off to `accelerate` when the work moves from issue design into actual
  multi-step execution
- pair with `linear-workflow-orchestrator` when the main problem is sequencing
  multiple related issues
- pair with `linear-progress-reporter` when the main deliverable is status
  reporting rather than issue authoring

## Verification

Before a Linear-governed issue closes, confirm at minimum:

- labels are present and valid
- assignee and project are correct
- priority is present when the issue requires it
- parent/child hierarchy is real when the package uses children
- dependency edges did not replace hierarchy
- lifecycle truth was visible during execution rather than reconstructed after
  the fact

Before closing a Linear-driven workflow:

- confirm blockers were respected
- confirm the lifecycle progression was honest:
  - real execution entered `In Progress`
  - real remaining review gate entered `In Review`
  - `Done` was not used as a shortcut around review state
- confirm scope was implemented or explicitly deferred
- confirm verification was run or clearly not run
- confirm no minimal-create fallback skipped metadata rehydration or execution
  revalidation
- confirm any out-of-scope global drift discovered by verification was turned into a tracked follow-up issue unless it already existed
- confirm labels and priority are present and coherent
- confirm assignee is present and correct
- confirm parent/child relation hygiene is correct for any decomposed sprint:
  intended children must actually be sub-issues, not merely adjacent issues
- confirm dependency edges did not replace hierarchy: `relatedTo`, `blocks`,
  and `blockedBy` may complement a child issue, but never justify a missing
  `parentId`
- confirm cycle assignment is coherent with execution status when cycles are
  enabled for the team
- confirm execution tasks and acceptance checklists are updated when present
- confirm any issue leaving `In Review` has an `AI Review Report` comment with
  requested-vs-implemented comparison, evidence, classification, explicit
  residuals, final recommendation, and `Product Correctness` / `Anti-Abuse` /
  `Contract Correctness` sections whenever those lenses applied
- confirm issue-driven implementation produced at least one real commit before
  `Done`
- confirm the governing issue key is visible in the commit trail, preferably in
  the implementation commit subject
- confirm closure is blocked when the work only exists in an uncommitted
  worktree or detached local state
- confirm Inertia prop-governance issues include a prop ownership matrix or an
  explicit link to the baseline matrix used
- confirm the review depth matched the change size; architecture/reorganization/migration work must explicitly show Levels 0-4 of the recursive review protocol
- confirm backend organization or contract work explicitly named the recursive backend scan commands and evidence, not just touched files
- confirm the review actually rechecked the code, tests, and issue body instead
  of trusting an earlier completion summary
- confirm no promised cleanup, export normalization, compat removal, or doc sync
  was silently left behind
- confirm parent/epic state still makes sense after the child review; do not
  let a child close cleanly while the parent incorrectly appears consolidated
- confirm closure notes are not being pushed into napkin; napkin is for durable
  guardrails, not issue history
- confirm `Duplicate` and `Canceled` were not used as shortcuts for unfinished
  work
