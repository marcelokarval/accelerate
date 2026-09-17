# DSH Accelerate Bootstrap Implementation Plan

> **Execution note:** Apply this plan task-by-task with red/green TDD. Do not
> mutate deployed user-home runtimes until Task 9's cutover gate. Do not commit
> or discard unrelated worktree changes.

**Goal:** Make `accelerate` the prompt-mandatory, proportionate entry classifier for
the DSH `code-orchestrated` preset, add portable operational skills for DSH,
OpenHands, and OmniRouter, and project those skills into OpenCode,
DSH/OpenHands, Codex, and Hermes from one repository authority.

**Architecture:** Keep classification semantic and portable in Accelerate.
Add a DSH adapter that maps Accelerate routes onto native DSH tools and aliases,
then inject only a compact bootstrap into the live preset. Canonical operational
skills live in `skills/operations/`; a guarded materializer copies identical bundles
to runtime-specific roots with digest markers and refuses unmanaged targets.
Codex receives explicit catalog entries; other runtimes use their native skill
discovery. Mechanical DSH enforcement remains deferred until runtime evidence
justifies a Cordis plugin.

**Implementation stack:** Markdown skills and policy, JSON Schema, Python 3.11
standard library (`argparse`, `hashlib`, `json`, `pathlib`, `shutil`, `tempfile`,
`tomllib`, `unittest`), Bash proof scripts, Cordis YAML, existing Accelerate
validators and catalog renderers.

**Authoritative design:**
`docs/superpowers/specs/2026-08-21-dsh-accelerate-bootstrap-design.md`

## Guardrails

- Treat `/home/marcelo-karval/Backup/Projetos/accelerate` as authority.
- Treat all copies under user-home runtime directories as generated projections.
- Preserve the existing modifications to `SKILL.md`,
  `scripts/sync-openhands-provider-credentials.py`,
  `references/release-update-governance.md`, and existing `__pycache__` paths.
- Never read, print, copy, or commit provider credentials. Tests use temporary
  roots and synthetic values only.
- Keep the live DSH checkout pinned to `dsh-v0.1.1-rc.2` and preserve its two
  documented local patches. This plan does not update DSH source.
- Do not patch DSH core. The deferred Cordis plugin is documentation-only here.
- Do not claim OpenHands native child dispatch; its current child contract is
  prompt-only until a separate runtime proof changes that status.
- Do not commit automatically. The commit boundaries below are recommended
  checkpoints for an operator who explicitly requests commits.

## Verification Strategy

The evidence ladder is intentionally layered:

1. Unit tests prove packet validation, bootstrap idempotence, safe projection,
   digest drift detection, and unmanaged-target refusal.
2. Repository truth tests prove registry/catalog consistency and portable skill
   structure.
3. Dry-run/readback proves the live targets can be reconciled without exposing
   secrets or overwriting user-owned files.
4. Fresh disposable runtime sessions prove discovery and behavior. Existing
   sessions are not accepted because their prompts and catalogs may be cached.
5. DSH behavior is tested across no-op, trivial bounded, bounded research,
   ambiguous, independent-lane, and missing-skill cases. The expected proof is
   route-proportionate tool behavior, not a specific natural-language sentence.

## Chunk 1: Portable Contract And DSH Adapter

### Task 1: Define the hardened execution packet

**Files:**

- Create: `core/contracts/hardened-execution-packet.schema.json`
- Create: `scripts/validate-hardened-execution-packet.py`
- Create: `tests/test_hardened_execution_packet.py`
- Create: `core/contracts/README.md`

**Step 1: Write failing tests**

Add `unittest` cases for:

- valid `non-trivial` packets for `scoped` and `orchestrated` routes;
- rejection of direct/no-op/trivial packets as disproportionate hardening;
- missing objective, success criteria, authority, scope, known-fact,
  unresolved-decision, risk, acceptance, proof, model, delegation, or stop fields;
- `orchestrated` packets with no independent task topology;
- secret-like values in packet payloads;
- unknown fields, so the contract cannot drift silently.

Use a packet shape with these required top-level keys:

