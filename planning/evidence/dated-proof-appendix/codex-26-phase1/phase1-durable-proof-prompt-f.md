# CODEX-26 Phase 1 Durable Proof — Prompt F

## Operator authorization

The operator authorized re-execution and explicitly selected:

- HCOM Agy using `gemini-3.8-flash-high` for adversarial analysis;
- HCOM Codex using `gpt-5.6-terra` with high reasoning for independent
  validation;
- Codex root for proof execution, review-of-review, consolidation, and bounded
  loop re-entry if an evidenced in-scope defect exists.

## Authority boundary

HCOM agents are supporting independent reviewers. They do not own repository,
Plane, promotion, or closure authority. Root owns the pollable execution
session, freezes, evidence reconciliation, review-of-review, and final gate.

## Tasks

1. `TASK-F01`: prove HCOM/model callability and current Plane capability.
2. `TASK-F02`: verify unchanged C14/R1 and freeze this durable-capture plan.
3. `TASK-F03`: launch both named HCOM reviewers and obtain readiness ACKs.
4. `TASK-F04`: root runs exactly one normal-environment `bash tests/all.sh`
   through a pollable unified execution handle and waits to terminal exit.
5. `TASK-F05`: only after F04 PASS, root runs one real-OpenSpec confirmation
   and waits to terminal exit.
6. `TASK-F06`: freeze exact proof evidence and revalidate C14/R1.
7. `TASK-F07`: send the frozen packet independently to Agy and Codex reviewers;
   loop only on concrete, in-scope defects and invalidate affected proof after
   any material correction.
8. `TASK-F08`: root review-of-review; optionally append one governed Plane
   `PROGRESS` comment after all gates PASS.
9. `TASK-F09`: emit `GO_FOR_PHASE1_CLOSURE_REVIEW` or
   `NO_GO_WITH_FIRST_BROKEN_BOUNDARY` and stop. Plane `Done` is not authorized.

## Frozen inputs

- C14 aggregate:
  `cbf26086ca9af5e7d927d7ee324818af35d74d972dfcdbfcce0cd562bc3780d4`.
- R1 aggregate:
  `aa9551f4b2f33fe382b043059034fe1b107e50ee8b99c5975869bdc67e5eaeed`.
- R1 freeze SHA-256:
  `23ec174a784f5a0570419086cbccda39f9b08f8dd780889b0e30e449c0a73ecb`.

## Non-goals

No source correction without a reviewer-found in-scope defect and explicit
generation loop; no C14/R1 silent mutation; no user-home mutation; no global
sync; no runtime promotion; no deployment; no Phase 2; no proposal rewrite;
no Plane state transition or `Done`.

## Capture contract — generation F2

Before each long command, root creates one explicit, task-bound directory under
`/tmp/codex26-prompt-f-*`. The command writes combined stdout/stderr to a
durable log while preserving the actual pipeline command's exit status in a
separate exit file. It also records normal-HOME classification without the HOME
value, cwd, ISO-8601 start/end, and `/usr/bin/time -p` metrics. After terminal
completion, root reads the exit file, hashes the full log, checks that no exact
command process remains, and revalidates C14/R1.

The same process is also started through a unified execution call. If a live
session id is returned, root polls that exact id with `write_stdin` while
omitting `chars`; this is an empty status poll and sends no input bytes to the
test process. The durable sink remains authoritative if the display transport
disconnects. Missing exit file, non-integer exit, partial metadata, orphaned
process, or absent terminal result is NO-GO.

A command is never relaunched merely because a collection window elapsed. The
temporary proof directory is retained through TASK-F09 and is not edited into
repository authority.
