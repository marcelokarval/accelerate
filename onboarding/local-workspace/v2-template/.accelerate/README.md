# `.accelerate`

## What This Is

This directory is the local workspace of `accelerate` inside this repository.

It persists onboarding truth, active planning truth, and local pre-agents
governance so a fresh session can continue without reconstructing context from
conversation alone.

## Canonical Files

The main canonical files here are:

- `state.yaml`
- `status/readiness-dashboard.yaml`
- `onboarding/status.yaml`
- `onboarding/decisions.yaml`
- `planning/current-plan.md`
- `planning/user-story.md`
- `planning/prd-lite.md`
- `planning/sdd.md`
- `planning/executive-plan.md`
- `planning/task-breakdown.md`
- `agents/status.yaml`
- `review/review-ready-packet.md`
- `review/ai-review-report.md`
- `review/closure-packet.md`
- `review/branch-entry-packet.md`
- `review/runtime-delta-packet.md`
- `review/handoff-summary.md`
- `review/pre-review-bundle.md`
- `review/closure-bundle.md`
- `review/current-slice-review.md`
- `review/current-slice-forensics.md`
- `review/defect-ledger.yaml`
- `review/seam-proof.md`

## Summary vs Detailed Authority

- `state.yaml` is the fast global summary index
- `status/readiness-dashboard.yaml` is the local branch/readiness synthesis authority
- `status/timeline.jsonl` is the append-only continuity log of meaningful local workspace transitions
- `status/learnings.jsonl` is the append-only store for durable operational learnings worth carrying across sessions
- `onboarding/status.yaml` is detailed onboarding and reentry authority
- `onboarding/decisions.yaml` is detailed onboarding decision authority
- `planning/current-plan.md` is the active local planning index and governing artifact pointer
- `planning/user-story.md`, `planning/prd-lite.md`, `planning/sdd.md`, `planning/executive-plan.md`, and `planning/task-breakdown.md` are the local artifact ladder
- `agents/status.yaml` is detailed local pre-agents posture authority
- `review/*.md` are persisted local handoff and closure artifacts derived from current local status
- `review/branch-entry-packet.md` and `review/runtime-delta-packet.md` are persisted local runtime observability packets
- `review/handoff-summary.md` is the compact session reentry view over the persisted review and runtime packet surfaces
- `review/current-slice-review.md`, `review/current-slice-forensics.md`, `review/defect-ledger.yaml`, and `review/seam-proof.md` are reusable per-project instances of the active review/correction model
- bundle artifacts group those review surfaces for operator handoff

## What Accelerate May Rewrite

`accelerate` may rewrite summary and planning state here when:

- onboarding is real
- discovery is factual
- planning artifacts have been created
- local agent posture is clearly inferable

## Fresh Session Reading Order

For a fresh session, read in this order:

1. `state.yaml`
2. `status/readiness-dashboard.yaml`
3. `onboarding/status.yaml`
4. `onboarding/decisions.yaml`
5. `planning/current-plan.md`
6. `planning/user-story.md`
7. `planning/prd-lite.md`
8. `planning/sdd.md`
9. `planning/executive-plan.md`
10. `planning/task-breakdown.md`
11. `planning/open-questions.md`
12. `agents/status.yaml`
13. `status/timeline.jsonl`
14. `status/learnings.jsonl`
15. `review/review-ready-packet.md`
16. `review/ai-review-report.md`
17. `review/closure-packet.md`
18. `review/branch-entry-packet.md`
19. `review/runtime-delta-packet.md`
20. `review/handoff-summary.md`
21. `review/pre-review-bundle.md`
22. `review/closure-bundle.md`
23. `review/current-slice-review.md`
24. `review/current-slice-forensics.md`
25. `review/defect-ledger.yaml`
26. `review/seam-proof.md`

## Non-Goals

This directory must not become:

- a duplicate of repo `AGENTS.md`
- a duplicate of standalone `accelerate` doctrine
- a raw session log
- a place for secrets or runtime noise
- a place for cache, tmp files, browser traces, or throwaway artifacts

`timeline.jsonl` and `learnings.jsonl` are exceptions only because they are
small, append-only operational memory surfaces. They should remain curated and
high-signal, not become general chat transcripts.
