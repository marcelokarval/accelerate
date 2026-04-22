# Architecture Planning

This sublayer governs planning artifacts that shape architecture before code
or doctrine mutation.

Use it for:

- PRD-to-SDD transitions
- architectural target-state plans
- control-plane refactors
- layer-boundary decisions

## Native Artifacts

- `sdd-template.md`

## Rule

Use SDD when a user story or PRD-lite is accepted but technical shape, layer
ownership, data contracts, workflow/runtime adapters, migration strategy, or
proof strategy are not yet safe for execution.

Do not use SDD as a generic planning synonym. It is the architecture/design
bridge between product scope and implementation-ready task breakdown.

The current architectural authority still lives primarily in:

- `../../docs/architecture/`

This sublayer exists so architecture planning becomes a native product concept,
not just a docs directory habit.
