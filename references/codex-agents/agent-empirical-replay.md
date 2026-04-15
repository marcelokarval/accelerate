# Agent Empirical Replay

Use this module when `accelerate` decisions need to be checked against
representative real-work classes from the dominant Prop4You stack.

This is not a donor summary. It is a replay-oriented evidence module that
captures how the `accelerate` control plane should packet common scenario types
before the governed pool is promoted into `~/.codex/agents/*.toml`.

## Method

For each scenario:

- shape the request as an engineering slice
- run `accelerate` classification explicitly
- leave the expected branch/persona/skills/gates visible
- compare the observed control-plane posture against:
  - `agent-ontology.md`
  - `agent-capability-matrix.md`
  - `agent-selection-policy.md`
  - `agent-gap-detection.md`
  - `agent-skill-envelopes.md`
  - `agent-pooling-model.md`

The replay here is empirical in the sense required by this ecosystem:

- `accelerate` is a governance/runtime-root skill
- the evidence is the packeted branch/persona/skill output it should emit for
  representative stack scenarios
- the goal is not to pretend an external binary exists, but to make the root
  operating model falsifiable against real classes of work

## Scenario Summary

| ID | Scenario | Observed `accelerate` center of gravity | Governed family fit | Result |
| --- | --- | --- | --- | --- |
| S1 | issue-ready shaping for a cross-stack feature | `Specification PM` -> `Product Planner` -> `Issue Architect / Linear PM` | `lifecycle-product-manager` plus root ownership | confirm root-preferred |
| S2 | bounded Django service/query/task mutation | `Backend Implementer` | `django-domain-implementer` | confirm |
| S3 | bounded Inertia/React page and component mutation | `Frontend Implementer` | `inertia-react-ui-implementer` | confirm |
| S4 | backend/frontend prop and identifier drift | `Data / Contract Steward` + `Governance Auditor` | `django-inertia-contract-integrator` | tighten donor mapping |
| S5 | shell churn, shared-prop instability, redirect truth | `Runtime/Product Reviewer` + `Browser-Proof Auditor` | `runtime-proof-auditor` | tighten runtime envelope |
| S6 | abuse-sensitive self-service flow | `Anti-Abuse Reviewer` + `Security Reviewer` | `trust-anti-abuse-reviewer` | add product-runtime conditional |
| S7 | Celery retry/idempotency/queue correctness | `Backend Implementer` + root compensation | no clean family | confirms async gap |
| S8 | legacy business truth adaptation | `Legacy Truth Analyst` | `legacy-truth-analyst` + backend worker when needed | confirm |
| S9 | provider-backed truth and leakage risk | `Provider Boundary Auditor` + `Data / Contract Steward` | no clean family | confirms provider-boundary gap |
| S10 | rollout-sensitive schema/data evolution | `Migration Steward` | no clean family | confirms migration gap |

## Macro Lane Replay

| Scenario class | Expected issue topology | Expected manager lane(s) | Expected blocker risk |
| --- | --- | --- | --- |
| cross-stack feature with one coherent outcome | parent + child when bounded slices exist, otherwise single issue | lifecycle -> technical | lifecycle blocker if issue shape is weak |
| backend/frontend contract drift | single issue or child issue under a parent feature | technical lane | contract blocker |
| user-facing runtime regression | single issue or proof child under a parent | proof lane | proof blocker |
| self-service abuse-sensitive flow | single issue or child issue under parent feature | trust lane, sometimes proof lane too | trust blocker |
| rollout-sensitive migration program | parent + child + review lane | technical lane plus rollout safety handling | rollout blocker |
| stale parent/child hierarchy | parent repair before execution continues | lifecycle lane | lifecycle blocker |

## Scenario Packet Matrix

