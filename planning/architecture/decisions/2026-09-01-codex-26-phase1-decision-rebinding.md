# CODEX-26 Phase-1 decision rebinding

## Status and authority

- Status: accepted for the explicitly authorized Phase-1 implementation
- Date: 2026-09-01
- Operator: Marcelo Karval
- Canonical issue: `CODEX-26`
- Proposal SHA-256: `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`
- Phase-0 operator-acceptance SHA-256: `f722da4531542f3e2585f111ba8f0d334e5bf3655e44c1cadf3f303cdb4c759d`

This record rebinds the accepted decision content below to the current proposal
candidate and the user's current-turn Phase-1 authorization. It does not
rewrite the historical files or extend their effect boundary.

## Rebound dispositions

| ID | Accepted source | Current disposition | Phase-1 effect boundary |
| --- | --- | --- | --- |
| D01 | `2026-09-01-d01-gauntlet-durable-state.md` | SQLite ledger plus same-filesystem immutable CAS | implement fixture-scoped store and A03/restore-CAS proof only |
| D08 | `2026-09-01-d08-openspec-delivery-form.md` | pinned OpenSpec Core CLI behind a repo-owned JSON adapter | isolated tool/test root only; no global or project dependency install |
| D11 | `2026-09-01-d11-openspec-artifact-location.md` | canonical project root `planning/`, child `planning/openspec/` | disposable equivalent only; no live project OpenSpec tree required |
| D12 | `2026-09-01-d12-skill-catalog-source-projection-contract-v2.md` | repository source is authority; runtime catalogs are projections | implement source/projection contract and stale/divergent fixtures only |
| D14 | `2026-09-01-d14-namespace-alias-retirement-source-contract.md` | typed identifiers, explicit aliases, collision and retirement rules | source schemas/validators/fixtures only; no migration or retirement |

## Frozen OpenSpec Core release

| Field | Value |
| --- | --- |
| Package | `@fission-ai/openspec` |
| Version/tag | `1.11.0` / `v1.11.0` |
| Git commit | `a0ddb60d040c61f4907436a9d91310934b1dda63` |
| npm shasum | `0637db769ac89a2120f98f5ce23f05f29e50c193` |
| npm integrity | `sha512-P9h8H4Snit8I7tHmCopjg3QDwBllIlObxb+/DebvBwhWTj6YEPPYRYkC4n5GqG4PdQnKMA6E1AlEOI9FT4G7FA==` |
| Downloaded tarball SHA-256 | `84820b173b57204bd7582a47ddae65e85fd492724172acc8e434e97ea1c05c3f` |
| Runtime requirement | Node.js `>=20.19.0` |
| License | MIT |

The release tuple was freshly resolved from the official GitHub tag/release,
`git ls-remote`, and npm registry metadata. Fixture staging must verify the
same tuple before execution and must not use `latest`, `main`, or `master`.

## Explicit forbidden effects

This rebinding does not authorize global install/sync, active catalog
projection, symlink creation, runtime loader mutation, namespace migration,
reader retirement, WebUI, deployment, or Phase 2–7 work.