```json
{
  "schema_version": 1,
  "classification": "non-trivial",
  "objective": "Implement a bounded behavior change",
  "success_criteria": ["focused tests pass"],
  "authority_set": ["repository policy", "live runtime readback"],
  "scope": {"in": ["src/"], "non_goals": ["credential migration"]},
  "known_facts": ["public API exists"],
  "unresolved_decisions": ["exact internal boundary"],
  "risk_classification": {"level": "medium", "reasons": ["cross-file behavior"]},
  "acceptance_criteria": ["focused tests pass"],
  "proof_plan": ["run focused-test-command"],
  "execution_route": "orchestrated",
  "model_decision": {"model": "auto/best-coding", "effort": "medium", "reason": "implementation"},
  "delegation_decision": {
    "mode": "physical",
    "reason": "independent implementation and proof lanes",
    "tasks": [
      {"id": "T1", "owner": "implementation", "depends_on": [], "deliverable": "change"},
      {"id": "T2", "owner": "qa", "depends_on": ["T1"], "deliverable": "evidence"}
    ]
  },
  "stop_conditions": ["authority conflict", "failed required proof"]
}
```

Run:

```bash
python3 -m unittest tests.test_hardened_execution_packet -v
```

Expected: FAIL because the schema and validator do not exist.

**Step 2: Implement the minimal schema and validator**

The validator must:

- parse one JSON file;
- enforce the checked-in schema without adding a third-party dependency;
- reject extra properties recursively where the schema declares them closed;
- enforce semantic route/class rules in Python;
- scan values for credential-bearing keys and common token/private-key forms;
- print only field paths and safe reasons on rejection, never rejected values;
- exit `0` on success and non-zero on invalid input.

Keep hardened-packet applicability narrow:

| Classification | Allowed route |
| --- | --- |
| `non-trivial` | `scoped`, `orchestrated` |

The adapter and preset tests own the full classification matrix. A
`conversational/no-op` request produces no execution artifact. Clear
`trivial-bounded` work uses the compact branch contract from Task 4 rather than
this schema.

**Step 3: Run focused tests**

```bash
python3 -m unittest tests.test_hardened_execution_packet -v
```

Expected: PASS.

**Step 4: Document authority and consumers**

Create `core/contracts/README.md` to state that the packet is an Accelerate
semantic contract. DSH is the first consumer; it is not the packet authority.

**Step 5: Recommended commit boundary**

```bash
git add core/contracts/hardened-execution-packet.schema.json \
  core/contracts/README.md scripts/validate-hardened-execution-packet.py \
  tests/test_hardened_execution_packet.py
git commit -m "feat: define hardened execution packet"
```

### Task 2: Add the DSH runtime adapter

**Files:**

- Create: `adapters/runtime/dsh/README.md`
- Create: `adapters/runtime/dsh/adapter-policy.json`
- Create: `adapters/runtime/dsh/validate-adapter.py`
- Create: `tests/test_dsh_runtime_adapter.py`
- Modify: `adapters/runtime/README.md`
- Modify: `adapters/runtime/cross-runtime-bootstrap-manifest.json`
- Modify: `adapters/runtime/runtime-consumer-registry.json`

**Step 1: Write failing adapter tests**

Test these exact policy facts:

- runtime id is `dsh` and status is `supported`;
- enforcement is `prompt-enforced`;
- root model alias is `auto/best-coding`;
- ambiguity/architecture/risk maps to `subagent_reasoning` and
  `auto/best-reasoning`;
- bounded factual research maps to `subagent_fast` and `auto/best-fast`;
- implementation/QA maps to the normal DSH subagent primitive and
  `auto/best-coding`;
- multiple independent implementation/proof lanes map to `workflow`;
- root retains hardening, fan-in, integration, review-of-review, and closure;
- maximum concurrent children is `4`;
- no-op and trivial routes prohibit unnecessary delegation;
- unsupported child types fail closed rather than being invented;
- missing Accelerate, reasoning-child failure, required-dispatch failure, and
  runtime/policy disagreement produce the design's explicit blocked/degraded
  outcomes rather than silent fallback;
