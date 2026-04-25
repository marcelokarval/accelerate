# Design-System Contract Application

## Purpose

Use this module when a project already has `docs/reference/design-system*`
artifacts and the next task is to implement, correct, improve, premiumize,
propose, or generate UI from that design-system package.

This is the native Accelerate operating surface for the
`apply-design-system-contract` skill.

Extraction answers "what is the design system?" Application answers "how must
new or existing UI obey it?"

When application mutates real UI, proof is owned by the control-plane gate:

- `../control-plane/design-implementation-proof-gate.md`

## Activation Trigger

Activate this module when the request includes or implies:

- implement a new page, screen, flow, component, or theme from
  `docs/reference/design-system.contract.md`
- correct an existing UI against `docs/reference/design-system.html`
- apply `design-system.premium-direction.md` or
  `design-system.premium-direction.html`
- use the extracted design system to improve a product surface
- propose UI changes from a local design-system package
- generate a reusable theme or broad component treatment from the premium
  direction

If the design-system artifacts do not exist yet, route first through
`html-design-system-extraction.md`.

## Required Skill

Load:

- `apply-design-system-contract`

Usually pair with:

- the active frontend stack skill
- `frontend-boundary-governance`
- `tailwind-design-system`
- `frontend-componentization-audit` when reuse or component mapping matters
- `product-runtime-review` when the target surface is user-facing
- `premium-interface-production.md` when premium direction is active

## Required Artifacts

At minimum, application needs:

- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.html`
- `docs/reference/design-system.theme.css`

When premium work is active, also use:

- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`
- `docs/reference/design-system.premium-theme.css`

The implementation packet must name which artifacts were read.

When rollout planning artifacts exist, the entrypoint handoff must also satisfy:

- `../control-plane/design-system-rollout-entry-gate.md`

When the task mutates UI, the implementation/proof handoff must also satisfy:

- `../control-plane/design-implementation-proof-gate.md`

## Workflow

0. Run the design-system artifact consistency gate before treating any artifact
   as implementation authority:
   `onboarding/local-workspace/check-design-system-artifact-consistency.sh`.
1. Read the contract before editing only after the consistency gate passes.
2. Read the canonical theme CSS and identify which `--ds-*` tokens apply to the
   target surface.
3. Inspect the visual showcase for concrete source examples.
4. If premium artifacts exist and the task is improvement/polish/premium work,
   read the slop audit and premium direction artifacts.
5. Inspect the target codebase for real components, tokens, routes, and runtime
   states.
6. Create a component mapping matrix:
   - `source-observed`
   - `code-available`
   - `premium-proposed`
   - `not-approved-yet`
7. Decide the honest owner layer using the UI mutation ladder:
   - `token`
   - `ui`
   - `ui-enhanced`
   - `registry`
   - `shell`
   - `page`
8. Separate component anatomy from theme tokens before changing code.
9. Prefer applying the generated theme CSS to the project token layer before
   changing component anatomy. If components do not consume tokens yet, make the
   smallest shared-token wiring change first.
10. Implement with existing project components first and shared owners before
    page-local overrides.
11. Leave a `Requested-Vs-Implemented Packet` for the active slice, naming:
   - contract authority
   - premium authority when active
   - requested surface changes
   - actual landed changes
12. Register concrete visual or contract defects when found:
   - seam drift
   - authority bypass
   - anatomy/token confusion
   - dark/light parity gap
   - premium direction miss
13. Correct in-scope defects before promotion when honest to do so, then rerun
     proof on the corrected state.
14. Validate with type/lint/build gates appropriate to the stack.
15. Run browser/runtime proof and compare the delivered surface against the
     source showcase and premium HTML when active.
16. Use the Design Implementation Proof Gate to name the runtime target,
     viewport/state coverage, owner layer, and corrected-state evidence.
17. Use seam proof when shell/layout/state joins are likely defect hotspots.
18. Store temporary screenshots and proof captures under the governed project
     root `.tmp/` tree.
19. Register residual drift instead of hiding it.
20. If execution starts from an executive rollout plan, verify that the plan
    explicitly names:
   - required pre-read artifacts
   - immutable contract authority
   - primary implementation driver
   - secondary macro direction when active
   - execution slicing artifact

## Implementation Rules

- Do not use `design-system.contract.md` as law when it conflicts with
  `design-system.html`; route back to extraction/repair and rerun the
  consistency gate.
- Do not use any design-system package as implementation law unless its
  generated theme CSS exists and passes token consistency checks.
- Treat `design-system.contract.md` as the immutable rulebook.
- Treat `design-system.html` as source-truth visual evidence.
- Treat `design-system.theme.css` as the source-truth token implementation API.
- Treat `design-system.premium-theme.css` as the premium replacement token API
  when premium direction is active.
