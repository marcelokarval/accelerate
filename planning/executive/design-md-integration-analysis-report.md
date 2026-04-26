# DESIGN.md Integration Analysis Report

## Purpose

Analyze the `DESIGN.md` ecosystem around `awesome-design-md` and `getdesign.md`
and compare it with Accelerate's current design-system extraction and
application stack.

This report is read-only analysis. It does not promote the external source to
governing authority yet.

## Source Observation Packet

| Field | Value |
| --- | --- |
| Observation date | 2026-04-26 |
| Source class | public benchmark/reference; user-provided URLs |
| Sources observed | `https://github.com/VoltAgent/awesome-design-md`, `https://getdesign.md/`, `https://getdesign.md/airbnb/design-md`, `https://getdesign.md/design-md/airbnb/DESIGN.md`, `https://getdesign.md/design-md/airbnb/preview.html`, `https://getdesign.md/about` |
| Allowlist decision | bounded allowlist for `github.com`, `raw.githubusercontent.com`, `getdesign.md`, `stitch.withgoogle.com` docs URLs |
| Fetch mode | `webfetch` markdown/html, GitHub contents API, `npm view`, `npx getdesign --help` |
| Raw storage | none; observations summarized here |
| Downstream use | evaluate whether and how DESIGN.md should be adapted into local Accelerate doctrine |
| Trust limits | third-party curated source, not official brand design systems; content is inspiration/reference, not ownership-safe product identity authority |

## What Was Found

### 1. Market Naming

`DESIGN.md` is presented as a plain markdown design-system file for AI agents.
The `awesome-design-md` README describes it as parallel to `AGENTS.md`:

| File | Claimed Reader | Claimed Purpose |
| --- | --- | --- |
| `AGENTS.md` | coding agents | how to build the project |
| `DESIGN.md` | design agents | how the project should look and feel |

The README attributes the concept to Google Stitch and frames it as a format AI
coding/design agents can consume without Figma exports, JSON schemas, or special
tooling.

### 2. Repository And Website Shape

`VoltAgent/awesome-design-md` is a curated public collection. Observed signals:

- GitHub stars shown by GitHub page: about `65.9k`
- README badge count: `69` DESIGN.md files
- website quick stats: `69` DESIGN.md files, last updated Apr 26, 2026
- license: MIT for the collection
- repo directories under `design-md/<slug>/` now mostly point to `getdesign.md`
  rather than storing the full markdown in GitHub

The GitHub path `design-md/airbnb/README.md` contains only:

```text
# Airbnb Inspired Design System

Design system details have been moved to: https://getdesign.md/airbnb/design-md
```

### 3. Download / Installation Mechanism

The site page for Airbnb shows:

```text
npx getdesign@latest add airbnb
```

`npm view getdesign` reports:

```json
{
  "version": "0.6.8",
  "bin": { "getdesign": "bin/cli.mjs" },
  "description": "CLI for installing DESIGN.md templates into projects",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/VoltAgent/awesome-design-md.git",
    "directory": "cli"
  }
}
```

`npx getdesign@latest --help` reports:

```text
getdesign CLI

Usage:
  getdesign add <brand> [--force] [--out <path>]
  getdesign list

Examples:
  npx getdesign add airbnb          # first add -> ./DESIGN.md
  npx getdesign add stripe          # already exists -> ./stripe/DESIGN.md
  npx getdesign add ibm --force     # overwrite active DESIGN.md
  npx getdesign add ibm --out ./docs/DESIGN.md
```

This means Accelerate can ingest through at least two practical channels:

- direct URL fetch: `https://getdesign.md/design-md/<slug>/DESIGN.md`
- CLI install: `npx getdesign@latest add <slug> --out <path>`

The direct raw-style endpoint was verified for Airbnb:

- `https://getdesign.md/design-md/airbnb/DESIGN.md`

The visual preview endpoint was also verified:

- `https://getdesign.md/design-md/airbnb/preview.html`

### 4. Example Airbnb Content Shape

The Airbnb `DESIGN.md` includes these sections:

- `Visual Theme & Atmosphere`
- `Color Palette & Roles`
- `Typography Rules`
- `Component Stylings`
- `Layout Principles`
- `Depth & Elevation`
- `Do's and Don'ts`
- `Responsive Behavior`
- `Agent Prompt Guide`

The Airbnb preview page includes visual sections for:

