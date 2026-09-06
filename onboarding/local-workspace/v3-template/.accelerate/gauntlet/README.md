# D01 Gauntlet State Root

This is an intended D01 state-root template/test layout, not an active runtime
or canonical store. It remains inactive until D01/D08/D11 phase dispositions
and implementation receipts authorize a separate implementation. If activated,
the state root is exactly `.accelerate/gauntlet/` under the verified project
root. It must not be a symlink, resolve outside the project workspace, or be
replaced with a user-home, XDG, temporary, network, or shared root.

The intended layout is:

```text
state.sqlite3        canonical mutable metadata and append-only ledger
cas/sha256/aa/<hash> immutable exact-byte objects
exports/             replaceable read-only projections
backups/             verified recovery material, never canonical state
```

No database is included in this template. `state.sqlite3`, CAS, exports,
backups, locks, logs, journals, provider payloads, and private/generated
evidence are ignored. OpenSpec, harness YAML, workflow adapters, and exports
cannot write or recover canonical ledger state.
