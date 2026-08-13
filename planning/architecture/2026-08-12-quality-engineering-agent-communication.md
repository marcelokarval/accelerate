# Quality Engineering Agent Communication Model

## Visual Modeling Packet

- Diagram type: agent communication
- Source truth:
  - `2026-08-12-quality-engineering-stack-sdd.md`
  - `../../agents/base-agent-contract.md`
  - `../../core/delegation/subagent-model.md`
  - `../../adapters/runtime/codex-collaboration/role-policy.json`
- Scope included: assignment, bounded execution/review, return packets,
  correction routing, integration, issue lifecycle, and closure authority.
- Scope excluded: process/filesystem isolation claims, hidden agent state,
  physical-agent promotion, and post-restart runtime discovery.
- Binding: agent templates, collaboration profiles, spawn packets, return
  validators, root review-of-review, and Plane lifecycle operations.

```text
╔══════════════ WORK-ITEM / USER AUTHORITY ══════════════╗
║ User intent + governed Plane issue                     ║
╚═══════════════════════╤════════════════════════════════╝
                        │ request + acceptance boundary
                        ▼
╔══════════════════ ROOT AUTHORITY BOUNDARY ═════════════╗
║ Accelerate root/orchestrator [1]                       ║
║ classify → accept SDD → assign → integrate → close     ║
╚══╤════════╤════════╤════════╤════════╤═══════════════╤═╝
   │        │        │        │        │               │
   │ draft  │ review │ write  │ review │ review        │ review
   ▼        ▼        ▼        ▼        ▼               ▼
┌────────┐ ┌────────┐ ┌──────┐ ┌──────┐ ┌────────┐ ┌──────────┐
│ Spec   │ │ Arch.  │ │Impl. │ │ Code │ │Security│ │Test/Perf │
│engineer│ │reviewer│ │worker│ │review│ │ auditor│ │reviewers │
└───╤────┘ └───╤────┘ └──╤───┘ └──╤───┘ └───╤────┘ └────╤─────┘
    │ packet   │ packet   │packet  │finding  │finding         │proof
    ╰──────────┴──────────┴────────┴─────────┴────────────────╯
                         ══→ root reconciliation [2]
                                  │
                    correction × self-acceptance [3]
                                  │
                                  ▼
                   ╔══════════════════════════╗
                   ║ Root review-of-review   ║
                   ║ + Plane progress/closure║
                   ╚══════════════════════════╝
```

## Callouts

1. Only the root owns issue topology, external mutation authorization,
   integration, review-of-review, acceptance, and closure.
2. Specialists return explicit packets; they do not rely on shared hidden
   context or directly accept another lane without root reconciliation.
3. A test engineer assigned to write tests loses independent acceptance
   authority for those tests. A separate review lane or root exception with
   residual risk is required.
4. Templates and logical collaboration profiles are routing contracts, not
   proof of tool, MCP, credential, process, or filesystem isolation.
5. Code, security, test, and performance findings remain separate inputs; the
   root may reconcile overlap but must not erase dissent or downgrade evidence.

## Residual Ambiguity

- Native Codex spawn does not yet prove per-agent skill/profile isolation.
- The pre-restart unit can prove packet and policy semantics, but fresh-process
  routing and prompt inventory remain pending after the user restarts Codex.
- Physical specialist promotion remains deferred until empirical replay proves
  value and containment.
