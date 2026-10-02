# Entry rubric — v1.1

## Observe before deciding

First distinguish a request for explanation from requested engineering work.
A conversation about authentication is still conversation. An explicit ASDS
selection is honored. Continue an already accepted ASDS task with its coordinator;
do not run entry again for each worker, review, or follow-up.

For new engineering work identify the intended outcome, target and material
constraints from the conversation and relevant sources. Separate observed facts,
assumptions and unresolved questions. Preserve the user's wording where rewriting
could change meaning. Prompt length, file count, urgency, confidence, availability
of agents and the number of tool calls are not complexity criteria.

## Trivial admission

Direct work has an understood, bounded outcome, a known reversible method and no
material unresolved choice or effect. Inspect/edit/test/format are operations for
one outcome, not independent deliverables. A typo correction with a parser check
can be trivial even if it takes several commands or spans equivalent files.
Ordinary precautions such as running tests or checking a diff do not themselves
make work non-trivial. Required project checks and actual permissions still apply.

## Material observations

Use a signal only with evidence/source and a concrete consequence. The terms in
this table are the canonical `core/entry.py` vocabulary. Topic mentions are not
effects; do not label a spelling fix as a security change because the page says
"authentication". Conversely, a one-line access check can change authorization.

| Signal | Positive example | Not enough by itself |
| --- | --- | --- |
| security_behavior | Changes who can read a record or obtain a token | Explaining login; correcting help copy |
| sensitive_data_effect | Changes exposure, retention or access to personal data | Synthetic fixture with no sensitive data |
| financial_effect | Changes charging, refund or accounting behavior | Correcting a heading on a billing help page |
| persistent_state_change | Migrates or alters live/durable application data | Editing and testing a local source file |
| irreversible_effect | Deletes unique data or performs an external irreversible action | Reversible source edit |
| shared_interface_change | Changes a payload consumed by independently evolving components | Renaming a local private variable with known callers |
| dependent_outcomes | A new backend contract must precede a frontend feature | Read -> edit -> test of one known adjustment |
| material_decision | Different answers change acceptance, behavior, scope or authority | Choosing a local variable name by existing convention |
| other_material_effect | Concrete comparable effect with evidence and consequence | Generic "might introduce a bug" caution |

Broad scope or irreversibility also excludes direct work. Unknown does not mean
low risk. Use a bounded inspection when the needed fact is in available sources.
An unavailable reference is an unresolved fact, not proof that a risk is absent.

## Inspect, ask, forward or proceed

- **Inspect** for an entry-blocking fact available from the project/session, such
  as which known key is invalid. Keep inspection bounded; it is not full design.
- **Ask** when entry depends on a user choice not already answered, such as which
  project or which of two incompatible requested outcomes. Ask the smallest
  necessary question, preserving existing grants and refusals.
- **Forward to ASDS** when routing is already clear and the missing choice belongs
  to requirements/design/planning. Carry the gap; do not resolve the entire design
  before handoff or ask the same question twice.
- **Proceed directly** for known routine implementation details within the
  accepted scope, applying existing conventions and relevant verification.

The `gaps` resolver is `inspect`, `user` or `asds`. Only unresolved gaps are
included. Reuse an existing answer; never manufacture consent from silence.
Inspection precedes asking only for genuinely entry-blocking facts. Do not use
an irrelevant lookup to delay the answer or treat a material choice as routine.
If inspection reveals material effects, update observations before mutation.

## Discovery scope

Keep entry discovery within the intended project and necessary instructions or
references. Before reading outside that scope, identify the missing task fact and
why the specific source can resolve it; do not search sibling projects, home-wide
logs or previous evaluation evidence merely because they are accessible. Stop
entry discovery when routing is clear. Carry these limits in the existing handoff
constraints/references; ASDS owns their preservation after acceptance. This is
prompt guidance, not filesystem confinement. Report actual tool activity precisely:
a version command is execution, but is not a test or a project program run.

## Hardening depth

Conversation needs no engineering hardening. Trivial work needs a concise outcome
and applicable constraints, normally implicit in the existing conversation.
Non-trivial work needs a bounded handoff: objective/project/scope/constraints,
material risks, useful references and existing authorization decisions. Keep
unknown facts visible. Never invent requirements, new scope or approvals while
rewriting. ASDS owns detailed discovery, solution choices, specs and tasks.
No Prompt A/Prompt B ritual, new document, tracker, worker count or approval turn
is required by hardening. A visible compact summary is useful when it resolves
ambiguity; it is not a mandatory artifact for every request.

## Executable support and limits

`assess_entry` validates structured observations and returns a route/action.
It does not extract facts from natural language or authenticate evidence. Its
signals must come from the adapter/agent applying this rubric. `classify` and the
seven-field `validate_handoff` API remain compatible with Accelerate 1.0.0.
There `multi_step` means dependent outcomes, and `risks` means material effects;
do not pass routine checklists or speculative generic hazards into those fields.

`evals/entry-cases.json` contains labelled prompts and paraphrases. Unit tests
verify the reference observations and policy, not a model's interpretation.
Controlled conversational exercises and fresh harness evaluation are separate
proof levels. Report model/context, actual outputs, over-routing, under-routing
and redundant questions; never report fixture replay as model qualification.
