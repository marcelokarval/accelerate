# Issue Creation Readiness

For `issue__add_issue`, pass `issue_readiness` separately from the provider
payload. It must carry contract version 1, objective, context, bounded scope,
non-goals, acceptance criteria, explicit owner disposition, priority rationale,
dependencies, validation plan, and execution units. The provider payload must
also contain a concrete title and an execution-ready `description_html` body.

Hash the canonical readiness document and put the digest in
`authorization_receipt.issue_readiness_fingerprint`. The governed adapter
rejects missing, incomplete, or mismatched readiness before it contacts Plane.
