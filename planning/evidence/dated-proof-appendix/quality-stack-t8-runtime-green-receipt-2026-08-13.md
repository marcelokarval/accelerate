# Quality Stack T8 Runtime Integration Green Receipt

## Identity

- Governing issue: `CODEX-1`
- Scope: `T8`, catalog/install/profile/sync/rollback integration
- Proof date: `2026-08-13`
- Implementation owner: `t8-runtime-correction-writer`
- Independent reviewer: `t8-runtime-parity-review`
- Root acceptance scope: T8 pre-restart only

## Proven State

- Catalog manifest: `inventory=131`, `enabled=39`.
- Global renderer preserves its negative-only contract; enabled root skills are
  proven from manifest semantics rather than fabricated `enabled=true` output.
- Package sync, managed `[skills].config`, catalog profiles, root defaults, and
  logical profiles participate in one receipt-backed transaction.
- Unmanaged packages, skill entries, MCPs, and unrelated configuration are
  preserved.
- Rollback restores exact state after repeated installs and failures injected
  after backup, before replacement, after replacement, and between runtime
  lanes.
- Production and disposable paths reject broad roots, ancestors, descendants,
  symlinks, C0/DEL characters, invalid receipts, and schema drift before unsafe
  mutation.

## Proof

Root and independent review observed these green surfaces:

```text
tests/codex-skill-catalog-truth.sh: PASS (131/39)
tests/global-skill-mirror-stage.sh: PASS
tests/runtime-sync-direct-fast-path.sh: PASS
tests/runtime-sync-codex-collaboration.sh: PASS
tests/doctrine-integrity.sh: PASS
tests/codex-logical-agent-topology.sh: PASS
tests/codex-logical-agent-install.sh: PASS
tests/host-export-contract.sh: PASS
tests/all.sh: PASS in independent frozen snapshot
opt-in disposable codex prompt-input proof: PASS in independent review
```

Independent adversarial proof also rejected symlink escape, C0/DEL input,
receipt containment and exact-schema mutants; recursive missing/different/stale
drift; and all transaction fault boundaries. Selected real `~/.codex` hashes
and trees were unchanged by the review, and no real sync receipt was created.

## Residual Boundary

This receipt proves a safe pre-restart deployment mechanism and disposable
runtime precedence. It does not claim that the current Codex process reloaded
the global catalog. The real repo-to-global sync, fresh process startup,
discovery, and spawn/return replay remain separate; `CODEX-1` stays open.