- material mutation invalidates affected proof receipts;
- the deferred plugin is marked `planned`, not `available`.

Run:

```bash
python3 -m unittest tests.test_dsh_runtime_adapter -v
```

Expected: FAIL because the adapter does not exist.

**Step 2: Implement adapter policy and validator**

Use the repository's existing runtime-adapter vocabulary. `validate-adapter.py`
must check required fields, tool/alias mappings, retained root duties, max
concurrency, and consistency with the two runtime registries.

`README.md` must clearly distinguish:

- DSH native tool availability;
- prompt-level Accelerate obligations;
- behavior that a future Cordis plugin may enforce;
- behavior that is not currently enforced mechanically.

**Step 3: Register DSH**

Add DSH to the cross-runtime bootstrap manifest and runtime consumer registry.
Use source checkout `/home/marcelo-karval/.deepseek-harness` only as runtime
identity metadata, never as policy authority.

**Step 4: Run adapter tests and broad runtime semantics tests**

```bash
python3 -m unittest tests.test_dsh_runtime_adapter \
  tests.test_other_runtime_adapters \
  tests.test_runtime_delegation_semantics -v
```

Expected: PASS.

**Step 5: Recommended commit boundary**

```bash
git add adapters/runtime/dsh adapters/runtime/README.md \
  adapters/runtime/cross-runtime-bootstrap-manifest.json \
  adapters/runtime/runtime-consumer-registry.json \
  tests/test_dsh_runtime_adapter.py
git commit -m "feat: add dsh runtime adapter"
```

### Task 3: Export DSH semantics with the portable Accelerate bundle

**Files:**

- Create: `global-runtime/accelerate/references/dsh-runtime-adapter.md`
- Create: `global-runtime/accelerate/assets/hardened-execution-packet.template.json`
- Modify: `global-runtime/accelerate/SKILL.md`
- Modify: `global-runtime/accelerate/README.md`
- Modify: `tests/skill-export-proof.sh`

**Step 1: Extend the export proof first**

Require the portable bundle to contain the DSH reference and packet template.
Require the DSH reference to name `subagent_reasoning`, `subagent_fast`, all
three OmniRouter aliases, the concurrency ceiling, and root-retained duties.

Run:

```bash
bash tests/skill-export-proof.sh
```

Expected: FAIL because the new portable resources do not exist.

**Step 2: Add the minimal portable mapping**

Add one short dispatch section to `global-runtime/accelerate/SKILL.md`:

- detect the DSH collaboration/tool surface;
- load the DSH reference before physical dispatch;
- classify every request before selecting tools;
- create a hardened packet only when ambiguity or multi-phase work warrants it;
- do not delegate no-op or trivial bounded work merely because tools exist.

The reference must mirror adapter semantics without claiming mechanical
enforcement. The template must satisfy Task 1's schema.

**Step 3: Run export and packet validation**

```bash
bash tests/skill-export-proof.sh
python3 scripts/validate-hardened-execution-packet.py \
  global-runtime/accelerate/assets/hardened-execution-packet.template.json
```

Expected: PASS.

**Step 4: Recommended commit boundary**

```bash
git add global-runtime/accelerate tests/skill-export-proof.sh
git commit -m "feat: export accelerate dsh semantics"
```

## Chunk 2: Preset Bootstrap

### Task 4: Build a guarded DSH preset installer

**Files:**

- Create: `adapters/runtime/dsh/code-orchestrated-bootstrap.md`
- Create: `adapters/runtime/dsh/install-code-orchestrated-bootstrap.py`
- Create: `tests/test_dsh_preset_bootstrap.py`

**Step 1: Write failing fixture tests**

Use temporary preset trees. Test:

- dry-run detects missing bootstrap and makes no changes;
- `--apply` inserts exactly one managed block;
- a second `--apply` is byte-for-byte idempotent;
- changed managed content is replaced atomically;
- an unexpected preset shape or duplicate managed markers fails closed;
- an absent `code-orchestrated` preset fails closed;
- unrelated YAML content is preserved byte-for-byte;
- backup/rollback restores the original if replacement fails;
- no absolute authority path is embedded in the managed prompt.

