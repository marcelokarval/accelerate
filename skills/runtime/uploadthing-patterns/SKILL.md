---
name: uploadthing-patterns
description: Optional UploadThing guidance for file upload routes, ownership, middleware auth, callbacks, lifecycle, and untrusted ingress proof.
user-invocable: true
related-skills: untrusted-ingress-hardening, security-patterns, anti-abuse-review, nextjs-app-router-patterns
---

# uploadthing-patterns

Use when a project chooses UploadThing for uploads in a Next.js app.

## Proof Checklist

- upload route and file router ownership
- middleware auth and ownership proof
- file size/type/metadata validation
- callback/webhook idempotency and failure proof
- public/private visibility and deletion lifecycle
- UI state proof for uploading, uploaded, failed, and deleted states
