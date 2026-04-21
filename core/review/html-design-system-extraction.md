# HTML Design-System Extraction

## Purpose

Use this module when a URL, local HTML file, or raw HTML reference is meant to
guide UI correction, recreation, premium visual convergence, or design-system
fidelity work.

This is the native Accelerate operating surface for the
`extract-html-design-system-v2` skill.

The skill file itself may live in the repo-managed seed catalog and the global
runtime mirror, but this module is the local control-plane doctrine that decides
when and how that skill is used.

## Activation Trigger

Activate this module when the request includes or implies:

- a URL used as visual/design reference
- a local `.html` file used as reference
- raw HTML used as reference
- a request to recreate, improve, correct, converge, or harden UI from an HTML
  source
- a premium interface task where HTML evidence is stronger than a screenshot or
  text description

Do not activate it for ordinary frontend work with no HTML reference.

## Required Skill

Load:

- `extract-html-design-system-v2`

Usually pair with:

- `front-react-shadcn` or the active frontend stack skill
- `frontend-boundary-governance`
- `tailwind-design-system`
- `product-runtime-review` when user-facing or runtime-sensitive
- `premium-interface-production.md` when the surface is brand-critical,
  conversion-critical, or quality-critical

## Output Contract

The required local artifact is:

- `docs/reference/design-system.html`

Temporary files belong under:

- `.tmp/`

Both directories must be created when missing.

## Workflow

1. Resolve the reference.
   - URL: fetch or capture the page first.
   - local `.html`: read it directly.
   - raw HTML: materialize it into `.tmp/` before extraction if needed.
2. Preserve original asset references when possible.
3. Generate `docs/reference/design-system.html`.
4. Treat that file as the design-system evidence artifact for subsequent UI
   correction, recreation, or convergence.
5. Before implementation, compare the target UI plan against the generated
   artifact instead of relying on memory or visual vibes.

## Closure Blockers

Do not close an HTML-reference-driven UI task if:

- the reference was used only as inspiration
- `docs/reference/design-system.html` was not produced
- the generated artifact invents classes or styles not present in the source
- the hero clone changes structure beyond text adaptation
- subsequent UI work ignores the generated design-system artifact
- temporary capture files are scattered outside `.tmp/`

## Relationship To Premium UI

This module does not replace premium visual judgment.

It supplies the concrete design-system evidence that premium review can use for
side-by-side comparison.

For premium surfaces, final review should compare:

- original URL / HTML reference
- `docs/reference/design-system.html`
- target implementation