Run:

```bash
python3 -m unittest tests.test_dsh_preset_bootstrap -v
```

Expected: FAIL because the installer does not exist.

**Step 2: Write the compact bootstrap contract**

The managed prompt block must require the root agent to:

1. load `accelerate` before engineering execution;
2. classify the request as `conversational/no-op`, `trivial-bounded`, or
   `non-trivial`;
3. choose `direct`, `scoped`, or `orchestrated` proportionately;
4. for clear bounded work, emit the compact contract
   `goal | target | constraints | proof | residuals` before task actions;
5. invoke `subagent_reasoning` only for ambiguity, architecture, risk, or
   critical review;
6. invoke `subagent_fast` only for bounded factual research;
7. use `workflow` for multiple independent implementation/proof lanes;
8. cap active children at four;
9. keep synthesis, integration, review-of-review, and closure in the root;
10. stop rather than invent a tool or agent type that is unavailable.

Keep detailed policy in the loaded skill, not in YAML.

**Step 3: Implement the installer**

Default to dry-run. Require both `--preset-dir` and explicit `--apply` for
mutation. Use managed begin/end markers, a SHA-256 digest, a same-directory
temporary file, and `os.replace`. Before replacement, write a timestamped
backup under `<preset-dir>/.accelerate-backups/` and print its path. Support
`--rollback BACKUP_PATH` only for a regular backup under that directory. Never
rewrite `preset.yml`; only reconcile `agent.cordis.yml`.

**Step 4: Run focused tests**

```bash
python3 -m unittest tests.test_dsh_preset_bootstrap -v
```

Expected: PASS.

**Step 5: Recommended commit boundary**

```bash
git add adapters/runtime/dsh/install-code-orchestrated-bootstrap.py \
  adapters/runtime/dsh/code-orchestrated-bootstrap.md \
  tests/test_dsh_preset_bootstrap.py
git commit -m "feat: add dsh accelerate bootstrap installer"
```

## Chunk 3: Operational Skills And Catalogs

### Task 5: Create the three canonical operational skills

**Files:**

- Create: `skills/operations/dsh-operations/SKILL.md`
- Create: `skills/operations/dsh-operations/references/runbook.md`
- Create: `skills/operations/dsh-operations/evals/trigger-cases.md`
- Create: `skills/operations/openhands-operations/SKILL.md`
- Create: `skills/operations/openhands-operations/references/runbook.md`
- Create: `skills/operations/openhands-operations/evals/trigger-cases.md`
- Create: `skills/operations/omnirouter-operations/SKILL.md`
- Create: `skills/operations/omnirouter-operations/references/runbook.md`
- Create: `skills/operations/omnirouter-operations/evals/trigger-cases.md`
- Create: `adapters/runtime/omnirouter/README.md`
- Create: `adapters/runtime/omnirouter/capabilities.yaml`
- Modify: `adapters/runtime/openhands/capabilities.yaml`
- Modify: `adapters/runtime/openhands/accelerate-bootstrap-projection.md`
- Modify: `skills/_registry/manifest.md`
- Modify: `skills/README.md`

**Step 1: Add failing registry assertions**

Extend `scripts/validate-skill-registry.sh` or its existing fixture proof to
require all three names, category `operations`, regular `SKILL.md` files, valid
frontmatter, local references, and `local-authoritative` status.

Run:

```bash
bash scripts/validate-skill-registry.sh
```

Expected: FAIL while registry entries point to absent skills.

**Step 2: Author `dsh-operations`**

Cover only operationally verified behavior:

- pinned version and checkout/state locations;
- service status, logs, HTTP health, and Web GUI checks;
- `code-orchestrated` preset inspection and fresh-session boundary;
- skill roots and catalog/readback checks;
- provider alias checks through OmniRouter;
- preservation/reapplication of the two local patches during upgrades;
- backup and rollback;
- explicit warning that LAN mode has no authentication;
- no credential values or instructions to print secret-bearing files.

