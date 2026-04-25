# Locale Pack Parity Runtime Adapter

This adapter defines how a target project should prove locale-pack parity.

It does not prescribe a universal i18n library. It maps the capability of
locale-pack validation to project-native commands, scripts, or manual evidence.

## Capability Inventory

The adapter should support:

- discovering locale roots
- listing supported locales
- comparing translation key sets
- detecting missing keys
- detecting extra/stale keys when useful
- reporting changed namespaces
- validating fallback policy where the project exposes it

## Common Locale Sources

Examples only. Discover the active project convention before enforcing one.

- `public/locales/<locale>/`
- `src/locales/<locale>/`
- `src/i18n/`
- message catalog modules
- framework-specific route dictionaries
- Django/gettext catalogs in backend-owned projects

## Evidence Shape

```text
Locale Pack Parity Packet
- locale roots:
- supported locales:
- default locale:
- namespaces checked:
- parity method:
- changed keys:
- missing keys:
- extra/stale keys:
- fallback exceptions:
- result: pass | blocked | fail
```

## Command Mapping

Prefer project-native commands if they exist, for example:

- `npm run i18n:check`
- `pnpm i18n:check`
- framework-specific validation scripts
- Django/gettext validation commands

If no project command exists, use a manual parity packet and recommend adding a
project-local validation script only when repeated i18n work justifies it.

## Failure Handling

Fail or block closure when:

- locale roots cannot be identified
- supported locales are unknown
- changed keys are absent from one or more supported locales
- the project relies on fallback behavior but cannot explain it
- the proof does not identify the namespaces checked