- palette
- type
- buttons
- booking
- responsive
- search bar
- listing cards
- booking panel
- guest favorite lockup
- amenity/review rows
- forms
- spacing
- radius
- elevation

This is materially useful for Accelerate because it is not only a prose moodboard;
it carries tokens, components, state rules, layout rules, responsive rules, and
agent prompt examples.

## Current Accelerate Design-System Stack

Accelerate currently uses a stronger local artifact set:

| Accelerate Artifact | Role |
| --- | --- |
| `docs/reference/design-system.html` | source-truth visual showcase, built from captured HTML/source evidence |
| `docs/reference/design-system.contract.md` | strict implementation rulebook |
| `docs/reference/design-system.theme.css` | canonical `--ds-*` implementation token layer |
| `docs/reference/design-system.slop-audit.md` | premium/de-AI baseline diagnosis |
| `docs/reference/design-system.premium-direction.md` | directional premium contract |
| `docs/reference/design-system.premium-direction.html` | visual proof of premium direction |
| `docs/reference/design-system.premium-theme.css` | premium token layer preserving `--ds-*` names |

Governing local surfaces:

- `core/review/html-design-system-extraction.md`
- `core/review/design-system-contract-application.md`
- `core/control-plane/design-implementation-proof-gate.md`
- `skills/design-system/extract-html-design-system-v2/SKILL.md`
- `skills/design-system/apply-design-system-contract/SKILL.md`
- `skills/design-system/premium-design-benchmark-corpus/`

Current local rules are stricter than DESIGN.md:

- external references must be captured under `.tmp/`
- source evidence must be traceable
- token API must normalize to stable `--ds-*` names
- HTML, markdown contract, and CSS token layer must not disagree
- premium direction cannot overwrite source truth
- implementation must use `apply-design-system-contract` after extraction

## Side-By-Side Comparison

| Concern | DESIGN.md / getdesign.md | Accelerate Today | Integration Judgment |
| --- | --- | --- | --- |
| Market term | `DESIGN.md` | `design-system.contract.md` plus HTML/CSS artifacts | Adopt term as an import/source format, not as the only artifact. |
| Primary consumer | AI design/coding agents | Accelerate-governed agents and implementation workflows | Compatible if wrapped in local gates. |
| Format | single markdown file, optional preview HTML | multi-artifact package: HTML + contract + theme CSS + premium package | Accelerate is stronger for implementation safety. |
| Token API | brand/raw token names and hex roles | stable canonical `--ds-*` token API | Need a translation step from raw DESIGN.md tokens to `--ds-*`. |
| Evidence trail | curated/inspired extraction, not official | source capture and source evidence required | Treat getdesign content as secondary reference unless captured/verified. |
| Download | `npx getdesign add <brand>` or direct endpoint | no native DESIGN.md import adapter yet | Add an adapter/skill slice. |
| Preview | `preview.html` visual catalog | `design-system.html` visual source-truth showcase | Preview can seed or compare, but should not replace local showcase. |
| Legal posture | not official, inspiration, trademarks owned by others | local caution against external sources as authority | Must preserve disclaimers and avoid brand cloning claims. |
| Premium corpus role | broad external collection | repo-local premium corpus required for governed premium decisions | Can become observed benchmark corpus input only after local adaptation. |

## Key Integration Problem

The market is converging around `DESIGN.md` as an agent-readable design contract,
but Accelerate already separates design-system authority into three safer layers:

1. visual source truth: `design-system.html`
2. implementation law: `design-system.contract.md`
3. token implementation API: `design-system.theme.css`

Directly replacing this with a root `DESIGN.md` would weaken the current system.
However, ignoring `DESIGN.md` would miss useful market vocabulary and a large
source corpus.

The correct integration is therefore:

```text
external DESIGN.md
  -> source observation packet
  -> DESIGN.md import/normalization
  -> local design-system.contract.md
  -> local design-system.theme.css with --ds-* tokens
  -> optional design-system.html / preview evidence
  -> apply-design-system-contract
```

## Recommended Accelerate Standard

### Naming

Add `DESIGN.md` as a recognized external/source format and optional project-root
agent convenience file.

Do not make it the only governed internal artifact.

Recommended local terminology:

| Name | Meaning |
| --- | --- |
| `DESIGN.md` | market-compatible agent-facing design brief or imported source file |
| `design-system.contract.md` | Accelerate implementation law derived from evidence |
| `design-system.theme.css` | Accelerate token API used by code |
| `design-system.html` | visual evidence/showcase |

