# Visual Modeling Boundary

Use this reference to decide whether `ascii-wireframe` is enough or whether the work needs a broader visual-modeling layer.

## Core Rule

`ascii-wireframe` owns UI/product surface visuals.

When the requested artifact models system truth rather than interface shape, do not force it into a wireframe. Treat it as visual modeling and select a diagram family intentionally.

## Use `ascii-wireframe` For

- page and layout wireframes
- modal, popup, dialog, dropdown, and overlay structure
- product surface before/after comparisons
- loading, empty, error, success, and permission state sets
- responsive product-surface comparisons
- UI flow sketches where screen shape is still the main concern
- reference ASCII and target ASCII for premium UI work

## Use Broader Visual Modeling For

- ERD or database relationship diagrams
- ORM lifecycle and model-to-service diagrams
- class, function, or module relationship diagrams
- sequence diagrams for callbacks, queues, providers, agents, or auth
- state machines for lifecycle-heavy domains
- swimlanes and journey maps for users, leads, owners, operators, or providers
- org charts, team topology, and agent communication diagrams
- C4/context/container/component sketches
- deployment and runtime topology diagrams
- queue/retry/dead-letter topology
- trust boundary and security dataflow diagrams
- issue topology, proof order, and governance flow diagrams

## Boundary Test

Ask:

1. Is the diagram primarily about what a user sees or manipulates?
   - yes: `ascii-wireframe` is probably enough.
2. Is the diagram primarily about persisted truth, runtime interaction, ownership, lifecycle, or communication?
   - yes: use broader visual modeling.
3. Would calling it a wireframe hide a stronger notation, such as ERD, sequence, state machine, or swimlane?
   - yes: do not call it a wireframe.

## Companion Use

A single task may need both layers.

Example:

```text
Lead intake redesign
├─ swimlane / journey map        broader visual modeling
├─ ERD impact                    broader visual modeling
├─ backend sequence              broader visual modeling
└─ React/Inertia page wireframe   ascii-wireframe
```

In that case, create the system diagram first when it constrains the UI, then draw the UI wireframe against the clarified truth.
