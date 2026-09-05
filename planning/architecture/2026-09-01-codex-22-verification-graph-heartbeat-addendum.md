# CODEX-22 Verification Graph and Heartbeat Addendum

## Status and authority

- Date: 2026-09-01
- Work-item authority: `CODEX-22` in Plane; Plane remains the sole tracker.
- Governing proposal: [Accelerate Portable Agent Fabric + OpenSpec Composition](./2026-09-01-accelerate-portable-agent-fabric-openspec-design.md)
- Observed governing-proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`
- Form: additive, source-only successor addendum.

This addendum extends the proposal by reference; it does not rewrite the
proposal, replace its recorded digests, transfer any prior acceptance, or
grant acceptance to itself. It authorizes neither implementation, installation,
copying, runtime activation, promotion, deployment, tracker transition, nor
external effect. Each requires its own accepted scope and predicate-bound
receipt.

## Decision set

| Decision | Subject | Disposition | Required later gate |
| --- | --- | --- | --- |
| D15 | role ontology and verification axes | implemented as source contract in this candidate | focused proof and independent review |
| D16 | Archify optional visual adapter | defer implementation; accept boundary | typed-IR schema, deterministic validation, provenance and output tests |
| D17 | heartbeat and Git snapshot reanalysis | implemented as source contract in this candidate | focused proof and independent review |
| D18 | AI Hero practices | selectively adopt doctrine | per-practice implementation/proof and independent review |

## Verification graph

## Visual Modeling Packet

- diagram type: governance topology
- source truth: governing proposal at the SHA-256 above; D15--D18 in this addendum
- decision surface: role separation, proof axes, optional visual outputs, and liveness evidence
- binding: future role/assignment schemas, proof validators, and source-only control-plane docs
- excluded scope: live runtime instances, provider liveness, Git state promotion, and tracker mutation

```text
                    ┌───────────────────────────┐
                    │ Hardened domain/capability │
                    │ + domain_path              │
                    └─────────────┬─────────────┘
                                  │ frozen input
                                  v
  ┌─────────────┐      ┌────────────────────┐      ┌──────────────────┐
  │ Builder     │ ───> │ candidate + proofs │ ───> │ Tester           │
  │ writes only │      └────────────────────┘      │ verification;    │
  └─────────────┘                    │              │ may challenge    │
                                     │              │ adversarially    │
                                     │              └────────┬─────────┘
                                     │                         │ findings
                                     v                         v
                              ┌───────────────┐       ┌──────────────────┐
                              │ QA             │       │ Independent      │
                              │ quality/runtime│       │ review axis      │
                              └───────┬───────┘       └────────┬─────────┘
                                      └──────────────┬─────────┘
                                                     v
                                            root fan-in / gate
                                                     │
       Git snapshot + heartbeat ── delta only ──────┘
       Archify typed IR ── standalone diagram only ─┘
```

### Callouts

- [1] `Tester`, `QA`, and `independent reviewer` are non-substitutable axes.
  Tester is verification work, QA is a proof discipline, and independent
  reviewer is an authority relationship. A green test run does not satisfy the
  entire QA stack, and a same-run critique does not establish independence.
- [2] Adversarial posture asks *how the candidate can fail*; independence asks
  *whether the assessor has a distinct runtime instance, isolated context,
  exact candidate/spec bindings, and no write authority*. They are orthogonal
  axes and can both be required.
- [3] Heartbeats and Git snapshots only select a reanalysis delta baseline;
  they are not proof of current runtime truth or a gate advance.
- [4] Archify output is reviewable documentation, never the architecture,
  impact analysis, risk finding, extraction authority, or runtime truth.

### Decisions / residuals

- accepted: source-only role, visual-adapter, heartbeat, and practice boundaries.
- implemented here: source-only assignment ontology and task-graph/heartbeat
  schemas, validators, and negative fixtures.
- deferred: runtime-adapter calls, Archify adapter implementation,
  installations, and promotion.
- residual ambiguity: runtime enforcement and any production heartbeat owner
  require a future accepted implementation contract.

## D15 application matrix

Every assignment records the domain/capability and a typed `domain_path`, for
example `backend / financial.gateway.refund`. The prefix is the technical
surface; the suffix identifies the bounded domain/capability/seam. It is not a
permission grant and it does not replace an ownership check.

| Surface | Tester focus | QA focus | Independent-review focus |
| --- | --- | --- | --- |
| backend | contracts, negative paths, authorization, idempotency | service behavior, logs, observability | scope/proof/risk critique |
| frontend | state, accessibility, error/retry behavior | browser truth, responsive and interaction quality | contract and product-risk critique |
| integrations | provider ordering, retry, malformed payloads | resilience and telemetry | authority, secret, and effect review |
| data | constraints, migrations, rollback, concurrency | data quality and operational safety | lineage and semantic-risk review |
| runtime | startup/failure/readback fixtures | health, logs, cleanup, operator journey | liveness/evidence and boundary review |
| governance | gate denial and stale-receipt fixtures | packet quality and traceability | authority and closure review |

## Gates common to D15--D18

1. A named source record and immutable pin/digest is required before doctrine
   is adopted.
2. A source-only decision does not make a component installed, callable,
   authorized, or promoted.
3. Any future adapter or practice must have deterministic negative fixtures;
   model judgment may complement but cannot replace them.
4. Review after a material correction is fresh and independent; builder,
   tester, QA, and reviewer claims are separately evidenced.
5. Plane lifecycle remains separate from documentation, diagrams, heartbeats,
   tests, and review conclusions.
