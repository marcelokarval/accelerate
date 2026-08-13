# Quality Stack Post-Restart Runtime Proof

## Identity

- Governing issue: `CODEX-1`
- Proof date: `2026-08-13`
- Runtime: `codex-cli 0.147.0`
- Correction generation: `5`
- Proof status: `observed-green`
- Source authority: repository
- Runtime target: `/home/marcelo-karval/.codex`
- Browser and persistent product E2E: not applicable; no product UI changed
- Requirement: `REQ-RUNTIME-002`
- Stable case: `CASE-RUNTIME-002`

## Post-Restart RED

The restarted default root and the installed `reviewer` profile returned the
requested readiness token but also emitted this governed startup error:

```text
Skill descriptions were shortened to fit the skills context budget.
```

The static catalog was still `inventory=131 enabled=39`. Effective discovery
showed 39 skills in the root: 20 repo-governed core skills, five Codex system
skills, and 14 host Superpowers skills. Restarting therefore exposed that the
pre-restart compactness threshold was not a sufficient runtime oracle.

`tests/codex-skill-catalog-truth.sh` was changed first and observed RED against
the old manifest. The opt-in
`tests/codex-logical-agent-runtime-proof.sh` was also changed first and observed
RED with `orchestrator exceeded the skills context budget` against the installed
runtime.

## Cause And Correction

The defect had two causes:

- the root contract carried workflow, implementation, review, shell, planning,
  debugging, and visualization skills that belonged in specialists or the
  on-demand route;
- `host-superpowers` was cataloged as unconditionally injected, so the global
  renderer and reconciler could not disable it.

Generation five keeps the full inventory of 131 skills while changing the
default selection to 13:

- eight exact repo-governed root skills: `accelerate`, `plane`,
  `prompt-hardening`, `skill-catalog-router`, `subagent-governance`,
  `specification-lifecycle`, `test-driven-development`, and
  `verification-before-completion`;
- five Codex system skills remain host-injected;
- `validation-governance` moved to the Python/backend family;
- `code-audit`, `governance-audit`, and `security-patterns` moved to the
  governance/reviewer family;
- eight other former root skills moved to the existing `on-demand` profile;
- all 14 Superpowers skills remain available through the new
  `superpowers-on-demand` profile and the catalog router.

No skill, plugin, MCP, credential, or unmanaged config entry was removed.

## Deployment Receipt

- Receipt schema: `3`
- Status: `installed`
- Backup:
  `/home/marcelo-karval/.codex/backups/skill-sync-20260813T112142Z-3821303`
- Machine receipt:
  `/home/marcelo-karval/.codex/backups/skill-sync-20260813T112142Z-3821303/sync-receipt.json`
- Changed governed packages: `108`
- Reconciled runtime files: `16`
- Backup complete: `true`
- Test allowlist: `false`

The new runtime-file denominator includes
`superpowers-on-demand.config.toml`. Unrelated MCP and operator configuration
remain outside the managed replacement set.

## Fresh Runtime GREEN

Effective `codex debug prompt-input ''` discovery after deployment produced the
following exact inventories:

| Context | Invocation | Visible skills |
| --- | --- | ---: |
| orchestrator | bare default root | 13 |
| python-backend | `-p python-backend` | 25 |
| nextjs-frontend | `-p nextjs-frontend` | 30 |
| research | `-p research` | 19 |
| reviewer | `-p reviewer` | 26 |
| qa | `-p qa` | 18 |

The opt-in runtime gate then executed one `--ephemeral --json -s read-only`
turn for each context. Every context returned the exact readiness token,
emitted zero item errors, and produced zero `Skill descriptions were shortened`
errors. The gate also compared every effective
inventory to the exact root plus specialist set derived from the manifest.

Observed command:

```bash
CODEX_RUNTIME_PROOF=1 CODEX_RUNTIME_HOME=/home/marcelo-karval/.codex \
  bash tests/codex-logical-agent-runtime-proof.sh
```

Observed result: `codex logical agent runtime proof passed`, exit `0`.

## Routing, Spawn, And Authority Boundary

Launcher dry-runs confirmed that the orchestrator uses bare `codex`, never
`-p orchestrator`, while the five logical specialists use `-p <name>` and an
unknown profile fails closed.

A fresh no-history native spawn named `post_restart_runtime_review` ran as a
read-only skeptical reviewer, returned evidence, findings, self-review, and
self-forensic review, and left integration and closure with the root. The spawn
itself proves native spawn and return behavior. It does not prove that native
spawn injects a logical `-p` profile, filesystem isolation, MCP isolation, or
physical-agent promotion. Logical profiles remain separately launched Codex
process configurations and assignment-packet routing metadata.

## Residual Before Closure

Independent generation-five review returned `P0=0`, `P1=0`, `P2=0`, and
`P3=0`. It independently reproduced the exact inventories, confirmed 104 r0
and 14 r1 disabled overrides, zero managed r2 overrides, complete Superpowers
recovery, warning-free startup, preservation boundaries, receipt truth and no
isolation overclaim. The runtime warning is corrected and empirically reproofed.

Final root reproof also exposed and corrected one stale checker message that
still said a restart was required. The stage contract observed RED first; the
checker now truthfully reports static installed-state proof only, leaving fresh
runtime proof to the separate opt-in gate above.

## Final Root Review-Of-Review

- isolated full repository suite: `all tests passed`, exit `0`;
- post-message-correction stage, quality `11/11`, mirror and manifest review
  gates: PASS;
- installed-runtime opt-in gate: PASS across six exact contexts;
- official Agent Skills validation: `9/9 PASS`;
- reviewed package integrity and eval-fixture validation: `9/9 PASS`, with
  behavioral replay explicitly not performed;
- global mirror readback: PASS;
- JSON, TOML, `git diff --check`, and generated-cache scan: PASS;
- independent review: zero P0-P3;
- root review-of-review: accepted.

Governed Plane closure is complete. The REVIEW comment
`b942077c-575f-4820-90ef-0f88ea46666e` was independently read back; the issue
was transitioned to the discovered Done state
`ed644a27-2d9b-403a-9b23-574715cb7c14`; and a fresh work-item GET confirmed
`completed_at=2026-08-13T12:04:24.208572Z`, high priority, one assignee, five
labels, start date `2026-08-12`, no due date, and the current `131/13` body.

The final lifecycle event is FINISH comment
`c93708e3-317f-41c0-8e0a-63667d578fb2`, external ID
`CODEX-1:finish:t11-generation-five:20260813`. The governed mutation reported
`mutation_applied=true` and `readback_verified=true`; an independent exact
comment GET confirmed FINISH, `review -> done`, empty blockers, and the current
inventory. A final independent work-item GET confirmed the issue remained Done.

The governed Plane PROGRESS packet was persisted and independently read back:

- comment ID: `c7031d70-8633-4c96-b5ab-d1fb1d1bb48a`;
- external ID: `CODEX-1:progress:t11-runtime-budget:20260813`;
- mutation applied: `true`;
- readback verified: `true`;
- provider work-item state remained `In Progress`.

The stale CODEX-1 body was then replaced from the governed HTML artifact
`codex-1-current-body-2026-08-13.html` through
`issue__update_issue_detail`. The mutation reported `mutation_applied=true` and
`readback_verified=true`. An independent GET confirmed the current `131/13`
contract and absence of `125/37`, while preserving high priority, one assignee,
five labels, start date `2026-08-12`, no target date, and the In Progress state.

That In Progress readback was the pre-review historical checkpoint. The final
authoritative provider readback is the Done state and FINISH receipt recorded
above.
