# CODEX-26 Phase 1 Dogfood Closure Correction — Prompt H

## Prompt A

Execute the separately authorized successor gate for every concrete boundary
proved by Prompt G. Use the HCOM Agy -> Terra loop in autopilot: Agy Gemini 3.8
Flash High implements and re-proves, Codex Terra Medium independently reviews
each frozen candidate, and Codex root owns architecture, dispatch, fan-in,
review-of-review, Plane reconciliation, and final closure judgment.

## Prompt B — execution-ready contract

Make the repository's selected `committed-dogfood-v2-index` profile support an
honest canonical closure-preparation path without silently materializing or
claiming the full-V2 profile. Replace C13-literal dogfood/currentness oracles
with a stable external authority binding that allows successor cycles without
weakening negative lifecycle checks. Preserve C13 and Prompt-G evidence as
historical inputs, project Prompt H as current and unaccepted until root
closure, regenerate all affected proof, freeze the final candidate, and require
an independent Terra review.

## Governing issue and entry authority

- Plane issue: `CODEX-26`
- work-item ID: `549d5c6e-9066-440c-85a6-973a33b7eefe`
- project ID: `d6b855ec-77cb-4df0-b471-4f6cea011e02`
- workspace: `karval`
- entry state: `In Progress`
- entry `completed_at`: `null`
- Prompt-G formal result:
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-task-g11-no-go.md`
- Prompt-G final freeze:
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-candidate-g2-freeze.json`
- Prompt-G final freeze SHA-256:
  `1c1420356eaadfd226942cbbec4ab46b45f6e966e9d5e243041c38bc78eddaa5`

The root-owned machine authority for the successor projection is
`prompt-h-current-authority.json`. Implementation and tests may read and bind
that receipt but must not edit it.

## Accepted architecture decision

Keep `committed-dogfood-v2-index` as the Accelerate repository's selected
profile. Do not migrate or imitate a full-V2 materialization.

The canonical `prepare-closure.sh` entrypoint must dispatch by declared
materialization profile:

- full-V2 continues through the existing full-V2 workflow unchanged;
- `committed-dogfood-v2-index` uses a bounded dogfood closure-preparation path
  that consumes only the committed subset authorities and produces an honest
  review/handoff result;
- unknown or malformed profiles fail closed;
- no branch may fabricate missing full-V2 files or claim acceptance, Plane
  closure, deployment, promotion, or Phase 2.

The dogfood path may add a dedicated helper when this produces a smaller and
more testable boundary than inline branching.

## Behavioral requirements

### H-R01 — profile-aware canonical closure

`prepare-closure.sh <repo>` must detect the selected materialization profile
before invoking full-V2-only helpers. On the current dogfood repository it must
complete closure *preparation* with exit 0 and create/update bounded local
handoff/review artifacts that state the actual readiness and open lifecycle.
Exit 0 means preparation succeeded; it must not mean `Done` or accepted.

### H-R02 — stable current-authority binding

The dogfood projection must bind a stable authority locator plus digest, rather
than letting tests infer correctness from the candidate files themselves. A
successor cycle updates the bound receipt/projection, not test source. The
binding must cover at least issue identity, cycle, plan, ledger, lifecycle
posture, materialization profile, and superseded historical authority.

### H-R03 — dogfood validator and contract

`validate-dogfood-v2-subset.sh` and `tests/dogfood-workspace-contract.sh` must:

- accept the Prompt-H current projection;
- validate cross-file consistency against the external authority binding;
- preserve secret/generated-path protections;
- preserve negative probes for false acceptance, false closure, and remote-call
  promotion;
- fail on authority digest drift, missing receipt, unknown profile, mismatched
  plan/ledger/cycle, and C13 restored as current;
- stop hardcoding C13 as the only legal current cycle.

### H-R04 — successor-aware phase currentness

`validate-phase1-entry-currentness.py` must preserve CODEX-17 and C13 as
historical lineage while validating Prompt H as the current unaccepted Phase-1
authority. Its success message and structured checks must not certify C13 as
current. Existing negative tests must be retained or strengthened.

### H-R05 — honest local observability

The three tracked `.accelerate/` control files and generated dogfood handoff
artifacts must agree on Prompt H, `In Progress`, `completed_at=null`, no remote
calls, and no acceptance/closure claim. After review, a small observability-only
successor correction is permitted but requires a new freeze and Terra review.

### H-R06 — compatibility and fail-closed behavior

The existing full-V2 closure tests must remain green. The new dogfood path must
be covered by positive and negative fixtures. No new dependency is allowed.
Shell/Python standard library and existing repository helpers are preferred.

## Honest TDD and debugging contract

This is a hybrid contract-defect/governance change.

Before product-source correction, Agy must re-observe and record the existing
Red commands:

1. `bash onboarding/local-workspace/prepare-closure.sh "$PWD"`
2. `bash tests/dogfood-workspace-contract.sh`
3. `bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .`
4. `python3 scripts/validate-phase1-entry-currentness.py` — record exit 0 as a
   semantic Red because the output certifies C13 as current.

