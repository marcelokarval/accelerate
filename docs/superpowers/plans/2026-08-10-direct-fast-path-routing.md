# Direct Fast Path Routing Implementation Plan

> **For agentic workers:** use bounded delegation only where it lowers discovery or review cost; do not delegate direct-path work by habit.

**Goal:** Make Accelerate choose direct, scoped, or orchestrated execution explicitly so small, known, low-risk work stays fast without weakening governing repo rules.

**Architecture:** Preserve the existing top-level classification and execution modes. Add an `execution route` selected after classification; define its entry and escalation rules in the root skill, trivial contract, delegation policy, quick map, and packet template. The portable runtime receives only the concise routing summary and continues to load references on demand.

**Non-goals:** No new resident skill, agent persona, task scheduler, automatic wake-up, wildcard catalog access, or exception to a target repository's issue/workspace authority.

---

### Task 1: Specify routing contract and prove it mechanically

**Files:**

- Create: `tests/direct-fast-path-routing.sh`
- Modify: `SKILL.md`, `references/trivial-branch-contract.md`, `core/delegation/subagent-model.md`

- [x] Write checks for the three routes, direct zero-agent policy, scoped one-sidecar cap, and parallelism preconditions.
- [x] Run the test and confirm it fails because the route contract is absent.
- [x] Add the smallest routing language to the governing documents.
- [x] Re-run the focal test and existing classification/delegation tests.

### Task 2: Make the route visible without increasing ceremony

**Files:**

- Modify: `core/runtime-packets/templates.md`, `core/control-plane/quick-invocation-map.md`, `global-runtime/accelerate/SKILL.md`

- [x] Add route, budget, and one-line delegation basis to the existing Branch Entry Packet.
- [x] Add the route decision to the quick map and portable runtime summary.
- [x] Keep the Direct Fast Path packet compact and retain stricter local authority precedence.
- [x] Re-run focal and relevant regression tests.

### Task 3: Review, export, and validate

**Files:**

- Modify: generated runtime mirror only through `scripts/sync-skills-to-global.sh`

- [x] Run the complete repository suite and formatting/link checks relevant to the changed docs.
- [x] Obtain independent specification and quality review after the candidate is stable.
- [x] Commit the bounded source change, merge it without disturbing pre-existing worktree changes, then synchronize and verify the global runtime mirror.
