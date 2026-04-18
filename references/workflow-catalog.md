# Workflow Catalog

## Local Authority Status

Primary local authority lives in:

- `../core/workflows/catalog.md`

Use this reference for supporting doctrine and comparison depth.

If the native local file and this reference disagree, prefer the local file.

Use this module when the operator needs the complete named workflow map for the
full `accelerate` model.

## Rule

Do not treat the workflow set as only branch classification.

The full model contains named workflows that can later become dedicated agents,
but must already exist as explicit operational lanes now.

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
  -> design artifact packet
  -> implementation handoff
```

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

### 20. Docs-Sync Workflow

```text
durable behavior change
  -> docs / change communicator
  -> living docs update or follow-up
```

### 21. Forensic-Closure Workflow

```text
verify
  -> requested vs implemented
  -> promised vs delivered
  -> issue vs landing
```

### 22. Release-Handoff Workflow

```text
closure-ready work
  -> release / handoff manager
  -> merge readiness
  -> handoff / rollback notes
```


### 19. Parallel-Discovery Workflow

```text
multiple independent reads / validations
  -> parallel-agents
  -> evidence synthesis
  -> execution decision
```

### 20. Governed Multi-Subagent Workflow

```text
non-trivial delegated execution
  -> subagent-governance
  -> bounded subagent returns
  -> master integration review
```
