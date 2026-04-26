---
name: nodemailer-patterns
description: Optional Nodemailer guidance for SMTP mail, transport configuration, test/fake proof, retries, templates, and failure handling.
user-invocable: true
related-skills: security-patterns, anti-abuse-review, product-runtime-review, i18n-patterns
---

# nodemailer-patterns

Use when a project chooses Nodemailer or direct SMTP for mail delivery.

## Proof Checklist

- SMTP transport and secret boundary proof
- test/fake transport proof
- template/copy/i18n ownership
- retry/failure handling and logging
- idempotency for repeated sends
- visible UI state for sent, pending, failed, or retried mail
