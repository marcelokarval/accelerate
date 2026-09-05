# Semantic Implication Gate

## Purpose

Run this mandatory gate in two stages. Stage A is a bounded semantic pre-scan
before choosing micro or full prompt hardening. Stage B turns the hardened
request into a bounded impact statement before classification. Together they
select route, risk, and proof from what the change can affect rather than from
prompt length, file count, or a reassuring verb such as "small" or "just".

Prompt length is non-authoritative. A one-line request can change a financial
invariant, authentication boundary, user-visible contract, or durable state.
A long request can still be a bounded documentation task after its effects are
shown to be local and reversible.

## Stage A — Pre-Hardening Semantic Pre-Scan

Before choosing hardening depth, identify the likely domain, capability,
invariant, seam, and effect from the request and immediately available
authority. This is a bounded uncertainty scan, not a route decision or a full
receipt. It must answer only:

- can `goal` and `done means` be stated without hiding an unknown invariant,
  seam, authority, or material effect?
- does any possible implication require full hardening: cross-surface behavior,
  sensitive data, auth, billing, migration, runtime/governance, external effect,
  or product/visual acceptance uncertainty?

If no such implication is exposed, micro-hardening remains eligible. If one is
exposed or cannot be ruled out, use full hardening. Unknown is an escalation
signal; Stage A never classifies work as trivial and never substitutes for the
Stage B receipt.

## Stage B — Required Expansion and Receipt

After hardening and before choosing `conversational / no-op`, `trivial bounded`,
or `orchestrated non-trivial`, record the smallest sufficient expansion:

| Field | Ask | Output |
| --- | --- | --- |
| `domain` | Which bounded business or technical context owns the behavior? | Owner and affected actors/data. |
| `capability` | What can a user, operator, or system do differently? | Requested behavior and explicit non-goals. |
| `invariant` | What must remain true before, during, and after the change? | Preserved or intentionally changed rule. |
| `seam` | Which boundary carries the behavior or truth? | API, UI, auth, queue, provider, persistence, adapter, or workflow boundary. |
| `effect` | What observable state, authority, money, access, or experience changes? | Reversibility, blast radius, and downstream consumers. |

Use existing repository authority for the expansion. The gate does not invent
an owner or turn a supporting reference into governing authority; apply the
Truth Ownership Check and Authority Set Gate where they are required.

## Stage B Decision Output

Produce a concise receipt in the Branch Entry Packet or visible runtime
preamble:

```text
semantic implication:
  domain: <owner/context>
  capability: <behavior + non-goal>
  invariants: <preserve/change explicitly>
  seams: <boundaries and consumers>
  effects: <state/access/money/UI impact and reversibility>
  risk: <low|medium|high|critical + basis>
  route: <direct-fast-path|scoped|orchestrated + basis>
  proof: <focal tests/readback/seam/browser/migration/independent review>
  escalation: <none|named gate or missing authority>
```

`risk`, `route`, and `proof` are required Stage B outputs. An unknown field is
an escalation signal, not evidence that the field has no impact.

## Route And Proof Rules

- `direct-fast-path` is possible only when the expansion shows one known,
  reversible surface, preserved invariants, no material seam, and focal proof.
- Use `scoped` when a single bounded uncertainty needs discovery or independent
  proof but the capability and invariant remain local.
- Use `orchestrated` when effects cross material seams, ownership is unresolved,
  multiple independent lanes are necessary, or proof cannot be focal.
- Select proof from the exposed effect: contract/seam tests for boundary
  changes; browser and accessibility proof for UI behavior; migration and
  rollback/readback proof for durable state; and provider receipts for external
  effects. Generic "tested" language is not a substitute.

## High-Stakes Escalation

Escalate before classification when the expansion touches financial balances or
refunds, authentication/authorization, sensitive data, irreversible external
effects, migrations, source-of-truth ownership, or an unbounded user-visible
contract. Open the applicable risk, issue, specification, and proof gates;
use full prompt hardening and do not select `direct-fast-path` solely because
the requested edit is short. Where the route becomes orchestrated, apply the
standing delegation rule before task-owned mutation.

This gate classifies and routes work. It does not itself authorize deployment,
provider calls, migration execution, promotion, or closure.

## Planning And Execution Consumers

The expansion is input to downstream artifacts, not a duplicate plan:

- An SDD consumes domain ownership, invariants, seams, and intentional changes
  when architecture, data, transport, or runtime ownership is unresolved.
- An OpenSpec artifact set, when the selected adapter and mode require one,
  consumes the capability delta, affected seams, and verification criteria.
  OpenSpec is optional unless another governing contract makes it required.
- A task graph consumes seams and effects to create vertically coherent tasks,
  dependencies, ownership, and proof obligations rather than file-shaped work.
- A Domain Gauntlet, when that governed flow is active, consumes risk, invariant,
  effect, and proof fields for admission and candidate/review gates. Do not
  claim a Gauntlet runtime exists merely because this analysis was performed.

Carry the same terms forward. If an artifact changes the identified domain,
invariant, seam, or effect, rerun this gate before execution continues.

## Examples

### Refund a duplicate payment

- `domain`: billing and payment ledger.
- `capability`: support may refund exactly one eligible duplicate charge.
- `invariant`: one refund per charge; ledger and provider state remain
  reconcilable.
- `seam/effect`: payment provider, idempotency key, accounting record, and
  customer balance are affected.
- `route/proof`: high-stakes escalation; orchestrated route with provider
  receipt, idempotency/negative-path tests, ledger readback, and independent
  review.

### Add a login error message

- `domain`: identity and authentication.
- `capability`: a failed sign-in receives a safe, actionable message.
- `invariant`: no account enumeration, rate-limit behavior, session issuance,
  and audit semantics remain unchanged.
- `seam/effect`: UI copy crosses the auth response boundary and changes the
  attacker-visible experience.
- `route/proof`: do not route from text-only appearance; require auth/security
  review proportionate to the response path plus browser proof of the message.

### Adjust a checkout button layout

- `domain`: checkout conversion interface.
- `capability`: customers can find and activate the existing purchase action.
- `invariant`: price, tax, entitlement, accessibility, and submission behavior
  remain unchanged.
- `seam/effect`: visual layout can affect responsive interaction and may expose
  the payment submission seam.
- `route/proof`: UI route with viewport, accessibility, browser console/network,
  and successful/failed checkout-flow proof; escalate if the action wiring or
  displayed financial terms change.

### Rename a persisted column

- `domain`: durable data model and its consumers.
- `capability`: the same behavior reads and writes the renamed field.
- `invariant`: existing records, constraints, readers, writers, reports, and
  rollback remain valid through the transition.
- `seam/effect`: schema, migration, ORM/API contracts, jobs, and integrations
  are affected.
- `route/proof`: migration escalation with an SDD when ownership/design is
  unresolved; require migration/rollback rehearsal, compatibility and data
  readback proof. It is not a trivial rename.

## Failure Labels

- `semantic-implication-missing`
- `prompt-length-used-as-risk-proxy`
- `invariant-unresolved`
- `seam-unmapped`
- `effect-unbounded`
- `route-without-semantic-basis`
- `proof-without-effect-basis`
