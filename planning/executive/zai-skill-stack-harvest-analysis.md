# Z.ai / GLM Skill Stack Harvest Analysis

## Purpose

This artifact records the first real external workflow-learning event for the
standalone `accelerate` repository after the self-evolution surface was kept at
`near parity`.

The inspected source was:

- `/home/marcelo-karval/Backup/Projetos/all-agrelli-projects/ht-agrelli-com-bot-telegram-dashboard/skills/`

The goal was not to mirror the Z.ai / GLM stack. The goal was to extract
operationally useful patterns that can improve the local `accelerate` control
plane without importing platform-specific commands, unsafe installation
patterns, or duplicate doctrine.

## Runtime Packet

- `active branch`: architecture / governance doubt
- `phase`: Frame -> Plan
- `issue stack`: pre-adapter / no-backend exception; durable executive artifact
  substitutes for issue-backend registration
- `single-threaded exception`: no subagent was spawned because the work was a
  bounded harvest / synthesis pass with no independent implementation slice
  safe enough to delegate without duplicating root judgment
- `proof lane`: document comparison and repository-local side-by-side analysis
- `closure blocker`: active core workflow mutation remains blocked until a
  dedicated implementation sprint and explicit approval of exact doctrine
  changes

## Side-By-Side Comparison

| Surface | Z.ai / GLM pattern observed | Local `accelerate` status | Harvest decision |
| --- | --- | --- | --- |
| browser runtime | `agent-browser` exposes a broad CLI surface for open, snapshot, click, fill, screenshots, PDFs, video, route mocks, cookies/storage, tabs, frames, dialogs, JS eval, and state save/load | Chrome DevTools and Playwright adapters exist, but their local docs are still thin placeholders | adapt as optional runtime adapter spec; do not replace Chrome DevTools-first proof ordering |
| scheduled active QA | platform appears to support recurring browser agents; `web-reader` also shows scheduled fetch patterns through cron-style examples | local has proof lanes, but no scheduled observer / active polishing doctrine yet | adapt as future `Active Browser Polishing Lane` with strict scope, budget, auth/session safety, and issue creation rules |
| UI polishing | `POLISHING_RULES.md` defines cross-component audit rules, severity levels, responsive checks, z-index/overlap checks, navigation consistency, and design-token consistency | local has `product-critical` and `premium-interface` discipline, but no dedicated recurring cross-component polishing lane | adapt into premium/product-critical proof as a follow-on lane, not as generic visual decoration |
| visual design foundations | explicit typography, spacing, color token, contrast, and fluid-type checklists | local frontend guidance already rejects generic UI and premium docs already enforce hierarchy | borrow checklist fragments only; avoid creating a parallel design-system doctrine |
| skill creation / evaluation | `skill-creator` defines baseline-vs-skill evals, assertions, blind comparison, analyst pass, timing/token metrics, HTML review artifact, and iterative improvement | local self-evolution currently captures durable evidence but lacks a native skill-lab/eval harness | high-priority adaptation; this is the strongest corrective signal for self-evolution |
| trigger optimization | `skill-creator/scripts/run_loop.py` tests should-trigger / should-not-trigger examples with train/test holdout to avoid overfitting descriptions | local skill activation guidance exists, but no native trigger-evaluation harness | adapt as future skill-description benchmark lane |
| external skill vetting | `skill-vetter` requires source inspection, file review, red-flag detection, permission review, and risk classification | local dependency/security governance exists, but external skill import has no named gate | adapt as `External Skill Vetting Gate` before any third-party skill or adapter adoption |
| coding workflow | `coding-agent` is conservative: plan, ask, execute, verify, deliver | local deliberately supports one-shot execution under root governance | reject as root pattern; selectively borrow verification wording only |
| fullstack-dev | Z.ai-specific Next.js 16 / Bun / Tailwind / shadcn / z-ai-web-dev-sdk instructions, including remote install command patterns | local is stack-agnostic and repository-specific; not a Z.ai runtime | reject direct import; treat only as stack-profile example |
| auto-target-tracker | scheduled / image-triggered goal-state tracking using VLM and daily progress notes | local has no equivalent active observer model | low-priority pattern for future observed-signal tracking, not current core |

## Useful Imports

### 1. Agent-Browser Runtime Adapter

The `agent-browser` skill is valuable because it treats browser interaction as a
first-class commandable runtime, not only as a testing library.

Potential local shape:

```text
Browser-Proof Workflow
  -> Chrome DevTools as discovery truth
  -> optional agent-browser CLI adapter for fast repeatable browser operations
  -> Playwright only after stable scenario extraction
```

The local architecture should not invert the existing proof order. The adapter
is useful as an additional runtime surface, not as proof authority above Chrome
DevTools or persistent Playwright.

Minimum future adapter contract:

- capability inventory
- command mapping
- evidence shape
- cookie/session/state handling policy
- screenshot/video artifact handling
- network mocking boundaries
- failure capture packet

### 2. Active Browser Polishing Lane

The user-observed 15-minute browser polishing loop is an attractive pattern, but
it must be treated as an observer with strict boundaries.

Safe future model:

