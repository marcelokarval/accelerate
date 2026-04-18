# Persisted Modeling Forensics

This document captures the persisted-modeling review method that must now be
native in the standalone platform.

Use it when reviewing:

- backend models
- schema aggregates
- compiled artifacts persisted in storage
- approval/lifecycle tables
- contract-heavy JSON payloads
- provider-to-canonical mapping persistence

When the target includes canonical identity, system protection, dedupe paths,
historical/provenance edges, or projection-vs-canonical drift, also load:

- `persisted-modeling-defect-bias.md`

## Goal

Do not stop at style, naming, or generic complexity complaints.

The review must look for structural truth failures such as:

- ownership inversion
- identity mismatch
- duplicated truth
- unconstrained vocabulary drift
- lifecycle overload
- doctrine-to-runtime contradiction

## Mandatory Reconciliation

For persisted-modeling review, reconcile all three:

1. doctrine / README / contract language
2. persisted model and database invariants
3. actual runtime lookup or admission path

If those three disagree, the review should say exactly where.

## Default Persona Stack

Default blocking personas:

- `Data / Contract Steward`
- `Closure / Forensic Reviewer`

Conditional additions:

- `Provider Boundary Auditor`
- `Governance Auditor`
- `Backend Implementer`

## Review Checklist

### 1. Boundary Direction

Check whether the semantic owner depends on a downstream or consumer-owned
normalizer, registry, or behavior.

Failure smell:

- the higher-order or semantic layer imports mutation or normalization logic
  from the downstream consumer layer

### 2. Identity And Lookup Invariants

Compare:

- unique constraints
- indexes
- runtime lookup keys
- activation scope

Failure smell:

- the database guarantees one identity axis
- the runtime queries another

### 3. Aggregate Overload

Check whether one persisted model is mixing:

- definition
- review/approval
- publication
- activation
- deprecation
- lineage
- summary metrics

Failure smell:

- one row acts as definition, release, audit, and runtime contract at once

### 4. Duplicate Truth

Check whether the same business decision is stored in multiple places:

- columns
- JSON payloads
- metadata blobs
- evidence blobs

Failure smell:

- partial update can leave contradictory state behind

### 5. Closed Vocabulary Enforcement

Compare contract-declared closed vocabularies against model and DB enforcement.

Failure smell:

- contracts define closed enums
- persisted model accepts free text

### 6. Lifecycle Semantics

Check whether approval, rejection, deferment, activation, deprecation, and
resolution are represented honestly.

Failure smell:

- an audit row records a status that does not match the action it claims to log

### 7. Validation Authority

Check whether strict validation exists only in optional code paths such as
`clean()`, while the persistence path can bypass it.

Failure smell:

- the model claims strong authority
- `save()` or manager path does not enforce it

## Expected Output

A serious persisted-modeling review should usually include:

- findings ordered by severity with file references
- the exact surfaces analyzed
- a compact model table with key fields and relations
- an ASCII UML or equivalent relation map when multiple models interact
- better-model suggestions, not only criticism

## Severity Bias

Prefer findings that can change runtime truth or persisted invariants over
findings that are only aesthetic or speculative.

That includes concrete defect candidates such as:

- broken uniqueness predicates
- unsafe dedupe keys
- incomplete router protection
- dangerous `CASCADE` on canonical/legal/history edges
- projection-vs-identity drift
