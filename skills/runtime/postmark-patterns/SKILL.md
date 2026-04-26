---
name: postmark-patterns
description: Optional Postmark mail guidance for transactional email streams, templates, test/fake proof, bounces, webhooks, and user-visible state.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review, i18n-patterns
---

# postmark-patterns

Use when a project chooses Postmark for transactional email.

## Proof Checklist

- message stream and template ownership
- test/fake send proof or provider sandbox proof
- recipient authorization and unsubscribe/consent posture when relevant
- bounce/spam/failure webhook handling
- idempotency for repeated sends
- visible UI state for sent, pending, failed, or retried mail