**Step 3: Author `openhands-operations`**

Cover:

- service status, logs, health, and disposable-session proof;
- governed skill projection/readback;
- governed model-profile inspection;
- MCP health including `open-design`;
- current `prompt-contract-only` child-dispatch limitation;
- safe restart, backup, and rollback;
- refusal to claim user-skill discovery until a fresh session proves it.

**Step 4: Author `omnirouter-operations`**

Cover:

- service status, logs, health, and OpenAI-compatible tool-call smoke tests;
- aliases `auto/best-coding`, `auto/best-reasoning`, `auto/best-fast`;
- `priority` strategy and `failoverBeforeRetry: true`;
- distinction between router responsibility and agent workflow responsibility;
- synthetic/no-secret test payloads;
- safe reload, backup, rollback, and fallback verification.

**Step 5: Validate the registry**

Before validation, add held-out `should trigger` and `should not trigger` cases
for every skill. Link the OpenHands skill from its existing adapter and define
OmniRouter's capability boundary in its new adapter: routing, priority,
concurrency, and failover only, never classification or closure.

```bash
bash scripts/validate-skill-registry.sh
```

Expected: PASS.

**Step 6: Recommended commit boundary**

```bash
git add skills/operations/dsh-operations \
  skills/operations/openhands-operations \
  skills/operations/omnirouter-operations \
  adapters/runtime/openhands adapters/runtime/omnirouter \
  skills/_registry/manifest.md skills/README.md \
  scripts/validate-skill-registry.sh
git commit -m "feat: add runtime operations skills"
```

### Task 6: Define portable projections and Codex catalog truth

**Files:**

- Create: `adapters/runtime/operational-skill-projections.toml`
- Modify: `adapters/runtime/codex/skill-catalog-manifest.toml`
- Modify: `tests/codex-skill-catalog-truth.sh`
- Modify: `adapters/runtime/README.md`

**Step 1: Add failing catalog tests**

Require the projection registry to contain these targets:

| Runtime target | Generated root |
| --- | --- |
| `opencode` | `~/.config/opencode/skills` |
| `agents` | `~/.agents/skills` |
| `codex` | `~/.codex/skills` |
| `hermes` | `~/.hermes/skills/runtime` |

Require exactly the same three source skill paths for every target. Add the
three skills to the Codex on-demand catalog and update generated disabled-count
expectations from the manifest-derived result, not by guessing in production
code.

Run:

```bash
bash tests/codex-skill-catalog-truth.sh
```

Expected: FAIL because entries and projections are absent.

**Step 2: Add registry and catalog entries**

The projection registry records source path, runtime target key, target suffix,
and marker schema. It must not contain credentials or machine-specific home
paths. Add Codex entries as on-demand operational skills; do not make them
always-on root skills.

**Step 3: Validate catalog truth**

```bash
bash tests/codex-skill-catalog-truth.sh
python3 scripts/validate-codex-skill-catalog.py \
  adapters/runtime/codex/skill-catalog-manifest.toml
```

Expected: PASS.

**Step 4: Recommended commit boundary**

```bash
git add adapters/runtime/operational-skill-projections.toml \
  adapters/runtime/codex/skill-catalog-manifest.toml \
  adapters/runtime/README.md tests/codex-skill-catalog-truth.sh
git commit -m "feat: register portable operations skills"
```

### Task 7: Implement the guarded multi-runtime materializer

**Files:**

- Create: `scripts/install-operational-skills.py`
- Create: `tests/test_install_operational_skills.py`

**Step 1: Write failing unit tests**

Import the script through `importlib.util` and test temporary source/target
trees. Cover:

- dry-run returns drift count and writes nothing;
- `--apply` creates all three copies and markers;
- idempotent second apply;
- source edits produce drift and atomic replacement;
- unmanaged directory, file, or symlink is refused;
- malformed marker is refused;
- symlinks or special files in source are refused;
- target path traversal and duplicate names are refused;
- apply rollback restores the prior managed tree on replacement failure;
- each apply writes a run manifest and persistent rollback data;
- `--rollback RUN_ID` restores prior managed trees and removes newly-created
  trees only when their current marker still matches that run;
