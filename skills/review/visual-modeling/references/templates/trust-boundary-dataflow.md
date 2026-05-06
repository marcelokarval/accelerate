# Trust Boundary / Dataflow Template

Use for auth, uploads, payments, exports, provider callbacks, recovery flows, PII, credentials, and hostile ingress.

## Must Include

- actors/systems
- trust boundaries
- sensitive payload labels
- validation/sanitization points
- storage/audit points
- blocked paths or redaction rules when relevant

## Template

```text
Untrusted User/Input
        │ raw payload [1]
        ▼
╔════════════════ BROWSER / PUBLIC BOUNDARY ════════════════╗
║ Frontend form / upload widget                              ║
╚══════════════════════╦═════════════════════════════════════╝
                       │ validated request
                       ▼
╔════════════════ SERVER TRUST BOUNDARY ═════════════════════╗
║ Backend route/controller                                   ║
║ ├─ authenticate                                             ║
║ ├─ authorize owner/tenant                                   ║
║ ├─ validate/sanitize payload                                ║
║ └─ write audit/event [2]                                    ║
╚══════════════════════╦═════════════════════════════════════╝
                       │ safe subset
                       ▼
              DB / Storage / Provider
```

## Callouts

- [1] Name sensitive fields or hostile input type.
- [2] Name audit, idempotency, redaction, or retention requirement.

## Common Mistakes

- drawing data movement without authority checks
- omitting redaction and storage boundaries
- treating provider payloads as trusted by default
