# Workflow Catalog

Use this module when the operator needs the complete named workflow map for the
full `accelerate` model.

## Rule

Do not treat the workflow set as only branch classification.

The full model contains named workflows that must already exist as explicit
operational lanes now, even before future agent promotion.

Named workflows are execution lanes, not decorative labels.

When a workflow is activated, its expected packet or proof shape should remain
visible in runtime updates.

## Catalog

### 1. Entry-Shaping Workflow

```text
User Request
  -> Specification PM
  -> Prompt Hardening Editor (when needed)
  -> Product Planner
```

### 2. Issue-Bootstrap Workflow

```text
accelerate
  -> Issue Bootstrap Gate
  -> active workflow adapter
  -> issue-ready validation
```

### 3. Prompt-Hardening Workflow

```text
Prompt A
  -> hardening pass
  -> Prompt B
  -> visible hardened artifact
```

### 4. Planning-Artifact Workflow

```text
issue-ready work
  -> plan artifact
  -> dependencies
  -> bounded execution order
```

### 5. Wireframe-Gate Workflow

```text
structural UI uncertainty
  -> reference extraction
  -> target ASCII
  -> state ASCII
  -> UI mutation
```

### 5b. Design-Artifact Workflow

```text
design uncertainty
  -> wireframe / visual contract / reference extraction
  -> HTML design-system extraction when URL/HTML reference is active
  -> paired visual showcase + LLM implementation contract
  -> design artifact packet
  -> implementation handoff
```

### 5c. Premium Design-System Direction Workflow

```text
HTML design-system extraction
  -> source-truth showcase + contract
  -> AI-slop / genericity audit
  -> premium direction markdown
  -> component coverage matrix when a broad primitive catalog exists
  -> light/dark token-sibling proof when theme switching exists
  -> premium direction HTML proof
  -> broad component gallery proof
  -> theme-generator readiness proof
  -> render / artifact validation
  -> implementation handoff
```

Use this workflow when an extracted design system is meant to become a better
premium product direction rather than only a faithful source-truth package.

The workflow must preserve the baseline extraction and place redesign judgment
in separate premium artifacts.

The premium HTML proof is invalid if it only demonstrates atmosphere, a hero,
cards, and one table. For shadcn/Radix-style stacks, it must show how the
direction treats realistic app primitives: actions, forms, controls, navigation,
data surfaces, overlays, feedback, loading, empty states, and coverage status.

When the source product supports light/dark themes, the premium proof is also
invalid if dark mode is only a decorative sample or an unrelated skin. It must
show equivalent component treatment across both themes and identify which
visual changes belong to tokens versus fixed component anatomy.

### 5d. Design-System Application / Recomposition Workflow

```text
existing docs/reference/design-system* package
  -> contract-first reading
  -> source-truth showcase inspection
  -> premium direction inspection when active
  -> target component / token / route inventory
  -> source-observed / code-available / premium-proposed / not-approved-yet map
  -> anatomy vs token split
  -> bounded UI implementation / correction / proposal
  -> runtime comparison against design-system artifacts
  -> residual drift registration
```

Use this workflow when the design-system package already exists and the task is
to implement, correct, improve, propose, or generate UI from it.

This workflow is invalid if the artifact package is treated as inspiration
instead of implementation law. `design-system.contract.md` must be read before
mutation, `design-system.html` must remain the source-truth visual evidence,
and premium artifacts may guide improvement only where they explicitly define a
direction.

For themeable systems, the workflow must separate fixed component anatomy from
changeable tokens. For broad component-library stacks, it must map more than
hero/card/table surfaces and prove realistic component recomposition.

### 6. Backend-Implementation Workflow

```text
Implementation Design Packet
  -> Backend Implementer
  -> Backend Tester
  -> backend proof
```

### 7. Frontend-Implementation Workflow

```text
Implementation Design Packet
  -> Frontend Implementer
  -> Frontend Tester
  -> frontend proof
```

### 7b. Implementation-Handoff Workflow

```text
Implementation Design Packet
  -> Implementer handoff
  -> code mutation
  -> Implementation Handoff Packet
```

### 8. Backend-QA Workflow

```text
backend mutation
  -> service/query/auth proof
  -> migrations/runtime proof
  -> residual backend packet
```

### 9. Frontend-QA Workflow

```text
frontend mutation
  -> type-check/state/i18n proof
  -> route-boundary proof
  -> residual frontend packet
```

### 10. Browser-Proof Workflow

```text
runtime-sensitive surface
  -> Chrome DevTools
  -> intensity declaration
  -> route-family / breadth proof
```

### 11. Playwright-Persistence Workflow

```text
browser truth stabilized
  -> scenario extraction
  -> Playwright persistence
  -> rerun proof
```

### 11b. Agent-Browser Runtime Workflow

```text
bounded browser operation need
  -> Chrome DevTools truth check when flow is unstable
  -> agent-browser adapter for repeatable browser operations
  -> evidence packet
  -> Playwright persistence decision
```

Use this workflow when a browser CLI adapter can preserve high-capability
interactive automation without replacing browser truth or persistent regression
ownership.

### 11c. UI Polishing Observer Workflow

```text
product-critical / premium surface allowlist
  -> browser observation
  -> visual / UX / cross-component audit
  -> severity classification
  -> issue or executive registration
  -> bounded implementation / proof
```

This workflow can support future scheduled observers, but observation must not
silently mutate code or doctrine.

### 12. Security-Review Workflow

```text
trust boundary risk
  -> security review
  -> exploitability judgment
  -> remediation or no-finding packet
```

### 13. Anti-Abuse Workflow

