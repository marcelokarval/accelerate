---
name: governed-us-lead-data-acquisition
description: Govern US lead-data acquisition and enrichment. Use when selecting lead sources, collecting public or licensed data, building enrichment or routing pipelines, or approving outreach-ready records in the United States; require source terms, provenance, minimization, retention, suppression, opt-out, and human approval before contact.
---

# Governed US Lead Data Acquisition

Apply this only to US-oriented acquisition. Read
[`references/us-lead-governance.md`](references/us-lead-governance.md) before
collecting, enriching, importing, or approving a lead dataset.

## Workflow

1. State the business purpose, target segment, fields required, responsible
   owner, and intended use before selecting a source.
2. Verify the source's permitted use, access method, commercial terms, and
   collection constraints. Keep source and collection time with every record.
3. Collect the minimum fields needed. Preserve provenance and transformation
   history; distinguish source assertions from verified facts.
4. Apply retention, deletion, suppression, and opt-out rules before import or
   routing. Keep a durable suppression check before every outbound contact.
5. Deduplicate and quality-check records without silently overwriting source
   provenance or a prior opt-out.
6. Require a named human approval before an acquired record becomes eligible
   for contact. Escalate unclear legal, contractual, or source-permission cases.

## Guardrails

- Do not provide anti-bot bypasses, evasion techniques, credential sharing, or
  instructions to defeat source controls.
- Do not infer consent, a relationship, or contact eligibility from public
  availability alone.
- Do not use this skill as a legal determination. The privacy/LGPD reference is
  consultation-only and is never a workflow gate for this US-only skill.
- Do not reuse suppressed, opted-out, expired, or provenance-free records.

## Output Contract

Produce a source register, purpose/field-minimization decision, provenance and
retention plan, suppression/opt-out handling, human approver, and unresolved
risks. State explicitly whether any record is contact-eligible.

## Resources

- [`references/us-lead-governance.md`](references/us-lead-governance.md): US
  source, provenance, lifecycle, and consultation guidance.
- `evals/evals.json`: trigger and output checks.
