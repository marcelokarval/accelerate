# Routing and Responsibility Matrix

This matrix governs Accelerate's entry decisions. It replaces the previous
matrix of automatically inherited planning, issue, workspace, delegation and
closure gates. Historical domain guidance may be selected for a task; it does
not reactivate that earlier controller.

| Request | Route | Process owner | Required behavior |
| --- | --- | --- | --- |
| Conversation, explanation or no-op | conversation | Accelerate | Respond directly; do not initialize project state |
| Understood, bounded, reversible engineering adjustment without sensitive risk | direct | Accelerate | Make the requested change and verify its relevant behavior |
| Uncertain, multi-step, broad or sensitive engineering work | asds | ASDS after acceptance | Transfer context; ASDS decides workflow and activation |
| Explicit request to use ASDS | asds | ASDS after acceptance | Honor the selection without inferring permission to initialize or mutate |

## Classification

`core/routing.py` accepts explicit observations, not raw natural-language intent.
All boolean observations must be actual booleans. `risks` contains nonempty
risk descriptions; any identified risk excludes the trivial route. Uncertainty,
a multi-step task, an unbounded scope or a non-reversible change also excludes it.
Unknown fields are rejected so an adapter cannot silently misspell a control.

The executable routes are `conversation`, `direct` and `asds`. Classification
never grants execution permission. Even a trivial edit remains subject to the
user's scope and project instructions. Explicit ASDS selection takes precedence
over the other observations, but ASDS still decides whether its full workflow is
appropriate. Otherwise non-engineering requests stay conversational, even when
the subject is complex, ambiguous or sensitive; metadata does not activate an
engineering workflow.

## Handoff Fields

The handoff contains `objective`, `project`, `scope`, `constraints`, `risks`,
`references`, and `authorizations`. Each authorization records `action`, `scope`,
`decision` (`granted` or `denied`) and `source`. These are context records, not
credentials or independently authenticated grants. An empty list conveys no
authorization. A missing or malformed field is not repaired by assuming consent.

The project must be identified before producing a handoff. Identification does
not authorize creation of that project, `.accelerate/` or `openspec/`. A harness
adapter remains responsible for faithfully extracting observations and carrying
existing decisions; the validator cannot authenticate their origin.

## Transfer and Return

Accelerate owns routing and context preparation. After ASDS accepts a handoff,
ASDS owns specifications, planning, task graph, execution strategy, delegation,
review, integration and conclusion. It may choose a lightweight flow and may
operate independently of Accelerate. Reusable technical skills supply expertise
without taking ownership of the process.

Accelerate presents returned results with their evidence and limitations. It
does not rebuild the task graph, repeat approval, demand a second review, or
maintain a duplicate progress store. Resume the existing owner and state.

The host harness owns actual tools, permissions and isolation. If ASDS is not
available, report the missing dependency and continue only independent useful
work; an alternative execution workflow requires an explicit user choice.
Historical Accelerate orchestration is not an automatic fallback.
