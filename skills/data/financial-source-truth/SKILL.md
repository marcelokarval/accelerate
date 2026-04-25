---
name: financial-source-truth
description: Codex-native skill for bank-grade credit, balance, charge, refund, reserve, reconciliation, SQL projection, and admin observability work.
metadata:
  category: backend-finance
  origin: project-local
---

# Financial Source Truth

Use this skill whenever work touches:

- balances and wallets
- charges, refunds, holds, captures, reversals
- ledgers and operation summaries
- pricing and plan-sensitive billing
- skip trace, SMS, or any credit-consuming product
- admin/support financial observability
- SQL views or materialized views over financial data

## First Principle

The backend is the only financial source of truth.

Frontend surfaces may present or filter, but they must not invent financial
meaning.

## Layer Split

### Product billing policy

The product decides whether to charge.

Examples:

- Skip Trace: charge only when real data exists
- SMS: charge according to the SMS product policy

### Shared financial kernel

The kernel handles:

- debit
- credit
- reserve
- capture
- refund
- void
- reverse
- reconcile
- idempotency
- append-only ledger logic

### Projections

User, admin, and internal analytics must all derive from the same canonical
operation summary.

## Operational Summary

Prefer a canonical summary shape with:

- gross amount
- refunded amount
- net amount
- financial status
- charge reference
- refund reference
- timestamps

Do not rely on a single request row field as the sole financial truth once
refunds and reversals exist.

## PostgreSQL Rules

- live balances and write-path truth stay in transactional tables
- normal SQL views are preferred for canonical read models
- materialized views are for heavy analytics only
- `pg_cron` is appropriate for MV refresh and stale-queue jobs
- `django-pgtrigger` is appropriate for immutable/append-only protection and
  transition guards
- `django-pghistory` is appropriate for event timelines and admin support

## Hard Don'ts

- do not hardcode pricing in presenter/query layers
- do not use materialized views for live balances
- do not let user and admin surfaces drift into incompatible stories
- do not compute wallet truth from frontend state

## Review Checklist

- what is the product billing policy?
- what is the canonical kernel event?
- what is the canonical backend summary?
- which surface is user-facing and which is operator-facing?
- where does reconciliation live?
- which values are gross, refunded, and net?
- which values are provider economics only and should stay internal?

## Evaluation Fixtures

Use `evals/` when checking whether an implementation or agent answer preserves
financial source-of-truth rules.

For implementation or closure packets, use
`core/risk/financial-provider-fixtures.md` to capture charge, refund,
idempotency, reconciliation, and projection evidence before accepting financial
correctness claims.

## Useful Companions

- `payment-integration`
- `postgresql`
- `database-design`
- `postgres-best-practices`
- `anti-abuse-review`
- `product-runtime-review`
