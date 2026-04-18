# Persisted Modeling Defect Bias

This module is the native local supplement for the part of persisted-modeling
review that the legacy runtime still did better in the benchmark battery:

- aggressive capture of concrete domain defects
- invariant-first reading
- higher suspicion of broken constraints, unsafe dedupe, incomplete protection,
  destructive cascade posture, and identity/projection drift

Use it together with:

- `persisted-modeling-forensics.md`

Do not replace the base forensic method with this supplement.

The goal is:

- keep the local strength in doctrine/persistence/runtime reconciliation
- add legacy-grade defect aggression on top

## When To Load This Supplement

Activate it when the review target includes one or more of these:

- canonical entities with dedupe or normalization logic
- uniqueness constraints or partial unique constraints
- system-owned write protection or router policy
- ownership/identity graphs
- historical/legal/provenance edges
- projection or overlay models that shadow canonical identity
- JSON-heavy models that may be hiding structured invariants

If the review is only talking about “architecture smell” while failing to
surface directly actionable defects, this supplement should already be active.

## Priority Question

Before explaining the system, ask:

- what is concretely broken here?

Then ask:

- what invariant allows that break?
- what persisted structure or policy failed to prevent it?
- what change would make that failure harder or impossible?

Do not let structural commentary outrun defect capture.

## High-Signal Defect Families

Treat these as first-class, not secondary embellishments.

### 1. Broken Uniqueness Predicates

Look for:

- partial unique constraints with impossible predicates
- uniqueness scoped to the wrong active/deleted condition
- app-level uniqueness logic that the database is not actually enforcing
- uniqueness rules that fail under nullable or placeholder values

Failure smell:

- the code talks as if “only one active row can exist”
- the actual DB condition cannot express that rule

### 2. Unsafe Dedupe Keys

Look for:

- `get_or_create()` or upsert logic that dedupes on incomplete identity
- canonicalization against blank or placeholder fields
- normalization keys that are too weak for the claimed authority level
- promotion of provisional entities into canonical rows too early

Failure smell:

- different real-world entities can collapse into one persisted row
- or one real-world entity can split into unstable duplicates

### 3. Incomplete Router Or Write Protection

Look for:

- system-owned models missing from the protected list
- protection applied to only part of a canonical family
- policy claims about system ownership that the router does not actually cover
- tests that only cover a narrow subset of the protected surface

Failure smell:

- the repo claims “system-owned” or “guarded”
- but non-system code can still write to adjacent canonical surfaces

### 4. Dangerous `CASCADE` On Canonical Or Historical Edges

Look for:

- `CASCADE` on ownership, party, legal, provenance, or history relations
- deletions that can erase evidence chains or canonical graph integrity
- relationship tables where deletes should probably be `PROTECT` or
  `RESTRICT`-like by policy

Failure smell:

- deleting an identity or parent row can erase records that should remain
  queryable or auditable

### 5. Projection-Vs-Identity Drift

Look for:

- canonical identity rows plus duplicated projection rows
- query projections that still look writable or authoritative
- heuristic fallback logic between canonical identity and mirrored fields
- overlays that are described as “not source of truth” but still store values
  that look durable

Failure smell:

- the system cannot cleanly answer which row owns the truth
- reconciliation depends on conventions more than hard boundaries

### 6. Hidden Invariants Inside JSON

Look for:

- structured business decisions stored as blobs
- lifecycle state repeated across columns and JSON
- payloads that should have FK-backed or enum-backed structure
- “artifact store” behavior inside relational models

Failure smell:

- the row looks relational
- the real invariant is only implicit inside JSON

## Ranking Bias

Prefer defect findings in this order when present:

1. direct corruption or collapse risk
2. direct DB enforcement failure
3. incomplete system-write protection
4. destructive delete/provenance risk
5. identity/projection truth ambiguity
6. architectural explanation of why the above happened

Do not reverse that order unless the concrete defect case is genuinely weak.

## Defect-Oriented Checklist

When this supplement is active, the reviewer should explicitly check:

1. Does any partial unique or active-row uniqueness rule have an impossible or
   weak predicate?
2. Does any canonicalization/upsert path dedupe on incomplete identity?
3. Does the router/protection policy actually cover every system-owned member of
   the family under review?
4. Are any canonical, legal, historical, or provenance edges deleted by
   `CASCADE` without strong reason?
5. Is any projection/overlay carrying duplicated truth while still looking
   mutable or authoritative?
6. Are any critical invariants only represented in JSON or metadata blobs?

## Output Expectations

When this supplement is active, the review should usually include at least one
explicit section for:

- concrete defect candidates
- why they are materially actionable
- which invariant or guard failed

Good phrasing:

- `The active uniqueness constraint is broken because ...`
- `This dedupe key can collapse distinct entities because ...`
- `System write protection is incomplete because ...`
- `This CASCADE can erase canonical/provenance history because ...`
- `This projection duplicates identity truth and relies on heuristic reconciliation ...`

Weak phrasing:

- `The model feels overloaded`
- `This looks risky`
- `There may be drift`

unless the concrete defect case was investigated and found genuinely uncertain.

## Anti-Drift Rule

Do not use this supplement to turn every review into bug theater.

Its job is narrower:

- make sure concrete persisted defects are not missed
- especially when the local method is otherwise tempted to stay at the level of
  system explanation alone
