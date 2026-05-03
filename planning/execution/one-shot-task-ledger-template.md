# One-Shot Task Ledger Template

## Purpose

Use this template for one-shot execution runs that require task-level
side-by-side review, auto-correction, and reproof before closure.

## Task Ledger

| Task ID | Requested Outcome | Executor Mode | Executor Identity | Implemented Evidence | Expected Proof | Actual Proof | Reviewer Mode | Reviewer Identity | Review Independence | Side-By-Side Judgment | Review-Of-Review Status | Defects Found | Correction Owner | Correction Summary | Reproof Evidence | Closure Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T1 | `<what was requested>` | `<physical|virtual>` | `<agent/persona/pass>` | `<files/packets/proof landed>` | `<required proof>` | `<proof actually run>` | `<physical|virtual>` | `<agent/persona/pass>` | `<independent|virtual-isolated|exception|missing>` | `<met|partial|missed|not-applicable>` | `<sufficient|thin|missing>` | `<ids or none>` | `<master|subagent|virtual-pass|n/a>` | `<summary or n/a>` | `<evidence or n/a>` | `<closed|blocked|waived>` |

## Defect Ledger

| Defect ID | Task ID | Severity | Finding | Owner | Correction Status | Reproof Evidence | Residual Risk | Disposition |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| D1 | T1 | `<low|medium|high>` | `<finding>` | `<owner>` | `<open|fixed|fixed-pending-reproof|waived>` | `<path/output or n/a>` | `<risk>` | `<blocked|clear|accepted>` |

## Final Forensic Reconciliation

| Comparison | Expected | Actual | Judgment | Follow-Up |
| --- | --- | --- | --- | --- |
| Executive plan vs landing | `<expected>` | `<actual>` | `<met|partial|missed>` | `<none|item>` |
| Task ledger vs closure | `<expected>` | `<actual>` | `<met|partial|missed>` | `<none|item>` |
| Defects vs correction | `<expected>` | `<actual>` | `<met|partial|missed>` | `<none|item>` |
| Corrections vs reproof | `<expected>` | `<actual>` | `<met|partial|missed>` | `<none|item>` |
| Validation expected vs run | `<expected>` | `<actual>` | `<met|partial|missed>` | `<none|item>` |

## Closure Rule

Closure is blocked while any task has an open in-scope defect, any correction is
missing reproof, skeptical review is missing, review-of-review is missing, or the
final forensic reconciliation is absent.