### Import Locations

Recommended import targets:

- `.tmp/design-md/<slug>/DESIGN.md` for raw third-party imports
- `.tmp/design-md/<slug>/preview.html` for preview capture
- `docs/reference/DESIGN.md` only after the import is approved as a durable
  reference in the project
- never overwrite root `DESIGN.md` in a target app without explicit user approval

### Adapter Shape

Add a small local workflow later, not now:

- `skills/design-system/design-md-import-patterns/`
- `adapters/runtime/design-md/README.md`
- `core/review/design-md-import.md`
- optional test: `tests/design-md-import-integrity.sh`

The adapter should support:

- allowlisted direct fetch from `https://getdesign.md/design-md/<slug>/DESIGN.md`
- optional CLI intake through `npx getdesign@latest add <slug> --out <path>`
- preview capture from `https://getdesign.md/design-md/<slug>/preview.html`
- provenance packet with source URL, timestamp, slug, license/disclaimer, and
  trust limits
- conversion checklist into local `design-system.contract.md` and `--ds-*`
  tokens

## Suggested Workflow

For a future run that imports `airbnb`:

1. Open `Source Observer Gate` and `External Skill Vetting Gate`.
2. Fetch:
   - `https://getdesign.md/design-md/airbnb/DESIGN.md`
   - `https://getdesign.md/design-md/airbnb/preview.html`
3. Store raw captures under `.tmp/design-md/airbnb/`.
4. Record source packet:
   - source URLs
   - timestamp
   - source class
   - license/disclaimer
   - trust limits
5. Normalize tokens into `--ds-*` names.
6. Generate or update:
   - `docs/reference/design-system.contract.md`
   - `docs/reference/design-system.theme.css`
   - `docs/reference/design-system.html` if preview/source evidence is sufficient
7. Run:
   - `onboarding/local-workspace/check-design-system-artifact-consistency.sh`
8. Only then allow `apply-design-system-contract` to mutate UI.

## Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Brand cloning / trademark confusion | Product may look like an official Airbnb/Stripe/etc. UI | Preserve disclaimers; classify as inspiration/reference; require product-specific adaptation. |
| Treating curated markdown as source truth | Inherited mistakes or hallucinated details can become local law | Use source observer packet, preview evidence, and local extraction/consistency gates. |
| Token vocabulary drift | Agents may implement raw `Rausch`, `Ink Black`, etc. directly | Map to `--ds-*` API with raw names as aliases only. |
| Overwriting local `DESIGN.md` | Existing project design truth could be replaced accidentally | Import to `.tmp/` first; require explicit approval for root/project durable placement. |
| CLI supply-chain risk | `npx getdesign` executes package code | Prefer direct URL fetch for read-only intake; use CLI only after dependency governance. |
| Weak preview capture | Site preview may omit interactive states | Treat preview as helpful evidence, not complete component inventory. |
| Conflict with local premium corpus rule | External corpus could bypass repo-local benchmark governance | Use getdesign as observed source material; promote/adapt into local corpus before governing premium decisions. |

## Recommended Next Work

1. Add a `design-md-import` protocol to core review.
2. Add a design-system skill for `DESIGN.md` import/normalization.
3. Add a runtime adapter note for direct URL vs CLI import.
4. Extend design-system extraction docs to recognize `DESIGN.md` as an input
   source alongside URL/local HTML/raw HTML.
5. Add tests that prevent imported `DESIGN.md` from bypassing
   `design-system.theme.css` and `--ds-*` token normalization.
6. Optionally seed a local benchmark/reference index from selected getdesign
   entries after explicit approval and provenance packets.

## Orchestrator Judgment

`DESIGN.md` should be added to Accelerate as a market-compatible source and
import format. It should not replace the current Accelerate artifact package.

The external `awesome-design-md` corpus is useful because it provides many
already-curated brand-inspired design contracts and visual previews. But it is a
third-party inspiration corpus, not official brand truth and not local authority.

The best integration is to add a governed import/normalization lane:

```text
getdesign DESIGN.md / preview.html
  -> bounded source observation
  -> local capture under .tmp/
  -> normalize to design-system.contract.md
  -> emit design-system.theme.css with --ds-* tokens
  -> optional design-system.html showcase
  -> apply-design-system-contract for implementation
```

That lets Accelerate speak the market's `DESIGN.md` language while preserving the
stronger local guarantees that prevent moodboard drift, token drift, and unsafe
brand-copy implementation.
