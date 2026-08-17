# Accelerate × Fable Method Composition

## Decision

Compose Fable as a reasoning and reporting overlay inside Accelerate. Do not merge
Fable into the Accelerate lifecycle and do not run the two methods side by side.

Accelerate remains the root control plane. It owns:

- classification, branch selection, issue topology and closure mode;
- staffing/delegation budget, risk enforcement and proof order;
- runtime packets, correction/reproof and final forensic acceptance.

Fable contributes:

- ask classification and explicit definition of done;
- primary-evidence discipline and intent resolution;
- one recommendation with an exact execution scope;
- smallest-correct-change bias;
- observed verification and outcome-first reporting.

## Overlay Decision

Record one state during Accelerate classification:

| State | Trigger | Action |
|---|---|---|
| `required` | The user explicitly names Fable or `/fable-method` in an Accelerate run | Apply Fable inside the active Accelerate branch. |
| `useful` | Authorities conflict, intent is ambiguous, or an outcome-first audit/report is requested | Apply the bounded Fable loop to resolve intent and sharpen proof/reporting. |
| `not-needed` | A narrower specialist skill already defines mechanics and proof without material ambiguity | Continue under Accelerate plus the specialist skill; do not add process theater. |

Persist `fable_overlay`, `basis`, and `mode` in the existing Branch Entry Packet or
other active runtime packet. Do not invent a Fable packet, gate, ledger or issue.

## Composition Map

| Fable output | Existing Accelerate owner |
|---|---|
| assessment / task / plan-first classification | root classification and branch |
| named observable done criterion | outcome preamble and proof lane |
| primary evidence | Authority Set and evidence locators |
| recommendation and exact scope | branch/scope decision and execution packet |
| smallest correct change | specialist implementation lane |
| observed verification | existing proof order; never independent closure authority |
| outcome-first report | requested-vs-implemented and root closure report |

## Bounded Fable Loop

When the overlay is `required` or `useful`:

1. Classify the ask as assessment, task, or plan-first.
2. Name done as an observable check before mutation.
3. Gather primary evidence and resolve authority conflicts before editing.
4. Commit to one recommendation and exact scope.
5. Execute through the narrowest specialist skill.
6. Observe the done criterion and affected Accelerate proof surfaces.
7. Report outcome-first with evidence, caveats and residual risk.

## Mode Rules

- `plan`: shapes the outcome preamble, evidence and recommendation; no mutation authority.
- `audit`: grades delivered work; Accelerate owns defect/correction/reproof and close.
- `report`: rewrites the final narrative; it cannot upgrade missing proof.
- default: runs the bounded loop inside the active branch.

## Hard Boundaries

- Repo policy and explicit user authorization always win.
- A specialist skill owns domain mechanics; Fable does not replace it.
- Fable verification feeds Accelerate proof but cannot close the root branch alone.
- Subagent Fable output is an input; root revalidates artifacts and claims.
- Do not duplicate todos, packets, reviews, evidence or lifecycle phases.
- Do not activate Fable automatically for every engineering run.

## Standalone Authority

This repository-local reference is the complete governing composition contract.
Do not depend on `~/.codex/skills/fable-method`, another user-home catalog, or a
network fetch as authority. A separately installed Fable skill may be consulted
only as non-governing supporting material; this repo-local contract wins on any
conflict.

## Provenance

Adapted from Fable Method v1.4 at upstream commit
`88b5cf36b10ee3679e08ee0f0181b9774d481508`, MIT licensed. This file imports
only the bounded composition interface needed by Accelerate; it does not claim
ownership of the upstream method or its companion skills.

## Verification

Before closure, confirm:

- exactly one Accelerate root and closure owner existed;
- the overlay decision and basis were explicit when Fable was considered;
- Fable outputs landed in existing Accelerate packets/artifacts;
- the specialist skill still owned mechanics;
- final proof was observed by root;
- the first user-facing sentence states the outcome.
