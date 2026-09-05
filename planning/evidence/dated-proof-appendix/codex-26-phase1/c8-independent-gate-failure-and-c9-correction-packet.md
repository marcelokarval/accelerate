# CODEX-26 Phase 1 — C8 Independent Gate Failure / C9 Correction

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C8`
- frozen aggregate: `sha256:72984ad9b39786eb138178c9383968e31187c2ba69c58db5d5edae9c0e31a871`
- freeze receipt: `sha256:d8ef27f3f0e08648e7a2503db046549e424e1dd0e8d8788a4746699e4e3235c7`
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- successor: `C9`
- operator-extra correction round: `5/8`

## Closed correction denominator

1. Every readiness family has a mandatory complete expected-context schema.
   Validation must reject an omitted material binding, an unrecognized trust
   root/validator identity, a wrong key, or any receipt field/nested binding
   that differs from current authority. Re-signing attacker-chosen current
   bindings must not make them authoritative.
2. The production A04 boundary must select an internally closed policy by
   fixture/action ID and derive its receipt digest set from observed artifacts.
   The caller/test may not supply arbitrary expected state, revision effect,
   forbidden effect or receipt digests. A no-op cannot claim `changed` or forge
   a receipt.
3. D12 catalog `source_digest` must be recomputed from a documented,
   domain-separated canonical source payload including source locators,
   revisions, entry digests, identities, lifecycle, aliases, reader denominator
   and rollback. A locator or any governed source mutation with the old digest
   must reject.

All other C8 probes remain regression requirements. C9 requires two real runs,
zero skips, deterministic validated receipts, no caches, clean diff and zero
known residuals before freeze. This packet grants no acceptance, promotion,
runtime, namespace, reader, Plane closure or Phase-2 authority.
