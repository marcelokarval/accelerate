# Stack Heuristics

Use heuristics only after loading repo-local instructions and stack authority.
A search hit is a candidate signal, not a confirmed defect.

## Universal Candidate Signals

- untrusted input reaches a shell, query, template, path, or deserializer;
- ownership is inferred from client-provided identity;
- critical read-modify-write behavior lacks concurrency reasoning;
- external calls lack bounded failure, timeout, retry, or idempotency handling;
- configuration changes silently alter defaults or authority;
- documentation or workflow text disagrees with machine-enforced behavior;
- tests assert implementation detail while missing affected behavior;
- proof is stale, planned, or detached from the changed generation.

## Stack-Aware Selection

1. Detect languages, frameworks, package manager, wrappers, and CI entrypoints.
2. Read local architecture, validation, security, and test conventions.
3. Select only checks supported by those authorities.
4. Capture commands and raw output without converting hits directly to severity.
5. Inspect context, reproduce when safe, and record confidence.

## Examples of Conditional Checks

- ORM code: ownership filters, query count, transactions, and eager loading.
- Browser UI: DOM safety, accessibility semantics, network errors, hydration,
  bundle/loading behavior, and responsive states.
- APIs: schema compatibility, authorization, idempotency, pagination, and
  provider failure.
- Infrastructure: least privilege, secret boundaries, rollback, drift, and
  immutable artifact provenance.

Do not impose a service-layer folder, file-size threshold, identifier scheme,
or tool command unless the active repository makes it authoritative.
