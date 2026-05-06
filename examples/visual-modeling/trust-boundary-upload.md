# Upload sample

- diagram type: Trust boundary / dataflow
- source truth: example-only pattern, not project runtime truth
- binding: demonstrates visual-modeling packet shape

## Artifact

```text
Untrusted file
     │ raw bytes
     ▼
╔════════ PUBLIC BOUNDARY ════════╗
║ Browser upload widget           ║
╚══════════════╦══════════════════╝
               │ multipart request
               ▼
╔════════ SERVER TRUST BOUNDARY ══╗
║ authenticate                    ║
║ authorize owner                 ║
║ validate MIME/size/content [1]  ║
║ store safe object + audit [2]   ║
╚══════════════╦══════════════════╝
               ▼
             S3/R2
```

## Callouts

- [1] Mark validation, authority, cardinality, or async behavior when relevant.
- [2] Bind the diagram to audit/proof/implementation surfaces when used in real work.

## Residuals

- Replace placeholder entities and actors with inspected project truth before using this as evidence.
