# Agent Factory Replay — 2026-05-08

## Scope

RC10 replayed one bounded candidate role through the promotion pipeline without
claiming autonomous runtime availability.

## Candidate

- role: `bounded-proof-auditor`
- status: `proof-replay` for fixture evidence only
- candidate packet: `agents/promotion/bounded-proof-auditor-replay.md`
- fixture: `planning/promotion/replay-fixtures/bounded-proof-auditor.md`
- governing pipeline: `core/control-plane/agent-factory-promotion-pipeline.md`

## Intake And Boundaries

Allowed:

- read bounded implementation packets, docs/tests, and proof appendices;
- verify requested-vs-implemented, validation output, residuals, cleanup, and
  status-honesty claims;
- recommend `accept-for-root-review`, `repair`, or `block-and-demote`.

Forbidden:

- final closure / `Done` authority;
- issue topology ownership;
- nested delegation;
- provider/live runtime writes;
- user-home skill authority;
- autonomous runtime availability claims;
- committing generated transcripts or private provider outputs.

## Skill Envelope

Repo-local authority only:

- `SKILL.md`
- `AGENTS.md`
- `skills/README.md`
- `skills/root/verification-before-completion/`
- `skills/review/code-audit/`
- `skills/governance/governance-audit/`
- `skills/workflow/subagent-governance/`
- `core/control-plane/agent-factory-promotion-pipeline.md`
- `core/control-plane/skill-sync-topology.md`

## Positive Fixture

The positive fixture passes only when the review packet contains bounded scope,
requested-vs-implemented, validation/proof locators, self-review,
self-forensic review, cleanup, demotion rules, and residuals. Expected result:
`accept-for-root-review`, not final acceptance.

## Negative Fixture

The negative fixture blocks when the candidate accepts any of these claims:

autonomous runtime available, generated export is source authority, user-home
catalog is governing authority, final closure is owned by the role, or required
review fields are missing. Expected result: `block-and-demote`.

## Cleanup / Idle-Agent Handling

No background process is started. The replay is file-fixture based. Temporary
scratch state is test-local and removed by traps. No generated transcript is a
committed artifact. The candidate remains fixture-scoped and idle after replay;
selection routes remain unavailable until root review and runtime proof exist.

## Demotion Rules

Demote to `blocked` if:

1. the skill envelope references non-local/user-home authority;
2. negative fixture claims are accepted;
3. cleanup or residuals are missing;
4. requested-vs-implemented or self-forensic review is missing;
5. the role claims root/final closure;
6. root review-of-review rejects this proof.

## Validation

Required validation commands:

```bash
bash tests/promotion-replay-fixtures.sh
bash tests/agent-install-export-contract.sh
```

## Verdict

The bounded proof-auditor candidate reached fixture-level `proof-replay`. This is
not `runtime-bound`, not `available`, not installed, not exported as a real
runtime agent, and not autonomous runtime availability.
