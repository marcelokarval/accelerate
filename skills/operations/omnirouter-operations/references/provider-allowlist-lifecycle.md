# Provider Allowlist Lifecycle

Use this reference when a supported OmniRoute provider connection must be
retained, disabled, or re-enabled under an explicit authorization. It governs
connection lifecycle; it does not qualify models or authorize deletion.

`isActive` is connection state. `excludedModels` is an independent model-level
filter. Do not infer either from the catalog, a dashboard appearance, an HTTP
status, or the other field. Read both before deciding the intended state.

## Governed sequence

1. Freeze the authorized connection identifiers, intent, operator, time, and
   complete affected denominator. Record a restricted pre-state and a supported
   rollback backup; never include credentials.
2. State the exact desired `isActive` and any separately authorized
   `excludedModels` change. Do not widen a model filter merely because a
   connection is being disabled.
3. Apply one narrow supported mutation at a time. For web providers, remain
   sequential and stop on rate limit, auth risk, or unexpected result.
4. Immediately read back the individual connection and then the affected
   denominator. Record requested change, observed `isActive`, observed
   `excludedModels`, timestamp, and redacted receipt locator.
5. Prove retained authorized connections positively with an appropriate
   non-destructive canary, and prove a discriminating negative for a disabled
   connection without corrupting credentials or deleting anything. A catalog
   listing alone is not either proof.
6. On a health, authorization, routing, or readback mismatch, stop and restore
   through the supported path. Read back rollback state and record residuals.

No provider, connection, model, credential, or historical evidence is deleted
under this lifecycle. Report unreconciled connections, ambiguous state,
unrun negative proof, and rollback artefacts as residuals rather than closing
over them. A disabled connection is reversible state, not erasure.
