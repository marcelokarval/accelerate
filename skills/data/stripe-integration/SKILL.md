---
name: stripe-integration
description: Codex-native Stripe billing guidance adapted to the project's current abstraction, webhook safety, and provider-state ownership model.
user-invocable: true
related-skills: payment-integration, security-patterns, django-service-patterns
---

# stripe-integration

Use this skill for Stripe-specific payment and billing integration decisions.

## Purpose

Provide Stripe-focused guidance adapted to the current project conventions,
especially where the codebase uses an abstraction layer instead of raw API-first
design.

## Load When

Load this skill when the task touches:

- Stripe checkout or subscription flows
- Stripe webhooks
- billing state synchronization
- refunds, invoices, payment methods, subscription lifecycle

## Core Rules

1. Respect the project's chosen Stripe abstraction and data ownership model.
2. Do not duplicate Stripe as a second source of truth in domain models.
3. Verify webhook authenticity and design handlers for idempotency.
4. Keep secrets, tokens, and card handling within provider-safe boundaries.
5. Model asynchronous Stripe events explicitly.

## Accelerate Guidance

- Treat Stripe integration as billing architecture, not just API calls.
- Align with the existing billing domain and persistence strategy already in the
  project.
- Prefer official provider flows and safe abstractions over custom raw-card
  handling.

## Review Checklist

- What is the source of truth?
- Is webhook handling idempotent and verified?
- Are asynchronous state changes reflected in the domain correctly?

## Evaluation Fixtures

Use `evals/` when checking whether an implementation or agent answer preserves
Stripe-specific provider-boundary safety.

For implementation or closure packets, use
`core/risk/financial-provider-fixtures.md` to capture Stripe charge, refund,
subscription, webhook signature, idempotency, and reconciliation evidence while
keeping concrete Stripe command execution outside core doctrine.