- projection roots resolve under an injected `--home`, enabling safe tests;
- each target's copied tree digest equals the canonical source digest.

Run:

```bash
python3 -m unittest tests.test_install_operational_skills -v
```

Expected: FAIL because the materializer does not exist.

**Step 2: Implement the minimum safe materializer**

Reuse the proven invariants from `install-openhands-governed-skills.py`, but do
not broaden or refactor that existing installer in this task. Support:

```text
--runtime opencode|agents|codex|hermes
--home PATH
--registry PATH
--backup-root PATH
--apply
--rollback RUN_ID
```

Default to dry-run. Write `.accelerate-operational-skill.json` with
`managed_by`, `managed_schema`, `name`, `runtime`, and `source_digest`. Only
replace a target carrying a valid matching marker. Stage under the destination
parent and use `os.replace`. Default backup storage to
`~/.local/state/accelerate/backups/operational-skills`; write a run manifest
before mutation, retain prior managed trees there, and print the rollback id.

**Step 3: Run focused tests**

```bash
python3 -m unittest tests.test_install_operational_skills -v
```

Expected: PASS.

**Step 4: Run all materialization-related tests**

```bash
python3 -m unittest tests.test_install_operational_skills \
  tests.test_model_lanes -v
bash tests/global-skill-mirror-stage.sh
```

Expected: PASS, proving the new installer did not change OpenHands Accelerate
materialization semantics.

**Step 5: Recommended commit boundary**

```bash
git add scripts/install-operational-skills.py \
  tests/test_install_operational_skills.py
git commit -m "feat: materialize runtime operations skills"
```

## Chunk 4: Repository Closure And Live Cutover

### Task 8: Add repository-level acceptance proofs

**Files:**

- Create: `tests/dsh-accelerate-bootstrap-truth.sh`
- Create: `tests/operational-skill-projection-truth.sh`
- Create: `tests/operational-skill-trigger-truth.sh`
- Modify: `README.md`
- Modify: `docs/superpowers/specs/2026-08-21-dsh-accelerate-bootstrap-design.md`

**Step 1: Write truth tests before documentation closure**

`dsh-accelerate-bootstrap-truth.sh` must run the adapter validator, packet
validator, preset fixture tests, and export proof. It must reject prose that
claims the deferred Cordis plugin is active.

`operational-skill-projection-truth.sh` must run registry validation, catalog
truth, materializer tests, then materialize all four targets under a temporary
home and compare every generated digest to its source.

`operational-skill-trigger-truth.sh` must verify that every operational skill
has durable held-out `should trigger` and `should not trigger` cases and that
each case names the expected skill or an explicit no-trigger result.

Run:

```bash
bash tests/dsh-accelerate-bootstrap-truth.sh
bash tests/operational-skill-projection-truth.sh
bash tests/operational-skill-trigger-truth.sh
```

Expected: PASS.

**Step 2: Close documentation gaps**

Update `README.md` with:

- DSH adapter status and preset installer command;
- canonical operational skill paths;
- dry-run/apply commands for all four projection targets;
- fresh-process/session readback requirement;
- rollback and authority rules;
- deferred native DSH plugin criteria.

Update the design only for factual implementation deltas. Preserve its
`Deferred Native DSH Plugin` section and OpenCode projection correction.

**Step 3: Run broad static verification**

```bash
python3 -m unittest discover -s tests -p 'test_*.py' -v
bash scripts/validate-skill-registry.sh
bash tests/skill-export-proof.sh
bash tests/codex-skill-catalog-truth.sh
bash tests/global-skill-mirror-stage.sh
bash tests/dsh-accelerate-bootstrap-truth.sh
bash tests/operational-skill-projection-truth.sh
bash tests/operational-skill-trigger-truth.sh
git diff --check
```

Expected: all commands PASS. If an unrelated pre-existing test fails, capture
the exact failure and prove whether it reproduces without this change; do not
silently edit unrelated files.

**Step 4: Recommended commit boundary**

