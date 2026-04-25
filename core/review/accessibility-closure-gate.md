# Accessibility Closure Gate

## Purpose

Accessibility Closure Gate makes accessibility a closure condition for
user-facing UI work instead of a late polish note.

This gate is capability-oriented. Concrete commands, scanners, and browser tools
belong in runtime adapters or stack profiles.

## When Required

Use this gate when a branch changes:

- product-critical user surfaces
- forms, dialogs, menus, navigation, tables, toasts, or empty/error states
- authentication, onboarding, billing, recovery, upload, export, or settings UX
- visual design-system primitives, composites, shells, or pages
- keyboard interaction, focus flow, dynamic state, animation, or loading states

## Required Proof Areas

### Semantics

- interactive controls expose their role and accessible name
- headings and landmarks preserve navigable structure
- tables, lists, field groups, and status regions use meaningful semantics
- icons and decorative media have correct text alternatives or hiding behavior

### Keyboard And Focus

- every interactive path is keyboard reachable
- tab order follows visible task order
- focus is visible and not trapped accidentally
- dialogs and overlays define initial focus, escape behavior, and focus return
- disabled/loading states do not strand keyboard users

### State And Feedback

- validation errors are associated with fields
- async, success, error, empty, and loading states are announced or discoverable
- destructive actions expose confirmation or recovery where product risk requires it

### Visual Accessibility

- text and essential UI controls meet contrast expectations
- focus indicators are visible against the active theme
- information is not conveyed only by color
- layout remains usable under zoom and narrow viewports

### Motion And Timing

- motion does not block task completion
- reduced-motion preferences are respected when meaningful animation is present
- timeouts, spinners, and optimistic states expose recovery or status when needed

## Accessibility Packet

For non-trivial UI work, leave an accessibility packet with:

- affected routes/components/states
- proof intensity: `sampled`, `targeted`, `broad sweep`, or
  `full route-family audit`
- keyboard/focus findings
- semantic/name findings
- contrast/theme findings
- screen-reader or accessibility-tree observations when applicable
- residual risks and explicit waivers

## Blocking Conditions

Do not close when:

- a primary action cannot be reached or operated by keyboard
- focus disappears, traps incorrectly, or returns to an unsafe location
- user-facing errors are visual-only
- a custom control has no role/name/state equivalent
- contrast is visibly insufficient on the active theme
- broad UI changes omit accessibility scope entirely

## Closure Rule

Closure must expose accessibility status separately from visual polish:

- `Accessibility=<present|missing|blocked|not-applicable>`
- `blocking accessibility issue=<issue or none>`

Accessibility proof can share browser evidence with design implementation proof,
but the packet must name accessibility-specific observations.
