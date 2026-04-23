# UI Mutation Ladder

## Purpose

Make broad UI mutation follow the correct ownership order instead of starting
from page-local markup or ad hoc premium polish.

This ladder is the default convergence order for:

- design-system application
- premium recomposition
- visual modernization
- broad frontend refactor
- new UI foundation work in a governed stack

## Ladder

Use this default order unless the run leaves an explicit bounded exception:

1. semantic tokens / theme authority
   - `globals.css`
   - canonical token source
   - light/dark sibling semantics
2. derived token wiring
   - `tailwind.config.*`
   - aliases, utility wiring, semantic scales
3. shared primitives
   - `components/ui/*`
   - low-level anatomy, states, density, interaction
4. shared composites
   - `components/ui-enhanced/*` or equivalent
   - canonical wrappers, compounds, structural reuse
5. design-system registry / examples / reference package
   - internal registry
   - `docs/reference/design-system*`
   - example surfaces and coverage maps
6. layouts and shells
   - auth shell
   - dashboard shell
   - onboarding shell
   - profile / account shell
   - public split / special shells
7. page and feature consumers
   - route-level pages
   - feature-local surfaces

## Default Rule

When the requested change affects multiple screens, repeated UI patterns, or
the perceived product language, do not start at step 7.

First decide whether the change belongs to:

- token authority
- primitive anatomy
- composite authority
- shell composition
- page-local exception

If the same visual change would otherwise be repeated in two or more surfaces,
the run should attempt the higher shared owner first.

## Bounded Exceptions

A lower-level consumer-first mutation is acceptable only when one of these is
explicitly true:

- the target is a truly local one-off surface
- the run is proving a spike before shared promotion
- the shared owner is known and deliberately out of scope for this slice
- the user requested a narrow page-only change and accepted the local scope

When taking this exception, record it in the packet as:

- `single-surface exception`
- `shared-owner deferred`
- `token-only`
- `shell-only`

## Premium Rule

Premium work must not be treated as page decoration.

When a surface is being premiumized:

- first classify whether the gain is token-level, primitive-level,
  composite-level, shell-level, or page-level
- do not claim premium convergence if the result still depends on repeated
  page-local overrides that should have been absorbed by shared authorities
- dark mode must move with the same authority layer as light mode unless the
  surface is explicitly forced to light

## New-System Rule

For creation from zero, prefer this build order:

1. tokens
2. typography and semantic scales
3. primitives
4. composites
5. shell
6. first page
7. dark parity
8. registry/examples/reference package

Do not let greenfield UI start as raw page markup when the intended system is
shared and durable.

## Closure Blockers

Do not close a broad UI or premium run if:

- page-local changes were used where the shared owner was the honest target
- token changes and anatomy changes were mixed without explanation
- shell composition changed before shared primitives/composites were stabilized
- dark mode was updated as a disconnected skin
- the design-system package was updated but shared runtime owners were not
- a broad visual request was satisfied only by page-level polish
