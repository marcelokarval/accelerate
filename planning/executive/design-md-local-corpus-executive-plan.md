# DESIGN.md Local Corpus Executive Plan

## Purpose

Add a repo-local, curated `DESIGN.md` corpus to Accelerate so design-system
extraction, premium direction, anti-template review, and application workflows
can draw from real premium examples without depending on live external fetches
or user-home catalogs.

This does not replace Accelerate's current artifact stack:

- `docs/reference/design-system.html`
- `docs/reference/design-system.contract.md`
- `docs/reference/design-system.theme.css`
- premium direction artifacts when in scope

Instead, the corpus becomes local source material and benchmark influence input.

## Source Correction

The user clarified that the goal is not to adopt one project-root `DESIGN.md` as
the sole design-system authority. The goal is to incorporate many curated
`DESIGN.md` examples into Accelerate's body, organized by brand/style, so the
platform has richer local examples.

## Selected Approach

Create a local corpus under `references/design-md/` with:

- one directory per design slug
- a raw curated `DESIGN.md` file per seed
- per-seed provenance metadata
- a corpus index and governance README
- a core review doctrine surface for corpus use
- a design-system skill that governs selection and influence mapping
- tests that prove the corpus cannot bypass the existing design-system stack

## Corpus Scope

The initial one-shot seeded a small representative corpus. The follow-up user
request expanded the corpus to every public `getdesign.md` entry visible on
`2026-04-26`.

Initial seed set:

- Airbnb: warm marketplace, photography, rounded consumer UI
- Stripe: fintech/payment infrastructure, gradients, precision SaaS
- Linear: product-management SaaS, minimal precision, dark/purple accent
- Vercel: developer platform, monochrome precision, Geist-like minimalism
- Notion: productivity, warm minimalism, editorial surfaces

Expanded corpus:

- Total entries: `69`
- Source: public `getdesign.md` catalog observed on `2026-04-26`
- Import helper: `scripts/import-design-md-corpus.sh`
- Coverage proof: `tests/design-md-corpus-integrity.sh` requires at least 69
  entries, per-entry `DESIGN.md`, per-entry metadata, index coverage, and the
  corpus total anchor.

## Non-Goals

- Do not treat the external collection as authority before local import,
  provenance metadata, tests, and side-by-side review.
- Do not make external brand identity an implementation authority.
- Do not replace `design-system.contract.md` or `design-system.theme.css`.
- Do not run `npx getdesign` as an uncontrolled install path when direct bounded
  fetch is enough.
- Do not use the corpus to justify trademark-confusing product UI.

## Required Artifacts

- `references/design-md/README.md`
- `references/design-md/index.md`
- `references/design-md/<slug>/DESIGN.md`
- `references/design-md/<slug>/metadata.md`
- `scripts/import-design-md-corpus.sh`
- `core/review/design-md-corpus.md`
- `skills/design-system/design-md-corpus-patterns/SKILL.md`
- manifest registration for the new skill
- tests:
  - `tests/design-md-corpus-integrity.sh`
  - `tests/design-md-corpus-semantic.sh`

## Proof Plan

1. Add failing corpus tests first.
2. Add corpus structure and seeded `DESIGN.md` files.
3. Wire governance into core review and design-system docs.
4. Register the skill in the local manifest.
5. Run corpus tests, doctrine tests, registry validation, and whitespace checks.
6. Record side-by-side task review and final forensic reconciliation.

## Closure Criteria

Closure requires:

- corpus files exist and include real DESIGN.md content for all 69 entries
- each entry has provenance metadata and disclaimer
- corpus README states source/reference role and no brand-copy authority
- design-system extraction/application docs mention corpus use without bypassing
  current artifacts
- tests enforce that corpus use still requires `design-system.contract.md`,
  `design-system.theme.css`, `--ds-*`, source observation/provenance, and
  Benchmark Influence Map discipline when premium is in scope
- all validation commands pass

## Residual Risks

- The full public catalog may change after the import date and requires a future
  refresh pass to add new public entries.
- External DESIGN.md quality varies and may contain inferred details.
- Legal/trademark posture requires careful wording and product-specific
  adaptation before use.
