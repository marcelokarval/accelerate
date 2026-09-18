# OpenChamber Runtime Delegation Contract & Timeout/Cancellation Boundary

## 1. Status and Authority Boundary

This contract formalizes the OpenChamber runtime adapter under `adapters/runtime/openchamber/` as a **staged-only** projection (`legacy-reference` in `runtime-consumer-registry.json` with `projection.mode=reference-only`).

- **Governing Law**: The Accelerate root control plane (`SKILL.md`, `README.md`, `core/delegation/runtime-neutral-delegation.md`) remains the sole authority.
- **Subordinate Role**: OpenChamber is an execution runtime; it does not own run classification, issue topology, task ledger authority, role-family selection, external workflow mutation, review-of-review, promotion, or root closure (`Done`).
- **Nesting**: Disabled (`max_assignment_depth=0`, `max_concurrent_children=3`).
- **Effort Limits**: Allowed efforts are `low`, `medium`, and `high`. `xhigh` and `max` are strictly forbidden and suppressed.

## 2. Primitives and Session Identity

Candidate OpenChamber primitives:
- `session.create`: Session establishment, repository binding, and optional worktree creation.
- `session.send`: Work-bearing dispatch with mandatory explicit `sessionId`, `prompt`, `model`, and `variant`.
- `session.status`: Non-blocking lifecycle polling and state inspection.
- `session.messages`: Bounded blocking collection (`wait=true, lastAssistant=true`).

### Worktree and Session Isolation
- Write-bearing executor assignments MUST use an isolated worktree and branch created at `session.create`:
  - `worktree: acc-oc-<run-slug>-w<wave>-<assignment-slug>-<hash8>`
  - `branch:   accelerate/openchamber/<run-slug>/w<wave>/<assignment-slug>-<hash8>`
- Independent reviewers MUST receive a fresh session created with `session.create` inspecting the frozen candidate hash. `session.fork` is prohibited for independent review.

## 3. Timeout and Cancellation Boundary (GAP 2 Resolution)

### The Defect / Gap
OpenChamber does not advertise native `session.cancel` or `session.delete` operations. A dispatched session that runs into an infinite loop, stalls, or exceeds token/time limits cannot be killed via an explicit runtime termination tool.

### Boundary Rules (Fail-Closed Polling & Graceful Abort)

1. **Mandatory Strict Timeout Policy**:
   - Every blocking wait or polling loop (`session.status` / `session.messages(wait=true)`) MUST specify a strict deadline:
     - Research / low-effort queries: max 180s (3 minutes).
     - Execution / medium-effort tasks: max 600s (10 minutes).
     - High-stakes review / high-effort queries: max 900s (15 minutes).
   - In `session.messages`, the `timeout` parameter MUST be set to an explicit bounded integer (default max 600s), never indefinite.

2. **Fail-Closed on Polling Expiration**:
   - If the timeout expires before terminal status (`completed`, `failed`, or `aborted`) is observed, the adapter MUST immediately classify the session as `stuck/nonterminal session` or `fan-in timeout`.
   - The adapter MUST NOT assume success or continue polling indefinitely.

3. **Graceful Abort & Isolation**:
   - Since `session.cancel` is absent, the orchestrator MUST treat the session as abandoned/quarantined:
     - The session ID is recorded in the dispatch receipt as `abandoned_due_to_timeout`.
     - The corresponding worktree and branch are quarantined; they MUST NOT be integrated or merged into the main workspace.
     - The assignment is marked `failed` (`timeout_unresponsive`).
     - No automatic retry or unapproved replay is permitted.

4. **Cleanup & Containment Disposition**:
   - Physical worktree directories created for timed-out sessions must be retained with an explicit `retained-with-reason` receipt, or purged via external filesystem cleanups if authorized.
   - The absence of native session cancellation acts as a **hard blocker** preventing OpenChamber from graduating from `staged-only` to `supported` write-bearing orchestration.

## 4. Model and Variant Binding Contract

- Observed truth: `session.create` does not reliably enforce the model/variant preset.
- Governance mandate: Every work-bearing `session.send` MUST explicitly pass `model` and `variant` in the payload:
  ```json
  {
    "action": "session.send",
    "parameters": {
      "sessionId": "<session-id>",
      "prompt": "<immutable-assignment-packet>",
      "model": "<providerID/modelID>",
      "variant": "<variant>"
    }
  }
  ```
- Any missing telemetry, fallback to agent presets, or model mismatch is a blocking failure.

## 5. Workflow and Plane Separation

- OpenChamber child sessions MUST NEVER mutate Plane or external workflow trackers.
- Issue context in prompts is read-only evidence. Root alone owns workflow reads, comments, status transitions, and closure.
