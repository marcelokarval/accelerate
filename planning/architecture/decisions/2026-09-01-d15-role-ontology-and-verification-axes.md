# D15 — Role Ontology and Verification Axes

- Status: accepted architecture for source-only implementation
- Date: 2026-09-01
- Governing proposal: `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- Governing proposal SHA-256: `79473c41e77c626a0c849d0ff385be7c140e7f66cfbf047e55ba5ccfe05cd067`
- Addendum: `planning/architecture/2026-09-01-codex-22-verification-graph-heartbeat-addendum.md`

## Context

The proposal distinguishes builders and reviewers, but a delivery also needs a
clear distinction between adversarial testing, QA assessment, and independent
review. Collapsing them would allow one favorable artifact to claim several
proof dimensions.

## Decision

`Tester` is a distinct role from `QA`. Tester creates or executes deliberate,
especially adversarial, verification against contracts and negative paths. QA
assesses delivered quality across behavior, usability/runtime evidence,
observability, resilience, cleanup, and the applicable proof lane. Neither
role is automatically an independent reviewer.

`adversarial` and `independent` are orthogonal axes:

- adversarial: the assessment actively seeks a violating input, transition,
  side effect, race, boundary breach, or false-success condition;
- independent: the reviewer has a distinct runtime `agent_id` and `call_id`,
  a non-empty isolation attestation reference, read-only review authority, and
  exact candidate/spec bindings. The source validator checks those fields; it
  does not inspect or prove a harness's actual context isolation.

An assignment MUST carry a surface and `domain_path`, such as
`backend / financial.gateway.refund`, so proof can be routed to the actual
domain/capability/seam rather than only a generic technical role.

## Consequences and gates

The source-only assignment schema and validator in this candidate reject role
collapse, a missing `domain_path`, reviewer write authority, reused
`agent_id`/`call_id` where independence is required, a missing isolation
attestation reference, and an adversarial claim with no negative-test evidence.
They do not establish live harness isolation. Backend, frontend, integrations,
data, runtime, and governance each
select their domain-relevant tester/QA checks; they do not share a universal
green result.

This decision does not create profiles, live assignments, runtime instances,
provider calls, Plane changes, or closure authority. The included schemas,
validator, and fixtures are source-only contracts; runtime enforcement remains
gated by a separately accepted adapter scope and fresh independent review.

## Rejected alternatives

| Alternative | Why rejected |
| --- | --- |
| Treat Tester as a QA alias | hides adversarial contract testing behind a quality label |
| Treat same-run review as independent | no fresh separation of actor/context/candidate authority |
| Infer domain from a technical role | loses capability/seam ownership and misroutes risk |
