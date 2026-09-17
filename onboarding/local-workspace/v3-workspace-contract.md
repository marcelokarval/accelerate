# V3 Local Workspace Contract

V3 is a project-local overlay and execution-state boundary. It is not a copy of
Accelerate core authority, a skill distribution, a workflow backend, or a
second planning tree. V2 remains intact and independently materializable. The
D01/D11 shape below is an intended template/test-root target only; it is
inactive until the required D01/D08/D11 phase dispositions and implementation
receipts authorize a separate implementation.

## Authority split

| Surface | Authority | Rule |
| --- | --- | --- |
| `planning/openspec/` | Canonical OpenSpec change, spec, binding, evidence, and archive artifacts | Tracked outside `.accelerate/`; the selected adapter is its only writer. |
| `.accelerate/planning-pointer.yaml` | Read-only overlay pointer | Names the intended D11 canonical target and binds the governing design digest; before activation it has no target-artifact digest and never contains a copied spec, fallback root, or writable projection. |
| `.accelerate/gauntlet/` | D01 mutable execution state | Holds only the durable ledger, immutable CAS, replaceable exports, and recovery material. |
| `.accelerate/harness/` | Narrowing local harness policy | Contains declarations, authority-narrowing overrides, and receipts only. It cannot grant a writer, provider, path, or capability. |

`planning/openspec/` is the intended D11 canonical target, pending its required
phase disposition and implementation receipts; it is not a live local-overlay
authority. No OpenSpec bytes, cache, lock, archive, or duplicate planning
hierarchy may be stored in `.accelerate/`. `governing_design_sha256` binds the
design authorization only, not target artifact bytes. Before activation,
`target_artifact_digest` must remain `unavailable-pending-activation`. A future
authorized activation must replace it with an approved manifest/content digest
and verify that digest before use. A mismatch or unavailable digest after
activation blocks use; it does not permit regeneration, fallback, or a local
copy.

## V3 template allowlist

```text
.accelerate/
  README.md
  state.yaml
  planning-pointer.yaml
  harness/
    declarations.yaml
    overrides.yaml
    receipts.yaml
  gauntlet/
    README.md
    .gitignore
    cas/sha256/             # generated, immutable content-addressed objects
    exports/                # generated, replaceable read-only projections
    backups/                # generated recovery material, never canonical
    state.sqlite3           # generated canonical mutable ledger; never template content
```

Only the named tracked control files are versioned. `state.sqlite3`, SQLite
journals, CAS objects, exports, backups, journals, locks, logs, private
evidence, and provider payloads are generated/private and ignored. No live
SQLite database is committed by this template.

## D01 state-root requirements

When separately implemented and activated by its required gates, the state root
is exactly `<project-root>/.accelerate/gauntlet/`. Its resolved path must be
inside the explicitly verified project root and neither the root nor any
ancestor in the governed path may be a symlink. Implementations must fail
closed if the root is absent, outside the workspace, network/shared, or
ambiguous; they must not redirect to `$HOME`, XDG, a temporary directory, or a
second store. This template does not create or activate that root.

The future `state.sqlite3` would be the sole canonical mutable metadata and
event ledger. CAS would contain exact immutable bytes only. Exports, harness
files, OpenSpec artifacts, and existing workflow files are projections or
declarations and are never a write source or recovery fallback for the ledger.

## Harness constraints

`declarations.yaml` states requested local constraints, `overrides.yaml` may
only narrow an already-authorized scope, and `receipts.yaml` records observed
or verifier-issued receipts. They are declarative documents: no executable
hooks, credentials, provider configuration, arbitrary paths, or approval
claims belong there. A harness document cannot widen authority, activate a
runtime, nominate a new canonical writer, or bypass a core/adapter/issue gate.

## Adoption boundary

This is a template and contract only. It does not implement migrations,
SQLite/CAS operations, backups, OpenSpec delivery, adapters, installation,
promotion, deployment, or runtime enablement. Those require their separately
approved implementation and proof gates.
