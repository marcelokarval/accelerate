# AI Hero Practice Adoption Boundary

This source-only guide implements the D18 doctrine boundary; it does not import
an external runtime, commands, tracker, or automation.

## Adopted practice set

| Practice | Accelerate adaptation | Gate |
| --- | --- | --- |
| decision frontier | ADR/spec when reversibility, authority, or risk crosses the frontier | hardened packet and decision record |
| prototype escape hatch | bounded, non-production experiment with expiry and disposition | explicit scope, no automatic graduation |
| vocabulary and ADRs | stable local terms and decisions | local source authority |
| seam-first spec and tracer bullet | specify contracts/side effects first; prove one vertical path | seam tests and fixed candidate |
| TDD at seams | deterministic tests before implementation claims | negative and contract fixtures |
| Standards + Spec review | separate quality/maintainability from scope/contract compliance | fresh independent reviews |
| deterministic-first evaluation | deterministic evaluator precedes advisory model judge | recorded evaluator result |
| agentic--deterministic dial | choose controlled autonomy per assignment | explicit value and boundary |
| least-privilege tools | assignment gets only needed tools | capability/authorization receipt |

## Explicitly not adopted

No automatic commit, non-Plane tracker, slash-command convention, donor runtime
assumption, same-run "independent" review claim, or unverified marketing claim
is admitted. A model judge cannot override deterministic failure.

## Sources and non-authorization

This adaptation is informed by
[`ai-hero-dev/ai-hero@8a2ab404cba5c70731edd3c2e919fea917f843aa`](https://github.com/ai-hero-dev/ai-hero/tree/8a2ab404cba5c70731edd3c2e919fea917f843aa)
and
[`mattpocock/skills@6654f6b60cd9d5be8b54c6fafe44346dabeb3b76`](https://github.com/mattpocock/skills/tree/6654f6b60cd9d5be8b54c6fafe44346dabeb3b76),
both inspected 2026-09-01. The pins preserve provenance only: no source was
installed, copied, synced, promoted, or treated as runtime authority.
