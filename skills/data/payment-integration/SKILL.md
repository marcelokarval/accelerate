---
name: payment-integration
description: Codex-native payment workflow guidance for checkout, subscriptions, idempotency, refunds, and asynchronous provider-event handling.
user-invocable: true
related-skills: stripe-integration, security-patterns, django-service-patterns
---

# payment-integration

Use this skill for broader payment workflow design beyond a single provider.

## Purpose

Provide cross-provider payment integration rules around checkout flows,
subscriptions, idempotency, webhook design, and payment-state modeling.

## Load When

Load this skill when the task touches:

- billing or payment architecture
- provider-agnostic payment flows
- checkout lifecycle, retries, disputes, refunds
- webhook patterns and payment-state persistence

## Core Rules

1. Security and idempotency come first.
2. Never trust client-side payment status alone.
3. Verify provider events server-side.
4. Keep payment state transitions explicit.
5. Design for retries, duplicates, partial failures, and asynchronous updates.

## Accelerate Guidance

- Use this skill for payment architecture and workflow reasoning.
- Use `stripe-integration` when the task is specifically Stripe-bound.
- Keep billing domain invariants and provider integration boundaries clean.

## Review Checklist

- Is idempotency handled?
- Are async payment events modeled explicitly?
- Is provider verification server-side?

## Evaluation Fixtures

Use `evals/` when checking whether an implementation or agent answer preserves
provider-agnostic payment workflow safety.
