# D14 — Namespace, alias, collision, and retirement source contract

## Disposition

- Status: accepted for Phase-1 source-contract implementation only
- Date: 2026-09-01
- Issue: `CODEX-26`
- Owner: architecture and migration owners
- Governing proposal: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- Governing proposal SHA-256: `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`
- Authorization boundary: current-turn operator authorization for Phase 1 only

## Decision

Phase 1 may implement the closed, repository-owned source contract for typed
canonical identifiers, explicit aliases, collision rejection, and retirement
metadata. It may add schemas, validators, registries, and isolated negative
fixtures. It may not rename a live identifier, activate an alias, migrate a
namespace, remove a reader, change a runtime projection, or mark any existing
entry retired.

Canonical identifiers are tuples of `kind`, `namespace`, `name`, and `version`.
Aliases are typed compatibility records with one canonical target, owner,
source digest, expiry/retirement state, and replacement rationale. Similar
spelling is never resolution. Cross-kind reuse, ambiguous targets, duplicate
canonical identifiers, alias cycles, an alias targeting a retired identifier,
and a projection digest that differs from its source all reject before load or
assignment.

Retirement is append-only and ordered: `active -> deprecated -> retired`.
`deprecated` requires either a replacement or a retained-reader rationale.
`retired` additionally requires a frozen reader denominator proving no active
canonical reader depends on the identifier. Phase 1 defines and tests these
source rules only; Phase 7 owns any later migration or reader retirement.

## Required Phase-1 proof

- closed schema and deterministic validator behavior;
- duplicate, cross-kind, ambiguous-alias, alias-cycle, retired-target, stale
  projection, and missing-reader-denominator rejection fixtures;
- an unchanged-state/no-runtime-effect assertion for every negative fixture;
- a compatibility receipt showing existing readers and names were untouched;
- rollback by deleting only the unpromoted Phase-1 source-contract candidate.

## Non-goals

No catalog installation, symlink, loader change, projection activation,
namespace migration, reader retirement, runtime mutation, or provider write is
authorized by this disposition.

