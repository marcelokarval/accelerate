# Canonical Catalog Projection Contract

`catalog/` is the canonical catalog. This repository is its authoring
authority. `~/.agents` is an installed/discovery catalog only: it may expose a
projection, but it does not prove the projection loaded, can be called, or is
authorized.

## Projection modes

| Mode | Meaning | Required receipt before its next lifecycle state |
| --- | --- | --- |
| `native-direct` | The harness uses its own native primitive without a filesystem projection. | Fresh native loader/callability receipt. |
| `symlink` | A specific allowlisted projected path refers to a canonical artifact. | Link target, canonical digest, loader receipt. |
| `generated-projection` | A renderer creates a runtime-owned representation. | Renderer manifest, output digest, readback, loader receipt. |
| `api-projection` | The runtime is represented or changed through its official API. | Request identity/idempotency, provider readback, scoped authorization. |

No mode authorizes a blanket home-directory symlink. A symlink projection is
legal only when the exact target, source digest, owner, rollback, and loader
are declared in an approved projection manifest. This contract does not
install, create symlinks, call providers, or promote artifacts.

## Existing consumer compatibility

This contract is additive. Existing runtime bootstrap and consumer registries
remain the runtime-specific compatibility surfaces. A catalog entry may point
at one only when its declared state and projection agree; disagreement blocks
projection and must be reported rather than corrected by silent registry edits.

For current known runtimes, the compatibility readers are
`adapters/runtime/runtime-consumer-registry.json` and
`adapters/runtime/cross-runtime-bootstrap-manifest.json`. Their status remains
authoritative for current callability claims. `Paperclip` has API authority;
it is not represented as a filesystem consumer registry entry.

## Required proof boundary

Each catalog asset records its canonical `lifecycle_state`. The lifecycle is
`defined → registered → projected → loader-confirmed → callable → authorized`.
Every state transition requires the receipt named in `catalog/lifecycle.yaml`;
absence of a receipt blocks the later claim. Existing consumer/bootstrap
statuses are compatibility observations, not replacements for the canonical
state: static, export-only, staged, or registration status cannot justify a
loader, callability, or authorization claim.

For every state above `defined`, an asset must carry the complete ordered
receipt chain for all completed transitions. Each receipt binds its destination
state and required receipt type to the same asset ID, the identity-derived
source path, and that source file's current SHA-256 digest. It also names a
separate repository-contained regular evidence file whose SHA-256 and
machine-readable binding fields are verified; evidence may not live under
`catalog/` or reuse the source artifact. A registry mapping is never such a
receipt. A `projected` receipt additionally names digest-bound physical
projection artifact and provider-or-loader readback files. Alias policy, if ever declared, may name an alternate
harness spelling but must resolve consumer and bootstrap to the same declared
canonical runtime identity; it cannot redirect one runtime to another.

## Source-only boundary

The current validator is deliberately source-only: every catalog asset must
remain `defined` and carry no lifecycle receipts. The lifecycle sequence above
is declarative architecture, not evidence that a repository-local JSON file is
independent runtime proof. Any future transition requires a separately approved
runtime-evidence gate with an external authority and must not be simulated or
authorized by this catalog validator.
Authorization is separately scoped and is never inferred from environment
presence, discovery, a successful loader, or a callable operation.
