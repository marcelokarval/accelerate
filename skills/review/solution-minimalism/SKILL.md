---
name: solution-minimalism
description: Review an accepted, green implementation for the smallest legible complete solution by preferring project reuse, the standard library, native platform capabilities, and already-approved dependencies before new abstractions or packages. Use after specification and tests are green when simplifying code, rejecting speculative complexity, evaluating a proposed dependency, or recording conditions that would justify a later upgrade; do not use it to define requirements, make failing code pass, or overrule correctness, security, architecture, accessibility, compatibility, observability, rollback, or proof obligations.
---

# Solution Minimalism

Treat minimalism as a subordinate, strictly read-only review lens. Optimize
implementation cost only inside an already accepted contract and proven
behavior. A separate executor owns every accepted correction.

## Core Rule

Run only as a **post-spec and post-green** pass. Choose the smallest legible,
correct, secure, observable, compatible, accessible, reversible, and testable
solution that satisfies the accepted specification.

Correctness, security, architecture decisions, and required proof outrank
brevity. Stop and return to the owning lane when the specification is missing,
tests are red, or a proposed simplification changes observable behavior.

Before every review, read
[the decision ladder](references/decision-ladder.md). Apply its steps in order;
do not jump from a real need directly to a new dependency or abstraction.

## Protected Guarantees

Do not remove or weaken required:

- boundary and domain validation;
- authentication, authorization, ownership, or other security controls;
- rollback, migration, recovery, or compatibility behavior;
- observability, audit, error reporting, or correlation;
- accessibility semantics and keyboard or assistive-technology behavior;
- positive, negative, regression, security, or contract tests;
- proof artifacts and acceptance evidence.

Treat each protected guarantee as a constraint, not complexity to optimize away.
If it appears unnecessary, route the claim to the authority that established it
and require new evidence before changing it.

## Review Workflow

1. Confirm the accepted specification, green baseline, target behavior, and
   protected guarantees.
2. State the real need in behavioral terms. Reject work that has no present need.
3. Inspect repository conventions and reusable project code before proposing a
   new helper, abstraction, file, dependency, or framework.
4. Apply the decision ladder and compare only options that preserve every active
   guarantee.
5. Choose the smallest legible correct option. Prefer explicit local code when
   an abstraction would hide behavior or create a premature extension point.
6. Record every material rejected complexity item with evidence, rationale, and
   a measurable upgrade trigger.
7. Define the proof that a separate executor must rerun after any accepted
   simplification; do not alter the candidate or execute its correction.
8. Return a bounded correction packet and disposition; do not mutate source,
   tests, dependencies, git, issue state, provider state, or root closure.

When a proposed simplification touches authorization, ownership, secrets, or a
trust boundary, defer specialist judgment to `security-patterns` and the
independent security review lane. Minimalism never absorbs that authority.

## Complexity Discipline

Reject speculative layers, generic extension points, duplicate wrappers,
unneeded configuration, and new dependencies when a lower ladder step solves
the accepted problem completely.

Never use line count (LOC), file count, abstraction count, diff size, or terseness
as closure authority. These may prompt inspection, but only preserved behavior,
guarantees, and proof can support acceptance.

An upgrade trigger must be observable and decision-relevant, such as a second
confirmed consumer requiring variation, a measured platform limit, or an
approved capability absent from current dependencies. Do not use vague triggers
such as "if needed", "for scale", or "later".

## Output Contract

Return a `Minimalism Disposition` containing:

- `target` and `accepted_spec`;
- `green_baseline` with command or evidence locator;
- `protected_guarantees` and owning authorities;
- `ladder_checks` for project reuse, standard library, native platform, and
  approved installed dependencies;
- `chosen_solution` and why it is the smallest legible complete option;
- `rejected_complexity`, each with evidence, rationale, and measurable upgrade
  trigger;
- `required_proof_after_change`, including affected negative tests for the
  separate executor and reviewer;
- `result`: `accept`, `correct`, `escalate`, or `not-applicable`;
- `residual_risks` and `root_closure_boundary`.

Use `correct` when the candidate is needlessly complex but safely reducible;
return the bounded correction packet without applying it.
Use `escalate` when simplification would change the specification or a protected
guarantee. Use `not-applicable` when the baseline is not accepted and green.

## Verification Gate

Accept the review only when:

- all ladder steps have evidence-backed dispositions;
- no protected guarantee was weakened;
- rejected complexity has a measurable upgrade trigger when future adoption is
  plausible;
- the original green proof and affected negative proof pass after the change;
- the output states residual risk and leaves final acceptance to Accelerate root.
