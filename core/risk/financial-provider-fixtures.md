# Financial Provider Fixtures

## Purpose

This packet gives financial, payment, and provider-specific work a repeatable
fixture shape for money correctness without binding core doctrine to one
provider or command runner.

Use it when a branch touches charges, refunds, subscriptions, webhooks,
idempotency, reconciliation, provider state, financial projections, or
customer/operator money surfaces.

## Source-Of-Truth Rule

The local backend financial model owns product money truth.

Providers supply verified evidence and settlement signals. Frontend returns,
provider dashboards, raw callback payloads, and customer-facing success screens
are not sufficient authority on their own.

## Fixture Packet

```md
# Financial Provider Fixture Packet

## Scenario

- fixture id: <short stable name>
- scenario type: <charge|refund|subscription|webhook|idempotency|reconciliation|mixed>
- provider scope: <provider-agnostic|Stripe|other named provider>
- product surface: <checkout|billing settings|admin|support|export|wallet|subscription gate|other>
- mutation path: <sync request|async event|scheduled reconciliation|manual operator action|read-only review>

## Actors And Boundaries

- customer/user actor: <who initiates or observes the action>
- backend authority: <model/service/ledger/summary expected to own truth>
- provider evidence: <verified event/object/state expected from provider>
- frontend evidence: <return URL/UI state/client callback, if any>
- operator evidence: <admin action/export/support view, if any>
- forbidden authority: <client-only success/provider-only narrative/stale projection/etc.>

## Money And State Inputs

- amount and currency: <gross amount, currency, minor-unit expectations>
- prior domain state: <pending|paid|refunded|partially_refunded|active|past_due|canceled|etc.>
- incoming provider state: <event/object/status and verification requirement>
- expected domain transition: <explicit state transition or no-op>
- ledger/operation effect: <debit|credit|reserve|capture|refund|void|reverse|none>
- projection surfaces: <user/admin/export/reporting surfaces that must agree>

## Idempotency And Replay

- idempotency key: <provider event id|domain operation key|request key|none-but-required>
- duplicate delivery behavior: <no duplicate financial effect|safe retry|blocked>
- race condition to probe: <concurrent webhook/request/operator action>
- audit expectation: <record duplicate evidence without duplicating money effect>

## Webhook And Provider Verification

- authenticity proof: <signature verification/server-side fetch/provider SDK verification/not applicable>
- ordering assumption: <in-order|out-of-order|unknown>
- missing-event behavior: <pending reconciliation|manual review|fail closed|not applicable>
- stale-provider-state behavior: <re-fetch|defer|mark reconciliation gap|not applicable>

## Reconciliation Proof

- canonical backend summary: <gross/refunded/net/status/provider refs/timestamps>
- provider comparison: <which verified provider fields must match or explain drift>
- internal comparison: <ledger vs summary vs domain state vs projections>
- user/admin/export parity: <expected agreement or intentional difference>
- residual drift: <none|known acceptable|blocked until resolved>

## Required Evidence

- implementation evidence: <service/model/handler/projection touched or reviewed>
- regression evidence: <unit/integration/eval fixture proving behavior>
- runtime evidence: <logs/trace/provider event replay/browser proof when needed>
- negative-path evidence: <duplicate, stale, unsigned, failed, partial, or raced input>

## Verdict

- pass/fail/blocked: <verdict>
- closure gaps: <missing proof or unresolved drift>
- follow-up owner: <domain owner/profile/adapter, if known>
```

## Scenario Checklist

### Charge

- The client cannot mark a charge paid without backend/provider verification.
- A successful charge creates one financial effect for one domain operation.
- Gross, fees/provider economics, refunded, and net values are not conflated.
- User, admin, and export surfaces derive from the same backend summary.

### Refund

- Partial and full refunds update the canonical backend summary.
- Refunds are idempotent by provider refund ID or domain refund operation key.
- Reversed/failed refund events do not leave projections in a paid/refunded split.
- Provider economics stay internal unless the operator surface explicitly owns them.

### Subscription

- Return URLs and browser redirects are not subscription authority.
- Local entitlement transitions are driven by verified provider state and product
  policy.
- Past-due, canceled, trialing, incomplete, and resumed states are modeled
  explicitly enough for access decisions.
- Reconciliation defines what happens when local and provider state disagree.

### Webhook

- Authenticity verification is mandatory before financial effects.
- Duplicate, delayed, out-of-order, and missing events have explicit behavior.
- Handler retries do not duplicate credits, invoices, ledger entries, or access.
- Raw payload storage must not leak secrets or card data.

### Idempotency

- Every mutation path names the idempotency key that prevents duplicate money
  effects.
- Idempotency is enforced at the backend authority boundary, not only in UI or
  transport code.
- Audit history may record attempts, but financial effects remain single-shot.

### Reconciliation

- The packet compares backend truth, provider evidence, and projections.
- Any unresolved drift is a closure blocker, not a documentation-only note.
- Scheduled/manual reconciliation paths must state what they can repair and what
  requires operator escalation.

## Skill Routing

- Use `financial-source-truth` for ledger, balance, refund, reserve,
  reconciliation, operation-summary, and financial projection correctness.
- Use `payment-integration` for provider-agnostic checkout, payment event,
  subscription, retry, and idempotency workflow correctness.
- Use `stripe-integration` for Stripe-specific webhook, Checkout, Billing,
  customer portal, invoice, refund, and subscription boundary correctness.

## Core Boundary

Core owns this fixture shape and closure expectations.

Concrete provider commands, SDK calls, dashboard steps, webhook replay commands,
and environment-specific secrets handling belong in adapters, profiles, or
project implementation docs rather than this core risk packet.
