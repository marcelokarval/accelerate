# ADR 003: Accelerate before ASDS

Status: accepted by the owner for implementation and release on 2026-10-01.
Version: 1.0.0. Supersedes ADR 002's assignment of methodological lifecycle
ownership to Accelerate; runtime infrastructure remains separate.

## Decision

Accelerate classifies and prepares requests. Conversation/trivial work is direct.
Other engineering work is handed to independent spec-driven-superpowers (ASDS),
which decides activation and owns planning, tasks, review, integration and closure.
Harnesses own tools, execution and permissions. Specialist capabilities remain
selectable without reactivating a competing workflow.

## Consequences

Remove mandatory issue/workspace/dispatch/proof-stack initialization from entry.
Preserve context, scope, prior approvals and refusals across handoff. No duplicate
planning, task ledger or closure. Preserve optional tooling with explicit scope;
old orchestration contracts are historical rather than current validation claims.

The structured Python classifier is reference code, not natural-language intent
recognition, model compliance proof or a live integration into ASDS. Runtime
prompts/adapters express the same roles; deployment is outside this release.