```text
abuse-sensitive surface
  -> anti-abuse review
  -> rate-limit / replay / resend / enumeration proof
```

### 14. Contract-Governance Workflow

```text
contract-sensitive change
  -> data / contract steward
  -> server prop governance
  -> contract correctness packet
```

### 15. Query-Shape Workflow

```text
backend-heavy surface
  -> query-shape proof
  -> query-count evidence
  -> EXPLAIN when needed
```

### 15b. Governance-Audit Workflow

```text
governance doubt
  -> governance audit
  -> stack truth packet
  -> remediation or policy conclusion
```

### 15c. Admin/Operator Workflow

```text
admin or operator surface
  -> readonly/operator distinction
  -> admin contract proof
  -> runtime/admin validation
```

### 15d. External-Skill-Vetting Workflow

```text
external skill / adapter / agent recipe
  -> source and runtime-power inspection
  -> platform-assumption classification
  -> direct-import / adapt-as-native / pattern-only / sandbox / reject decision
  -> insertion target and proof requirement
```

Run this before importing or promoting third-party skill-stack material.

### 15e. Skill-Evaluation-Lab Workflow

```text
skill / workflow / trigger hypothesis
  -> baseline run
  -> candidate run
  -> assertions / rubric
  -> blind comparison
  -> analyst pass
  -> promote / revise / rerun / reject
```

Use this when workflow or skill evolution needs evidence rather than taste.

### 16. Provider-Runtime-Audit Workflow

```text
external integration / provider dependency
  -> provider boundary audit
  -> runtime truth packet
```

### 16b. Performance / Observability Workflow

```text
perf or telemetry-sensitive surface
  -> query / perf proof
  -> observability review
  -> residual perf packet
```

### 17. Legacy-Transplant Workflow

```text
legacy domain truth
  -> legacy-first protocol
  -> legacy truth analyst
  -> adaptation packet
```

### 18. Feature-Flag / Rollout Workflow

```text
rollout-sensitive work
  -> rollout planner
  -> staged validation
  -> release packet
```

### 19. Incident / Hotfix Workflow

```text
incident severity
  -> hotfix commander
  -> containment
  -> bounded emergency execution
  -> forensic closure
```

### 19b. Incident Re-Entry Workflow

```text
post-incident stabilization
  -> re-entry assessment
  -> backlog / follow-up recovery
  -> normal workflow reintegration
```

### 20. Benchmark-Rerun / Result-Registration Workflow

```text
comparative or representative benchmark
  -> entry shaping when target / registration scope is not already bounded
  -> governance audit when authority or parity status is under judgment
  -> benchmark packet
  -> standard comparative outputs or weaker-evidence declaration
  -> scoreboard / executive artifact update
  -> forensic closure
```

For standard comparative benchmarks, this workflow composes with:

- `Parallel-Discovery` or `Governed Multi-Subagent` when independent local and
  legacy outputs are actually produced.
- `Docs-Sync` when the result updates living docs, scoreboards, or executive
  artifacts.
- `Issue-Bootstrap` plus `Planning-Artifact` when that durable registration is
  mutating work, unless the current pre-adapter/no-backend exception is
  explicitly recorded before the doc mutation.

### 21. Docs-Sync Workflow

```text
durable behavior change
  -> docs / change communicator
  -> living docs update or follow-up
```

### 22. Forensic-Closure Workflow

```text
verify
  -> requested vs implemented
  -> promised vs delivered
  -> issue vs landing
```

### 23. Release-Handoff Workflow

```text
closure-ready work
  -> release / handoff manager
  -> merge readiness
  -> handoff / rollback notes
```

### 24. Parallel-Discovery Workflow

```text
multiple independent reads / validations
  -> parallel-agents
  -> evidence synthesis
  -> execution decision
```

### 25. Governed Multi-Subagent Workflow

```text
non-trivial delegated execution
  -> subagent-governance
  -> bounded subagent returns
  -> master integration review
```

## Workflow Output Expectations

Some workflows are especially easy to name but under-run. Do not compress them
to vague `reviewed` or `tested` claims.

- `Forensic-Closure`
  - output should reconcile requested vs implemented, promised vs delivered,
    and issue or plan truth vs actual landing.
- `Benchmark-Rerun / Result-Registration`
  - output should name benchmark, objective, rule, target, task, expected
    output, comparison axes, evidence strength, registration artifact, and
    final status decision.
  - if the standard comparative benchmark method is used, raw side-by-side
    outputs should be preserved or referenced and the active
    `Parallel-Discovery` or `Governed Multi-Subagent` posture should be named.
  - if a lighter synthetic rerun is used, the output must say it is weaker
    evidence and must not promote a parity verdict by itself.
  - if the result is registered durably, the output should name the
    `Issue-Bootstrap` / no-backend-exception posture and the planning artifact
    or reason it is not required.
- `Release-Handoff`
  - output should leave merge-readiness status, operator handoff notes, and
    rollback or follow-up posture when relevant.
- `Parallel-Discovery`
  - output should synthesize the parallel reads into one execution decision,
    not just list independent observations.
- `Governed Multi-Subagent`
  - output should include bounded subagent returns plus a visible master
    integration pass that checks conflicts, overlap, and hidden scope drift.

## Selection Rule

Activate the smallest honest workflow set that still protects correctness.

If a benchmark result is being registered into living docs, pair
`Benchmark-Rerun / Result-Registration` with `Issue-Bootstrap` or explicitly
record the current pre-adapter/no-backend exception. Do not hide doc mutation
behind a read-only benchmark label.

If a run repeatedly activates one of the high-signal workflows above but keeps
failing to leave its expected output shape, that is workflow-governance
evidence, not mere local sloppiness.
