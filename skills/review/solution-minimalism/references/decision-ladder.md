# Solution Minimalism Decision Ladder

Apply every step in order. Advance only when the preceding step cannot satisfy
the accepted behavior while preserving all active guarantees.

## 1. Confirm A Real Need

Describe the current behavioral need and link it to an accepted requirement.
Reject anticipated variants, hypothetical reuse, or future scale as present
requirements unless their threshold has already been observed.

## 2. Prefer Project Reuse

Search the repository for an existing implementation, convention, primitive,
or approved service that already owns the behavior. Reuse it when its contract
and lifecycle fit; do not force reuse that introduces coupling or changes its
meaning.

Record the inspected paths and why the selected reuse is safe. Treat local
brownfield changes as user-owned and leave them untouched outside the authorized
scope.

## 3. Prefer The Standard Library

Check whether the language standard library supplies the complete behavior with
acceptable clarity, portability, security, and maintenance cost. Prefer it over
custom helpers or packages when it does.

## 4. Prefer The Native Platform

Check the active framework, browser, database, operating system, or runtime for
a supported native capability. Confirm version support and project conventions;
"native" is not sufficient when the capability is unavailable in the deployed
baseline.

## 5. Reuse An Approved Installed Dependency

Inspect the governed dependency inventory. Use an already-approved dependency
only when it owns the needed capability, its use is permitted for new code, and
the narrower steps are insufficient. Dependency governance remains authoritative
over adding, upgrading, or replacing packages.

## 6. Choose The Smallest Legible Correct Solution

Choose the least complex candidate that fully preserves the accepted behavior,
validation, authorization, security, rollback, observability, accessibility,
compatibility, and proof. Prefer direct code over a generalized abstraction when
there is only one confirmed shape and the direct behavior remains readable.

Minimal means fewest unjustified concepts, not fewest lines or files.

## Rejected Complexity Record

For every material option rejected as premature, record:

- candidate and capability it would add;
- evidence that the capability is not currently required;
- maintenance, coupling, or dependency cost avoided;
- why the selected option remains complete;
- measurable upgrade trigger;
- authority that will decide when the trigger is reached.

Valid upgrade trigger examples:

- a second accepted consumer requires a distinct strategy;
- profiling shows the named operation exceeds its approved latency budget;
- the supported runtime matrix adds a target the current native API cannot serve;
- an approved requirement needs a capability absent from installed dependencies.

Invalid upgrade trigger examples:

- "if needed";
- "when we scale" without a metric and threshold;
- "later" or "future proofing";
- a line count, file count, or aesthetic preference.

## Decision Outcome

Return `accept` only when the selected solution is complete and the proof remains
green. Return `correct` for safely removable complexity. Return `escalate` when
the change would affect the accepted specification or protected guarantees.
Return `not-applicable` when the work is not post-spec and post-green.
