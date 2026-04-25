---
name: premium-design-benchmark-corpus
description: Repo-local Accelerate corpus for anti-AI-template premium UI judgment, benchmark selection, and influence mapping without depending on external user-home skills.
---
# Premium Design Benchmark Corpus

Use this skill when premium, humanized, de-AI, less-template, executive,
financial, dashboard, landing-page, or product-critical UI work needs benchmark
judgment.

This is an Accelerate-native corpus. Do not load `popular-web-designs` or any
other user-home skill as the governing source. External libraries may inspire a
future import, but once a benchmark is required by Accelerate it must live under
this repository.

## Operating Rule

Premium design work must borrow principles, not identities.

Allowed:

- use benchmarks to name concrete qualities: density, materiality, typography,
  restraint, data hierarchy, trust cues, interaction polish
- translate those qualities into `--ds-*` tokens, component recipes, and product
  anatomy constraints
- cite which benchmark influenced which decision

Forbidden:

- copying a brand identity, exact palette, logo treatment, or marketing voice
- using benchmarks as moodboard names without implementation consequences
- shipping generic violet SaaS gradients, raw framework defaults, card soup, or
  fake metrics while claiming premium influence

## Required Artifact

When premium or de-AI work is in scope, the premium direction markdown must
include:

```markdown
## Benchmark Influence Map

| Benchmark | Relevant Quality | Adopted Principle | Token/Component Impact | Non-Copy Boundary |
| --- | --- | --- | --- | --- |
| Linear | crisp hierarchy | quieter chrome around dense work | `--ds-surface`, table rows | no Linear purple clone |
```

Minimum rows:

- 2 benchmarks for narrow UI correction
- 3 benchmarks for a product screen or dashboard
- 4 benchmarks for a broad design-system or theme-generator direction

Each row must name a real token, component family, layout rule, state rule, or
forbidden pattern changed by the benchmark.

## Benchmark Families

Use these local benchmark families before creating new ones.

| Family | Use When | Strong Benchmarks | Qualities To Borrow |
| --- | --- | --- | --- |
| Developer precision | developer tools, admin shells, workflow products | Linear, Vercel, Raycast, Resend | restrained chrome, crisp spacing, fast scanning, command-first interaction |
| Data-dense operations | dashboards, observability, analytics, finance tables | Sentry, Kraken, ClickHouse, Cohere | dense hierarchy, status grammar, table legibility, signal separation |
| Fintech trust | banking, ledgers, billing, pricing, crypto/finance | Wise, Revolut, Coinbase, Kraken | trust cues, monetary hierarchy, regulatory calm, balance between clarity and energy |
| Premium consumer | executive landing pages, brand-heavy product surfaces | Apple, BMW, Airbnb, Superhuman | materiality, white space, editorial hierarchy, tactile controls |
| Editorial productivity | docs, knowledge bases, content tools | Notion, Mintlify, Sanity, Intercom | readable surfaces, low-friction composition, friendly affordances |
| Technical infrastructure | infra/cloud/API surfaces | Stripe, HashiCorp, MongoDB, Supabase | technical credibility, code/data pairing, structured explanation |
| Creative/product-led | design, collaboration, visual creation | Figma, Framer, Webflow, Miro | motion intent, visual rhythm, canvas metaphors, playful restraint |

## Anti-Template Smell Matrix

Score every premium candidate from `0` to `3` for each signal.

| Signal | 0 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- |
| Violet SaaS bias | absent | minor accent only | dominant palette | identity depends on it |
| Raw framework leakage | none | isolated primitive | repeated default surfaces | system is visibly stock |
| Card soup | clear hierarchy | some repeated cards | panels blur together | screen is only cards |
| Fake data theater | realistic | slightly generic | obvious placeholder metrics | impossible/fake product truth |
| Typography blandness | distinctive | competent | generic Inter-only | no hierarchy/personality |
| Material flatness | intentional | mild | low-depth sameness | no premium surface logic |
| Layout memorability | specific | familiar but useful | interchangeable | template clone |
| State poverty | broad states | common states | few states | static mockup only |

Closure fails when:

- any signal scores `3` without a documented correction
- total score is above `10` for premium direction
- the benchmark influence map does not reduce named smells
- the implementation does not reflect the benchmark-token/component impacts

## Fintech/Dashboard Default Set

For finance, accounting, ledgers, billing, portfolio, analytics, or risk
dashboards, start from this set unless the product context says otherwise:

- Wise: clarity, approachable trust, monetary legibility
- Revolut: modern financial energy and polished app surfaces
- Sentry: dense operational signal and issue/status hierarchy
- Kraken: market/data density and dark-mode discipline
- Linear: navigation restraint and crisp interaction grammar

Pick 3-4, not all five by default. Explain exclusions.

## Output Contract

The corpus is satisfied only when the resulting design-system package contains:

- `design-system.slop-audit.md` with scored smells and concrete evidence
- `design-system.premium-direction.md` with `## Benchmark Influence Map`
- `design-system.premium-theme.css` preserving the same `--ds-*` token API as
  `design-system.theme.css`
- product markup that proves one active theme at a time, not simultaneous
  light/dark product compositions
