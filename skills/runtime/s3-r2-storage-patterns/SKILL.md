---
name: s3-r2-storage-patterns
description: Optional S3/R2 storage guidance for uploads, object ownership, visibility, signed URLs, lifecycle, deletion/export posture, and untrusted ingress hardening.
user-invocable: true
related-skills: untrusted-ingress-hardening, security-patterns, anti-abuse-review
---

# s3-r2-storage-patterns

Use when a project chooses S3-compatible storage or Cloudflare R2.

## Proof Checklist

- bucket, prefix, and object ownership model
- content-type, size, malware/parser, and metadata handling
- public/private visibility and signed URL posture
- lifecycle, retention, deletion, and export behavior
- upload/download authorization proof
- provider credentials and environment boundary proof
