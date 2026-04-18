# Premium Interface Production

## Local Authority Status

Primary local authority lives in:

- `../core/review/premium-interface-production.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when the page is not only user-facing and critical, but also a
premium product surface where perceived quality is part of the outcome.

Typical examples:

- premium billing recovery
- high-value onboarding checkpoints
- pricing, checkout, and subscription surfaces
- conversion-critical dashboards and upgrade flows
- any screen where premium interface quality is a competitive differentiator

## Premium Surface Branch

Treat this as a stricter subset of `Product-Critical Surface` work.

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

When a reference image, Stitch output, or Figma frame exists, follow this
sequence:

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
   - create a rich ASCII artifact of the Prop4You-adapted proposal
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

This packet is part of the execution truth, not optional decoration.

## Artifact Sufficiency Check

Premium work fails when the artifacts are present but too shallow to control the
implementation.

At minimum, verify:

- `Reference ASCII` shows spans, dominance, and reading order rather than only
  block names
- `Target ASCII` makes the Prop4You adaptation explicit instead of vaguely
  paraphrasing the source
- `Hierarchy Map` names what is primary, secondary, and tertiary
- `CTA Map` names the dominant CTA and why it wins
- `Design-System Mapping` shows how the composition will be translated into the
  real primitives, compounds, and tokens without flattening the reference
- `Preserved / Adapted / Discarded` is explicit enough to review side by side

If the packet still allows multiple materially different screens to be built
from the same artifact set, it is not sufficient yet.

## Premium UI Gate

Do not pass the gate unless the answer is strong for all of these:

- does the screen have a dominant visual center?
- is there a clearly dominant CTA?
- does the page read as one narrative, not a pile of fragments?
- are secondary actions truly secondary?
- does the page feel like part of the product?
- does the design system support the composition rather than flatten it?
- does the result preserve the essence of the reference?

## Design System Rule

Design-system adherence is necessary but not sufficient.

The workflow must distinguish:

- using the correct primitives, compounds, and tokens
- from actually landing a premium interface

Do not confuse component correctness with premium visual direction.

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

## Premium Interface Reconciliation

Final review for premium surfaces must compare side by side:

- source reference
- target ASCII / approved composition
- delivered implementation

Review must explicitly judge:

- CTA dominance
- hierarchy fidelity
- preservation of the reference essence
- premium framing
- remaining drift

Verdicts may include:

- `premium-aligned`
- `technically-correct-but-visually-weak`
- `drifted-from-reference`
- `card-soup`
- `not-closable`
