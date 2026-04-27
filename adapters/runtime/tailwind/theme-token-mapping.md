# Tailwind Theme Token Mapping

## Purpose

Use this adapter note when a project uses Tailwind and a design-system package or
theme generator expects portable visual changes through CSS variables.

Tailwind is a derived-token layer. It must not become a competing source of
truth when `design-system.theme.css` or `design-system.premium-theme.css` exists.

`--ds-*` is the Accelerate artifact interchange namespace. A target app may keep
a mature runtime token API, such as shadcn's `--background`, `--primary`, and
`--border`, when a Token Alias Map explicitly connects that API to the
design-system contract.

## Tailwind v3 Pattern

Tailwind v3 projects usually map semantic utilities in `tailwind.config.*`:

```js
theme: {
  extend: {
    colors: {
      background: 'var(--ds-bg)',
      foreground: 'var(--ds-fg)',
      surface: 'var(--ds-surface)',
      border: 'var(--ds-border)',
      primary: 'var(--ds-primary)',
      'primary-foreground': 'var(--ds-primary-fg)',
    },
    borderRadius: {
      sm: 'var(--ds-radius-sm)',
      md: 'var(--ds-radius-md)',
      lg: 'var(--ds-radius-lg)',
    },
    fontFamily: {
      sans: 'var(--ds-font-sans)',
      mono: 'var(--ds-font-mono)',
    },
  },
}
```

For shadcn-style projects, this equivalent local-token mapping is acceptable
when recorded as the app's runtime token API:

```js
colors: {
  background: 'hsl(var(--background))',
  foreground: 'hsl(var(--foreground))',
  primary: {
    DEFAULT: 'hsl(var(--primary))',
    foreground: 'hsl(var(--primary-foreground))',
  },
  border: 'hsl(var(--border))',
}
```

## Tailwind v4 Pattern

Tailwind v4 projects usually map semantic utilities in CSS with `@theme`:

```css
@theme {
  --color-background: var(--ds-bg);
  --color-foreground: var(--ds-fg);
  --color-surface: var(--ds-surface);
  --color-border: var(--ds-border);
  --color-primary: var(--ds-primary);
  --color-primary-foreground: var(--ds-primary-fg);
  --radius-sm: var(--ds-radius-sm);
  --radius-md: var(--ds-radius-md);
  --radius-lg: var(--ds-radius-lg);
  --font-sans: var(--ds-font-sans);
  --font-mono: var(--ds-font-mono);
}
```

## Rules

- Raw palette values belong in the token authority file, not repeated in Tailwind
  config or shared components.
- Tailwind semantic utilities should derive from `--ds-*` or documented aliases.
- Tailwind semantic utilities should derive from `--ds-*`, the accepted local
  token API, or documented aliases.
- `darkMode`, `[data-theme]`, or provider-based switching must preserve one
  active theme at a time.
- Arbitrary visual values in feature code are residual debt unless the Theme /
  Template Portability Packet records a bounded exception.
- If a template swap changes anatomy, Tailwind mapping is necessary but not
  sufficient; use `template-swap-proof-packet.md`.
