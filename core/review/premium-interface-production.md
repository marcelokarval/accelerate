# Premium Interface Production

## Purpose

Use this module when the page is not only user-facing and critical, but also a
premium product surface where perceived quality is part of the outcome.

Typical examples:

- premium billing recovery
- high-value onboarding checkpoints
- pricing, checkout, and subscription surfaces
- conversion-critical dashboards and upgrade flows
- any screen where premium interface quality is a competitive differentiator

## Premium Surface Branch

Treat this as a stricter subset of `product-critical-surfaces.md`.

Activate it when:

- the page must feel premium, trustworthy, and intentional
- a weak visual result would materially reduce product value
- a screenshot, Stitch output, Figma, or other visual reference is central to
  the requested outcome
- technical correctness alone would still leave the work unacceptable

## Premium Interface Director

This role owns visual direction before implementation begins.

Responsibilities:

- define the job of the screen
- define narrative reading order
- define the dominant panel and dominant CTA
- define what is primary, secondary, and tertiary
- extract composition, rhythm, and hierarchy from references
- block implementation when the structure is still weak

This role is not the same as raw frontend implementation. It is a product and
visual orchestration posture.

## Reference-To-Wireframe Protocol

When a reference exists, follow this sequence:

1. `Reference Reading`
   - identify composition
   - identify panel dominance
   - identify CTA placement
   - identify editorial framing and brand weight
   - identify what makes the reference feel premium
2. `Reference ASCII`
   - create a rich ASCII artifact of the reference itself
   - preserve regions, spans, hierarchy, and reading order
3. `Target ASCII`
   - create a rich ASCII artifact of the adapted proposal
   - explicitly state what is preserved, adapted, or discarded
4. `Side-By-Side Comparison`
   - compare reference ASCII and target ASCII before coding starts

Do not treat premium references as weak inspiration. Treat them as partial
contracts.

## Rich ASCII Requirement

The ASCII artifacts for premium work must be rich enough to show:

- dominant header or framing zones
- major panels and their spans
- CTA priority
- support actions vs core actions
- visual reading path
- which blocks are subordinate and which are not allowed to compete

Poor ASCII means poor direction. Keep it detailed.

## Premium Surface Packet

Premium work should leave a visible packet containing:

- `Job Of The Screen`
- `Reference Reading`
- `Reference ASCII`
- `Target ASCII`
- `Hierarchy Map`
- `CTA Map`
- `Design-System Mapping`
- `Preserved / Adapted / Discarded`
- `Requested-Vs-Implemented`
- `Defect Disposition`

This packet is part of the execution truth, not optional decoration.

## Artifact Sufficiency Check

Premium work fails when the artifacts are present but too shallow to control the
implementation.

At minimum, verify:

- `Reference ASCII` shows spans, dominance, and reading order rather than only
  block names
- `Target ASCII` makes the adaptation explicit instead of vaguely paraphrasing
  the source
- `Hierarchy Map` names what is primary, secondary, and tertiary
- `CTA Map` names the dominant CTA and why it wins
- `Design-System Mapping` shows how the composition will be translated into
  real primitives, compounds, and tokens without flattening the reference
- `Preserved / Adapted / Discarded` is explicit enough to review side by side

If the packet still allows multiple materially different screens to be built
from the same artifact set, it is not sufficient yet.

## Premium UI Gate

Do not pass unless the answer is strong for all of these:

- does the screen have a dominant visual center?
- is there a clearly dominant CTA?
- does the page read as one narrative, not a pile of fragments?
- are secondary actions truly secondary?
- does the page feel like part of the product?
- does the design system support the composition rather than flatten it?
- does the result preserve the essence of the reference?

## Premium Failure Modes

Watch for:

- `card-soup`
- `cta-dilution`
- `flat-hierarchy`
- `reference-as-moodboard`
- `premium-surface-treated-as-safe-ui`
- `design-system-as-component-bin`
- `implementation-first-on-premium-surface`
- `visually-correct-spacing-but-no-direction`