- Treat premium artifacts as directional improvement, not source evidence.
- When an executive rollout plan is the session entrypoint, treat it as an
  orchestrator only. It must not replace the contract, source evidence, or the
  primary implementation driver.
- Preserve source-observed component anatomy unless the premium direction
  explicitly authorizes recomposition.
- Prefer token/config changes for theme generation.
- Keep the generated `--ds-*` token names stable. Premium direction may change
  token values, not rename the theme API.
- Keep light and dark themes as sibling token systems over the same component
  semantics.
- Render one active theme at a time. Do not ship split-screen light/dark product
  composition as the final surface.
- For premium/de-AI work, apply the Benchmark Influence Map from the repo-local
  premium corpus and prove each adopted benchmark changed tokens, components,
  state rules, layout rules, or forbidden patterns.
- Use the highest honest shared owner first when the visual change repeats
  across multiple surfaces.
- Do not invent component families that are neither source-observed,
  code-available, nor premium-proposed.
- Do not collapse a broad component system into hero/cards/tables only.
- Do not accept raw framework defaults when the contract defines a different
  product identity.
- Do not silently translate token names between artifacts during implementation.
  If aliases are needed, they must be explicit in the contract and visible in the
  showcase evidence.
- Do not solve theming by spreading new colors through page-local classes. Wire
  components to the canonical theme tokens instead.

## Application Packet

Use this compact packet before mutation:

```text
Design-System Application Packet
- source artifacts:
- target surfaces:
- active branch:
- immutable laws:
- premium direction rules:
- component mapping:
- owner layer:
- anatomy fixed:
- token changes allowed:
- benchmark influence rows:
- theme CSS artifact:
- token mapping / aliases:
- states/components required:
- forbidden patterns:
- proof plan:
```

During or after mutation, the branch should also leave:

- `Requested-Vs-Implemented Packet`
- `Design Implementation Proof Packet` for mutation-bearing UI work
- defect ledger update when concrete defects are found
- seam proof when route-level proof would be too coarse

## Acceptance Gate

The task is not complete unless:

- the contract and relevant premium artifacts were read
- the design-system artifact consistency gate passed before mutation
- the generated theme CSS was read and either applied or explicitly mapped to the
  project's token layer
- any executive rollout entrypoint explicitly declared the required pre-read
  set, constraint artifact, primary implementation driver, and slicing artifact
- every changed UI element maps to `source-observed`, `code-available`,
  `premium-proposed`, or explicitly registered gap
- the packet names the chosen owner layer and justifies any page-first
  exception
- anatomy/token separation is visible in the implementation decision
- broad component coverage is honored when the project exposes a broad
  primitive catalog
- dark mode, when present, is validated as a sibling token system
- theme switching, when present, uses one active selector/provider at a time
- premium benchmark influences are visible in concrete token/component changes
- the active slice leaves `Requested-Vs-Implemented`
- concrete defects are dispositioned instead of buried in prose
- proof corresponds to the corrected state when in-scope defects were fixed
- seam proof is used when the likely drift lives at a seam
- browser/runtime proof compares the result to the design-system artifacts
- the Design Implementation Proof Gate is satisfied when UI was mutated
- type-check/lint/build gates run according to the target stack
- residual drift is documented

## Closure Blockers

Do not close if:

- the design-system package was used as inspiration rather than law
- an executive rollout plan was used as the only artifact and did not declare
  the rest of the required read set
- the contract was skipped
- the source showcase and contract disagree on tokens/classes and were used
  anyway
- the package lacks `design-system.theme.css`, or premium work lacks
  `design-system.premium-theme.css`
- implementation renames generated `--ds-*` tokens instead of applying or
  mapping them
- premium artifacts existed but were ignored for improvement/premium work
- the implementation invents unsupported colors, gradients, components, states,
  metrics, or layouts
- shared-owner changes were handled as repeated page-local polish without
  justified exception
- component anatomy and theme tokens are mixed without explanation
- dark mode is visually unrelated to light mode
- light/dark are rendered simultaneously as final product UI instead of one
  active theme at a time
- premium/de-AI work omits the Benchmark Influence Map or leaves benchmark
  influence as moodboard prose
- broad component coverage is required but not represented
- the slice closes with no `Requested-Vs-Implemented Packet`
- defects are described but not dispositioned
- corrected-state proof is missing after in-scope fixes
- seam-sensitive drift is claimed resolved without seam proof
- temporary capture evidence is normalized into `/tmp` instead of
  `project-root/.tmp/`
- final proof is screenshot-only with no artifact comparison
- final proof is code-only with no runtime/browser evidence
- runtime proof shows pre-fix state after in-scope visual defects were corrected
