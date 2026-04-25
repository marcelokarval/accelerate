# Workflow Self-Evolution

Use this module when the question is not only how to finish the current work,
but how to evolve skills, gates, or workflow truth from repeated runtime
evidence.

## Purpose

This is the native autoresearch protocol for evolving workflow truth from
delivery evidence.

It exists to prevent two bad extremes:

- treating every failure as one-off noise
- promoting every local annoyance into permanent workflow bloat

## Trigger Conditions

Use it when one or more of these are true:

- the same failure pattern repeats across sessions or sprints
- a root gate allowed a serious miss that should have been blocked
- a skill was structurally too weak, vague, or easy to misapply
- an external skill stack exposes a materially stronger operating pattern that
  should be harvested into local doctrine without blind import
- implementation was technically correct but repeatedly weak as product
- reviews passed but the real request still drifted in a recurring way
- the same follow-up class keeps reappearing because the workflow lacks a
  durable playbook

Do not trigger it for isolated mistakes, typo-level misses, or local execution
noise that does not justify workflow change.

External workflow harvests are valid self-evolution evidence when they reveal a
repeatable capability gap or a stronger proven operating loop. They still need
vetting, insertion planning, and rerun proof before promotion.

## Evidence Packet

Capture the failure before proposing changes.

Minimum packet:

1. `Failure Capture`
   - what went wrong
   - where it happened
   - what the user or runtime observed
2. `Root Cause`
   - `missing-rule`
   - `enforcement-failure`
   - `routing-failure`
   - `review-failure`
   - `closure-failure`
   - `execution-drift`
3. `Pattern Test`
   - isolated or repeated
   - previous examples
   - affected surfaces
4. `Impact`
   - product
   - runtime
   - security
   - review drag
   - rework cost

## Durable Evidence Capture Rule

When benchmark, rerun, or arbitration evidence changes parity, promotion,
workflow truth, or closure judgment, preserve it before claiming closure.

Acceptable durable homes:

- executive planning artifact
- architecture artifact
- living workflow doc updated by an approved change

Chat history, project-root `.tmp/` files, untracked scratch notes, and
conversational memory can be diagnosis inputs. They are not closure proof.

In the standalone pre-adapter / no-backend phase, a durable executive artifact
is the substitute for issue-backend registration. Do not invent fake adapter
behavior to satisfy this rule.

Keep this rule narrow. It applies to evidence that affects parity, promotion,
workflow truth, or closure decisions, not to every disposable exploration note.

## Promotion Decision

Promote only as far as needed.

- root orchestrator gap -> update `accelerate`
- detailed repeated procedure -> create or extend an adjacent skill
- domain-specific repeated practice -> promote to a playbook
- stack truth or repo contract -> promote to living docs or constitution
- local anomaly only -> fix locally and stop

Do not push project-specific business language into `accelerate` when a stack
rule or adjacent skill is the correct home.

Before a workflow-level promotion is treated as authorized, run
`../control-plane/workflow-change-approval-gate.md`.

When the proposed promotion comes from an external skill stack, run
`../risk/external-skill-vetting-gate.md` first.

When the proposed promotion changes skill behavior, trigger selection, or
workflow method, prefer `skill-evaluation-lab.md` before promoting the change.

That gate exists to ensure repeated failure evidence does not silently mutate
the control plane without explicit human approval.

Do not treat issue creation, issue decomposition, or issue-detail writing by
the agent as equivalent to that approval.

## Project-Agnostic, Stack-Aware Boundary

When evolving `accelerate`, preserve this split:

- project-specific business truth belongs in overlays, docs, and adjacent skills
- stack-level operating truth belongs in `accelerate`
- implementation examples belong in specialized skills, not in the root control
  plane

This keeps the root reusable across projects on the same stack while avoiding
business-domain lock-in.

## Insertion Plan

When a promotion is justified, define:

1. where the rule will live
2. what concrete gap it closes
3. which failure mode it prevents
4. how it will be validated
5. how to avoid duplicating nearby guidance

If those answers are unclear, the promotion is probably premature.

The failure class should remain visible in the promotion narrative. Do not jump
straight from a bad outcome to a workflow edit without naming whether the miss
was a missing rule, weak enforcement, bad routing, weak review, weak closure,
or simple execution drift.

## Anti-Bloat Rules

Keep the workflow teachable.

- prefer short root pointers plus deeper references
- prefer adjacent skills when examples and recipes matter
- merge with existing modules before creating parallel guidance
- do not turn every failure into a new named branch
- remove or relocate unused guidance when evidence shows it is dead weight

## Closure

A self-evolution cycle is only complete when:

- explicit approval exists when the promotion changes workflow truth
- the promoted change actually landed
- repo-local seeds were updated, and optional runtime exports were aligned only
  when export was in scope
- living docs were updated when durable behavior changed
- the new rule is narrow enough to solve the pattern without overfitting
