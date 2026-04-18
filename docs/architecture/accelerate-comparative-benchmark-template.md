# Accelerate Comparative Benchmark Template

## Purpose

This document defines a reusable benchmark format for comparing:

- the legacy/global `accelerate` runtime
- the local/standalone `accelerate` runtime

The goal is not only to compare writing quality. The benchmark must compare
real operational value on a non-trivial engineering task.

Use this artifact when the question is:

- does the local platform already execute a class of work as well as or better
  than the legacy/global runtime?
- did a newly rehomed methodology actually improve local execution quality?
- is a claimed parity or superiority judgment supported by a repeatable test?

## Replacement Rule

Comparative benchmarks should follow the local replacement rule:

the local platform only replaces the legacy as the primary operational
distribution when it is **superior or equal in operational value**, ignoring
the future-agent layer.

This benchmark exists to make that judgment testable instead of intuitive.

## Benchmark Objective

Compare, in a real non-trivial task:

- quality of analysis
- depth of critique
- adherence to the real code context
- quality of method applied
- practical usefulness of the output

## Standard Execution Rule

1. Open two subagents.
2. One subagent uses the legacy/global `accelerate` runtime naturally.
3. One subagent uses the local/standalone `accelerate` runtime explicitly.
4. The local subagent must be instructed not to use the legacy runtime as
   primary authority.
5. Both subagents analyze the exact same target.
6. Both subagents return full raw output.
7. The master returns:
   - what each one analyzed
   - the raw output of each one
   - comparative analysis
   - technical and critical judgment
   - justification of the judgment

## Scope Rule

If the requested target is partially absent, the agent must:

- declare that explicitly
- re-scope honestly to what actually exists
- avoid inventing missing structures

Honest scoping is part of benchmark quality.

## Semantic Scope Recovery Rule

When the literal target does not exist, benchmark quality also depends on
whether the agent recovers the nearest semantically valid target instead of
becoming uselessly narrow.

The benchmark should distinguish:

- `strict literal scope`
  - stays only with the exact surviving target
- `semantic scope recovery`
  - moves to the closest real adjacent target that better matches user intent
- `dual scope`
  - keeps the literal surviving target as primary but uses the semantically
    adjacent target as explicit comparator context

Prefer `dual scope` when:

- the user named a surviving local seam explicitly
- but the closest real domain target is clearly where the fuller truth lives
- and a single-scope answer would force the agent to choose between being
  correct-but-narrow or useful-but-partial

In that case, benchmark quality should reward agents that make both surfaces
first-class in the review instead of burying one as weak comparator context.

The agent must state which of these it chose.

## Output Contract For Each Agent

Each agent should return:

- surfaces analyzed
- prioritized findings
- technical rationale for the findings
- suggested better modeling or design
- rich ASCII UML when multiple models or entities exist
- compact table of models, fields, and relations when applicable
- self-review
- self-forensic review

## Judging Criteria

The comparative judgment should consider:

1. adherence to the real target
2. quality of semantic scope recovery when the literal target is absent
3. severity and relevance of findings
4. specificity of identified problems
5. reconciliation quality between doctrine, persistence, runtime, and
   operational reality
6. practical usefulness of remediation suggestions
7. quality of method, not only quality of prose

## Suggested Benchmark Packet

Use this benchmark packet when running a new comparison:

### Benchmark Name

Short name for the benchmark run.

### Objective

What is being compared and why.

### Rule

- one agent uses legacy/global
- one agent uses local/new
- same target
- local agent explicitly forbidden from using legacy as primary authority

### Target

Exact repository and path.

### Task

Exact review or implementation ask.

### Expected Output

What each side must return.

### Comparison Axes

Which criteria will decide the result.

### Final Judgment

- winner
- why
- strongest finding from each side
- what the test teaches about the local platform

## Example Benchmark

### Name

`Prop4You backend modeling review: system / real_state`

### Objective

Compare the legacy/global and local/standalone `accelerate` runtimes on a real
backend persisted-modeling review.

### Rule

- two subagents
- one uses legacy/global naturally
- one uses local/new explicitly
- the local/new subagent must not use the legacy runtime as primary authority
- both analyze the same code target
- both return raw output

### Task

Analyze the backend of project `prop4you`, focusing on the group `system` and
`real_state`.

The intention is to capture:

- bad modeling
- discrepancies
- models that do not make sense
- better alternatives
- rich ASCII UML
- compact model/field/relation table

### Target Path

- `/home/marcelo-karval/Backup/Projetos/prop4you/prop4you-inertia/backend/src`

### Real Scope Outcome

`real_state` was not found under the requested path.

This benchmark then became a scope-recovery test as well:

- one side used a stricter scope centered on `apps/system/matrix`
- one side recovered semantically toward the existing `domains/real_estate`
  area plus adjacent `system` infrastructure

### What The Benchmark Was Measuring

- persisted-modeling forensic review quality
- contract vs persistence vs runtime reconciliation
- ability to find structural rather than cosmetic issues
- practical usefulness of the proposed remodel

### Why This Example Matters

This benchmark was useful because it exposed a real methodological gap:

- the legacy runtime was initially stronger on persisted-modeling review
- the local runtime improved after native persona/review/forensics surfaces were
  rehomed
- rerunning the same benchmark then showed whether the local method actually
  became competitive
- a later rerun also exposed a second gap:
  - the local runtime needed a clearer native rule for semantic scope recovery

## Versioning Guidance

When using this template:

- keep the template stable in `docs/architecture/`
- version concrete benchmark runs as separate artifacts if needed
- prefer one file per benchmark when the raw outputs, findings, or judgment are
  important enough to preserve

Suggested naming:

- `accelerate-comparative-benchmark-<topic>.md`

Examples:

- `accelerate-comparative-benchmark-persisted-modeling.md`
- `accelerate-comparative-benchmark-product-surface-review.md`
- `accelerate-comparative-benchmark-proof-stack.md`

## Anti-Illusion Rule

Do not claim victory because:

- the local runtime sounds cleaner
- the local docs are better organized
- the prose is more polished

The result must be grounded in actual execution quality on the same target.