```text
Scheduled Observer
  -> route / surface allowlist
  -> browser snapshot and visual/UX scan
  -> issue or executive finding
  -> no silent production mutation
  -> proof packet
```

Required guardrails:

- no unbounded authenticated browsing
- no broad cookie exfiltration or storage dumping
- route allowlist by product-criticality
- capped runtime budget
- severity taxonomy before action
- issue/document registration before mutation
- explicit split between observation, triage, implementation, and closure

### 3. Skill-Lab Evaluation Harness

The strongest Z.ai contribution is not browser automation. It is the skill
improvement loop.

The local `self-evolution` surface should evolve from passive recurrence
waiting into a governed evaluation harness:

```text
Skill / Workflow Hypothesis
  -> eval prompts
  -> baseline run
  -> candidate run
  -> assertions / rubric
  -> blind comparison
  -> analyst pass
  -> durable result artifact
  -> narrow workflow change proposal
```

This directly addresses the current local gap: `self-evolution` can now learn
from real external workflow evidence without needing to wait for a production
incident.

### 4. External Skill Vetting Gate

Any harvested third-party skill must pass a vetting gate before adoption.

The GLM stack itself proves why the gate is needed:

- `agent-browser` can touch cookies, storage, screenshots, JS eval, and network
  routes
- `fullstack-dev` contains platform-specific installation and runtime commands
- several skills are valuable as patterns but unsafe or irrelevant as direct
  imports

The gate should classify findings as:

- `safe-to-adapt`
- `pattern-only`
- `requires-sandbox`
- `reject`

### 5. UI Polishing / Cross-Component Audit Lane

The local premium/product-critical branch is already strong on product judgment,
but the GLM polishing rules add a useful operational layer:

- componentization
- tokenization
- utility centralization
- cross-view consistency
- theme harmony
- z-index and overlap checks
- responsive expansion
- data integrity
- file architecture
- navigation consistency

This should become a product-critical or premium proof companion, not a generic
requirement for every frontend task.

## Rejected Direct Imports

Do not mirror the GLM directory into the local `accelerate` runtime.

Rejected as direct imports:

- Z.ai-specific `fullstack-dev` commands and stack assumptions
- remote `curl | bash` installation patterns
- platform-specific gateway and port assumptions
- root workflow behavior that asks for permission at every step
- business- or project-specific polishing docs copied without normalization
- browser agents with unrestricted session/cookie/storage access

## Executive Plan

### Sprint 1: Register Harvest And Bound The Experiment

Status:

- current artifact

Output:

- durable side-by-side harvest record
- no active workflow doctrine mutation yet

### Sprint 2: External Skill Vetting Gate

Add a native gate for third-party skill and adapter adoption.

Candidate location:

- `core/risk/external-skill-vetting-gate.md`

Acceptance:

- adoption decisions must distinguish direct import, pattern-only harvest,
  sandboxed experiment, and reject

Status:

- landed in `zai-skill-stack-harvest-implementation-result.md`

### Sprint 3: Agent-Browser Runtime Adapter Spec

Add an optional runtime adapter specification.

Candidate location:

- `adapters/runtime/agent-browser/README.md`

Acceptance:

- adapter has capability inventory, evidence shape, session safety rules, and
  proof-order relationship to Chrome DevTools and Playwright

Status:

- landed in `zai-skill-stack-harvest-implementation-result.md`

### Sprint 4: Skill-Lab / Evaluation Harness

Add a native skill/workflow evaluation lane.

Candidate locations:

- `core/workflows/skill-evaluation-lab.md`
- `planning/evaluation/README.md`

Acceptance:

- supports baseline-vs-candidate comparisons
- supports blind comparison and analyst pass
- supports trigger / no-trigger description tests
- records durable benchmark artifacts before any workflow promotion

Status:

- landed in `zai-skill-stack-harvest-implementation-result.md`

### Sprint 5: UI Polishing Observer Lane

Add a product-critical / premium proof companion for recurring visual QA.

Candidate location:

- `core/review/ui-polishing-observer.md`

Acceptance:

- route allowlist
- browser evidence expectations
- severity taxonomy
- no silent mutation rule
- escalation into issue/planning/proof stack

Status:

- landed in `zai-skill-stack-harvest-implementation-result.md`

## Effect On Current Parity Status

This event improves the evidence base for `autoresearch / self-evolution`, but
it does not justify promotion by itself.

Reason:

- the local platform has now captured a real workflow-learning opportunity
- the opportunity produced concrete adaptation targets
- the adaptation has not yet landed in active core/adapter doctrine
- no rerun has shown the new lanes operating successfully

Current recommended verdict:

- `autoresearch / self-evolution`: remains `near parity`
- status note: first real external workflow-learning event captured; next proof
  should be implementation of the vetting/adapter/eval/polishing slices followed
  by a rerun

## Decision

Adopt the GLM/Z.ai stack as a pattern source, not as a source tree.

Highest-value additions:

1. `External Skill Vetting Gate`
2. `agent-browser` runtime adapter specification
3. `Skill-Lab / Evaluation Harness`
4. `UI Polishing / Cross-Component Audit Lane`

Do not install or promote any of these as active runtime behavior until the
corresponding local sprint lands and is verified.
