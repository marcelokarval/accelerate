# i18n Closure Gate

## Purpose

Use this gate when user-facing copy, locale packs, translation keys, localized
errors, locale formatting, or backend/frontend copy ownership are part of a
change.

The goal is to prevent mixed-language runtime, hidden fallback drift, and backend
copy leakage from being closed as ordinary frontend polish.

## Rule

i18n closure requires three truths:

1. supported locales were discovered from the active project or profile
2. changed user-facing copy is represented consistently across those locales
3. runtime proof covers at least one non-default locale when UX is affected

Do not hardcode universal locale lists in core doctrine. Stack profiles or target
projects may declare default locale expectations, but execution must discover and
name the active locale set for the current target.

## Activation

Activate this gate when the change touches:

- pages, components, dialogs, toasts, banners, tables, forms, empty states, or
  other user-facing strings
- locale JSON, dictionaries, modules, message catalogs, or translation code
- backend error keys or presenter fields that surface in UI
- date, time, number, amount, currency, or pluralization formatting
- route, middleware, shared-prop, or cookie behavior that changes locale state
- a mixed-language runtime regression

## Ownership Boundary

Backend owns:

- truth
- codes
- enums
- flags
- timestamps
- amounts
- stable translatable error identifiers
- translation keys only when the project architecture explicitly requires them

Frontend owns:

- final human-readable copy
- labels and helper text
- presentation wording
- locale formatting
- translation namespace composition
- runtime fallback behavior

Backend-generated localized prose is a closure blocker unless explicitly
justified by the active stack/profile contract.

## i18n Packet

```text
i18n Closure Packet
- target surface:
- active i18n library / convention:
- discovered locale sources:
- supported locales:
- default locale:
- namespaces touched:
- keys added / changed / removed:
- backend/frontend copy boundary notes:
- formatting changes:
- fallback behavior:
- parity command or manual parity method:
- non-default runtime proof:
- residual drift / blocked reason:
```

## Locale-Pack Parity

Locale-pack parity means every changed key is accounted for across the active
locale set.

Allowed states:

- translated value present
- intentionally same-as-default value with reason
- blocked translation with explicit placeholder policy and follow-up owner
- deleted consistently across all locales

Not allowed:

- missing key masked by fallback
- dynamic key construction with no parity proof
- one locale updated while others silently fall back
- backend display string substituted for frontend translation work

## Runtime Proof

When UX is affected, closure needs at least one non-default locale proof.

Proof may be:

- browser screenshot or browser packet
- rendered route inspection
- component/story proof if the project lacks a live app
- explicit blocked reason when local runtime cannot switch locale

English/default-locale proof alone is not enough for UX-relevant i18n work.

## Closure Blockers

Do not close if:

- supported locales were assumed instead of discovered or profile-declared
- changed user-facing strings are hardcoded without exception
- locale-pack parity was not checked
- fallback behavior masks missing keys
- backend-owned localized copy appears in frontend props without justification
- mixed-language runtime remains
- non-default locale proof is missing for UX-relevant work
- formatting changed without locale-sensitive proof
