# HTML Design-System Extraction

## Purpose

Use this module when a URL, local HTML file, or raw HTML reference is meant to
guide UI correction, recreation, premium visual convergence, or design-system
fidelity work.

This is the native Accelerate operating surface for the
`extract-html-design-system-v2` skill.

The skill file lives in the repo-managed skill catalog. Optional runtime exports
may be generated from it, but this module is the local control-plane doctrine
that decides when and how that skill is used.

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
- `design-md-corpus.md` when the extraction or premium direction should be
  compared against the repo-local curated DESIGN.md corpus

## Output Contract

The required local artifacts are:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.theme.css`

When premium improvement, humanization, de-AI cleanup, visual polish, or
product-critical visual direction is in scope, the extended artifact set is:

- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`
- `docs/reference/design-system.premium-theme.css`

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

`design-system.theme.css` is the implementable token layer. It must expose the
canonical `--ds-*` CSS variables that new UI should consume. The HTML showcase
and markdown contract must reference those same tokens.

`design-system.premium-theme.css`, when present, is the premium replacement
theme layer. It must keep the same `--ds-*` token names so a target app can adopt
the new direction by replacing or importing the CSS token file instead of
rewriting component anatomy.

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
6. Generate `docs/reference/design-system.theme.css` as the canonical token
   layer using `--ds-*` variables. Map source tokens/classes into this layer;
   do not leave raw source names as the implementation API.
7. Keep `design-system.html`, `design-system.contract.md`, and
   `design-system.theme.css` synchronized. Any CSS custom property used by the
   HTML showcase or named in the contract must be declared in the theme CSS.
8. Prefix documentation-only wrapper classes with `ds-doc-` so they cannot be
   mistaken for source-observed component classes.
9. Include visible source evidence for every major section or pattern in the
   HTML artifact and every major rule/component in the contract artifact.
10. Treat the HTML, contract, and theme CSS as the design-system evidence package for subsequent UI
   correction, recreation, or convergence.
11. When premium improvement is in scope, run the AI-slop audit and premium
     direction extension before implementation.
    Use the DESIGN.md corpus as local example material only when selected entries
    are named and their influence is mapped into concrete token/component/layout
    consequences.
12. Run the local consistency gate before implementation or closure:
     `onboarding/local-workspace/check-design-system-artifact-consistency.sh`.
13. Before implementation, hand off to
    `design-system-contract-application.md` instead of relying on memory or
    visual vibes.

## Artifact Consistency Gate

The source-truth showcase and implementation contract are one atomic package.
They must not be allowed to describe different systems.

The failure mode to prevent is:

- `design-system.html` visually looks correct and uses one token/class set
- `design-system.contract.md` describes a different token/class set
- no canonical CSS token layer exists to implement the system
- a later agent reads only the markdown and implements the wrong system

Rules:

- `design-system.html` is the visual source-truth showcase.
- `design-system.contract.md` is the implementation rulebook for that same
  showcase, not a parallel interpretation.
- `design-system.theme.css` is the stable implementation API.
- Theme CSS tokens must use the `--ds-*` namespace.
- `--ds-*` is the Accelerate interchange namespace for generated artifacts. A
  target app may keep an established runtime token API, such as shadcn/Tailwind
  `--background` and `--primary`, when a Token Alias Map explicitly proves the
  semantic equivalence.
- The contract may mention source/raw tokens only as evidence, but the
  implementation token contract must use `--ds-*` names.
- The HTML may not use CSS custom properties that are absent from the theme CSS.
- The contract may not name CSS custom properties that are absent from the theme
  CSS.
- Documentation-only scaffolding is allowed only when clearly prefixed, such as
  `ds-doc-*`.
- Premium direction artifacts have their own consistency obligation:
  `design-system.premium-direction.html` and
  `design-system.premium-direction.md` tokens must be declared in
  `design-system.premium-theme.css` using the same `--ds-*` names.
- DESIGN.md corpus entries are not a replacement token API. Any imported or
  selected corpus pattern must be normalized into the canonical `--ds-*` layer.

## Canonical Theme CSS Contract

The generator must produce a CSS file that can become the app theme layer.

Required source-truth artifact:

- `docs/reference/design-system.theme.css`

Required premium artifact when premium direction exists:

- `docs/reference/design-system.premium-theme.css`

Rules:

- Use stable `--ds-*` tokens, not one-off names like `--bg`, `--ledger-bg`, or
  `--vault-surface` as the implementation API.
- In generated Accelerate artifacts, use stable `--ds-*` tokens. In target app
  runtime code, a mature local token API may remain the implementation API when
  it is explicitly mapped to the `--ds-*` interchange contract.
- Represent light/dark as selectors over the same token names, for example
  `:root` and `[data-theme="dark"]`, not separate unrelated token vocabularies.
- Keep semantic meaning in reusable names such as `--ds-bg`, `--ds-fg`,
  `--ds-surface`, `--ds-border`, `--ds-primary`, `--ds-accent-positive`,
  `--ds-accent-warning`, `--ds-accent-danger`, `--ds-accent-info`,
  `--ds-accent-ai`, `--ds-radius-sm`, `--ds-radius-md`, `--ds-radius-lg`,
  `--ds-shadow-sm`, `--ds-shadow-md`, and `--ds-font-sans`.
