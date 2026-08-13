---
name: code-audit
description: Audit code and governed engineering changes across correctness, legibility, architecture, security, performance, tests, and verification evidence. Use for independent code-quality review, security-aware audit, architecture validation, compliance review, or CI quality assessment when findings need evidence-based P0-P3 severity and actionable proof.
---

# Code Audit

Perform an independent, read-only audit. Treat searches and heuristics as
candidate signals until inspection or reproduction confirms affected behavior.

## Core Rule

Derive severity from demonstrated impact, reach, exploitability,
reproducibility, and evidence. Never derive severity from category alone.

## Workflow

1. Read the accepted specification, task scope, repository instructions, and
   candidate diff. Include governed docs, config, tests, and workflow changes.
2. Establish the baseline: intended behavior, pre-existing failures, affected
   trust boundaries, and proof already observed.
3. Review every applicable axis in
   [review-axes.md](references/review-axes.md). Record `not-applicable` with a
   substantive reason; do not silently omit an axis.
4. Use [stack-heuristics.md](references/stack-heuristics.md) only to find
   candidate signals. Inspect context and exercise the failure scenario before
   confirming a finding.
5. Record each confirmed or explicitly dispositioned finding using
   [review-finding-schema.md](references/review-finding-schema.md).
6. Validate machine-readable findings with:

   ```bash
   python3 scripts/validate-review-finding.py finding.json
   ```

7. Return blockers, non-blockers, false positives, waivers, required
   corrections, required proof, and residual risks to the root reviewer.

Route threat modeling, hostile trust-boundary analysis, and security negative
proof to `security-patterns`; this general audit records the disposition but
does not absorb specialist security authority.

## Severity Judgment

- `P0`: observed or strongly evidenced catastrophic impact requiring immediate
  containment; explain reach and exploitability.
- `P1`: material correctness, security, data, availability, or contract impact
  that blocks the active delivery.
- `P2`: bounded defect or material maintainability risk that should be planned
  but does not meet P0/P1 impact.
- `P3`: low-impact improvement with concrete value.

A security-category issue can be P2 or P3 when impact is bounded; a
correctness, documentation, configuration, or workflow issue can be P0 or P1
when its reach is severe. Confidence is separate from severity.

## Evidence Rules

- Name the exact location and affected behavior.
- Describe a concrete failure scenario, not a vague concern.
- Cite inspected code, command output, trace, test, or authoritative contract.
- State confidence and exploitability, including `not-applicable` with reason.
- Propose the smallest safe correction and the proof required afterward.
- Preserve uncertain hits as candidate signals; do not inflate them into facts.
- Never modify, accept, publish, merge, or close the candidate under review.

## Output Contract

Return:

- reviewed scope and baseline;
- axis dispositions;
- validated findings ordered by severity, then confidence;
- candidate signals requiring more evidence;
- false-positive and waiver dispositions;
- requested correction and proof per finding;
- residual risks and the root-owned closure boundary.

## Resource Router

- Read [review-axes.md](references/review-axes.md) before a complete audit.
- Read [review-finding-schema.md](references/review-finding-schema.md) before
  writing findings.
- Read [stack-heuristics.md](references/stack-heuristics.md) when selecting
  stack-aware searches or checks.
- [full-procedure.md](references/full-procedure.md) preserves the exact legacy
  procedure for migration evidence only; it is not executable authority.

## Verification

- Every applicable axis is present.
- Every confirmed finding passes the validator.
- Severity rationale names impact and reach; security findings also address
  exploitability.
- Candidate signals remain visibly unconfirmed.
- No review action mutates source, git state, provider state, or closure state.
