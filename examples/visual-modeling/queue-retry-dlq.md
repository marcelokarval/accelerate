# Retry/DLQ sample

- diagram type: Queue topology
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
API request
  │ enqueue [idempotency key]
  ▼
╔══════════════╗      lease       ╔══════════════╗
║ default queue║━━━━━━━━━━━━━━━━→ ║ worker       ║
╚══════╦═══════╝                  ╚══════╦═══════╝
       │ retry 3x                        │ success
       ▼                                 ▼
╔══════════════╗                  audit/job_events
║ DLQ          ║
║ manual review║
╚══════════════╝
```

## Callouts

- [1] Mark validation, authority, cardinality, ordering, retry, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
