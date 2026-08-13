# Specification Entry Gate

## Purpose

Block every mutation from entering implementation until its proportional
Specification Lifecycle is explicit and machine-checkable.

## Entry Contract

Before mutation, require:

1. a governing issue or an explicitly approved narrow exception;
2. an Engineering Artifact Manifest;
3. `SDD Mode Gate` selection;
4. a design authority in `accepted` or `implementing` state;
5. complete decision-artifact dispositions;
6. `REQ -> task -> test or justified exception -> proof` traceability;
7. Test Design and TDD entry dispositions appropriate to the change kind.

Validate the manifest at the actual stage:

```bash
python3 scripts/validate-engineering-artifact-manifest.py <manifest.json> --stage implementation
```

## Proportionality

Direct-fast-path mutation uses `micro`, a non-empty Spec Capsule, and a compact
manifest. This is semantic SDD, not permission to skip specification or issue
bootstrap. Standard, hierarchical, and critical work materialize the larger
artifacts owned by `sdd-mode-gate.md`.

## Blocking Conditions

- mutation declares mode `none`;
- selected mode is below a deterministic risk trigger;
- design authority is only `draft` or is superseded;
- a required disposition, reason, or locator is absent;
- traceability is incomplete or planned proof is presented as observed;
- Test Design or TDD Receipt is missing, conflated, or stale after correction.

## Ownership

Accelerate root owns classification, acceptance, exceptions, and the entry
decision. Specialists may draft or validate artifacts, but cannot accept their
own design or close the governing issue.
