# Environment capability preflight

Use the host machine catalog before selecting an external provider, database,
local infrastructure service, credential-backed CLI, or MCP.

## Authority order

1. Read `~/.codex/capabilities/environment-capabilities.json`.
2. Resolve the requested system by `id`, display name, or alias.
3. Check `policy_state`, `source_of_truth`, `preferred_access`,
   `forbidden_fallbacks`, `availability`, `read_probe`, and `write_policy`.
4. Validate catalog structure with the bundled script. It must never read or
   emit ENV values.
5. Run the smallest fresh-process read probe needed for the claim.
6. Require explicit authorization and applicable governance for writes.

## Capability states

`defined` means only that configuration is non-empty. Keep it distinct from
registered, materialized, authenticated, callable, and authorized. Empty ENV
entries do not establish access. A disabled system stays unavailable even when
its credentials are defined.

## Fixed local decisions

- PostgreSQL is the primary authority for Hermes application state. Do not
  inspect or use SQLite first, and do not silently fall back to SQLite.
- Plane is accessible only through the governed Plane MCP adapter. Never use a
  copied token or direct HTTP as a substitute.
- ManyChat is disabled. Do not perform even a read probe while that policy
  remains in force.

## Reporting

Report only system identity, ENV names when necessary, defined/empty counts,
policy state, authority, preferred access, and probe outcome. Never include
values, reversible encodings, raw config excerpts, auth headers, or provider
payloads containing secrets.

## Failure posture

Fail closed when the system is absent, ambiguous, disabled, lacks a governed
access path, or requires a write that was not authorized. Do not replace a
missing capability with a familiar tool, local database, cache, or stale
session assumption.