```bash
git add README.md \
  docs/superpowers/specs/2026-08-21-dsh-accelerate-bootstrap-design.md \
  tests/dsh-accelerate-bootstrap-truth.sh \
  tests/operational-skill-projection-truth.sh \
  tests/operational-skill-trigger-truth.sh
git commit -m "test: prove dsh bootstrap and skill projections"
```

### Task 9: Dry-run and apply the live projections

**Files outside repository:**

- Reconcile: `/home/marcelo-karval/.dsh/.agent-presets/code-orchestrated/agent.cordis.yml`
- Reconcile: `/home/marcelo-karval/.config/opencode/skills/{dsh-operations,openhands-operations,omnirouter-operations}`
- Reconcile: `/home/marcelo-karval/.agents/skills/{dsh-operations,openhands-operations,omnirouter-operations}`
- Reconcile: `/home/marcelo-karval/.codex/skills/{dsh-operations,openhands-operations,omnirouter-operations}`
- Reconcile: `/home/marcelo-karval/.hermes/skills/runtime/{dsh-operations,openhands-operations,omnirouter-operations}`

**Step 1: Capture safe pre-cutover evidence**

```bash
git status --short
python3 adapters/runtime/dsh/install-code-orchestrated-bootstrap.py \
  --preset-dir /home/marcelo-karval/.dsh/.agent-presets/code-orchestrated
python3 scripts/install-openhands-governed-skills.py
python3 scripts/install-operational-skills.py --runtime opencode
python3 scripts/install-operational-skills.py --runtime agents
python3 scripts/install-operational-skills.py --runtime codex
python3 scripts/install-operational-skills.py --runtime hermes
```

Expected: dry-runs report only intended drift and no writes. If any destination
is unmanaged, stop and request an operator decision; never adopt it silently.

**Step 2: Cutover gate**

Before mutation, confirm all static verification from Task 8 is green and the
dry-run found no unmanaged collision. The approved design authorizes these
specific generated projections; any additional runtime/config mutation requires
new approval.

**Step 3: Apply bootstrap and projections**

First archive the currently managed Accelerate projection without reading its
contents. Record the generated directory name for rollback:

```bash
BACKUP_DIR="/home/marcelo-karval/.local/state/accelerate/backups/dsh-bootstrap/$(date -u +%Y%m%dT%H%M%SZ)"
install -d -m 700 "$BACKUP_DIR"
tar -C /home/marcelo-karval/.agents/skills -czf "$BACKUP_DIR/accelerate.pre-cutover.tar.gz" accelerate
```

Then apply:

```bash
python3 adapters/runtime/dsh/install-code-orchestrated-bootstrap.py \
  --preset-dir /home/marcelo-karval/.dsh/.agent-presets/code-orchestrated --apply
python3 scripts/install-openhands-governed-skills.py --apply
python3 scripts/install-operational-skills.py --runtime opencode --apply
python3 scripts/install-operational-skills.py --runtime agents --apply
python3 scripts/install-operational-skills.py --runtime codex --apply
python3 scripts/install-operational-skills.py --runtime hermes --apply
```

Expected: each command reports successful reconciliation and every mutating
installer prints a rollback path or id. Do not restart services yet.

**Step 4: Prove idempotence and readback**

Repeat the six dry-run commands from Step 1. Expected: zero drift.

Read back only managed marker files, skill names/frontmatter, and the managed
preset block. Do not dump complete runtime configs or settings files because
they may contain credentials.

**Step 5: Rollback rule**

If projection readback fails, use the printed preset backup or operational-skill
rollback id for the failing operation and stop. The existing governed
Accelerate installer must be restored only from its pre-cutover managed copy.
Do not use `git checkout`, `git reset`, or delete unrelated runtime skill
directories.

### Task 10: Prove fresh runtime behavior

**No repository files should change during this task.**

**Step 1: DSH discovery and bootstrap proof**

Open a fresh disposable DSH session with `code-orchestrated`. Verify the skill
catalog exposes `accelerate` and the three operational skills. Use these probes:

