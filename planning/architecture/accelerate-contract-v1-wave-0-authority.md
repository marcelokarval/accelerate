# Accelerate Contract V1 Wave 0 Authority Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish and test an acyclic authority graph before any machine contract is introduced.

**Architecture:** Existing repo-local authority classes remain intact, but their precedence, ownership, mutation paths, and generated-export edges become explicit in one graph. The graph forbids reverse authority from `global-runtime/accelerate/` or user-home catalogs and becomes the prerequisite for Contract V1.

**Tech Stack:** Markdown, Mermaid or fenced text topology, Bash tests using `rg`, existing doctrine and link integrity suites.

---

## Identity And Dependencies

- Plan ID: `ACV1-W0`
- Parent: [Accelerate Contract V1 Master Plan](../executive/accelerate-contract-v1-master-plan.md)
- Depends on: accepted master plan and implementation entry packet
- Produces: accepted authority graph and Wave 0 Closure Packet
- Behavior change: none; governance clarification only

## Exact Goal

For every Contract V1 source or output, answer and test:

1. What authority class is it?
2. Which file owns the statement?
3. Which direction may information flow?
4. Who may modify it and by what process?
5. What happens when it drifts?

## Scope

- Reconcile `AGENTS.md`, root `SKILL.md`, authority-set doctrine, branch/gate owners, references, backend facts, planning decisions, and generated runtime.
- Add an explicit graph with precedence and generation edges.
- Add closure blockers for cycles, generated-output authority, and user-home authority.
- Add focused structural tests and register them in doctrine integrity.

## Non-Scope

- No JSON contract, schema, validator, adaptive rules, or evaluator.
- No routing, classification, gate, proof-order, or runtime behavior change.
- No generated-runtime regeneration.
- No edits to user-home paths.
- No cleanup of concurrent dirty changes.

### ACV1-W0-001: Open The Wave 0 Entry And Ownership Packet

**Depends on:** none

- [ ] Run `git status --short --branch`; expect branch identity plus the known or newly classified dirty paths.
- [ ] Run `git diff --name-only`; record all overlaps with planned Wave 0 files.
- [ ] Read `.accelerate/review/handoff-summary.md` or use canonical local reentry fallback.
- [ ] Attach an execution-ready governing issue or record an explicit user-approved no-issue exception.
- [ ] Read `AGENTS.md`, `SKILL.md`, `README.md`, `core/control-plane/authority-set-gate.md`, `core/control-plane/gate-ownership-index.md`, `core/control-plane/skill-sync-topology.md`, and `global-runtime/accelerate/README.md`.
- [ ] Confirm ownership before touching currently dirty files; stop if overlap is unresolved.
- [ ] Run `bash tests/authority-set-gate.sh`, `bash tests/doctrine-integrity.sh`, and `bash tests/markdown-link-integrity.sh`; expect pass or classify pre-existing failures before mutation.

Entry evidence: baseline status/path list, local workspace decision, issue decision, owner map, and focused baseline outputs.

## Exact Files

**Create:**
- `core/control-plane/authority-graph-v1.md`
- `tests/authority-graph-v1.sh`
- `planning/execution/accelerate-contract-v1-wave-denominator.json`
- `tests/accelerate-contract-v1-denominator.sh`

**Modify:**
- `AGENTS.md`
- `SKILL.md`
- `README.md`
- `core/control-plane/README.md`
- `core/control-plane/authority-set-gate.md`
- `core/control-plane/gate-ownership-index.md`
- `tests/doctrine-integrity.sh`

**Test without modifying:**
- `core/control-plane/branch-enforcement-matrix.md`
- `core/control-plane/skill-sync-topology.md`
- `global-runtime/accelerate/README.md`
- `global-runtime/accelerate/SKILL.md`
- `tests/authority-set-gate.sh`
- `tests/markdown-link-integrity.sh`
- `tests/all.sh`

If implementation discovers that an unlisted existing file must change, stop and amend the plan/issue before editing it.

## Required Graph Contract

The new graph must define these nodes:

| Node | Class | Required disposition |
| --- | --- | --- |
| `AGENTS.md` | `governing-authority` | repository bootstrap law |
| root `SKILL.md` | `governing-authority` | root runtime/classification law for this repo |
| accepted `core/` owners | `governing-authority` | detailed control-plane law |
| active `adapters/`, `profiles/`, `skills/`, `onboarding/` | `governing-authority` within scope | bounded native owners |
| `references/` | `supporting-reference` | cannot override native owners |
| accepted `planning/` artifact | `decision-artifact` | bounded run decision only |
| implemented adapter state | `backend-authority` | only facts owned by that backend |
| `global-runtime/accelerate/` | `generated-export` | downstream deployment bundle |
| user-home catalogs | `forbidden-authority` | never an authoring or proof source |

Required edge types: `governs`, `refines`, `informs`, `decides-bounded-run`, `reports-backend-fact`, and `generates`. Only `generates` may enter `global-runtime/accelerate/`; no edge may leave generated or forbidden nodes toward a governing node.

### ACV1-W0-002: Freeze The Authority Denominator And Write Failing Graph Tests

