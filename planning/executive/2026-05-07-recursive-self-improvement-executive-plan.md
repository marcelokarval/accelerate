# Recursive Self-Improvement Executive Plan

Date: 2026-05-07
Root role: orchestrator / final reviewer
Execution model: bounded subagent implementation + subagent task review + root integration review
Repository: `/home/marcelo-karval/Backup/Projetos/accelerate`

## Goal

Make Accelerate recursively inspect and improve itself as a first-class internal operating mode.

The new loop must help future sessions look inward at Accelerate's own purpose, functionality, implementation progress, gaps, drift, duplication, redundancy, proof coverage, and next-step sequencing. It must not be a vague retrospective ritual: findings must become durable artifacts, bounded tasks, tested contracts, and next-cycle inputs.

## Current Context

Accelerate already has:

- root control-plane doctrine;
- local workspace scripts;
- runtime packets;
- workflow/runtime capability manifests;
- repo-local skill registry;
- visual modeling governance;
- capability maturity dashboard;
- green local and remote test suite.

Recent confirmed state:

- GitHub PR adapter is partially native/proven;
- GitHub PR land/merge remains `planned`;
- Linear writes remain `blocked` by `structured_non_llm_mcp_write_binding_required`;
- runtime adapter manifests contain many `planned`/`substitute` states;
- agent factory is architecturally meaningful but not operationally complete;
- local `.accelerate/` workspace exists as a target-repo mechanism but is not yet persistently dogfooded in this repo.

## Success Criteria

This slice is successful when it adds a native recursive-improvement operating surface that:

1. names the internal audit cadence and scope;
2. defines required output packets for each cycle;
3. creates a dashboard of improvement situations, not just prose;
4. maps improvement situations to bounded follow-up tasks;
5. requires subagent task review before root closure;
6. requires proof and persisted artifacts before any improvement is called done;
7. is covered by a repository contract test;
8. passes `tests/all.sh`, `git diff --check`, push, and remote CI.

## Non-Goals For This Slice

- Do not implement Linear remote writes in this slice.
- Do not run a real GitHub PR land/merge proof in this slice.
- Do not create a persistent `.accelerate/` dogfood workspace yet.
- Do not build the full agent factory.
- Do not rewrite the entire README or global doctrine.

Those are downstream tasks that the recursive loop must surface and prioritize.

## Operating Model To Add

Add a native self-improvement loop with these phases:

1. **Inventory** — read repo status, CI, tests, manifests, dashboards, skills, adapters, runtime packets, planning artifacts.
2. **Situation Detection** — classify internal situations such as blocked capability, planned capability without proof, duplicate doctrine, stale supporting reference, weak negative fixture coverage, missing dashboard, skill-sync drift, idle planned agent surface.
3. **Task Shaping** — convert each situation into bounded tasks with owner lane, files, proof, and stop rules.
4. **Delegated Execution** — implementation slices go to bounded subagents where safe.
5. **Delegated Task Review** — every task gets independent task review or a declared exception.
6. **Root Review-of-Review** — root verifies the reviewers, not just implementers.
7. **Persistence** — update dashboards, ledgers, packets, and proof appendices.
8. **Next-Step Emission** — report completed work and precompute the next improvement queue.

## Files Expected To Change

Primary additions:

- `core/control-plane/recursive-self-improvement-loop.md`
- `core/control-plane/recursive-improvement-situation-dashboard.md`
- `core/runtime-packets/recursive-improvement-cycle-packet.md`
- `planning/executive/2026-05-07-recursive-self-improvement-executive-plan.md`
- `planning/executive/2026-05-07-recursive-self-improvement-task-ledger.md`
- `tests/recursive-self-improvement-contract.sh`

Likely supporting edits:

- `core/README.md`
- `core/runtime-packets/README.md`
- `tests/all.sh`

## Task Breakdown

### RSI-1 — Native loop contract

Deliver `core/control-plane/recursive-self-improvement-loop.md`.

Required content:

- purpose and scope;
- recursive trigger conditions;
- cycle phases;
- situation taxonomy;
- bounded task shaping rules;
- subagent execution/review rules;
- idle-agent/process cleanup rule;
- root final review rule;
- persistence and next-step emission contract.

Proof:

- Contract test must verify presence of core loop terms and required phases.

### RSI-2 — Improvement situation dashboard

Deliver `core/control-plane/recursive-improvement-situation-dashboard.md`.

Required content:

- dashboard status vocabulary;
- current internal situations;
- status, evidence, residual, next task, owner lane;
- must include at least: GitHub land proof, Linear MCP writes, `.accelerate/` dogfood, semantic negative gates, runtime adapter maturity, skill sync topology, agent factory promotion pipeline.

Proof:

- Contract test must verify dashboard rows for all priority situations and that blocked/planned states are not promoted without proof.

### RSI-3 — Recursive cycle packet

Deliver `core/runtime-packets/recursive-improvement-cycle-packet.md` and index it in `core/runtime-packets/README.md`.

Required fields:

- cycle id;
- trigger;
- inventory scope;
- detected situations;
- task ledger link;
- subagent assignment map;
- review map;
- proof map;
- closure verdict;
- next-cycle queue.

Proof:

- Contract test must verify packet is indexed and contains required fields.

### RSI-4 — Task ledger and review structure

Deliver this task ledger and ensure it records:

- implementation task;
- assigned subagent or root/orchestrator role;
- reviewer;
- requested-vs-implemented check;
- proof;
- status;
- residual.

Proof:

- Contract test must verify the ledger exists and contains RSI-1..RSI-4 task IDs.

### RSI-5 — Test and integration

Deliver `tests/recursive-self-improvement-contract.sh` and wire it into `tests/all.sh`.

Proof:

- `bash tests/recursive-self-improvement-contract.sh`
- `bash tests/all.sh`
- `git diff --check`
- final remote CI success after push.

## Subagent Plan

- Implementer subagent A: RSI-1 and RSI-2.
- Implementer subagent B: RSI-3, RSI-4, RSI-5.
- Reviewer subagent C: independent review of the combined diff and task ledger.

Root orchestrator will not trust subagent summaries blindly. Root must verify files, tests, git diff, and remote CI.

## Risks And Stop Rules

Stop or re-plan if:

- subagents edit outside assigned scope;
- a subagent works in the wrong repository/branch;
- tests fail in ways that require architectural changes;
- the loop duplicates existing surfaces instead of linking them;
- dashboard promotes planned/blocked capabilities without proof.

## Verification Commands

```bash
bash tests/recursive-self-improvement-contract.sh
bash tests/all.sh
git diff --check
git status --short --branch
gh run watch <run-id> --repo marcelokarval/accelerate --exit-status
```

## Expected Next Queue After This Slice

1. GitHub PR land/merge live proof.
2. Linear structured MCP write binding.
3. Persistent `.accelerate/` dogfood workspace for this repo.
4. Semantic negative fixtures for packets/gates.
5. Runtime capability maturity dashboard.
6. Skill sync topology.
7. Agent factory promotion pipeline.
