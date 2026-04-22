# Product-Critical Surfaces

## Purpose

Use this module when the work is a critical user-facing surface where backend
truth and frontend product quality are both blocking concerns.

Typical examples:

- billing recovery and delinquent regularization
- auth recovery and account access restoration
- onboarding-critical checkpoints
- sensitive self-service settings
- financial user-facing flows

## Product-Critical Surface Branch

Activate this branch when all of the following are true:

- the user is directly interacting with a critical flow
- the flow can be technically correct but still poor as product
- backend contract quality determines whether the frontend can be correct
- closure would be unsafe without stronger visual/product review

This branch is stricter than generic runtime-heavy work.

If the surface is also conversion-critical, trust-critical, or brand-critical,
escalate further into `premium-interface-production.md`.

## Branch Entry Packet Requirements

Make visible:

- which surface is product-critical and why
- which backend truth model still needs to be proved
- whether backend query-shape proof is already required
- which gates are already blocking
- which artifacts are required before implementation can honestly close

## Default Skill Bundle

Load this bundle unless a smaller one is explicitly justified:

- `product-runtime-review`
- `ascii-wireframe`
- `server-prop-governance`
- `front-react-shadcn`
- `tailwind-design-system`
- `sql-optimization-patterns` when relational fetch risk is real
- `anti-abuse-review` when abuse-sensitive
- concrete domain authority skills such as `financial-source-truth`,
  `payment-integration`, or `stripe-integration` when specialized truth is involved

For backend-heavy relational surfaces, `Backend Query Correctness` is not only a
review lens. It is an execution gate.

## Backend Product Contract Protocol

Do not start final UI implementation until the backend product model is real.

Produce, at minimum:

- `Truth Model`
  - main state
  - valid states and transitions
  - restrictions and effects per state
- `Action Model`
  - user-visible actions
  - preconditions
  - side effects
  - error paths
  - idempotency and retry expectations
- `Security Model`
  - ownership boundary
  - anti-IDOR posture
  - anti-enumeration and anti-replay posture
  - rate-limit expectations when applicable
- `Page Contract`
  - exact props or endpoints
  - allowed identifiers
  - reason codes and flags
  - action URLs
  - no user-facing copy in backend contracts unless explicitly justified
- `Query Shape Proof` when the surface aggregates related entities
  - expected ORM fetch posture
  - known sync or provider-refresh points
  - query-count evidence or equivalent runtime proof
  - `EXPLAIN` when the fix depends on execution-plan claims

Treat the backend as the source of truth. The frontend is the thin product
surface over that truth.

## Recovery Surface Isolation Rules

For auth, billing, or recovery states:

- do not reuse generic private hubs as recovery surfaces
- do not allow special-state users to roam into unrelated private pages
- do not use temporary allowlists as long-term product surfaces
- do not let dependency reuse override surface correctness

## Visual Contract Extraction

When an image, Stitch output, Figma, or screenshot is provided:

- extract composition
- extract hierarchy
- extract CTA dominance
- extract which areas are dominant vs subordinate
- state what will be preserved, adapted, or discarded

Do not treat the reference as a moodboard when it is actually carrying layout
and composition truth.

## Artifact Sufficiency Check

For this branch, verify:

- the backend packet names state, transitions, restrictions, actions, and error
  paths explicitly enough for UI and review
- query shape is proved when the backend owns relational aggregation
- the wireframe shows dominant reading order and main actions clearly enough to
  prevent implementation guesswork
- the visual contract says what was preserved, adapted, or discarded from the
  reference
- the artifact shows why the surface is isolated instead of leaking into a
  generic private hub

If the artifact exists but still leaves major execution decisions implicit, the
gate is not passed.

## Wireframe Before UI

For new product-critical pages:

- create an explicit wireframe or equivalent compositional artifact first
- get the structure stable before refining implementation
- do not skip this gate because the code feels straightforward

Implementation should not begin until the dominant reading order is clear.

## Design-System Adherence Review

Design-system usage is not only about component availability.

Review must ask:

- does this read like a real product surface?
- is the hierarchy clear?
- is there a dominant action?
- is the page over-segmented into equivalent cards?
- is branding accurate?
- does the composition fit the product language?

If the current design system is too weak to guarantee a professional result,
say so explicitly rather than pretending adherence means quality.

For premium surfaces, also load `premium-interface-production.md`.

## No-Close Principle

Do not close if any of these remain true:

- backend truth is still too thin for the UI
- the surface leaks into an unrelated private hub
- reference-driven work ignored the approved composition
- wireframe and implementation materially diverge
- the page is visually weak, generic, or amateur despite compiling and working
