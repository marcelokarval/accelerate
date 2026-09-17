# Controlled Model-Role Comparison

Use this reference to compare candidate roles on a single small engineering
task. It is not a provider qualification battery and it never promotes a model,
alias, or provider automatically.

## Preconditions

Freeze one reversible task, repository snapshot, acceptance test, expected
contract, budget, and stop rule before requesting any candidate. Record each
candidate's model version, route, effort, local-tool availability, prompt
detail, executor, and reviewer. Effort or configuration differences are valid
comparison configurations when declared; they are not intrinsically invalid.

Run one task at a time. Do not turn a small comparison into a benchmark suite,
provider load test, or paid capability battery. Isolate a prompt-detail
experiment: vary prompt detail only, retain task/test/route/effort, and report
it as a separate result.

## Atomic task packet

Before dispatch, persist one packet containing: what must change and why;
allowed files; base commit/tree hash; a bounded implementation suggestion;
non-goals; invariants; exact acceptance-test command and expected result;
time/request/spend limits; stop rule; and required return receipt. The packet
must make a direct implementation possible without hidden context recovery.
Use a single task and one frozen snapshot per wave. If the task or base hash
changes, stop and start a new packet.

Reusable packet shape (fill values before dispatch; do not send placeholders):

```yaml
task_id: frozen-task-identifier
objective: concrete change and reason
base: commit plus tree or supplied-file hashes
allowed_files: explicit paths
non_goals: excluded behavior and surfaces
invariants: behavior that must remain unchanged
context: supplied code, interfaces and relevant failure evidence
suggested_approach: non-binding bounded implementation steps
acceptance: exact command, expected behavior and independent edge cases
candidate: requested model, route, effort and tool availability
controls: prompt hash, harness version and isolation settings
limits: wall time, calls, output and spend or quota ceiling
stop_rule: conditions that terminate this attempt
return: patch, assumptions, executed commands, terminal status and evidence
review: independent reviewer and identity-blinding disposition
```

For each candidate, record declared model/version, route, effort, tool mode,
and prompt digest. Configuration differences are named configurations, not a
fairness defect by themselves. A prompt-detail experiment changes prompt detail
only and retains the task, snapshot, test, route and effort; report it apart.

## Tracks

### No-tools proposal track

No-tools means the proposer has no local workspace tools: it may not inspect,
modify, execute, or test repository files. It may receive minimum sufficient
context and propose a function, patch, counterexample, edge case, or diagnosis.
Its statements that it “applied” or “tested” are unverified prose.

DeepSeek Web in this track is a proposal source, not an executor or runtime
proof. Provider-native web search may supply sources when the selected provider
offers it; that is distinct from local tool execution. Preserve the existing
DeepSeek Search alias contract for grounded cited research.

### Tool-enabled executor track

The executor may inspect and apply only the frozen task scope, run the frozen
test, and capture the result. It must not make hidden repairs, change the
acceptance test, or attribute its own correction to the proposer. A distinct
reviewer checks the diff and evidence; root integrates or rejects it.

Where feasible, withhold candidate identity from the independent reviewer until
its verdict is locked. Executor self-review is useful but never independent
acceptance; a distinct reviewer still checks the submitted candidate.

## Terminal envelope and repeats

Capture returned provider/CLI fields separately from semantic evidence:
`finish_reason`, `status`, `error`, partial-output markers, `denied_actions`,
output completeness, timeout and exit code. Record unavailable fields rather
than inventing them; adapt the envelope to the actual transport contract.
For Agy, `status=ERROR`, a nonempty error or denied actions, or an incomplete
terminal response disqualifies the original attempt from `accepted`, even if
exit code is zero and the partial patch looks useful. Classify a provider,
permission or harness failure as `infra_fail`; missing terminal evidence as
`inconclusive`; a complete but defective candidate as `quality_fail`.
`empty_success` means a transport-success envelope with no usable final answer,
not every code-quality defect. Preserve the exact failure reason in the receipt.

An `infra_fail` is an observation about route/harness availability, not a score
of zero for unobserved code quality. Keep it separate from `quality_fail`.

Run repeated trials of the same frozen task only when confidence is needed and
budget permits; keep each trial's row and do not average away failures. A
partial proposal may be retained as an explicitly labelled salvage candidate,
but its executor application is a separate result. Never silently repair it or
count the repair as the proposer's pass.

## Receipt and classification

Keep one row per candidate with input digest, proposal digest, applied diff
digest, test command and result, reviewer verdict, elapsed time, and total work
for context preparation, application, correction, review, and retries. Compare
cost per accepted change, not response speed, token count, or a leaderboard.

Classify separately:

- `accepted`: complete valid terminal delivery, frozen test passes, and independent review finds no material gap;
- `quality_fail`: candidate or applied result violates the frozen contract;
- `infra_fail`: unavailable, timeout, denied, transport, or provider failure;
- `empty_success`: successful transport with no usable final answer;
- `stopped`: budget or stop rule ended an unfinished run;
- `inconclusive`: a required denominator differs or evidence is missing.

Exit 0 and HTTP 200 are transport observations, never semantic acceptance.
Retain all rows, including denied and stopped requests. No hidden repair may
convert a `quality_fail` into an `accepted` row.

Group by candidate configuration and task class before computing
`accepted_change_cost = total observed monetary cost / accepted deliveries`.
The numerator includes context, proposal, application, correction, review and
retry costs, including failed attempts, within that group's frozen trial set.
Do not pool rival models into one denominator or add minutes to currency.
Report latency, operator time and quota consumption separately; API list-price
estimates are not subscription charges. Missing cost or quota is `unknown`, not
zero. With no accepted deliveries, report `not_computable` and no accepted
delivery winner. A descriptive relative comparison may still explain defects;
it does not license promotion or score unobserved quality as zero.

## Decision

Among configurations evaluated on the same frozen task, snapshot, acceptance
contract and risk boundary, prefer the lowest evidenced total accepted-change
cost. Different declared routes and efforts are eligible: a conclusion such as
Luna/xhigh versus Terra/medium is about those tested configurations, not a
controlled estimate of model-only superiority. In a no-tools-versus-agent
comparison, include the separate application layer and call it a workflow
comparison. Unknown cost prevents a numeric economy winner, not a qualified
report of acceptance. One trial supports only a narrow observation; repeat
within budget before broad role recommendations. Escalate ambiguity or material
risk to the active root/review authority; never auto-change OmniRoute admission.
