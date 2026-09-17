# CODEX-26 Phase 1 Exit Revalidation — Hardened Prompt C

## Accepted instruction

> autorizo explicitamente o Prompt C

## Objective

Restore the canonical authority chain for the frozen C14 candidate and execute
only fresh, isolated Phase-1 exit proof through `TASK-011`.

## Authority restoration

Bind a fresh Phase-0 reaffirmation to the provider-backed CODEX-25 `FINISH`
record and fresh Done readback, then bind the canonical proof-only Phase-1
authorization to that reaffirmation, the proposal, SDD, test design, both task
graphs, D01/D08/D11/D12/D14/decision-rebinding, and C14 exact bytes.

## Required proof sequence

Run the full root suite and real OpenSpec lane twice in separate disposable
copies. Audit exit requirements only after those proofs. Then obtain a fresh
independent tester and a fresh independent normative reviewer, perform root
review-of-review, and attempt at most one governed Plane PROGRESS comment only
when all prior gates pass and its fresh preparation handshake is exact.

## Non-goals and stop rules

No candidate correction, historical rewrite, global sync/install, runtime
activation, namespace/reader change, WebUI, deployment, release, Phase 2+, or
Plane Done transition. Stop on authority drift/expiry, C14 hash drift, any test
failure, real-OpenSpec failure/skip/divergence, reviewer rejection, ambiguous
Plane outcome, new P0, needed implementation change, or scope expansion.

## Human boundary

Stop at `TASK-011`. A `Done` transition requires a distinct post-`TASK-011`
human GO.
