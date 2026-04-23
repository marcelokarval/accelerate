# Quick Invocation Map

## Purpose

This is the native operator quick map for answering fast:

- what branch is active
- what proof is missing
- what review still blocks closure
- what workflow family is running

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
9. what proof lane is next?
10. what review still blocks closure?
