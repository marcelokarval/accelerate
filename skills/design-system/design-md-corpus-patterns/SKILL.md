---
name: design-md-corpus-patterns
description: Use when selecting and applying repo-local curated DESIGN.md examples as premium design influence without replacing Accelerate design-system contracts or token artifacts.
related-skills: extract-html-design-system-v2, apply-design-system-contract, premium-design-benchmark-corpus
---
# DESIGN.md Corpus Patterns

Use this skill when a design-system, premium UI, de-AI, anti-template, or theme
generation run needs examples from the repo-local curated `DESIGN.md` corpus.

The corpus lives at:

- `references/design-md/`

## Core Rule

The corpus is reference material, not implementation authority by itself.

Do not skip:

- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.theme.css`
- canonical `--ds-*` token normalization
- `apply-design-system-contract` for implementation

## Workflow

1. Select examples from `references/design-md/index.md` based on product need.
2. Read each selected `DESIGN.md` and `metadata.md`.
3. State why each example applies.
4. Do not copy brand identity or trademarked product meaning.
5. Map influence to tokens, components, state rules, layout rules, motion rules,
   or forbidden patterns.
6. For premium/de-AI work, include the selected entries in the Benchmark
   Influence Map.
7. Translate local adoption into `design-system.contract.md` and
   `design-system.theme.css` with stable `--ds-*` tokens.
8. Keep source-observed, corpus-influenced, and premium-proposed rules separate.

## Selection Guidance

- Airbnb: warm consumer marketplace, photography-first cards, booking/search.
- Stripe: fintech/SaaS precision, light typography, purple accents, shadows.
- Linear: dark-native SaaS, dense app shells, command/search, subtle borders.
- Vercel: developer platform minimalism, Geist-like type, shadow-as-border.
- Notion: warm productivity/editorial surfaces and whisper borders.

## Output Requirement

Every corpus-assisted run should leave a short packet:

```text
DESIGN.md Corpus Influence Packet
- selected slugs:
- product need:
- useful patterns:
- rejected patterns:
- token consequences:
- component consequences:
- layout/state/motion consequences:
- brand-cloning guardrail:
- mapped artifacts:
  - design-system.contract.md:
  - design-system.theme.css:
```

## Closure Blockers

Do not close if:

- no selected examples are named
- influence remains moodboard prose
- implementation uses raw brand token names instead of `--ds-*`
- the corpus bypasses local design-system artifacts
- the output copies brand identity instead of adapting product-specific lessons
