# Accelerate

Version **1.2.0**. Accelerate classifies and prepares requests before
`spec-driven-superpowers` (ASDS).
It also provides reusable engineering skills. ASDS owns the structured workflow
for work handed to it and remains usable independently.

```text
Request -> Accelerate
             conversation -> direct response
             trivial engineering -> direct execution and relevant checks
             non-trivial / explicit ASDS -> ASDS activation and workflow
```

## Responsibilities

| Layer | Owns |
| --- | --- |
| Accelerate | Intent, initial scope, target, constraints, risk screening, routing |
| ASDS | Its activation, specs, plans, tasks, scheduling, reviews, integration, completion |
| Harness | Available tools, execution, permissions, session persistence |
| Specialist skills | Selected technical guidance, without workflow ownership |

A handoff does not automatically initialize OpenSpec or activate every ASDS step.
ASDS applies its own activation rules. Accelerate passes existing approvals and
refusals without asking again or expanding them. A risk flag prevents the trivial
route; it does not grant authority or prescribe an entire engineering ceremony.

## Entry and implementation

Read [SKILL.md](SKILL.md) for agent behavior and
[the integration contract](core/asds-integration.md) for ownership, handoff,
resumption and unavailable-ASDS behavior. `core/routing.py` is a dependency-free
Python reference implementation for structured observations; it does not infer
intent from arbitrary text or invoke ASDS. `core/entry.py` adds
evidence-labelled observations, entry gaps and ASDS continuation using the
[entry rubric](core/entry-rubric.md). Its labelled prompt cases live in
`evals/entry-cases.json`; reference-observation tests do not measure model
interpretation. Executable cases are in `tests/test_routing.py` and `tests/test_entry.py`.

A harness adapter loads the entry instructions through its supported discovery
mechanism. Runtime prompts live under `global-runtime/accelerate/` and
`adapters/runtime/`. Source availability is not proof of installation. This
release does not install/update DSH, ASDS or any user-home runtime.

The [native Agy adapter](adapters/runtime/agy/README.md) provides a preview-first
installer and explicit hash-bound skill updates using the supported user paths.
Its optional entry rule preserves owner policy and creates no backups. See the
[bounded runtime evidence](docs/reviews/native-entry-1.2.0.md) for observed
selection, scope drift and the limits of the repeated probe.

## Reusable capabilities and previous releases

Technical skills under `skills/` and bounded validators/adapters remain reusable.
Select only what a task needs. Older planning, delegation, issue and closure
procedures are optional historical capabilities, not default Accelerate policy.
Their commands must not run merely because the package was loaded. See
[core](core/README.md) and [planning](planning/README.md).

The breaking 1.x change removes Accelerate's universal ownership of planning,
delegation and completion. Do not compose the old root procedure with ASDS.
There is one workflow owner and one progress authority per task. Existing user
project state is preserved; no automatic migration or directory creation occurs.

## Development and releases

```sh
bash tests/all.sh
git diff --check
```

The test inventory distinguishes current routing/capability coverage from
superseded v0 orchestration contracts. Tests cover source behavior, not real
model compliance or deployed harness interoperability.

[Release procedure](docs/releases.md) · [Changelog](CHANGELOG.md) ·
[Architecture decision](docs/architecture/adr/2026-10-01-adr-003-accelerate-before-asds.md)
