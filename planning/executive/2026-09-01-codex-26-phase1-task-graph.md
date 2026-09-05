# CODEX-26 Phase-1 frozen task graph

State: `FROZEN_CURRENT`

Baseline: dirty-worktree delta captured 2026-09-01T22:34:06-04:00.
The existing dirty denominator is user/root-owned and preserved. Child scopes
are new exact paths that do not overlap the staged proposal, modified files, or
existing untracked paths. No child may reset, stash, stage, commit, rebase, or
rewrite work outside its assignment.

## Frozen inputs

- proposal SHA-256: `749d829a5b5868370b05007ad71e4b4b285623db79cbefeaa47ba9a3b07e7cca`
- Phase-0 acceptance SHA-256: `f722da4531542f3e2585f111ba8f0d334e5bf3655e44c1cadf3f303cdb4c759d`
- SDD SHA-256: `2e037c4063adf4d4088843baf1f655410d74424c2a0866c0bbd5951fe9aadefc`
- Test Design SHA-256: `f9a3f4f9708a54b9815b980cbfe342fe230744f97d1b37413175ed294a9eb147`
- Decision rebinding SHA-256: `fc9ba212ca715a413470fb0b69cb17f5719d7678e9e7b15c226f254d7f448c16`
- D12 v2 SHA-256: `62f05ee362aaf9967f3cf5749f41977a9c798690c8be13f83b6a4db9afd960ea`
- D14 SHA-256: `261e4d7005b11d3f769ee65d05743b5dd80d12f332be23f1a881c7ff2e0dffb2`
- independent SDD acceptor: `/root/phase1_sdd_acceptance`, Terra/medium, PASS

## DAG

```text
P1-PLAN (root, complete)
    |
    v
P1-IMPLEMENT (Terra/medium, writer)
    |
    +------------------+
    v                  v
P1-TEST (Terra/medium) P1-REVIEW (Terra/medium, fresh read-only)
    |                  |
    +--------+---------+
             v
P1-CLOSE (root review-of-review and Plane reconciliation)
```

`P1-TEST` and `P1-REVIEW` begin only after root freezes the implementation
candidate. They may execute concurrently because neither repairs implementation
code. Any FAIL returns a correction packet to a new implementer turn and
invalidates prior candidate-bound proof.

## Assignment P1-IMPLEMENT

- Model: `gpt-5.6-terra`
- Reasoning effort: `medium`
- Fork turns: `none`
- Write scopes, all new and exclusive:
  - `core/phase1/`
  - `adapters/openspec/`
  - `planning/openspec/`
  - `scripts/phase1/`
  - `tests/phase1/`
- Deliver: nine Phase-1 schemas/validators/canonicalizers, D01 A03 store,
  fixture-only OpenSpec adapter and schema draft, D12/D14 source contracts,
  complete implementation tests, compatibility/cleanup/rollback artifacts.
- Must not edit any existing dirty path or any planning/authorization artifact.

## Assignment P1-TEST

- Model: `gpt-5.6-terra`
- Reasoning effort: `medium`
- Fork turns: `none`
- Write scope: none; evidence returns through the Subagent Return Packet.
- Deliver: independent fresh execution of the complete A03/A04 union, exact
  manifest bytes/hashes, all nine schema families, adapter behavior,
  containment, cleanup, compatibility, and rollback.
- Verdict: `PASS` or `FAIL`; no implementation repair.

## Assignment P1-REVIEW

- Model: `gpt-5.6-terra`
- Reasoning effort: `medium`
- Fork turns: `none`
- Write scope: none.
- Deliver: adversarial independent review of scope, architecture, authority,
  security, schema/fixture denominator, proof freshness, and forbidden effects.
- Verdict: `PASS` or `FAIL`; no implementation repair.

## Budget and stop rules

- Initial physical budget: three Terra/medium executions after SDD acceptance:
  implementer, tester, reviewer.
- Agy Flash/low is advisory structural preflight/postflight only and never
  mutation or acceptance authority.
- Maximum three correction rounds. No automatic fourth round, scope expansion,
  denominator reduction, or change of runtime/model class.
- Stop on release-tuple mismatch, dirty-path overlap, global/runtime effect,
  real project archive, incomplete nine-schema/A03/A04 denominator, or
  unresolvable test/review conflict.

