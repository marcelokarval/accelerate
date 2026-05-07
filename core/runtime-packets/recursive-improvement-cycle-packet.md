# Recursive Improvement Cycle Packet

This packet records one bounded recursive self-improvement cycle for Accelerate.
It is a runtime contract, not a retrospective note: every cycle must connect
inventory, detected situations, delegated work, review, proof, closure, and the
next queue.

Use this packet when the root opens an internal improvement loop for the
Accelerate repository itself.

## Required Fields

Every recursive improvement cycle packet must include the fields below.

| Field | Required content |
| --- | --- |
| Cycle ID | Stable cycle identifier, date, and branch/session locator. |
| Trigger | Why the recursive cycle opened: scheduled audit, drift finding, failed proof, capability maturity review, dashboard residual, or root-directed improvement. |
| Inventory Scope | Repository surfaces inspected before shaping work: git state, CI/tests, control-plane docs, workflow/runtime adapters, runtime packets, skills, dashboards, planning artifacts, and known residuals. |
| Detected Situations | Classified internal situations found during inventory, with evidence and severity. |
| Task Ledger Link | Durable link to the task ledger that maps situations to bounded tasks. |
| Subagent Assignment Map | Which tasks are delegated, to whom or which lane, write scope, forbidden scope, and stop rules. |
| Review Map | Independent task review assignment or explicit exception for each task. |
| Proof Map | Required validation commands, artifacts, and proof appendices per task. |
| Closure Verdict | Root verdict after reviewing implementers, reviewers, proof, residuals, and scope discipline. |
| Next-Cycle Queue | Ordered follow-up queue emitted from residuals and blocked/planned situations. |

## Packet Template

```markdown
# Recursive Improvement Cycle Packet: <cycle id>

## Cycle ID

- Cycle ID: `<YYYY-MM-DD-short-name>`
- Repository: `<absolute or repo-relative locator>`
- Branch / worktree: `<branch and workspace evidence>`
- Root role: `orchestrator / final reviewer`

## Trigger

- Trigger type: `<scheduled audit | drift finding | failed proof | capability maturity review | dashboard residual | root-directed improvement>`
- Trigger evidence: `<links, command output, dashboard row, failed test, or plan>`
- Stop rule if trigger is invalid: `<what prevents execution>`

## Inventory Scope

Record the surfaces actually inspected before task shaping.

- Git status and branch:
- CI / test state:
- Control-plane doctrine:
- Workflow adapter capabilities:
- Runtime adapter capabilities:
- Runtime packet index:
- Skills / sync topology:
- Dashboards:
- Planning artifacts:
- Known residuals and blocked capabilities:

## Detected Situations

| Situation | Classification | Evidence | Severity | Proposed task |
| --- | --- | --- | --- | --- |
| `<situation name>` | `<blocked capability | planned without proof | duplicate doctrine | stale reference | weak negative fixture | missing dashboard | skill-sync drift | idle planned agent surface | other>` | `<durable evidence>` | `<high | medium | low>` | `<task id>` |

## Task Ledger Link

- Ledger: `<path or issue/work item>`
- Ledger status at cycle open:
- Ledger status at cycle close:

## Subagent Assignment Map

| Task | Assigned lane | Write scope | Forbidden scope | Stop rules |
| --- | --- | --- | --- | --- |
| `<task id>` | `<root | bounded implementer | reviewer | external adapter>` | `<allowed files/surfaces>` | `<forbidden files/surfaces>` | `<conditions requiring return to root>` |

## Review Map

| Task | Reviewer | Review type | Required requested-vs-implemented check | Review status |
| --- | --- | --- | --- | --- |
| `<task id>` | `<reviewer lane>` | `<subagent review | root review | declared exception>` | `<yes/no + evidence>` | `<pending | passed | failed | exception>` |

## Proof Map

| Task | Required proof | Actual proof | Artifact / command | Residual |
| --- | --- | --- | --- | --- |
| `<task id>` | `<test, diff check, CI, packet, dashboard, appendix>` | `<observed result>` | `<path, command, run id>` | `<remaining risk>` |

## Closure Verdict

- Root verdict: `<closed | closed-with-residuals | blocked | reopened>`
- Requested vs implemented summary:
- Scope discipline result:
- Reviewer verification result:
- Proof sufficiency:
- Honest status check:
- Residuals accepted:

## Next-Cycle Queue

| Priority | Situation / residual | Next task | Owner lane | Entry condition |
| --- | --- | --- | --- | --- |
| `1` | `<highest priority residual>` | `<next task>` | `<root/subagent/adapter>` | `<condition to start>` |
```

## Governance Notes

- The root remains the orchestrator and final reviewer for recursive cycles.
- Bounded subagents may execute scoped slices, but they do not close the cycle.
- Planned or blocked capabilities must stay planned or blocked until durable
  proof exists.
- Every recursive cycle must leave a next-cycle queue, even when the current
  cycle closes successfully.
