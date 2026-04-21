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

The required local artifacts are:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`

When premium improvement, humanization, de-AI cleanup, visual polish, or
product-critical visual direction is in scope, the extended artifact set is:

- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`

Temporary files belong under:

- `.tmp/`

Both directories must be created when missing.

For multiple URLs in the same request, the artifact must be a consolidated
design-system corpus, not one isolated page sample. Each source URL must have a
separate capture trail under `.tmp/`.

`design-system.html` is the human visual showcase.

`design-system.contract.md` is the implementation contract for future AI/agent
work. It must be prescriptive enough for another agent to build new screens
without treating the showcase as a loose moodboard.

## Workflow

1. Resolve the reference.
   - URL: fetch or capture the page first.
   - local `.html`: read it directly.
   - raw HTML: materialize it into `.tmp/` before extraction if needed.
2. Inventory the captured sources before writing the final artifact.
   - page shell: header, nav, footer, and global wrappers
   - hero structure and assets
   - typography classes and text hierarchy
   - colors, surfaces, borders, overlays, and gradients
   - buttons, links, icon buttons, labels, inputs, textareas, selects,
     checkboxes, radios, switches, sliders, cards, menus, tabs, badges, forms,
     validation messages, tables, lists, dropdowns, popovers, tooltips,
     dialogs, modals, drawers, alerts, banners, toasts, progress indicators,
     skeletons/loaders, empty states, charts, code blocks, logos, and other
     real components
   - layout patterns and spacing scales
   - motion, transition, hover, focus, disabled, active, and `data-state`
     behavior
   - icon markup and SVG conventions
3. Preserve original asset references when possible.
4. Generate `docs/reference/design-system.html` using real source markup and
   class strings.
5. Generate `docs/reference/design-system.contract.md` with immutable design
   laws, token contract, component recipes, state coverage matrix, layout
   recipes, motion/interaction contract, composition rules, forbidden patterns,
   not-observed component families, rebuild checklist, and source evidence map.
6. Include visible source evidence for every major section or pattern in the
   HTML artifact and every major rule/component in the contract artifact.
7. Treat both files as the design-system evidence package for subsequent UI
   correction, recreation, or convergence.
8. When premium improvement is in scope, run the AI-slop audit and premium
   direction extension before implementation.
9. Before implementation, compare the target UI plan against the generated
   artifacts instead of relying on memory or visual vibes.

## Premium Extension

The premium extension exists because source-truth extraction can faithfully
capture a weak or AI-shaped design.

Do not solve that by corrupting `design-system.html` with invented premium
styles. Preserve the baseline, then create a separate premium package:

1. `design-system.slop-audit.md`
   - score concrete AI/genericity smells
   - name evidence from the baseline and contract
   - compare against local benchmarks such as `popular-web-designs` when useful
   - distinguish source-truth pass/fail from premium-direction pass/fail
2. `design-system.premium-direction.md`
   - define the proposed premium identity, tokens, surfaces, component
     direction, motion, forbidden patterns, and handoff rules
   - explain exactly how the direction reduces the audit findings
3. `design-system.premium-direction.html`
   - render a concrete visual proof of the proposed direction
   - label itself as directional, not source truth
   - avoid cloning benchmark brands or pretending invented styles were observed

The premium extension is required when the user asks for terms such as:

- improve
- humanize
- premium
- polish
- de-AI
- less AI
- less generic
- upgrade the design
- make it feel like a real product

## Acceptance Gate

The extraction is not complete unless all of these are true:

- `.tmp/` contains the captured source HTML for every input URL or source
- source CSS/JS asset references are preserved or explicitly documented
- the first section is a direct hero clone with text-only adaptation
- `docs/reference/design-system.contract.md` exists and is contract-shaped, not
  summary-shaped
- the final artifact includes visible evidence labels that connect sections to
  source files or URLs
- the contract maps rules/components back to source evidence
- UI components are backed by source markup, not invented approximations
- broad component families were checked, including forms, tooltips, modals,
  alerts, toasts, tables, menus, validation states, loading states, and empty
  states when relevant
- major source patterns are represented or explicitly omitted with reason
- absent component families are listed under `Not Observed / Do Not Invent`
  instead of being guessed into the system
- the artifact pair can be used as a practical reference for later UI correction
  and new-screen generation
- when premium improvement is active, the audit, premium direction markdown, and
  premium direction HTML all exist and the premium HTML has render proof
- when the local frontend stack exposes a broad primitive catalog such as
  shadcn/ui or Radix, premium direction includes a component coverage matrix and
  the premium HTML includes enough component families to judge recomposition
  beyond atmosphere

If the generated file is thin, synthetic, or only moodboard-like, treat the run
as failed even if `design-system.html` exists.

## Closure Blockers

Do not close an HTML-reference-driven UI task if:

- the reference was used only as inspiration
- `docs/reference/design-system.html` was not produced
- `docs/reference/design-system.contract.md` was not produced
- `.tmp/` does not contain traceable source captures
- source evidence is missing from the final artifact
- the contract does not define immutable design laws, component recipes, state
  coverage, forbidden patterns, and source evidence
- the generated artifact invents classes or styles not present in the source
- the generated artifact invents component structures, metrics, logos, icons, or
  copy not backed by source markup
- the generated artifact omits source-evidenced forms, tooltips, modals, alerts,
  toasts, tables, menus, validation, loading, or empty states without reason
- the hero clone changes structure beyond text adaptation
- the artifact omits major visible page patterns without explanation
- subsequent UI work ignores either generated design-system artifact
- temporary capture files are scattered outside `.tmp/`
- premium improvement was requested but the slop audit or premium direction
  artifacts were skipped
- the premium direction is just another generic violet/shadcn/SaaS moodboard
- the premium HTML is not rendered or reviewed before being used as handoff
- the premium HTML only proves a hero/card/table slice and is too thin to judge
  how forms, overlays, feedback, navigation, loading, and empty states would
  look in the proposed direction

## Relationship To Premium UI

This module does not replace premium visual judgment.

It supplies the concrete design-system evidence that premium review can use for
side-by-side comparison.

For premium surfaces, final review should compare:

- original URL / HTML reference
- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.slop-audit.md` when premium improvement is in
  scope
- `docs/reference/design-system.premium-direction.md` when premium improvement
  is in scope
- `docs/reference/design-system.premium-direction.html` when premium improvement
  is in scope
- target implementation
