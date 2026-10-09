# Routing and Responsibility Matrix

This matrix governs Accelerate's entry decisions. It replaces the previous
matrix of automatically inherited planning, issue, workspace, delegation and
closure gates. Historical domain guidance may be selected for a task; it does
not reactivate that earlier controller.

| Request | Route | Process owner | Required behavior |
| --- | --- | --- | --- |
| Conversation, explanation or no-op | conversation | Accelerate | Respond directly; do not initialize project state |
| Understood, bounded, reversible engineering adjustment without sensitive risk | direct | Accelerate | Make the requested change and verify its relevant behavior |
| Planning requested, or materially uncertain/dependent/broad/sensitive engineering | asds | ASDS for planning | Transfer context; ASDS delivers reviewed planning and releases ownership |
| Explicit request to use ASDS | asds | ASDS after acceptance | Honor the selection without inferring permission to initialize or mutate |

## Classification

`core/routing.py` accepts explicit observations, not raw natural-language intent.
All boolean observations must be actual booleans. `risks` contains nonempty
material risk descriptions supported by evidence and consequence. Material uncertainty,
dependent deliverables, broad scope or irreversible change exclude direct work.
Read/edit/test operations alone are not dependent deliverables. Apply
[the entry rubric](../entry-rubric.md); `core/entry.py` also represents unresolved
entry gaps and continuation without reclassifying ASDS-owned work.
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
ASDS owns specifications, planning graph, planning review, persistence and planning
return. It releases ownership after delivery. A caller-selected consumer owns future
execution, code review, integration and software conclusion. Reusable skills supply
expertise without changing these boundaries.

Accelerate presents returned results with their evidence and limitations. It
does not rebuild the task graph, repeat approval, demand a second review, or
maintain a duplicate progress store. Resume the existing owner and state.

The host harness owns actual tools, permissions and isolation. If ASDS is not
available, report the missing dependency and continue only independent useful
work; an alternative execution workflow requires an explicit user choice.
Historical Accelerate orchestration is not an automatic fallback.
