# Deep Componentization Audit Gate

## Purpose

Use this gate when componentization quality must be proven rather than sampled.

The fast `Componentization Enforcement Gate` blocks obvious page-local sprawl.
This deep gate produces a page-by-page and code-layer report so reviewers can see
exactly where `.tsx` and `.ts` files violate the product's componentization and
clean-code standards.

## Required Analysis

The audit must cover:

- every page-like `.tsx` file
- reusable component `.tsx` files
- non-visual `.ts` modules
- clear separation between visual `.tsx` and non-visual `.ts` ownership
- duplicated or repeated page patterns that should become central components
- `className` density and direct class usage
- `div` soup / inline JSX structure
- component imports and central component reuse
- `.ts` responsibility boundaries, reuse, duplicate helpers, and market-standard
  clean-code posture

## Required Artifacts

When a governed workspace is available, run:

- `onboarding/local-workspace/run-deep-componentization-audit.sh`

The command writes:

- `.accelerate/review/componentization/pages/<slug>.md`
- `.accelerate/review/componentization/components-report.md`
- `.accelerate/review/componentization/typescript-report.md`
- `.accelerate/review/componentization/executive-summary.md`

## Report Standard

Each page report must include:

- file path
- counts for `div`, `className`, long class strings, direct visual classes, and
  imported central components
- layer judgment: `healthy`, `watch`, or `refactor-candidate`
- concrete extraction candidates
- whether the page should stay page-local or move logic/UI to central owners

The condensed executive summary must include:

- total pages scanned
- total components scanned
- total `.ts` modules scanned
- highest-risk pages
- recurring componentization defects
- suggested central components / primitives / enhanced composites
- `.ts` cleanup recommendations
- links to the page/component/TypeScript reports
- an explicit “report -> executive plan” section with prioritized next actions

## `.tsx` Rules

- Pages compose. Components own reusable anatomy.
- High `className` density in pages indicates missing variants or components.
- Repeated structural blocks across pages should move to shared components.
- Direct visual classes in consumers are allowed only for narrow layout glue or
  recorded exceptions.
- Broad product UI should flow through foundation, primitives, second-layer
  primitives, enhanced composites, shared product components, and shells before
  page consumers.

## `.ts` Rules

- `.ts` files should own pure logic, contracts, parsing, formatting, adapters,
  constants, and reusable utilities.
- `.ts` files should not become mixed responsibility bags.
- Duplicate helper names, repeated literal-heavy maps, and generic `utils` growth
  are refactor candidates.
- UI class strings and JSX-like visual decisions do not belong in `.ts` unless
  they are explicit variant/config modules.
- Logic reused by two or more pages belongs in shared `.ts` modules with clear
  names and tests when behavior is non-trivial.

## Closure Blockers

Do not claim extreme componentization if:

- the deep audit was not run
- page reports are missing
- the executive summary is missing
- high-risk pages are found but not acknowledged in the response
- `.ts` duplication/responsibility findings are omitted
- recommendations are vague instead of mapped to central component or module
  owners
