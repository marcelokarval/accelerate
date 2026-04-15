# Team Operating Model

Use this module when `accelerate` must be explained or operated as a visible
team operating system rather than as a narrow branch classifier.

## Core Principle

`accelerate` should make explicit who is currently shaping, planning,
implementing, testing, reviewing, and closing the work.

These roles are operating postures. They can later become real agents, but they
must already exist as workflow personas now.

## Full Persona Stack

### Core personas

- `Specification PM`
- `Prompt Hardening Editor`
- `Product Planner`
- `Issue Architect / Workflow Adapter`
- `Implementation Designer`
- `Wireframe / Design Contract Extractor`
- `Implementer / Developer`
- `Backend Implementer`
- `Frontend Implementer`
- `Delivery PM`
- `Backend Tester`
- `Frontend Tester`
- `Browser-Proof Auditor`
- `E2E Regression Engineer`
- `Security Reviewer`
- `Anti-Abuse Reviewer`
- `Accessibility Reviewer`
- `Performance / Observability Reviewer`
- `Data / Contract Steward`
- `Provider Boundary Auditor`
- `Stack Constitution Auditor`
- `Legacy Truth Analyst`
- `Recovery Surface Reviewer`
- `Migration Steward`
- `Fixture / Test Data Steward`
- `Experiment / Rollout Planner`
- `Compliance / Policy Reviewer`
- `Docs / Change Communicator`
- `Release / Handoff Manager`
- `Incident / Hotfix Commander`
- `Governance Auditor`
- `Closure / Forensic Reviewer`
- `Master Integrator`

## Rich Operating Diagram

```text
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                   ACCELERATE — TEAM OPERATING SYSTEM                                              ║
╠══════════════════════╦══════════════════════╦══════════════════════╦══════════════════════╦══════════════════════╣
║ ENTRY / SHAPING      ║ ISSUE / PLANNING     ║ IMPLEMENTATION       ║ QA / PROOF           ║ CLOSURE              ║
╠══════════════════════╬══════════════════════╬══════════════════════╬══════════════════════╬══════════════════════╣
║ Specification PM     ║ Issue Architect /    ║ Implementation       ║ Backend Tester       ║ Closure / Forensic   ║
║ [1]                  ║ Workflow Adapter [4] ║ Designer [5]         ║ [9]                  ║ Reviewer [17]        ║
║ actor/goal/accept    ║ labels/parent/status ║ slices/contracts     ║ services/queries     ║ req vs impl          ║
║                      ║                      ║                      ║                      ║                      ║
║ Prompt Hardening     ║ Product Planner [3]  ║ Wireframe / Design   ║ Frontend Tester [10] ║ Governance Auditor   ║
║ Editor [2]           ║ rollout/deps/scope   ║ Contract [6]         ║ TS/i18n/states       ║ [16]                 ║
║ Prompt A -> Prompt B ║                      ║                      ║                      ║ stack/truth drift    ║
║                      ║                      ║                      ║                      ║                      ║
║                      ║                      ║ Implementer /        ║ Browser-Proof        ║ Release / Handoff    ║
║                      ║                      ║ Developer [7]        ║ Auditor [11]         ║ Manager [18]         ║
║                      ║                      ║ code mutation        ║ Chrome DevTools      ║ release / follow-up  ║
║                      ║                      ║                      ║                      ║                      ║
║                      ║                      ║ Delivery PM [8]      ║ E2E Regression       ║ Master Integrator    ║
║                      ║                      ║ checkpoints/cadence  ║ Engineer [12]        ║ [19]                 ║
║                      ║                      ║                      ║ Playwright           ║ final authority      ║
╠══════════════════════╩══════════════════════╩══════════════════════╩══════════════════════╩══════════════════════╣
║ Specialist sidecars available on demand: Security Reviewer [13], Anti-Abuse Reviewer [14], Accessibility          ║
║ Reviewer [15], Performance / Observability Reviewer [20], Data / Contract Steward [21], Provider Boundary         ║
║ Auditor [22], Legacy Truth Analyst [23], Experiment / Rollout Planner [24], Docs / Change Communicator [25].      ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
```

## Handoff Rule

Every persona must leave a named packet or a concrete decision artifact before
the next blocking owner proceeds.

Minimum chain:

1. `Specification Handoff Packet`
2. `Planning Handoff Packet`
3. `Implementation Design Packet`
4. `Implementation Handoff Packet`
5. `Runtime Review Packet` / `QA Packet`
6. `Governance Packet` when stack or truth drift exists
7. `Closure Packet`
8. `Master Revalidation Checklist`

## Why This Exists

Without this explicit team model, `accelerate` risks looking like an abstract
branch router rather than the collaboration system from which future agents can
be derived.

## Future Agent Derivation Rule

The full team model is not decorative.

It exists so that future concrete agents can be derived from already explicit
workflow roles instead of being invented ad hoc later.

When a future agent is proposed, the proposal should say:

- which existing persona it comes from
- which packet/handoff it owns
- which gates it can block
- which proofs it is allowed to collect
- which review lane still remains with the master
