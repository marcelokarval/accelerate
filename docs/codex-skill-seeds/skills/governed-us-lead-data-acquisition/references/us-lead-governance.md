# US Lead Governance Checklist

## Required Record of Decision

- Purpose and approved business use.
- Source, source URL or contract reference, collection date, and permitted-use
  basis as documented by the source.
- Minimum required fields, enrichment sources, transformations, and owner.
- Retention/deletion schedule, suppression source, opt-out path, and human
  approver before the first contact.

## Lifecycle

1. Reject a source when its terms, access method, or intended use are unclear.
2. Store provenance alongside the lead record; do not convert a derived field
   into a source claim.
3. Minimize fields at collection and restrict downstream access to the stated
   purpose.
4. Check suppression and opt-out before import, routing, and every outbound
   contact. An opt-out wins over enrichment or source recency.
5. Expire or delete records according to the recorded retention decision.
6. Require named human approval before any record is contact-eligible.

## Privacy Consultation (Non-Gate)

This skill governs US-only acquisition. Consult privacy, LGPD, or other
jurisdictional materials only when comparison or escalation helps the named
owner; they are not an operational gate in this workflow. Do not substitute a
generic privacy reference for the required source, provenance, minimization,
retention, suppression, opt-out, and human-approval decisions above.

## Boundaries

Do not bypass anti-bot or access controls, impersonate users, share source
credentials, or automate around a source's restrictions. Escalate ambiguous
legal, contractual, or privacy questions to the designated owner. Privacy and
LGPD materials may be consulted for comparison, but they are not an operational
gate in this US-only workflow.
