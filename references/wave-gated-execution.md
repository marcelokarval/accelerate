# Wave-Gated Execution

Use this reference when a mission has many similar targets, repeated work, multiple surfaces, or measurable coverage requirements. It generalizes the pattern:

```text
wave -> implementation -> tests -> validation -> >=95% coverage -> next wave
```

This is not an Agent Skills-only workflow. It is a general accelerate mode for broad operational, engineering, governance, audit, refactor, migration, QA, or cleanup missions.

## Use When

Use Wave-Gated Execution when any of these are true:

- the work spans many similar targets;
- the user asks for all phases, all waves, or complete coverage;
- the task can be grouped into repeatable waves;
- progress must not drift as new findings appear;
- closure depends on a numeric or target-count gate;
- broad mutation requires rollback safety and reproof;
- a large mission would otherwise become opaque.

Typical examples:

- skill catalog modernization;
- lint/type/test cleanup across many files;
- migration of configs, routes, docs, or schemas;
- security hardening across endpoints;
- frontend QA matrices;
- integration/provider sweep;
- repeated fixes over many modules.

## Do Not Use When

Do not use this workflow for:

- conversational/no-op answers;
- quick read-only checks;
- tiny deterministic mutations;
- a one-file bounded slice with obvious proof;
- exploratory work where no target set can be frozen yet.

In those cases, use the smallest valid accelerate path.

## Classification Rule

Wave-gated execution is usually:

```text
class: orchestrated mission
mode: wave-gated
```

It can also be a `bounded slice` when the whole wave set is small, local, and single-surface. Do not create a new root task class unless the mission also has runtime-incident or governance-mutation properties.

## Denominator Freeze Rule

Before mutation, freeze the target set for the current wave.

```text
Denominator Freeze
- selection rule:
- target count:
- target list or artifact:
- explicit exclusions:
- allowed residuals:
```

Coverage is calculated against this frozen denominator. New findings go to the next-wave backlog unless they prove the selection rule was wrong.

## Wave Packet

```text
Wave Packet
- wave id:
- class/mode:
- objective:
- target selection rule:
- frozen denominator:
- target list/artifact:
- non-goals:
- required mutations:
- proof gates:
- coverage threshold:
- allowed residuals:
- stop conditions:
- rollback/safety:
```

## Standard Pipeline

```text
1. Baseline audit
2. Freeze denominator
3. Implement smallest safe mutations
4. Run local mechanical tests
5. Run domain validators/suites
6. Run portability/interface/runtime gates when applicable
7. Compute coverage
8. Self-review + forensic review
9. Close wave or correct/reproof
10. Advance next wave
```

## Coverage Gate

Default threshold:

```text
coverage >= 95%
```

Formula:

```text
coverage = covered_targets / frozen_denominator
```

A target counts as covered only when every applicable gate passes. Examples of target-specific gates:

- file changed and lint/test passes;
- route implemented and API test passes;
- screen verified with browser proof;
- script supports `--help` and no cache/proof junk remains;
- skill validates in Hermes and portability checks;
- DB migration applies and rollback/contract proof exists;
- provider integration has dry-run or sandbox proof.

Use 100% when the target set is small, critical, or cheap to finish. Lower thresholds require explicit user/product/risk justification.

## Correction and Reproof Loop

If any gate fails, do not close the wave. Open a correction loop:

```text
Wave Correction Loop
- failed gate:
- affected targets:
- defect classification:
- correction applied:
- denominator preserved or re-frozen:
- fresh proof:
- coverage after correction:
- residual risk:
```

A failed first attempt is not a failed mission if the correction loop produces fresh passing proof.

## Structured Mutation Safety

For broad structured-file edits:

- use a real parser for YAML, JSON, TOML, XML, AST, OpenAPI, Compose, package manifests, and frontmatter;
- do not line-edit structured fields when block scalars, lists, anchors, or continuation lines may exist;
- validate the structured parser result before running broader suites;
- keep backups for governance or broad-catalog mutations.

## Script Interface Gate

For scripts touched by a wave:

- CLI-intent scripts must support `--help`;
- `--help` must work before optional heavy/runtime dependencies import;
- use lazy imports inside execution functions when needed;
- side-effecting scripts need `--dry-run` or explicit scoped inputs;
- do not leave `__pycache__`, `.pyc`, temp logs, or proof junk in governed artifacts.

## Ad-hoc Verification Gate

When no canonical suite/lint/build exists, use focused ad-hoc verification:

- create `/tmp/hermes-verify-*.py` with `tempfile`;
- verify changed paths and changed behavior;
- run local validators relevant to the touched surface;
- clean verifier and caches;
- report as `Ad-hoc verification`, not as full suite green.

## Wave Closure Packet

```text
Wave Closure Packet
- wave id:
- requested objective:
- frozen denominator:
- covered targets:
- failed/residual targets:
- coverage percent:
- validators/suites:
- interface/runtime proof:
- correction loops:
- residual classification:
- decision: advance | correct | block | waive-with-reason
- next wave:
```

## Behavior by Mission Shape

| Shape | Default accelerate behavior |
| --- | --- |
| prompt trivial | compact proof; no wave |
| prompt non-trivial | entry packet + proof lanes + review |
| small work | smallest valid workflow; no denominator unless repeated |
| large one-shot | orchestrated mission with ledger/proof; wave only if targets can be grouped |
| large repeated | wave-gated mission; denominator + coverage gates |
| small multitask | bounded slice with checklist; wave only if tasks are homogeneous/repeated |
| large multitask | orchestrated mission; split lanes, then waves where repeated target sets exist |

## Stop Conditions

Stop and correct before advancing if:

- a required validator/test fails;
- coverage is below threshold;
- denominator changes without re-freeze;
- a residual is unclassified;
- a mutation weakens domain-specific rules;
- runtime/source/config seams remain unproved;
- proof becomes narrative instead of executable evidence.
