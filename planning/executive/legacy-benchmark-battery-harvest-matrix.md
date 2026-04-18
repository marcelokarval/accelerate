# Executive Matrix: Legacy Benchmark Battery Harvest

## Purpose

This artifact converts the completed benchmark battery into an explicit
side-by-side harvest matrix.

It exists to answer one practical question:

- what should stay as the local/standalone shape
- what should be harvested from the legacy/global runtime
- what should be corrected next so the local actually becomes the improved
  replacement instead of a cleaner-but-weaker rewrite

This matrix is derived from the real benchmark battery already run against the
Prop4You backend modeling review target.

## Governing Conclusion

The benchmark battery did **not** show that the local platform is broadly
inferior in structure.

It showed something more specific:

- the local is now stronger in explicit method, doctrine, and
  persistence/runtime reconciliation
- the legacy is still stronger at aggressively surfacing concrete domain
  defects, broken invariants, and directly actionable persisted-modeling bugs

So the strategic move is now explicit:

- keep the local layered organization
- keep the local native ownership of the control plane
- harvest almost all remaining operational strength from legacy into the local
  runtime by default
- stop treating slice-by-slice convergence as the main strategy

The burden of proof is inverted:

- local structure is already good enough to keep
- legacy operational sharpness is now presumed worth transplanting unless it
  clearly conflicts with `pre-agents` reality or with the standalone layered
  architecture

## Battery-Derived Judgment

The battery produced this durable split:

- `legacy/global`
  - better concrete-domain bug hunting
  - better instinct for broken invariants, bad constraints, unsafe dedupe,
    router-protection gaps, and projection-vs-identity drift
- `local/standalone`
  - better explicit method
  - better doctrine/persistence/runtime reconciliation
  - better naming of aggregate overload, boundary inversion, taxonomy drift,
    runtime-identity mismatch, and cache-vs-truth confusion

The local therefore should not be “softened” or replaced.

It should become:

- the current local architecture
- plus legacy-grade defect aggression
- plus legacy-grade closure harshness

## Keep / Harvest / Correct Matrix

| Surface | Keep From Local | Harvest From Legacy | Next Correction |
| --- | --- | --- | --- |
| Root control plane | layered native ownership, explicit runtime packets, prompt-hardening and scope-calibration posture | stronger coercion in selection and closure tone | make runtime behavior reflect the existing doctrine more consistently |
| Review method | doctrine/persistence/runtime reconciliation, aggregate-overload detection, boundary-inversion framing | concrete-domain bug bias, invariant-first reading, broken-constraint instinct | teach the local to ask “what is concretely broken here?” earlier than “what is structurally misaligned?” |
| Scope handling | `dual scope`, explicit scope declaration, honest absence handling | more aggressive recovered-domain-first execution when the domain target is clearly the real center of the request | stop letting the recovered domain become “secondary” when it is actually where the main truth lives |
| Persisted-modeling forensics | strong explicit local framework for lifecycle, identity, truth-ownership, and aggregate overload | stronger focus on unsafe dedupe keys, impossible predicates, missing DB protections, `CASCADE` blast radius, router coverage gaps | add a local “domain defect bias” checklist to persisted-modeling review and benchmark invocation |
| Domain bug hunting | none to keep as primary advantage; this is where local still lags | legacy-style concrete defect ranking | promote `broken constraint`, `unsafe dedupe`, `incomplete write guard`, and `identity collapse` to first-class high-signal findings in local reviews |
| Workflow governance | now largely harvested and structurally sound in local | legacy harshness when a named workflow is under-run or its expected packet is missing | treat missing workflow output shapes as stronger closure blockers in live runs |
| Parity judgment | explicit local replacement rule, explicit gap matrix | legacy’s behavioral harshness about not claiming parity too early | create a native parity gate artifact that can reject “clean docs” as insufficient proof |
| Benchmark memory | local has the right executive/architecture home for this | legacy benefited from implicit practiced memory | version benchmark runs as first-class artifacts so parity judgments stop depending on conversational recall |

## What Must Stay Local

These are not to be replaced by legacy shape:

- the standalone layered architecture
- native `core/` ownership of doctrine
- explicit packeted runtime visibility
- explicit `scope strategy` language
- explicit parity/replacement rule
- explicit `pre-agents` discipline

The local is not failing because it is too organized.

It is failing only when the organized structure does not yet carry enough
legacy-grade operational aggression.

## What Must Be Harvested Aggressively

These should now be treated as default import candidates from legacy:

- concrete-domain bug bias
- invariant-first reading
- broken-constraint ranking
- stronger recovered-domain aggression
- harsher closure when the requested workflow shape was not actually executed
- stronger suspicion of router/write-guard incompleteness
- stronger suspicion of projection-vs-identity drift
- stronger suspicion of unsafe dedupe and collapse of canonical entities

## Immediate Corrections To Derive From This Battery

1. Add a local persisted-modeling review supplement focused on:
   - broken uniqueness predicates
   - missing/incomplete router protection
   - unsafe dedupe keys
   - dangerous `CASCADE` usage on canonical/legal/history surfaces
   - projection-vs-canonical identity splits
   - status: landed as `core/review/persisted-modeling-defect-bias.md`

2. Create a native parity gate artifact that answers:
   - what evidence upgrades a surface from `near parity` to `local at parity`
   - what benchmark failures block a replacement claim
   - status: landed as `core/control-plane/parity-replacement-gate.md`

3. Version the completed benchmark runs so that each rerun can prove:
   - what changed
   - which correction moved the result
   - whether the local is improving in method only, or also in concrete defect
     capture
   - status: landed as
     `docs/architecture/accelerate-comparative-benchmark-persisted-modeling-battery.md`
     and
     `docs/architecture/accelerate-comparative-benchmark-persisted-modeling-model-comparison.md`

4. Re-run the persisted-modeling battery after the next domain-defect-bias
   harvest.
   Success is not “the prose sounds better.”
   Success is:
   - local keeps its current method advantages
   - and matches or beats legacy on directly actionable domain findings
   - status: satisfied by the bounded rerun now recorded as `R6`; the local
     moved from harvest target to demonstrated lead for this battery class

## Anti-Drift Rule

Do not let this matrix be reinterpreted as:

- “copy the old tree”
- “undo the standalone architecture”
- “make the local noisier”

The target is:

- local architecture
- legacy sharpness
- stronger than both previous states
