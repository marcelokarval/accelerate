# Sequence Diagram Template

Use when ordered interactions across actors/systems matter.

## Must Include

- actors/systems
- ordered arrows
- important payload/transition labels
- async vs sync distinction
- provider callback or failure path when relevant

## Template

```text
User          Frontend          Backend          Provider          DB
 │               │                │                │              │
 │ action        │                │                │              │
 ├──────────────→│                │                │              │
 │               │ request        │                │              │
 │               ├───────────────→│                │              │
 │               │                │ provider call  │              │
 │               │                ├───────────────→│              │
 │               │                │ result         │              │
 │               │                │←═══════════════┤              │
 │               │ response       │                │              │
 │               │←═══════════════┤                │              │
 │               │                │ webhook/event  │              │
 │               │                │← - - - - - - - ┤              │
 │               │                ├─────────────────────────────→│
```

## Callouts

- Mark idempotency, signature verification, retries, and ledger/audit writes.
- Use `- - - →` for async callbacks and queue handoffs.

## Common Mistakes

- omitting provider callbacks
- making async work look synchronous
- missing failure/retry/idempotency path
