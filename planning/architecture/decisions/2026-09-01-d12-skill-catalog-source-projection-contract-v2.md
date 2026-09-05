# D12 — Skill catalog source and projection contract v2

## Disposition

- Status: accepted for Phase-1 source-contract implementation only
- Date: 2026-09-01
- Issue: `CODEX-26`
- Owner: architecture owner
- Governing proposal SHA-256: `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`
- Predecessor: `2026-09-01-d12-skill-catalog-authority-projection.md`

## Decision

The Accelerate repository is the only authoring authority for governed skill,
profile, adapter, and overlay definitions. User-home catalogs, harness-native
directories, installed mirrors, API registrations, and loader inventories are
read-only projections. Presence, loader discovery, callability,
authentication, and mutation authorization are distinct states and must never
be collapsed.

Phase 1 may implement a closed source/projection mapping contract, deterministic
digest validation, and stale/divergent/missing projection fixtures. Each record
binds canonical identifier and digest, source locator/revision, projection
mode, target harness/locator, owner, reader, lifecycle state, and rollback
route. Missing or unequal bindings reject before bootstrap.

## Allowed Phase-1 effects

- repository schemas, registry examples, validators, documentation, and
  isolated fixtures;
- exact-path negative tests for stale, divergent, missing, ambiguous, and
  unverified projections;
- compatibility proof that current readers and runtime mirrors were unchanged.

## Forbidden effects

No runtime sync, global/user-home install, symlink, API registration, loader
change, active projection, cutover, promotion, removal, or provider mutation is
authorized. Paperclip, Hermes, Codex, Claude, OpenCode, OpenHands, DSH, and any
other harness retain their current effective state until a later adapter- and
operator-specific receipt proves otherwise.

## Rollback

Remove only the unpromoted CODEX-26 source-contract candidate and its isolated
fixtures. Never infer rollback bytes from an installed projection and never
modify a runtime reader during Phase 1.

