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
| existing_behavior_compatibility | A new admission rule can reject credentials, clients or stored values that the current authority accepts | A presentation-only change with unchanged acceptance and wiring |
| other_material_effect | Concrete comparable effect with evidence and consequence | Generic "might introduce a bug" caution |

Broad scope or irreversibility also excludes direct work. Unknown does not mean
low risk. Use a bounded inspection when the needed fact is in available sources.
An unavailable reference is an unresolved fact, not proof that a risk is absent.

### Surface is not behavior

Classify the behavior imposed by the change, not the layer named in the prompt.
Words such as `UI`, `button`, `frontend`, `one line` and `simple` do not establish
that an edit is presentation-only. Before admitting direct work, identify the
authority that decides the requested behavior and whether the edit changes what
the system accepts, rejects, exposes or persists.

For authentication, copy or layout with unchanged submission criteria can remain
direct. Making a login button reject a credential according to password-creation
rules changes authentication behavior. If the provider or existing contract may
accept that credential, it also has an existing-behavior compatibility effect.
Applying a signup or password-change policy to sign-in without an authority that
equates them is a material decision. Inspect an available authority only when it
can settle entry classification; otherwise carry the conflict and affected users
to ASDS. The word `login` alone is not a material signal.

After inspection, do not convert a confirmed authority conflict into a premature
user choice. If the requested behavior conflicts with the authoritative sign-in
contract or creates a credential-compatibility decision, forward that decision to
ASDS. If an accepted ASDS workflow or planning package already owns the objective,
continue it with the same coordinator instead of asking the user to choose between
the request and the existing plan. Ask only when the missing decision is genuinely
the user's and cannot be resolved through the accepted planning workflow.

A current defect report is new intent evidence. An older plan may explain the
existing behavior, but it cannot silently cancel or close the current request.
When the report conflicts with a delivered or accepted plan, treat it as a
requirements-change input and reopen/continue that same ASDS planning lineage.
Do not merely explain the old decision and stop; do not implement before the
compatibility decision is revised and reviewed.

If the ASDS coordinator cannot actually be invoked, fail closed at the ownership
boundary. Do not create a reassessment note, edit `tasks.md`, revise a manifest or
otherwise mutate ASDS/OpenSpec planning state as a substitute for the coordinator.
Report the unavailable or approval-blocked capability and preserve the package
unchanged for a later authorized continuation.

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

## Evidence floor for direct work

Verification must exercise the behavior claimed at the relevant boundary. A
classifier test does not prove product behavior, and a typecheck or lint result
does not prove an interactive login state. For a changed visible interaction,
obtain proportional browser or equivalent behavioral evidence when the environment
supports it. For authentication admission, include a focused regression covering
the affected accepted/rejected credential boundary. If pertinent proof is blocked,
report the implementation and the missing verification separately; do not call the
outcome fixed, complete or accepted. This evidence rule does not itself make an
otherwise trivial documentation or presentation-only edit non-trivial.

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
