# Design Implementation Proof Gate

## Purpose

Use this gate when a design-system package, premium-direction artifact, visual
reference, or UI implementation plan is expected to become real product UI.

This gate closes the gap between:

- extracted design-system evidence
- premium direction and executive rollout plans
- actual code mutation
- browser/runtime proof
- visual defect correction
- closure

## Rule

Design-system compliance is not proven by code inspection, markdown plans, or a
single screenshot.

For mutation-bearing UI work, the branch must prove that the delivered runtime
surface obeys the active visual authorities and that in-scope visual defects
found during proof were corrected and reproved.

## Activation

Activate this gate when any of these are true:

- `docs/reference/design-system*` artifacts exist and the task mutates UI
- `apply-design-system-contract` is loaded for implementation or correction
- premium direction artifacts are used to change a product surface
- the branch is `visual / artifact-driven frontend`
- browser proof is needed to validate design, layout, theme, or state fidelity
- a UI polishing observer finds an in-scope defect during an active slice

This gate is optional for proposal-only work that does not mutate UI, but the
proposal must still name the proof this gate would require before execution.

## Required Inputs

Before mutation, name the active authorities:

- `contract authority`
  - usually `docs/reference/design-system.contract.md`
- `source visual evidence`
  - usually `docs/reference/design-system.html`
- `premium authority`
  - `design-system.premium-direction.md/html` when active
- `rollout or task driver`
  - sprint plan, issue plan, or explicit bounded task
- `runtime target`
  - route, shell, component family, or page state

If any required authority exists but is not read, the branch is not ready for
mutation.

## Implementation Proof Packet

Emit this packet before or during mutation:

```text
Design Implementation Proof Packet

- target surface:
- active branch:
- contract authority:
- source visual evidence:
- premium authority:
- rollout / task driver:
- owner layer:
  - token | derived-token | primitive | composite | registry | shell | page
- component mapping:
  - source-observed:
  - code-available:
  - premium-proposed:
  - not-approved-yet:
- anatomy fixed:
- token changes allowed:
- required states:
- required viewports:
- runtime adapter plan:
- defect ledger path / packet:
- closure blockers:
```

## Viewport And State Coverage

For premium, product-critical, or broad design-system application, browser proof
should cover the smallest honest matrix:

| Coverage | Default expectation |
| --- | --- |
| mobile narrow | `375px` or equivalent narrow viewport |
| tablet | `768px` when layout changes at tablet widths |
| desktop | `1024px` or `1440px` depending on target shell |
| dark mode | required when theme switching exists or was changed |
| hover / focus | required for changed interactive elements |
| loading / error / empty | required when those states exist in the slice |
| seam capture | required when drift is likely at shell/layout/state joins |

The branch may reduce this matrix only with an explicit bounded exception, such
as a token-only change with no runtime surface available.

## Browser Runtime Order

Use runtime capabilities in this order unless a bounded exception is packeted:

1. implementation proof
2. frontend QA such as type-check, lint, or component proof
3. Chrome DevTools or equivalent interactive browser truth
4. optional `agent-browser` repeatable operations after the path is bounded
5. Playwright persistence only after browser truth is stable
6. forensic closure

Do not use Playwright or agent-browser automation to bypass an unknown runtime
path.

## Visual Defect Loop

When proof reveals an in-scope visual or UX defect:

1. register it in the defect ledger
2. classify severity and owner
3. fix it before promotion when the fix belongs to the active slice
4. rerun browser proof on the corrected state
5. emit or update a correction loop packet
6. record residual drift when any defect remains

Do not close with a statement like "screenshot shows a minor issue" when that
issue is in scope and fixable.

## Defect Classes

Use these labels before inventing new ones:

- `contract-drift`
- `premium-direction-miss`
- `raw-framework-default`
- `card-soup`
- `cta-dilution`
- `flat-hierarchy`
- `responsive-break`
- `dark-mode-skin-drift`
- `missing-state`
- `accessibility-regression`
- `shell-seam-break`
- `token-anatomy-confusion`
- `shared-owner-bypass`

## Agent-Browser Compatibility

An `agent-browser`-style runtime may power repeatable observation, screenshots,
video, semantic snapshots, and state-aware checks after the surface is bounded.

It does not own:

- source authority selection
- issue topology
- root closure
- production session scraping decisions
- Playwright persistence decisions

Browser state access must follow the runtime adapter's session safety rules.

## Closure Blockers

Do not close when:

- UI was mutated from design-system artifacts without this gate being satisfied
- the implementation packet does not name the visual authorities
- the owner layer is omitted or page-local work bypasses the honest shared owner
- component mapping contains unapproved `not-approved-yet` elements
- proof is code-only with no runtime/browser comparison
- proof is screenshot-only with no comparison against active artifacts
- viewport or state coverage is missing without a bounded exception
- dark mode changed but sibling parity was not inspected
- in-scope visual defects were found but not registered
- fixed visual defects lack corrected-state proof
- residual drift is hidden in prose instead of registered
- Playwright persistence is used before interactive browser truth stabilizes the
  path

## Acceptance Standard

The gate passes only when a fresh reviewer can answer:

- which artifact controlled the implementation
- which runtime surface changed
- which shared owner layer was used
- which browser/runtime evidence proves the current corrected state
- which visual defects were opened, fixed, waived, or deferred
- what residual drift remains
