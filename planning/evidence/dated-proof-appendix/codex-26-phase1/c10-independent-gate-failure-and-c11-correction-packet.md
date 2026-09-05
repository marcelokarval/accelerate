# CODEX-26 Phase 1 — C10 Independent Gate Failure / C11 Hardening

- rejected candidate: `CODEX-26-P1-IMPLEMENT-C10`
- frozen aggregate: `sha256:4e40f38027678423c7a2bcf5610150d88c50563be00c90af394869ab60068ae2`
- freeze receipt file: `sha256:33e5e7be32115134dac7b5606279ec380cf58d4899661b3e2309722028845f2b`
- tester verdict: `FAIL`
- reviewer verdict: `FAIL`
- successor: `C11`
- operator-extra correction round: `7/8`

## Closed correction denominator

1. Readiness verification uses a trust authority captured inside the production
   verification boundary. Runtime lookup of a replaceable module global, or a
   caller-supplied verifier/keyring, is forbidden.
2. G4/G5/G6 aggregate receipts receive the same cryptographic authority,
   signer/epoch, freshness and exact expected-context enforcement. A nonempty
   arbitrary signature cannot pass.
3. A04 production execution does not accept a caller callback or caller-created
   state/observation adapter. A closed internal dispatcher selects the handler,
   validates supplied fixture input and observes its own revision/effect and
   artifact state. Caller-controlled `True`, fake state or external adapter
   cannot establish `changed` or a forbidden-effect claim.
4. A04 policy is an exact transcription of the governing main and supplemental
   tables. Public outcomes expose normalized domain states (`NO_GO`,
   `NO_GATE_EVIDENCE`, etc.) and family-specific forbidden effects, never raw
   `BAD_DIGEST`/`SCHEMA_MISSING_FIELD` implementation details where the
   proposal specifies a normalized result. Every five-field value is asserted.
5. Remove gate-created cache residue before successor freeze.

All other C10 probes remain regression requirements. C11 requires two real
runs, zero skips, deterministic validated receipts, no caches, clean diff and
zero known residuals. No acceptance, promotion, runtime, namespace, reader,
Plane closure or Phase-2 authority is granted.
