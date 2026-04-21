# HTML Design-System Premium Pipeline Plan

Date: 2026-04-21

## Decision

Promote the successful `launch-fullstack` experiment into the governed
Accelerate workflow.

The extraction skill remains responsible for source-truth design-system
evidence:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`

Premium improvement becomes a second, explicit pipeline stage rather than a
silent rewrite of the source truth:

- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`

Premium direction must now include a component coverage layer when the local
stack exposes broad primitives such as shadcn/ui or Radix. This prevents the
premium HTML from becoming a thin moodboard that proves atmosphere but not
recomposition capacity.

## Why

The `launch-fullstack` test showed that the extracted design system was useful
but visibly AI-shaped: violet/fuchsia bias, generic SaaS gradients, raw shadcn
surface language, card-soup risk, weak materiality, and low brand specificity.

Running a structured slop audit and then generating a premium direction produced
a materially better target artifact without destroying the original extracted
truth.

## Operating Rule

Do not let premium direction overwrite source evidence.

The baseline extraction says:

- what the current/reference system actually is
- which classes, states, components, and assets are evidenced
- what an implementation must not invent

The premium pipeline says:

- what smells AI-generated or template-shaped
- which benchmark lessons are relevant
- what premium direction should replace the weak parts
- what visual proof exists before product code is mutated

## Activation

Open the premium stage when any of these are true:

- the user asks to improve, humanize, premiumize, de-AI, polish, or upgrade a
  design extracted from HTML/URL/app evidence
- the surface is product-critical, conversion-critical, brand-critical, or
  premium-interface class
- the extracted result shows generic AI/SaaS smells such as purple-gradient
  bias, raw shadcn defaults, card-soup, weak materiality, low typography
  personality, generic gradients, or motion without intent

## Expected Workflow

```text
reference URL / HTML / app
  -> capture and inventory
  -> source-truth design-system.html
  -> LLM-safe design-system.contract.md
  -> AI-slop audit
  -> premium direction markdown
  -> component coverage matrix
  -> premium direction HTML proof
  -> visual/render validation
  -> implementation handoff
```

## Benchmark Policy

Use local benchmark systems such as `popular-web-designs` as comparison
material, not as copy targets.

The pipeline should extract lessons from benchmarks:

- restraint
- materiality
- accent discipline
- hierarchy
- motion intent
- brand specificity

It must not clone another product's identity.

## Acceptance

The pipeline is not complete unless:

- the baseline source-truth pair exists
- the audit names concrete AI/genericity smells
- the premium direction defines tokens, surfaces, components, motion, forbidden
  patterns, and composition rules
- the premium HTML renders as a concrete visual proof with enough component
  families to compare forms, overlays, feedback, navigation, loading, empty
  states, and data surfaces when those primitives exist in the stack
- the premium direction clearly reduces the smells detected by the audit

## Updated Surfaces

- `docs/codex-skill-seeds/skills/extract-html-design-system-v2/SKILL.md`
- `core/review/html-design-system-extraction.md`
- `core/review/premium-interface-production.md`
- `core/workflows/catalog.md`
- `core/control-plane/branch-enforcement-matrix.md`
- `docs/codex-skill-seeds/skills/README.md`
