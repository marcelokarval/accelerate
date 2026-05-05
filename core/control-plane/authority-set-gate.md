# Authority Set Gate

## Purpose

The Authority Set Gate classifies every source used during an Accelerate run so
operators do not confuse doctrine, references, decisions, workflow backend state,
or generated exports.

Use this gate whenever a run is mutation-bearing, governance-heavy, adapter-
shaped, reference-heavy, or likely to import outside material.

## Authority Classes

Every cited source must be classified as exactly one of these classes:

| Class | Meaning | Examples | May decide runtime behavior? |
| --- | --- | --- | --- |
| `governing-authority` | Repo-local source that directly governs Accelerate behavior. | `AGENTS.md`, `SKILL.md`, `README.md`, `core/`, active `adapters/`, active `profiles/`, active `skills/`, accepted `planning/` artifacts | yes, within scope |
| `supporting-reference` | Inherited or comparative material that informs but does not override native authority. | `references/`, external docs imported for comparison, design benchmark corpora | no, unless promoted into governing authority |
| `decision-artifact` | A specific plan, packet, review, ADR, or task ledger accepted for a run. | `planning/executive/*.md`, PRD-lite, SDD, task breakdown, branch entry packet | yes, for the bounded run and only under root laws |
| `backend-authority` | State read from the active workflow/runtime backend through an implemented adapter. | local `.accelerate/` work item, implemented workflow adapter rehydration packet, tested runtime proof output | yes, only for the backend facts it owns |
| `generated-export` | Outward runtime host material generated from this repository. | `global-runtime/`, host export files, generated runtime bundles | no; advisory/deployment copy only |
| `forbidden-authority` | Any source that must not govern this repository unless imported, adapted, registered, and enforced here first. | user-home skill catalogs, stale global mirrors, unvetted external agent files, chat memory as sole evidence | no |

## Packet Vocabulary

Use `authority set`, not the older unqualified phrase `active references`.

A visible packet should name:

```text
- authority set:
  - governing-authority:
    - <path>
  - supporting-reference:
    - <path|none>
  - decision-artifact:
    - <path|none>
  - backend-authority:
    - <adapter/state path|none>
  - generated-export:
    - <path|none>
  - forbidden-authority:
    - <source excluded|none>
- authority decision: <what this set is allowed to decide>
- authority gaps: <missing governing source|none>
```

Deprecation note: legacy packets may say `active ADRs / references`; new or
edited packet templates must prefer `authority set` and classify references
instead of presenting them as equal authority.

## Enforcement Rules

1. Native repo authority wins over inherited `references/` when both cover the
   same method surface.
2. Supporting references can explain, compare, or provide depth; they cannot
   overrule root laws, native core docs, or accepted decision artifacts.
3. Backend state is authoritative only through an implemented, selected adapter
   and only for facts that backend owns.
4. Generated exports are deployment outputs, not doctrine. Operationally:
   generated exports are deployment outputs, not doctrine; repository remains source of truth.
   If generated exports drift from the repository, the repository wins.
5. User-home catalogs and stale global mirrors are forbidden authority for this
   repository unless their content is imported and governed here.
6. If authority is ambiguous, block closure and record an authority gap instead
   of silently choosing a convenient source.

## Closure Blockers

- A mutation cites `references/` as primary authority when a native `core/`,
  `adapters/`, `profiles/`, `skills/`, or accepted planning source exists.
- A packet lists unclassified references as if all cited files have equal force.
- A workflow backend is treated as active runtime truth without an implemented
  adapter and rehydratable state.
- A generated host export is described as canonical or authoritative.
- A user-home or external catalog is used as authority without repo-local import
  and registration.

## Failure Labels

- `authority-set-unclassified`
- `supporting-reference-used-as-authority`
- `backend-authority-overclaimed`
- `generated-export-treated-as-authority`
- `forbidden-authority-used`