| Probe | Expected evidence |
| --- | --- |
| `Reply with the word ready only.` | classified no-op/direct; no child tool |
| `Fix one typo in a named file and prove the diff.` | Accelerate loaded; compact branch contract; no child |
| `Find the pinned DSH release in one named source.` | bounded research through `subagent_fast`; root reports source |
| `Design and verify a multi-file change with unclear constraints; do not mutate.` | Accelerate loaded; hardened packet; reasoning child; root synthesis |
| `Plan two independent read-only checks and combine the evidence.` | workflow path; at most four children; root challenges and synthesizes |
| In an isolated DSH process with temporary `HOME`, omit the Accelerate projection. | explicit blocked result; no engineering mutation |

Inspect session events/tool calls rather than accepting prose claims. Confirm no
more than four children and that the root performs final synthesis. Never
remove or rename the live Accelerate projection to run the missing-skill probe.

**Step 2: OpenCode discovery proof**

Start a fresh OpenCode process and verify all three skills appear in the native
catalog. Load each once and confirm its runbook path resolves under the
generated bundle.

**Step 3: Codex discovery proof**

Regenerate/apply the governed Codex catalog using the repository's existing
catalog workflow, start a fresh Codex process, and confirm each skill is
on-demand rather than always-on. Do not edit `~/.codex/config.toml` manually and
do not print it.

**Step 4: Hermes discovery proof**

Start a fresh Hermes session and confirm recursive discovery under
`~/.hermes/skills/runtime`. Invoke each skill by exact name once. Confirm
`using-superpowers` remains the preload root and that these skills do not
replace its classification role.

**Step 5: OpenHands discovery proof**

Start a disposable OpenHands session after its normal supported restart/reload
boundary. Confirm the generated skills are actually visible before claiming
support. If they are absent, record the runtime evidence and stop; investigate
the official user-skill loader separately instead of modifying opaque state or
claiming success.

**Step 6: OmniRouter smoke proof**

Use the operational skill's safe local smoke command to test one tool call per
alias and the documented fallback path. Record route/model identifiers and
success/failure only; never record authorization headers or provider payload
secrets.

### Task 11: Final review and closure

**Step 1: Inspect only intended diff**

```bash
git status --short
git diff --stat
git diff --check
```

Confirm pre-existing unrelated changes remain untouched and unstaged.

**Step 2: Review against the design**

Check each acceptance criterion in the authoritative design. Explicitly record:

- DSH adapter enforcement remains prompt-level;
- Cordis plugin remains deferred;
- OpenHands child dispatch remains prompt-contract-only;
- operational bundles are generated copies;
- runtime readback result for each of five consumers;
- any proof that could not be completed.

**Step 3: Independent review attempt**

Request a read-only code/spec review if a valid review subagent is available.
If agent dispatch still rejects all supported reviewer types, record
`independent review unavailable` with the tool error and perform a local
requirements/security review. Do not describe the local review as independent.

**Step 4: Re-run verification after review fixes**

Repeat Task 8 Step 3 and only the live probes affected by review fixes.

**Step 5: Final report**

Report changed repository files, deployed projections, static test evidence,
fresh runtime evidence, residual limitations, and rollback location. Do not
claim completion for a runtime whose fresh-session discovery was not observed.

## Deferred Follow-Up: Native DSH Cordis Plugin

Do not implement this in the current plan. Promote it into a separate design
only when all conditions hold:

1. Prompt-only operation has produced recurring, documented policy violations.
2. DSH's plugin API is stable enough to avoid patching core.
3. The plugin can consume Accelerate classification receipts rather than
   becoming a second classifier.
4. It can fail closed before mutation, invalidate stale evidence after mutation,
   and emit actionable diagnostics.
5. Fixture and live-session tests can prove it without weakening direct/trivial
   paths.

## Known Separate Follow-Ups

- Resolve Codex's required `napkin` skill/catalog drift in a separate bounded
  change; it is not part of this bootstrap.
- Rotate credentials previously exposed in local tool output and migrate
  literal secrets out of user configuration in a separate security task.
- Reconcile OpenHands documentation/version drift separately.