Agy then adds or strengthens the lowest-effective contract tests, observes
their failure for the intended missing behavior, implements the minimum
complete correction, and re-runs fresh proof at the same correction generation.
The test author is not the independent reviewer; Terra reviews tests, oracles,
implementation, and proof together.

## Implementer write allowlist

Agy may modify only the smallest necessary subset of:

- `onboarding/local-workspace/prepare-closure.sh`
- a new bounded dogfood closure helper under `onboarding/local-workspace/`
- `onboarding/local-workspace/validate-dogfood-v2-subset.sh`
- `onboarding/local-workspace/README.md` and
  `onboarding/local-workspace/v2-materialization-contract.md` only if behavior
  needs documentation
- `scripts/validate-phase1-entry-currentness.py`
- one new focused standard-library validator under `scripts/` when it removes
  duplicated shell oracle logic
- `tests/dogfood-workspace-contract.sh`
- `tests/test_phase1_entry_currentness.py`
- one new focused dogfood closure/current-authority test under `tests/`
- `tests/local-workspace-proof-gates.sh` and `tests/all.sh` only when required
  to register/prove the new behavior
- `.accelerate/state.yaml`
- `.accelerate/status/readiness-dashboard.yaml`
- `.accelerate/workflow/active-work-item.yaml`
- generated closure/handoff evidence under `.accelerate/review/`
- `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-h-agy-return.md`

Every changed path must be justified. Existing unrelated dirty-worktree changes
are user-owned and must be preserved.

## Forbidden scope

- no edit to Prompt-G artifacts, Prompt-F artifacts, C14/R1 freezes, this Prompt
  H, its authority receipt, task graph, proposal, root `SKILL.md`, core,
  adapters, profiles, skills, V3 surfaces, or runtime mirrors;
- no dependency installation, global sync, symlink change, WebUI, Phase 2,
  commit, push, merge, deploy, release, or branch rewrite;
- no Plane access by children and no Plane lifecycle transition by root;
- no nested spawn;
- no deletion of user-owned or pre-existing evidence.

## Required proof after final mutation

Run, in order:

1. the new focused positive and negative dogfood/current-authority tests;
2. `bash onboarding/local-workspace/validate-dogfood-v2-subset.sh .`;
3. `bash tests/dogfood-workspace-contract.sh`;
4. `python3 scripts/validate-phase1-entry-currentness.py`;
5. `python3 -m unittest tests/test_phase1_entry_currentness.py`;
6. `bash onboarding/local-workspace/prepare-closure.sh "$PWD"`;
7. inspect every created closure/handoff artifact for placeholders, stale C13
   current authority, false acceptance, and lifecycle overclaim;
8. `bash tests/local-workspace-proof-gates.sh`;
9. `bash tests/all.sh` once after the final material correction;
10. `git diff --check`;
11. prove Prompt-G G11/freeze and Prompt-F/C14/R1 immutable evidence unchanged;
12. remove only Prompt-H-created disposable fixtures, `__pycache__`, `.pyc`, and
    temporary helper output; preserve reports, manifests, and audit artifacts.

If the global suite fails for an unrelated pre-existing baseline, classify and
prove that boundary; do not weaken an oracle or edit outside the allowlist.

## Independent review contract

Root freezes the complete candidate after Agy stops. Terra receives only the
frozen manifest, Prompt H, current-authority receipt, exact diff, proof
receipts/logs, and governing source. Terra is read-only and must verify:

- requirement-to-test-to-implementation traceability;
- honest pre-change Red and fresh proof generation;
- full-V2 compatibility plus dogfood positive/negative behavior;
- external authority binding is non-circular and digest-checked;
- historical C13/Prompt-G evidence remains historical, immutable, and usable;
- negative lifecycle and remote-call probes remain strong;
- no false closure, acceptance, Plane, runtime, or Phase-2 claim;
- scope and cleanup discipline;
- all candidate hashes before and after review.

Return `PROMPT_H_REVIEW_PASS` or `PROMPT_H_REVIEW_FAIL` with concrete evidence.

## Operational loop and heartbeat

- maximum material correction generations: 4
- heartbeat interval: inspect HCOM status/terminal at least every 60 seconds
  while a child is executing
- intervene immediately on an approval menu, wrong model/effort, unexpected
  scope, or non-progressing tool wait
- after 180 seconds without meaningful state change, request a checkpoint; if
  still idle at the next heartbeat, interrupt and resume/restart from the
  frozen assignment
- every material correction invalidates affected proof and requires a new root
  freeze plus fresh Terra review
- root may perform only integration/governance artifact repair, never the
  child-owned implementation scope

Stop at exactly one result:

- `GO_FOR_OPERATOR_PHASE1_CLOSURE`; or
- `NO_GO_WITH_FIRST_BROKEN_BOUNDARY`.

Neither result transitions Plane to Done.
