# Outcome Preamble Gate

## Purpose

Use this gate to keep Accelerate's initial analysis outcome-first instead of
process-heavy.

It is based on the GPT-5.5 prompting guidance: define the target outcome,
success criteria, constraints, expected output, and stopping conditions before
deep process detail.

## Rule

For every non-trivial engineering run, the initial Branch Entry Packet or visible
runtime preamble must include a concise outcome preamble.

Minimum fields:

- `goal`
- `success criteria`
- `constraints`
- `expected output`
- `stop rules`

Keep the preamble short. It anchors execution; it does not replace branch gates,
proof packets, issue topology, or final forensic review.

## Trivial Branch

For trivial bounded work, the preamble may be compact:

```text
Goal: <one sentence>
Done means: <one observable result>
```

If the trivial task mutates code, docs, workflow seeds, or runtime governance,
include enough success criteria to verify the mutation.

## Success Criteria Requirements

Success criteria should be observable. Prefer criteria that can be checked by:

- file/content evidence
- tests or validation commands
- browser/runtime proof
- route/view/data coverage matrix
- task ledger status
- review or contradiction packet status

Avoid vague criteria such as `make it better`, `finish everything`, or `improve
quality` unless they are converted into concrete checks.

## Stop Rules

Stop rules must say when to:

- continue searching or validating
- stop because evidence is sufficient
- ask for missing information
- mark an item blocked
- refuse to close because proof is incomplete

For broad or looped work, include a stop rule that prevents `done` from being
claimed while any success criterion remains unproved, partial, or contradicted.

## Closure Blockers

Do not proceed to implementation or closure when:

- non-trivial work has no goal
- success criteria are missing or too vague to verify
- stop rules are absent for broad, looped, or proof-heavy work
- gates are listed but no user-visible outcome is defined
- a final `done` claim cannot be traced back to the initial success criteria

## Failure Labels

- `outcome-preamble-missing`
- `success-criteria-missing`
- `success-criteria-unverifiable`
- `stop-rules-missing`
- `process-heavy-without-goal`
- `done-not-traceable-to-criteria`
