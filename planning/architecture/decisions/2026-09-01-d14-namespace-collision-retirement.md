# D14 — Namespace Collision and Retirement

- Status: accepted architecture; no retirement action authorized
- Date: 2026-09-01
- Decision owner: operator-approved Accelerate architecture
- Governing proposal: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`

## Decision

Governed catalog assets use the repository-owned `prop4you.accelerate`
namespace. Unqualified lookup is denied. The name `accelerate` is reserved for
the repository's canonical namespace and cannot be claimed by a harness,
runtime projection, installed catalog entry, or external package.

The external Hugging Face distribution is identified only as
`external.huggingface.huggingface-accelerate`. Its distribution name,
`huggingface-accelerate`, is not an alias for this repository; the aliases
`accelerate` and `hf-accelerate` are forbidden. Any normalized-name collision
blocks resolution and produces a report instead of choosing a winner.

## Projection and lifecycle consequences

The namespace rule applies before any `native-direct`, `symlink`,
`generated-projection`, or `api-projection` operation. Discovery in `~/.agents`
does not reserve a namespace or establish authority. An installed projection
must carry its fully qualified canonical identity, source digest, and
projection receipt; the loader, callability, and authorization receipts remain
independent requirements.

Paperclip remains an API-authoritative projection. Its provider readback and
scoped authorization are required regardless of namespace availability.

## Migration, shadowing, and rollback

A collision migration is shadow-first: create a distinct fully-qualified
candidate definition, validate the per-harness projection canary, and preserve
the active projection until an explicitly authorized cutover. No blanket home
symlink may be used to redirect names. An exact-path symlink, if separately
approved, must be manifest-backed and recoverable.

Rollback restores the prior verified projection or removes only the candidate
projection. Retirement requires a recorded successor or a verified no-reader
state, retained provenance, and a separate authorization; it does not delete
the repository definition merely because a home catalog changed.

There is no current promotion, cutover, installation, symlink creation,
provider call, retirement, or removal authorized by this decision.

## Consequences

`catalog/namespaces.yaml` is the machine-readable collision policy. Existing
runtime consumer and bootstrap registries are not changed by this decision;
any inconsistency is a blocking reconciliation finding, not permission to
mutate a registry or runtime.
