# Theme / Template Portability Gate

## Purpose

Use this gate when visual work claims that a product can change theme or
template through `global.css`, `globals.css`, Tailwind configuration, CSS
variables, or an equivalent visual configuration layer.

The gate prevents two false claims:

- a theme swap that only changes a reference CSS file while real components keep
  hardcoded visual values
- a template swap described as a simple token change even though shell,
  primitive, composite, or page anatomy must change

## Activation

Activate this gate when a request includes or implies:

- theme switching, theme generation, skinning, visual config, Tailwind config, or
  `global.css` / `globals.css` mutation
- applying `design-system.theme.css` or `design-system.premium-theme.css` to a
  real application
- changing a product template, dashboard template, marketing template, app shell,
  or broad visual language
- validating whether an existing stack can adopt a theme by replacing a single
  CSS/config layer

## Required Local Commands

When a governed local workspace is available, use:

- `onboarding/local-workspace/discover-visual-config.sh`
- `onboarding/local-workspace/check-theme-consumption.sh`
- `onboarding/local-workspace/check-componentization-discipline.sh`

The first command identifies visual authority files. The second command checks
whether real app surfaces consume the token API instead of bypassing it with
hardcoded visual decisions.

## Layer Classification

Every theme/template claim must classify the minimum honest owner layer:

| Layer | Meaning | Typical Owners |
| --- | --- | --- |
| `token-only` | Values change, component anatomy remains stable. | `global.css`, `globals.css`, `theme.css`, `tokens.css`, `design-system.theme.css` |
| `derived-token-wiring` | Utility/config aliases must point at token values. | `tailwind.config.*`, Tailwind v4 `@theme`, component library theme config |
| `primitive-token-wiring` | Existing primitives need to consume semantic tokens. | buttons, inputs, cards, dialogs, badges, focus rings |
| `primitive-anatomy` | Low-level component structure, state model, density, or interaction changes. | `components/ui/*` or equivalent |
| `composite-template` | Shared composed patterns change while primitives remain recognizable. | tables, forms, dashboard panels, nav groups, command surfaces |
| `shell-template` | Route frame, navigation, sidebar/header/footer, or layout zones change. | app shell, dashboard shell, auth shell, public shell |
| `page-local` | A genuinely isolated surface changes. | one page or feature-only consumer |
| `mixed` | Multiple layers are honestly required. | broad template or product-language change |

If the same visual decision repeats across two or more surfaces, prefer the
highest shared owner rather than page-local overrides.

## Theme Swap Standard

A theme swap can be claimed only when all are true:

- the token authority file is identified
- `design-system.theme.css` or `design-system.premium-theme.css` is applied or
  explicitly mapped into that authority
- the stable design-system interchange API is preserved in Accelerate artifacts,
  or explicitly mapped to the target app's local token API
- Tailwind or equivalent derived utilities point at the accepted token API when
  present
- shared primitives consume semantic tokens for core surfaces, borders, focus,
  typography, radius, shadow, and state colors
- the swap proof shows the same route/state before and after the theme change
- componentization audit shows real surfaces consume central owners rather than
  page-local class sprawl
- expected values change while component anatomy, data, and interaction state stay
  stable unless a deeper layer is declared

## Template Swap Standard

A template swap is deeper than a theme swap. It must name which anatomy changes:

- primitive anatomy
- composite composition
- shell/navigation/layout zones
- page-local content arrangement
- responsive behavior
- empty/loading/error/auth states

Do not close a template swap with only a CSS token diff unless the packet proves
that the requested template is token-only.

## Tailwind Standard

When Tailwind is present:

- identify whether the project uses Tailwind v3 config, Tailwind v4 CSS-first
  `@theme`, or both
- semantic colors, radii, shadows, fonts, and focus rings should derive from
  `--ds-*`, the accepted local token API, or documented aliases
- raw palette values belong in the token authority, not repeated across shared
  primitives or pages
- dark mode/theme selectors must support one active theme at a time
- arbitrary values in feature code are residual debt unless they are documented
  one-off exceptions

## Portability Packet

Use this packet before closure:

```text
Theme / Template Portability Packet
- target stack:
- visual config discovery artifact:
- token authority file:
- derived token config:
- Tailwind mode: none|v3|v4|mixed|unknown
- active theme selector/provider:
- source theme artifact:
- premium theme artifact:
- desired change class:
- minimum honest owner layer:
- files changed:
- files intentionally unchanged:
- token API preserved:
- aliases introduced:
- local runtime token API:
- token alias map:
- component anatomy preserved:
- template anatomy changed:
- hardcoded visual debt:
- theme consumption audit:
- swap proof packet:
- residual non-portable surfaces:
```

## Closure Blockers

Do not close if:

- the target visual config files were not discovered
- no token authority file is named for a theme claim
- `design-system.theme.css` or `design-system.premium-theme.css` is skipped when
  design-system artifacts are the authority
- the implementation renames or bypasses the design-system token API without an
  explicit alias contract
- Tailwind config or `@theme` duplicates raw values that should derive from
  tokens
- shared primitives keep hardcoded visual values while the branch claims portable
  theming
- a template-level request is closed as `token-only` without proof
- theme switching renders simultaneous light/dark product compositions instead of
  one active selector/provider
- componentization audit is missing or blocked
- runtime proof does not show the target route/state after the swap
- residual non-portable surfaces are hidden instead of listed