- If the source has project-specific raw tokens, document them as aliases to the
  canonical token layer instead of making future UI consume the raw names.
- Premium direction must change token values, not rename the token API.
- Premium direction must change token values, not silently rename the token API.
  If the target app uses a local API, the alias map must remain stable across
  source and premium themes.

The intended implementation path is: import or merge the generated theme CSS
into `global.css`, Tailwind theme variables, or equivalent project token layer;
then existing components that consume the canonical tokens can reskin without
component rewrites.

This path is a portability claim, not a guarantee. Before closing real app
implementation on that claim, use
`../control-plane/theme-template-portability-gate.md` to prove whether the change
is `token-only`, derived-token wiring, primitive wiring, or a deeper template
change.

If the gate fails, do not choose whichever artifact looks better. Treat the
package as stale or split-brained, regenerate or repair the inconsistent
artifact, then rerun the gate.

## Premium Extension

The premium extension exists because source-truth extraction can faithfully
capture a weak or AI-shaped design.

Do not solve that by corrupting `design-system.html` with invented premium
styles. Preserve the baseline, then create a separate premium package:

1. `design-system.slop-audit.md`
   - score concrete AI/genericity smells
   - name evidence from the baseline and contract
   - compare against the repo-local `premium-design-benchmark-corpus`
   - distinguish source-truth pass/fail from premium-direction pass/fail
2. `design-system.premium-direction.md`
   - define the proposed premium identity, tokens, surfaces, component
     direction, motion, forbidden patterns, and handoff rules
   - explain exactly how the direction reduces the audit findings
   - include `## Benchmark Influence Map` with concrete token/component impacts
     from the repo-local benchmark corpus
   - include `## Single Active Theme Model` when theme switching is supported or
     requested
   - when the source supports theme switching, define light and dark as sibling
      token systems over the same product semantics instead of unrelated skins
   - separate immutable component anatomy from theme tokens so the artifact can
     seed future theme generation through `global.css`, CSS variables, Tailwind
     tokens, or equivalent configuration
3. `design-system.premium-direction.html`
   - render a concrete visual proof of the proposed direction
   - label itself as directional, not source truth
   - avoid cloning benchmark brands or pretending invented styles were observed
   - when dark mode exists or is requested, prove one active theme at a time via
     the same markup/anatomy and a selector or theme provider model
   - when a broad primitive catalog exists, behave like a theme showroom rather
     than a landing-page moodboard

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
- `docs/reference/design-system.theme.css` exists and declares the canonical
  `--ds-*` token layer
- `design-system.html` and `design-system.contract.md` pass the artifact
  consistency gate
- documentation-only classes are distinguishable from source-observed component
  classes, preferably with `ds-doc-*`
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
- the next implementation or correction step is explicitly routed through
  `apply-design-system-contract`
- when premium improvement is active, the audit, premium direction markdown, and
  premium direction HTML all exist, `design-system.premium-theme.css` exists,
  and the premium HTML has render proof
- when premium improvement is active, `design-system.premium-direction.md`
  includes `## Benchmark Influence Map` and every selected benchmark creates a
  token, component, state, layout, or forbidden-pattern consequence
- when theme switching is supported or requested, the premium direction includes
  `## Single Active Theme Model` and proves one active theme at a time, not a
  simultaneous light/dark product composition
- when the local frontend stack exposes a broad primitive catalog such as
  shadcn/ui or Radix, premium direction includes a component coverage matrix and
  the premium HTML includes enough component families to judge recomposition
  beyond atmosphere
- when dark mode is source-supported or requested, the premium artifact proves
  dark mode as a coherent token-derived sibling of light mode, not a single
  decorative black panel or unrelated neon dashboard
- for themeable systems, the premium direction identifies what can change by
  tokens and what must remain fixed as product/component anatomy

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
- the generated artifact and contract declare different token or class systems
- the source-truth or premium package lacks the required implementable theme CSS
- generated theme CSS uses non-canonical custom property names outside the
  `--ds-*` namespace
- the generated artifact invents component structures, metrics, logos, icons, or
  copy not backed by source markup
- the generated artifact omits source-evidenced forms, tooltips, modals, alerts,
  toasts, tables, menus, validation, loading, or empty states without reason
- the hero clone changes structure beyond text adaptation
- the artifact omits major visible page patterns without explanation
- subsequent UI work ignores either generated design-system artifact
- subsequent UI work skips `apply-design-system-contract` after the artifact
  package exists
- temporary capture files are scattered outside `.tmp/`
- premium improvement was requested but the slop audit or premium direction
  artifacts were skipped
- the premium direction is just another generic violet/shadcn/SaaS moodboard
- the premium HTML is not rendered or reviewed before being used as handoff
- the premium HTML only proves a hero/card/table slice and is too thin to judge
  how forms, overlays, feedback, navigation, loading, and empty states would
  look in the proposed direction
- dark mode is supported or requested but the premium direction only mentions
  it textually, shows it as a small decorative block, or makes it visually
  disconnected from the light theme
- the premium HTML presents `Light vs Dark System` as simultaneous product UI
  instead of proving one active theme at a time
- the premium direction omits the Benchmark Influence Map or cites benchmarks
  without token/component consequences
- the component gallery is not broad enough to evaluate the design as a future
  theme generator for many interfaces
- the artifact consistency gate fails for source-truth or premium-direction
  artifacts

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
