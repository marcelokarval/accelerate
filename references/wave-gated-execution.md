# Wave-Gated Execution

Use this reference when a mission has many similar targets, repeated work,
multiple surfaces, or measurable coverage requirements.

```text
wave -> implementation -> tests -> validation -> >=95% coverage -> next wave
```

## Use When

Use Wave-Gated Execution for many similar targets, all-phase/all-wave asks,
repeatable groupings, frozen coverage requirements, broad mutations needing
rollback and reproof, or missions that would otherwise become opaque.

Do not use it for conversational/no-op answers, quick read-only checks, tiny
deterministic mutations, one-file bounded slices, or exploration whose target
set cannot be frozen. Use the smallest valid Accelerate path instead.

## Classification and Freeze

Wave-gated execution is normally:

```text
class: orchestrated mission
mode: wave-gated
```

Before mutation, freeze the selection rule, target count, target artifact,
exclusions, and allowed residuals. Coverage is calculated against this frozen
denominator. New findings go to the next-wave backlog unless the selection rule
was wrong.

## Standard Pipeline

1. Baseline audit.
2. Freeze denominator and emit a Wave Packet.
3. Implement smallest safe mutations.
4. Run mechanical and domain proof gates.
5. Compute coverage with `scripts/wave_gate_report.py`.
6. Self-review and forensic review.
7. Close the wave or correct/reproof; only then advance.

The default coverage threshold is `>=95%`. Use 100% when the target set is
small, critical, or cheap to finish. A lower threshold requires an explicit
user, product, or risk reason.

A target counts as covered only after every applicable gate passes. On a failed
gate, preserve or explicitly re-freeze the denominator, record the correction,
re-run fresh proof, and recompute coverage.

## Safety and Closure

For broad structured-file edits, use a real parser and validate parser output.
Touched CLI-intent scripts must support `--help`; side-effecting scripts require
`--dry-run` or explicit scoped inputs. Do not leave caches or proof junk.

Stop and correct before advancing when a validator fails, coverage is below the
threshold, the denominator changes without re-freeze, a residual is
unclassified, a domain rule weakens, a runtime seam is unproved, or proof is
narrative rather than executable evidence.

Use `templates/wave-packet.md` to freeze a wave and
`templates/wave-closure-packet.md` to close it. The Runtime Delta Packet must
record denominator and coverage-gate changes.
