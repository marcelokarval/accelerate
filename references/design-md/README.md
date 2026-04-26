# DESIGN.md Corpus

## Purpose

This directory is the repo-local curated `DESIGN.md` corpus for Accelerate.

It contains real, agent-readable design-system examples imported from public
reference sources such as `getdesign.md` and reviewed into this repository as
local source material.

The corpus increases Accelerate's design capacity by giving extraction,
premium-direction, anti-template review, and design-system application workflows
concrete examples of premium visual languages.

## Authority Boundary

The corpus is reference material. It is not implementation authority by itself.

Do not use a corpus `DESIGN.md` file to bypass:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.theme.css`
- premium artifacts when premium work is active
- `apply-design-system-contract`

Each corpus entry is inspired by publicly visible design patterns. It is not an
official brand design system and must not be used for brand cloning or trademark
confusing product UI.

## Structure

Each entry uses:

```text
references/design-md/<slug>/
├── DESIGN.md
└── metadata.md
```

`DESIGN.md` contains the imported design reference.

`metadata.md` records provenance, source URL, fetch date, source class, trust
limits, and recommended use.

## Current Seeds

See `index.md` for the active seed list and tags.

## Use In Accelerate

Use this corpus to:

- choose design influence examples for Benchmark Influence Maps
- compare a local extraction against concrete premium patterns
- identify token, typography, surface, spacing, motion, and component lessons
- guide premium direction without depending on live web fetches

Do not copy brand identity directly. Convert influence into local product
semantics, canonical `--ds-*` tokens, and project-specific component rules.

## Expansion Rule

Add new entries only with:

- raw `DESIGN.md` content
- metadata with source URL and fetch date
- category/style tags in `index.md`
- explicit disclaimer that the design is not official
- test coverage through `tests/design-md-corpus-integrity.sh`
