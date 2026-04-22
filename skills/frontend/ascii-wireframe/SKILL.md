---
name: ascii-wireframe
description: Codex-native high-fidelity ASCII wireframe and diagram skill for UI proposals, modal reviews, flows, and architecture sketches. Use whenever the task benefits from a visual artifact, not just textual explanation.
user-invocable: true
related-skills: architecture, active-frontend-stack
---

# ascii-wireframe

Use this skill for wireframes, flow diagrams, before/after proposals, modal
comparisons, page layout sketches, and architecture visuals.

## Mandatory Protocol

This skill must produce an actual visual artifact when invoked for a wireframe
or diagram task.

Rules:

1. Always draw a real wireframe or diagram.
2. Always use fenced code blocks for alignment.
3. Use legends like `[1]`, `[2]`, `[3]` when elements need callouts.
4. Explain the important decisions after the diagram.

Prohibited:

- text-only UI analysis when a wireframe was requested
- “it would look something like…” without drawing it
- diagrams outside fenced code blocks

## When To Use

Load this skill when the task involves:

- wireframes
- modal or popup comparisons
- before/after UI proposals
- flow diagrams
- layout comparisons
- architecture sketches
- state visualization

## Required Sequence

1. Identify what is being drawn:
   - modal, popup, dialog, dropdown
   - page or layout
   - flow or architecture
   - state set (loading, empty, error, success)
2. Choose the right fidelity:
   - `compact` for fast sketches
   - `normal` for standard proposals
   - `spacious` for design review and ADR-like work
3. Draw the artifact.
4. Add callouts when the drawing would otherwise be ambiguous.
5. Explain the decisions briefly after the drawing.

## Special Enforcement For Modals And Popups

If the request mentions modals, dialogs, popups, or overlays:

1. Show the overlay/background context with `░`.
2. Show the modal position relative to the viewport.
3. Show header, body, and footer zones explicitly.
4. If multiple modals are being compared, draw all relevant variants.
5. Use callouts for conflicting ownership or layout decisions.

Recommended modal template:

```text
┌─────────────────────────────────────────────┐
│░░░░░░░░░░░░ OVERLAY BACKGROUND ░░░░░░░░░░░░│
│░░░    ╔══════════════════════════╗    ░░░░│
│░░░    ║  Modal Title      [✕]    ║    ░░░░│
│░░░    ╠══════════════════════════╣    ░░░░│
│░░░    ║  Content area            ║    ░░░░│
│░░░    ║  shown visually          ║    ░░░░│
│░░░    ╠══════════════════════════╣    ░░░░│
│░░░    ║ [Cancel]    [Action]     ║    ░░░░│
│░░░    ╚══════════════════════════╝    ░░░░│
└─────────────────────────────────────────────┘
```

## Visual Vocabulary

### Boxes And Borders

Lo-fi:

```text
┌──────────────┐
│              │
├──────────────┤
│              │
└──────────────┘
```

Hi-fi / modal emphasis:

```text
╔══════════════╗
║              ║
╠══════════════╣
║              ║
╚══════════════╝
```

Rounded / card-like:

```text
╭──────────────╮
│              │
╰──────────────╯
```

### Flow Connectors

```text
→   simple direction
━━━━━━━━→ critical path
- - - → async or looser flow
═══→ return/result
```

### Useful Marks

```text
✓ success / present
✕ failure / close
⚠ warning
★ highlight
[1] callout
```

## Density Guidance

| Context | Density | Fidelity |
| --- | --- | --- |
| quick sketch | compact | lo-fi |
| default product discussion | normal | hi-fi |
| ADR, design review, stakeholder proposal | spacious | hi-fi |

Compact example:

```text
┌─────────────┐
│ Title       │
├─────────────┤
│ Item 1      │
│ Item 2      │
└─────────────┘
```

Normal example:

```text
╭──────────────────────────────────────╮
│ Title                                │
├──────────────────────────────────────┤
│ Content with standard spacing        │
╰──────────────────────────────────────╯
```

Spacious example:

```text
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    Title with breathing room                                 ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║    Content with generous spacing                             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

## Accelerate Guidance

- Use this skill before coding when UI shape or interaction boundary is still
  under discussion.
- For billing, onboarding, settings, and modal-family decisions, prefer
  `normal` or `spacious` wireframes.
- When comparing current vs legacy or modal vs page ownership, draw both sides.
- This skill is a planning and review tool, not a substitute for implementation.

## Internal Validator

Before finishing, verify:

- Was an actual wireframe or diagram drawn?
- Was it inside a fenced code block?
- Were callouts added when needed?
- Was the visual followed by a short explanation?

If any answer is no, the skill was not applied correctly.

## Review Checklist

- Did the response include a real visual artifact?
- Is the chosen density appropriate for the decision?
- Are modal overlays and action zones explicit when relevant?
- Are multiple states or competing surfaces drawn side by side when needed?
