# Quick Invocation Map

## Purpose

This is the native operator quick map for answering fast:

- what branch is active
- what proof is missing
- what review still blocks closure
- what workflow family is running
- what readiness / timeline / learning state is currently visible

Use this before opening deeper modules when the goal is orientation, not full
study.

## Minimal Flow

```text
User Request
  -> classify
     -> governed target repo in scope?
        -> yes -> local workspace entry
        -> no  -> continue
     -> conversational / no-op
     -> trivial bounded
     -> ambiguous / prompt hardening
     -> non-trivial engineering
          -> branch select
          -> issue / planning / execution / proof / closure
```

## Active Branch Families

- issue-driven delivery
- product spec to execution
- bug / failure / regression
- architecture / governance doubt
- backend implementation
- frontend implementation
- full-stack delivery
- product-critical surface
- visual / artifact-driven frontend
- design-system application / recomposition
- query / contract-sensitive backend
- browser-proof audit
- agent-browser bounded browser operations
- persistent regression authoring
- UI polishing observer
- adversarial / hostile-path review
- observability / performance / N+1
- transport / dependency / legacy doubt
- external skill / adapter vetting
- skill / workflow evaluation lab
- benchmark rerun / result registration

## Workflow Families

Use the named workflow catalog for exact sequencing, but the common families
are:

- entry shaping
- local workspace bootstrap / reentry
- local status dashboard / continuity
- local checkpoint / readiness reconciliation
- issue bootstrap
- product spec to execution
- planning artifact
- implementation handoff
- design-system application / recomposition
- backend QA
- frontend QA
- browser proof
- agent-browser bounded browser operations
- UI polishing observer
- persistent regression
- governance / contract review
- external skill vetting
- skill evaluation lab
- benchmark rerun / result registration
- closure / forensic review

## Fast Reading Order

1. `root-laws.md`
2. `branch-enforcement-matrix.md`
3. `../issue-topology/issue-driven-mutation-stack.md`
4. `../runtime-packets/qa-proof-stack.md`
5. `../review/architecture.md`
6. `../workflows/catalog.md`

## Quick Questions

Before starting a non-trivial run, answer:

1. what branch is active?
2. is a governed target repo in scope, and what is the `.accelerate/` local
   workspace state?
3. what mandatory skills are in force?
4. is local workspace init / reentry / reonboarding required before branch
   execution?
5. is issue bootstrap already satisfied?
6. is Story / PRD-lite / SDD / task breakdown required and satisfied?
7. is the planning artifact already satisfied?
8. if `docs/reference/design-system*` exists, is this extraction or
   application?
9. what does the readiness dashboard currently say?
10. what checkpoint was crossed last and what comes next?
11. did the run produce a learning that must be registered before closure?
12. does `current-plan.md` need to be synchronized into local status now?
13. should a closure packet be rendered from local status already?
14. should an AI Review Report be rendered from local status already?
15. should a review-ready packet be rendered now?
16. should the review artifacts now be persisted canonically under `.accelerate/review/`?
17. should a pre-review bundle or closure bundle be persisted now?
18. should `prepare-review.sh` or `prepare-closure.sh` be used now instead of a looser manual sequence?
19. what does `suggest-next-local-action.sh` say?
20. should `render-branch-entry-packet.sh` be emitted now?
21. should `render-runtime-delta-packet.sh` be emitted now?
22. should `persist-runtime-packets.sh` be used now?
23. what proof lane is next?
24. what review still blocks closure?
