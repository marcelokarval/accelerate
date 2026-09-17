# CODEX-26 Phase 1 Closure Review — Prompt G

## Prompt A

Proceed with the authorized HCOM autopilot pattern: Agy Gemini 3.8 Flash High
implements, Codex Terra Medium independently reviews, and Codex root performs
review-of-review and returns concrete defects to the Agy -> Terra loop.

## Prompt B — execution-ready contract

Perform only the separately authorized Phase-1 closure review for `CODEX-26`.
Use Agy `gemini-3.8-flash-high` as the bounded implementation/correction lane,
Codex `gpt-5.6-terra` at medium reasoning as the independent review lane, and
Codex root as sole orchestrator, evidence reconciler, review-of-review owner,
and final gate authority.

The implementer must reconcile the repo-local `.accelerate/` projection from
its stale C13 state to the current Prompt-F proof truth, use the canonical
local-workspace closure preparation flow, and produce complete closure-review
artifacts without changing the accepted Phase-1 implementation/proof
denominators. The reviewer evaluates a root-frozen candidate, not a moving
workspace. Root may return only concrete, in-scope defects to the implementer;
every correction invalidates affected proof and requires a successor freeze
and fresh Terra review.

Stop at exactly one result:

- `GO_FOR_OPERATOR_PHASE1_CLOSURE`; or
- `NO_GO_WITH_FIRST_BROKEN_BOUNDARY`.

Neither result performs Plane `Done` or any other lifecycle transition.

## Authority and frozen inputs

- governing issue: `CODEX-26`
- current Plane state at entry: `In Progress`
- Prompt-F closure-review authorization:
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-f-task-f09-closure-review-go.md`
- Prompt-F F09 SHA-256:
  `fcb91ad773a46b20467778cbb82959aa0a38d8d4f1b2927b9dd9a93aa57085aa`
- Prompt-F durable proof freeze:
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-f-durable-proof-freeze.json`
- Prompt-F proof-freeze SHA-256:
  `1d21bbe918886ff8ff3acf696bd20f9f736a6b81d445e28f7e037e7245cbebda`
- C14 freeze-file SHA-256:
  `7215486904c9fee3172ad1f53c3c3a63d4aa9ba62cea424d5bf8da60fcf72bc2`
- C14 aggregate:
  `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`
- R1 freeze-file SHA-256:
  `23ec174a784f5a0570419086cbccda39f9b08f8dd780889b0e30e449c0a73ecb`
- R1 aggregate:
  `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`
- local-state entry hashes:
  - `.accelerate/state.yaml`:
    `893c4382113fcac209cf1a540e342f0e00ff98408e800562096eb1bdb9d4f5d4`
  - `.accelerate/status/readiness-dashboard.yaml`:
    `f8bb037cbe9e99357782cbef4874423c536e01956ed999a0d5c964e6a8621565`
  - `.accelerate/workflow/active-work-item.yaml`:
    `9e2fe257cd75f3bacb50125cff73cc2b00ddac33b26b97f3c696169e7d1985e6`

## Bounded implementer write scope

Agy may mutate only:

- tracked/local control and closure surfaces under `.accelerate/`;
- one implementation return artifact named
  `planning/evidence/dated-proof-appendix/codex-26-phase1/prompt-g-agy-closure-candidate.md`.

Agy must use `onboarding/local-workspace/prepare-closure.sh` rather than invent
an ad hoc closure sequence. Before invoking it, Agy must ensure the local
projection names the current Prompt-G/Prompt-F authority rather than C13 as the
active closure truth. Generated/private `.accelerate/` outputs remain local
evidence and must obey `.accelerate/.gitignore`.

## Forbidden scope

- no edits to C14 files, R1 files, Prompt-F artifacts, root `SKILL.md`, V3
  planning pointer, governing proposal, tests, scripts, adapters, core, skills,
  profiles, onboarding source, or runtime mirrors;
- no Plane access or mutation by either child;
- no global/user-home sync, symlink, installation, promotion, deploy, release,
  WebUI, Phase 2, commit, push, merge, or branch rewrite;
- no nested spawn; child assignments declare `fork_turns=none`;
- no claim of `Done`, FINISH, acceptance, or production/runtime activation.

## Required implementer proof

After the final Agy mutation:

1. run the canonical closure preparation command against this repository;
2. inspect every generated closure/review artifact for current authority and
   absence of template placeholders or C13-as-current claims;
3. run `bash tests/local-workspace-proof-gates.sh`;
4. run `bash tests/dogfood-workspace-contract.sh`;
5. run `python3 scripts/validate-phase1-entry-currentness.py`;
6. run `git diff --check`;
7. prove C14, R1, Prompt-F F09, and Prompt-F proof-freeze hashes unchanged;
8. return requested-vs-implemented, self-review, self-forensic review, exact
   changed paths, proof exits, blockers, and residuals.

Existing Prompt-F global-suite and real-OpenSpec proof remains reusable only
if all of its frozen source/control inputs remain unchanged. Any such mutation
invalidates Prompt F and forces `NO_GO` rather than an implicit rerun.

## Independent review contract

Terra receives only the root-frozen closure candidate, Prompt G, Prompt-F
authority, and proof receipts. Terra is read-only and must verify:

- current-authority accuracy of `.accelerate/` and closure artifacts;
- no hidden widening or forbidden mutation;
- proof and hash fidelity after the last mutation;
- C14/R1/Prompt-F preservation;
- absence of stale C13 closure authority, placeholders, false acceptance, or
  lifecycle overclaim;
- whether the candidate supports the exact final gate and nothing broader.

Terra returns `PROMPT_G_REVIEW_PASS` or `PROMPT_G_REVIEW_FAIL` with concrete
file/line or artifact/hash evidence. A summary-only approval is invalid.

## Operational loop

- maximum correction generations: 4
- root classifies every reviewer finding before re-entry
- only independently corroborated, reproducible, in-scope defects re-enter Agy
- Agy corrects the smallest authoritative surface and re-runs affected proof
- root freezes a new candidate; Terra re-reviews from that frozen candidate
- unresolved authority, scope expansion, denominator drift, repeated failure,
  or exhausted budget ends in `NO_GO_WITH_FIRST_BROKEN_BOUNDARY`

## Completion boundary

Root may emit `GO_FOR_OPERATOR_PHASE1_CLOSURE` only after an independent Terra
PASS, root review-of-review, current Plane readback, and exact proof/freeze
reconciliation. Plane REVIEW/PROGRESS commentary is optional and root-only.
Plane FINISH/Done remains a separate operator gate.
