# Prompt Upgrade Approval Gate

## Purpose

Use this gate when the user gives a raw prompt and asks Accelerate to improve it
for the active project/stack before execution.

This gate is different from ordinary prompt hardening. It has an explicit
approval boundary: improve and present the prompt first, then wait for the user's
approval before generating persisted analysis, plan, tasks, or implementation.

## Invocation Alias

Recommended shorthand / wildcard:

- `upgrade-prompt`
- `prompt-to-plan`
- `harden-and-wait`
- `upgrade-and-wait`
- `prompt-coringa`

Any equivalent user wording should activate this gate when it asks to improve a
prompt and wait for approval before execution.

## Rule

Do not execute the raw prompt immediately.

The required order is:

1. analyze the raw prompt against the active repo, stack, and known Accelerate
   gates
2. produce an improved prompt with clear scope, evidence, outputs, constraints,
   proof lanes, and non-goals
3. present the improved prompt and material changes to the user
4. wait for explicit approval such as `aprovo`, `approved`, or equivalent
5. only after approval, use the improved prompt to generate persisted outputs
6. present the persisted plan and tasks for user reading
7. do not implement until the user asks for execution, unless the approved prompt
   explicitly included implementation authorization

Commit and push are separate terminal actions. Do not treat approval of the
improved prompt, approval of the plan, or execution authorization as implicit
approval to commit or push.

## Required Improved Prompt Contents

The improved prompt must include:

- target repo/project and stack assumptions
- active scope
- explicit non-goals
- required source discovery
- required browser/runtime proof
- required persisted artifacts
- required task status model
- required correction loop and reproof rules
- visual/product/domain review gates, when relevant
- optional wireframe and AI-smell requirements when the raw prompt asks for
  strategic UI/product improvement
- approval boundary
- execution trigger phrase or next step

## Automatic Use

Accelerate may invoke this gate without the user spelling the full prompt when a
request is broad, high-impact, multi-phase, or likely to benefit from an upgraded
execution-ready prompt before planning or mutation.

When auto-invoked, be explicit that the run is pausing at the prompt approval
boundary rather than refusing or delaying work.

## Required Persisted Outputs After Approval

After approval, generate and persist:

- analysis report from the improved prompt
- executive plan
- detailed tasks with status markers
- proof plan / browser-proof matrix when runtime/UI is in scope

Then present the plan and tasks on screen for user review.

## Commit / Push Boundary

If the raw prompt includes a later `commit and push` step, preserve it as a
separate post-proof phase in the improved prompt.

The improved prompt must state that commit and push require explicit user
authorization after:

- implementation is complete
- proof and corrected-state reproof have run
- task-by-task side-by-side review is complete
- final forensic reconciliation is complete
- no secrets or unrelated user changes are being included

## Prompt Upgrade Packet

Use `core/runtime-packets/prompt-upgrade-approval-packet.md` or include the same
fields inline.

## Closure Blockers

Do not proceed when:

- raw prompt was executed before upgrade approval
- improved prompt does not name project/stack constraints
- approval was assumed from silence
- persisted artifacts were skipped after approval
- implementation began before the user approved execution
- commit or push was performed without explicit separate authorization
- generated tasks lack status transition markers
- broad work skipped prompt upgrade even though the user invoked a prompt
  wildcard or approval-boundary wording

## Failure Labels

- `raw-prompt-executed-before-approval`
- `approval-boundary-skipped`
- `improved-prompt-without-stack-basis`
- `persisted-plan-missing`
- `tasks-without-status-markers`
- `implementation-started-before-execution-approval`
- `commit-push-boundary-skipped`
- `prompt-wildcard-ignored`
