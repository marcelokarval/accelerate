# DESIGN.md Corpus

## Purpose

The DESIGN.md corpus is a repo-local curated corpus of real design-system
examples stored under `references/design-md/`.

It exists to give Accelerate extraction, premium direction, anti-template review,
and design-system application workflows richer examples than generic prose or
one-off moodboards.

## Authority Boundary

The corpus is not implementation authority by itself.

It must not replace:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.theme.css`
- premium artifacts when premium work is active
- browser/runtime proof for mutated UI

Corpus entries influence local work only after the active run maps their lessons
into project-specific tokens, component rules, layout rules, state rules, or
forbidden patterns.

## Activation

Use this corpus when work involves:

- premium direction
- de-AI or anti-template review
- design-system extraction quality judgment
- theme generation
- product-specific visual recomposition
- Benchmark Influence Map creation

Pair with `Source Observer` discipline when importing new external entries. Once
an entry is local and indexed, use the local corpus first instead of live fetch.

## Required Use Rules

When using the corpus:

1. Select examples by product need, not brand fame.
2. Name the selected slugs and why each applies.
3. Do not copy brand identity directly.
4. Map influence to tokens, components, states, layout, motion, or forbidden
   patterns.
5. Normalize implementation tokens into the local `--ds-*` API.
6. Keep `design-system.contract.md` as implementation law.
7. Keep `design-system.theme.css` as token authority.
8. Include a `Benchmark Influence Map` when premium or de-AI work is active.
9. Preserve provenance and disclaimers from each entry.

## Closure Blockers

Do not close a corpus-driven design-system run if:

- a corpus DESIGN.md is treated as direct implementation law
- selected examples are not named
- influence is not mapped to concrete local consequences
- `--ds-*` token normalization is skipped
- `design-system.contract.md` or `design-system.theme.css` is bypassed
- brand cloning or trademark-confusing UI is encouraged
- imported entries lack provenance metadata

## Current Local Corpus

The index is:

- `../../references/design-md/index.md`

The initial curated seeds are:

- Airbnb
- Stripe
- Linear
- Vercel
- Notion
