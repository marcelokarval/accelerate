# D13 — Project-local Accelerate overlay boundary

## Decision

| Field | Value |
| --- | --- |
| Disposition ID | `CODEX-17/D13/2026-09-01-project-local-accelerate-overlay-v1` |
| Status | accepted-by-operator |
| Owner | local-workspace owner |
| Date | 2026-09-01 |
| Governing design | `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md` |
| Governing design SHA-256 | `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067` |
| Related decisions | D01 durable state; D11 OpenSpec artifact location |
| Scope | Project-local `.accelerate/` overlay and state boundary |

The project-local `.accelerate/` workspace is an overlay and local-state
surface. It is not an Accelerate core authority, skill package/distribution,
OpenSpec authority, workflow/provider authority, or a substitute for any
approved adapter or lifecycle gate.

## Accepted boundary

1. Core rules, skill source, runtime activation, promotion, provider selection,
   and lifecycle authority remain outside the local overlay.
2. Canonical OpenSpec artifacts remain under `planning/openspec/`, outside
   `.accelerate/`, as established by D11. A local pointer may identify the
   canonical root only when it is digest-bound; it is read-only and cannot hold
   copied artifacts, become a fallback root, or nominate a writer.
3. The D01 Gauntlet layout is an intended template/test-root target, not a
   present active canonical authority. Only after the D01/D08/D11 phase
   dispositions and implementation receipts authorize it may D01-owned mutable
   Gauntlet state be rooted at `<project-root>/.accelerate/gauntlet/`. The root
   and its governed ancestor chain must not be symlinks and must resolve inside
   the explicitly verified project workspace. A missing, outside,
   shared/network, or ambiguous root fails closed; no user-home, XDG,
   temporary, or alternate-store fallback is allowed.
4. Local harness declarations, overrides, and receipts are declarative. Their
   precedence may only narrow an existing authorized scope. They cannot widen
   paths, writers, providers, operations, runtime capability, external-effect
   authority, or a core/adapter/issue gate.
5. The local overlay contains no secrets. Generated/private execution state,
   CAS objects, exports, backups, journals, locks, logs, and private evidence
   must be excluded from the tracked template unless a later, explicit decision
   authorizes a named non-secret control artifact.

## Migration, rollback, and readback

V2 is preserved; adoption of V3 is explicit and does not silently rewrite,
delete, or reinterpret V2 state. A future migration must establish a bounded
source/target inventory, dry-run result, compatibility decision, backup or
rollback receipt, and post-change readback before the old surface can be
retired. It must never create dual canonical writers for planning or Gauntlet
state.

Rollback is non-destructive: preserve the prior state, restore only into a new
verified target where D01 state is involved, and read back the selected
authority, digest, root containment, and generated-state boundary. A digest,
root, or authority mismatch blocks use and requires an operator/root
disposition; it does not permit hand editing, regeneration, or fallback.

## Non-authorization

This decision records architecture only. It does not authorize implementation,
installation, activation, migration execution, runtime enablement, adapter
selection, promotion, backup/restore execution, deployment, or tracker closure.
Each requires its own approved scope and proof gate.