**Depends on:** `ACV1-W0-001`

**Files:**
- Create: `tests/authority-graph-v1.sh`
- Create: `.tmp/authority-graph-v1/` fixtures at test runtime and remove them on exit
- Read: proposed `core/control-plane/authority-graph-v1.md`

- [ ] **Step 1: Inventory authority-bearing paths**

Run: `rg -n "governing-authority|supporting-reference|decision-artifact|backend-authority|generated-export|forbidden-authority|source of truth" AGENTS.md SKILL.md README.md core adapters profiles onboarding planning references global-runtime/accelerate`

Expected: matches identify all six existing classes and any contradictory language requiring disposition.

- [ ] **Step 2: Freeze the denominator**

Record in the Wave Packet every node class, required edge, owner file, and observed contradiction. Expected: no `unknown` class remains before edits.

- [ ] **Step 3: Write the failing graph contract test**

Require purpose, normative vocabulary, node table, precedence order, topology,
allowed/forbidden edges, mutation protocol, drift response, generated-export
direction, and user-home exclusion. Add test-owned reverse-edge and user-home
authority fixtures.

- [ ] **Step 4: Run the red test before graph implementation**

Run: `bash tests/authority-graph-v1.sh --graph-only`

Expected: FAIL with `authority-graph-v1 failed: missing graph`; this test exists
before `ACV1-W0-003` creates the graph.

- [ ] **Step 5: Do not commit yet**

Wait until the focused test for this task exists and passes so the later commit remains a bounded test/owner pair.

### ACV1-W0-003: Implement Authority Graph And Complete Positive/Negative Tests

**Depends on:** `ACV1-W0-002`

**Files:**
- Create: `core/control-plane/authority-graph-v1.md`
- Modify: `tests/authority-graph-v1.sh`
- Test: `core/control-plane/authority-graph-v1.md`
- Test: `AGENTS.md`
- Test: `core/control-plane/authority-set-gate.md`

- [ ] **Step 1: Confirm the predecessor test is red**

Run: `bash tests/authority-graph-v1.sh --graph-only`

Expected: FAIL because the graph is still absent.

- [ ] **Step 2: Implement the graph document**

Include every frozen class/edge, precedence, owner, mutation rule, drift response,
and the sole outward path `repo source -> generated export -> explicit host`.

- [ ] **Step 3: Complete negative checks**

Use a temporary fixture under `.tmp/authority-graph-v1/` generated by the test. Expected: a reverse-edge fixture and user-home-authority fixture are rejected.

- [ ] **Step 4: Run the focused graph mode to Green**

Run: `bash tests/authority-graph-v1.sh --graph-only`

Expected: graph structure, direction, and negative fixtures pass with marker
`authority graph v1 graph-only passed`. This mode excludes owner-pointer
assertions, which are introduced and made red/green only by `ACV1-W0-004`.

Rollback for `ACV1-W0-003` removes/reverts
`core/control-plane/authority-graph-v1.md` and the matching
`tests/authority-graph-v1.sh` changes together as one bounded slice; preserve
all unrelated worktree and predecessor test state.

- [ ] **Step 5: Commit later as the complete task-scoped graph slice**

After explicit implementation authorization only:

```bash
git add core/control-plane/authority-graph-v1.md tests/authority-graph-v1.sh
git commit -m "docs(contract-v1): add tested authority graph"
```

No commit is authorized during the current planning task.

### ACV1-W0-004: Reconcile Canonical Authority Owners

**Depends on:** `ACV1-W0-003`

**Files:**
- Modify: `AGENTS.md`
- Modify: `SKILL.md`
- Modify: `README.md`
- Modify: `core/control-plane/README.md`
- Modify: `core/control-plane/authority-set-gate.md`
- Modify: `core/control-plane/gate-ownership-index.md`
- Modify: `tests/doctrine-integrity.sh`
- Test: `tests/authority-graph-v1.sh`

- [ ] **Step 1: Add minimal owner pointers**

First extend `tests/authority-graph-v1.sh` with an `--owner-pointers` mode and run
it before owner edits:

Run: `bash tests/authority-graph-v1.sh --owner-pointers`

Expected: FAIL with a stable missing-owner-pointer label. Then add links and
concise rules rather than duplicating the entire graph.

`AGENTS.md` retains bootstrap supremacy; `authority-set-gate.md` retains class
definitions; the graph owns edges and precedence.

- [ ] **Step 2: Clarify generated runtime**

State that repo-contained `global-runtime/accelerate/` is a generated/export deployment surface and that drift is repaired from canonical repo owners, never by adopting output as authority.

- [ ] **Step 3: Register graph integrity**

Add `tests/authority-graph-v1.sh` as a required file and invoked test in `tests/doctrine-integrity.sh`.

- [ ] **Step 4: Run focused tests**

Run: `bash tests/authority-graph-v1.sh`

Expected: both graph-only and owner-pointer modes pass with final marker
`authority graph v1 passed`.

Run: `bash tests/authority-set-gate.sh`

Expected: `authority set gate passed`.

Run: `bash tests/doctrine-integrity.sh`

