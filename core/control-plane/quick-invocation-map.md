# Quick Invocation Map

## Purpose

This is the native operator quick map for answering fast:

- what branch is active
- what proof is missing
- what review still blocks closure
- what workflow family is running
- what readiness / timeline / learning state is currently visible
- what comparative review or defect posture is still missing

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
- prompt upgrade approval
- execution-to-spec loop
- systemic UI inconsistency audit
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
- active correction / defect reconciliation
- adversarial / hostile-path review
- observability / performance / N+1
- transport / dependency / legacy doubt
- external skill / adapter vetting
- skill / workflow evaluation lab
- benchmark rerun / result registration

## Prompt Wildcards

Use these operator shortcuts when the user wants Accelerate to turn a raw or
implicit broad request into an approval-gated execution-ready prompt:

- `upgrade-prompt`
- `prompt-to-plan`
- `harden-and-wait`
- `upgrade-and-wait`
- `prompt-coringa`

These activate `Prompt Upgrade Approval Gate`: improve and present the prompt,
wait for explicit approval, then generate persisted report/plan/tasks before any
implementation unless execution authorization is also explicit.

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
- UI shared-owner convergence
- backend QA
- frontend QA
- browser proof
- prompt upgrade approval
- execution-to-spec loop
- systemic UI inconsistency audit
- agent-browser bounded browser operations
- UI polishing observer
- persistent regression
- active correction / defect reconciliation
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
3. has `review/handoff-summary.md` already been read as the compact reentry surface?
4. what mandatory skills are in force?
5. is local workspace init / reentry / reonboarding required before branch
   execution?
6. is issue bootstrap already satisfied?
7. is Story / PRD-lite / SDD / task breakdown required and satisfied?
8. is the planning artifact already satisfied?
9. if `docs/reference/design-system*` exists, is this extraction or
   application?
10. for UI/design-system work, what is the honest owner layer: `token`, `ui`, `ui-enhanced`, `registry`, `shell`, or `page`?
11. is this a UX/UI fullstack surface where backend truth, frontend state, and runtime behavior must be reconciled?
12. is this a shared-owner change that should start above page level?
13. if rollout planning exists, does the entrypoint explicitly name the required pre-read set, contract authority, primary implementation driver, and slicing artifact?
14. does the run need the UI Mutation Ladder explicitly packeted before editing?
15. if UI is mutated from a contract, premium direction, or visual reference, is the Design Implementation Proof Gate active?
16. does the active slice need an explicit `Requested-Vs-Implemented Packet`?
17. does the active slice need a `UX/UI Fullstack Surface Packet`?
18. does the active slice need a `Design Implementation Proof Packet`?
19. have concrete defects already been registered, or is the run still speaking in vague review language?
20. if a defect is in-scope, has the branch corrected it before promotion?
21. does the proof reflect the corrected state or a pre-fix state?
22. is seam proof required instead of a broad route-level claim?
23. for design-system premium work, are the active comparison authorities loaded and named explicitly?
24. for screenshot/capture-heavy proof, is temporary evidence going to `project-root/.tmp/`?
25. what does the readiness dashboard currently say?
26. what checkpoint was crossed last and what comes next?
27. did the run produce a learning that must be registered before closure?
28. does `current-plan.md` need to be synchronized into local status now?
29. should a closure packet be rendered from local status already?
30. should an AI Review Report be rendered from local status already?
31. should a review-ready packet be rendered now?
32. should the review artifacts now be persisted canonically under `.accelerate/review/`?
33. should a pre-review bundle or closure bundle be persisted now?
34. should `prepare-review.sh` or `prepare-closure.sh` be used now instead of a looser manual sequence?
35. what does `suggest-next-local-action.sh` say?
36. should `render-branch-entry-packet.sh` be emitted now?
37. should `render-runtime-delta-packet.sh` be emitted now?
38. should `persist-runtime-packets.sh` be used now?
39. should `persist-handoff-summary.sh` be used now?
40. what proof lane is next?
41. what review still blocks closure?
