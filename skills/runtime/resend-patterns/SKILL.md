---
name: resend-patterns
description: Optional Resend mail guidance for transactional email, templates, provider events, test/fake proof, bounces, and user-visible state.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review, i18n-patterns
---

# resend-patterns

Use when a project chooses Resend for transactional email.

## Proof Checklist

- template/copy/i18n ownership
- test/fake send proof or provider sandbox proof
- recipient authorization and unsubscribe/consent posture when relevant
- bounce/failure/provider event handling
- idempotency for repeated sends
- visible UI state for sent, pending, failed, or retried mail