Expected: final marker `doctrine integrity passed` and all nested tests pass.

- [ ] **Step 5: Run link and whitespace checks**

Run: `bash tests/markdown-link-integrity.sh`

Expected: `markdown link integrity passed`.

Run: `git diff --check`

Expected: no output and exit 0.

- [ ] **Step 6: Commit later as a bounded slice**

Before commit: `git diff --cached --name-only` must list only ACV1-W0 files and no pre-existing unowned dirty file.

Commit command after explicit implementation authorization:

```bash
git add AGENTS.md SKILL.md README.md core/control-plane/README.md core/control-plane/authority-set-gate.md core/control-plane/gate-ownership-index.md tests/doctrine-integrity.sh
git commit -m "docs(contract-v1): reconcile authority owners"
```

Expected: one bounded commit; do not commit during the current planning task.

### ACV1-W0-005: Materialize The Six-Wave Denominator Manifest

**Depends on:** `ACV1-W0-002`

**Files:**
- Create: `planning/execution/accelerate-contract-v1-wave-denominator.json`
- Create: `tests/accelerate-contract-v1-denominator.sh`
- Read: `planning/executive/accelerate-contract-v1-task-catalog.md`
- Read: `planning/executive/accelerate-contract-v1-validation-checklist.md`

- [ ] **Step 1: Write the failing denominator test**

Require a machine-readable denominator containing all 45 catalog IDs with wave, owner, dependencies, priority, capability target, proof, exclusions, and threshold. Require unique IDs, acyclic dependencies, and exact catalog parity.

- [ ] **Step 2: Run the denominator proof to verify failure**

Run: `bash tests/accelerate-contract-v1-denominator.sh`

Expected: non-zero because the denominator manifest is absent.

- [ ] **Step 3: Materialize the frozen manifest**

Transcribe the stable denominator from the task catalog and represent each detailed wave capability denominator. A membership change requires an explicit re-freeze and invalidates prior coverage reports.

- [ ] **Step 4: Validate exact parity**

Run: `bash tests/accelerate-contract-v1-denominator.sh`

Expected: exit `0` with required fields present, all IDs unique, dependencies acyclic, and exact 45-task catalog parity. This Wave 0 proof must be self-contained and must not invoke the general contract validator introduced by `ACV1-W1-004`.

- [ ] **Step 5: Preserve rollback identity**

If membership changes after acceptance, restore the last accepted manifest and invalidate every report that used the changed denominator.

- [ ] **Step 6: Commit later as this task-scoped slice**

After explicit implementation authorization only:

```bash
git add planning/execution/accelerate-contract-v1-wave-denominator.json tests/accelerate-contract-v1-denominator.sh
git commit -m "test(contract-v1): freeze implementation denominator"
```

No commit is authorized during the current planning task.

### ACV1-W0-006: Independently Review And Close Wave 0

**Depends on:** `ACV1-W0-003`, `ACV1-W0-004`, `ACV1-W0-005`

**Files:**
- Test: all Wave 0 files
- Evidence: Wave Closure Packet in the active repo-local planning/workflow surface

- [ ] Have a skeptical reviewer compare graph nodes and edges against actual repo files.
- [ ] Classify every finding; correct valid in-scope defects before closure.
- [ ] Re-run focused tests after corrections.
- [ ] Run `bash tests/all.sh`; expect final marker `all tests passed`.
- [ ] Run `git status --short --branch`; verify pre-existing dirty changes are still present or explicitly integrated, never silently removed.
- [ ] Record denominator coverage; require 100% of authority nodes and edges because waiving authority ambiguity is not allowed.

## Rollout

Wave 0 is documentation/test-only. Publish the graph as a prerequisite owner and leave runtime behavior untouched.

## Rollback

Rollback by task-scoped slice. For `ACV1-W0-003`, remove/revert the authority
graph and matching focused test together. Revert owner pointers and denominator
files only with their own task slices. Do not reset or restore the whole
worktree; preserve unrelated state.

## Risks

| Risk | Mitigation |
| --- | --- |
| Graph duplicates authority-set doctrine | Keep classes in `authority-set-gate.md`; graph owns relationships and precedence only |
| Runtime export language conflicts with current files | Record current implementation reality without promoting output to authority |
| Dirty generated-runtime work is accidentally folded in | Do not modify generated runtime in Wave 0; inspect staged paths |
| Tests only search keywords | Include negative reverse-edge and forbidden-authority fixtures |
| Link updates create broad documentation churn | Add minimal pointers only |

## Exit Gate And Deliverables

Deliverables:

- `core/control-plane/authority-graph-v1.md`
- `tests/authority-graph-v1.sh`
- minimal owner pointers and doctrine test registration
- accepted Wave 0 Closure Packet
- task-scoped bounded commits for each owned Wave 0 slice later

Exit requires:

- authority denominator coverage = 100%
- no cycles or unresolved authority owner
- focused, doctrine, link, full-suite, and diff checks pass
- no runtime behavior or generated file changed
- no user-home path read as authority or written as output
- no unowned dirty change staged or reverted
- reviewer acceptance and explicit `advance to ACV1-W1` decision