| ID | Classification | Branch | Active persona(s) | Active skills | Key gates | Proof lane | Single-threaded exception |
| --- | --- | --- | --- | --- | --- | --- | --- |
| S1 | non-trivial | issue-driven delivery | `Specification PM`, `Product Planner`, `Issue Architect / Linear PM` | `linear-pm`, `linear-implementation-planner`, `prompt-hardening` when needed | `Issue Bootstrap Gate`, `Post-Issue Planning Gate` | n/a | root-owned framing and lifecycle authority |
| S2 | non-trivial | query / contract-sensitive backend | `Backend Implementer` | `django-pro`, `django-service-patterns`, `python-pro`, backend validation stack | `Truth Ownership Check`, `Query Shape Proof`, backend validation gate matrix | Backend QA | bounded backend slice handled locally for replay |
| S3 | non-trivial | visual / artifact-driven frontend | `Frontend Implementer` | `front-react-shadcn`, `inertia-patterns`, `frontend-boundary-governance`, `i18n-patterns` when needed | visual contract when needed, frontend validation gate matrix | Frontend QA | bounded frontend slice handled locally for replay |
| S4 | non-trivial | contract-governance workflow | `Data / Contract Steward`, `Governance Auditor` | `django-inertia-integration`, `server-prop-governance`, `validation-governance` | `Truth Ownership Check`, `Contract Correctness` | contract packet + browser truth when user-facing | replay focus is role fit, not delegation |
| S5 | non-trivial | browser-proof broad audit | `Runtime/Product Reviewer`, `Browser-Proof Auditor` | `product-runtime-review`, `dogfood`, `inertia-runtime-persistence-audit`, `server-prop-governance` when causal | `Browser Truth Gate`, `Audit Intensity Disclosure` | Browser-Proof | replay focus is packet capture |
| S6 | non-trivial | runtime / product-heavy + anti-abuse | `Anti-Abuse Reviewer`, `Security Reviewer` | `anti-abuse-review`, `security-patterns`, `product-runtime-review` when self-service UX matters | `Containment Policy Check`, hostile-path review | trust review + browser truth when user-facing | replay focus is fit scoring |
| S7 | non-trivial | backend implementation + async correctness | `Backend Implementer` with root compensation | `django-service-patterns`, `celery-tasks`, backend validation stack | backend validation plus queue/idempotency reasoning | backend proof + observability reasoning | no honest delegate family exists yet |
| S8 | non-trivial | legacy-transplant workflow | `Legacy Truth Analyst` | `legacy-first-protocol`, `legacy-transplant`, `architecture` when placement rationale matters | `Truth Ownership Check` | adaptation packet + normal implementation proof when mutation follows | replay focus is ontology fit |
| S9 | non-trivial | provider-runtime-audit workflow | `Provider Boundary Auditor`, `Data / Contract Steward` | `api-surface-governance`, provider/runtime skills, contract truth | `Truth Ownership Check`, provider/runtime packet | provider truth + contract proof | no honest delegate family exists yet |
| S10 | non-trivial | feature-flag / rollout or migration-sensitive backend | `Migration Steward` | backend validation gate matrix, rollout-sensitive schema/data reasoning | backend validation + migration/runtime evidence | backend proof + staged rollout proof | no honest delegate family exists yet |

## Consolidated Findings

### Confirmed Families

- `lifecycle-product-manager`
- `django-domain-implementer`
- `inertia-react-ui-implementer`
- `django-inertia-contract-integrator`
- `runtime-proof-auditor`
- `trust-anti-abuse-reviewer`
- `legacy-truth-analyst`

### Families That Needed Tightening

- `django-inertia-contract-integrator`
  - explicitly inherit `Data / Contract Steward` posture
- `runtime-proof-auditor`
  - explicitly inherit `Runtime/Product Reviewer` +
    `Browser-Proof Auditor` posture
- `trust-anti-abuse-reviewer`
  - explicitly allow `product-runtime-review` when the trust surface is
    self-service and user-facing

### Replay-Backed Future Gaps

- `async-workflow-steward`
- `provider-boundary-auditor`
- `migration-steward`

## Macro Findings

Replay confirms that the current family layer is not enough by itself to
explain the real control-plane behavior.

The root repeatedly behaves like:

- executive router
- technical lane governor
- lifecycle lane governor
- proof lane governor
- trust lane governor

These should remain explicit root-owned management functions rather than being
smuggled into bounded family descriptions.