Name the failure mode when it appears and re-enter design framing instead of
decorating the weak layout.

## Design System Rule

Design-system adherence is necessary but not sufficient.

The workflow must distinguish:

- using the correct primitives, compounds, and tokens
- from actually landing a premium interface

Do not confuse component correctness with premium visual direction.

## Premium Correction Rule

Premium review is not allowed to stop at "the result still feels weak" or "the
layout drifted a bit".

When the active premium slice finds concrete defects, it should:

1. classify the defect
2. decide whether it is in-scope
3. correct it before promotion when in-scope
4. rerun proof on the corrected state

Common premium defect classes include:

- `shell-seam-break`
- `cta-dilution`
- `flat-hierarchy`
- `card-soup`
- `premium-direction-miss`
- `theme-parity-gap`
- `authority-bypass`

Do not let premium review become articulate disappointment with no correction
posture.

## AI-Slop Premium Direction Protocol

When the premium branch depends on an extracted HTML/URL/app design system, use
the HTML design-system package as evidence, then open the premium direction
extension.

Required comparison set:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.slop-audit.md`
- `docs/reference/design-system.premium-direction.md`
- `docs/reference/design-system.premium-direction.html`

When the task moves from diagnosis/direction into implementation, correction,
or proposal, route through `design-system-contract-application.md` and
`apply-design-system-contract`. Premium direction is not allowed to remain a
pretty reference detached from code. It must become a contract-aware
implementation packet with component mapping, anatomy/token separation,
requested-vs-implemented comparison, defect disposition, and runtime
comparison proof.

The slop audit should explicitly inspect for:

- purple/violet/fuchsia default bias
- generic AI/SaaS gradients
- raw shadcn or framework-default leakage
- card-soup
- flat hierarchy
- weak typography personality
- weak materiality
- low brand specificity
- motion with no product intent

The premium direction is valid only if it does three things:

- preserves the source-truth extraction as baseline evidence
- names which baseline smells it is correcting
- proves the new direction with a rendered HTML artifact before implementation
- includes a component coverage matrix when the stack exposes many primitives,
  using shadcn/ui, Radix, or the active component library as a checklist rather
  than as a visual identity to copy
- demonstrates enough component families in the premium HTML to evaluate real
  screen recomposition, not just atmosphere
- when light/dark themes exist, proves dark mode as a token-derived sibling of
  the light system, not as an unrelated black/neon product
- separates theme-token changes from immutable component anatomy so the
  direction can become a future theme generator rather than a one-off mockup
- covers enough states and primitives to behave like a product UI/theme kit,
  comparable in breadth expectation to Bootstrap or mature component systems

Benchmark systems such as `popular-web-designs` may inform the judgment, but
they are comparison references, not identities to copy.

Add these premium failure modes when relevant:

- `ai-saas-purple-bias`
- `generic-gradient-language`
- `raw-shadcn-surface`
- `premium-direction-missing`
- `slop-audit-missing`
- `premium-html-not-rendered`
- `premium-component-gallery-too-thin`
- `dark-mode-as-unrelated-skin`
- `theme-generator-contract-missing`
- `component-kit-coverage-too-thin`

## Premium Interface Reconciliation

Final review for premium surfaces must compare side by side:

- source reference
- target ASCII / approved composition
- slop audit when the surface came from HTML design-system extraction
- premium direction HTML when premium improvement is in scope
- delivered implementation

Temporary screenshots and seam captures supporting this comparison should live
under the governed project root `.tmp/` tree.

Review must explicitly judge:

- CTA dominance
- hierarchy fidelity
- preservation of the reference essence
- premium framing
- remaining drift
- whether the corrected-state proof actually matches the claimed fix
- whether seam-sensitive drift was proved at the seam instead of only at the
  route level

Verdicts may include:

- `premium-aligned`
- `technically-correct-but-visually-weak`
- `drifted-from-reference`
- `card-soup`
- `not-closable`
