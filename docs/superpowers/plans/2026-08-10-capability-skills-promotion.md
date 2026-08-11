# Capability Skills Promotion Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create four on-demand, versioned Agent Skills for the active portfolio and export equivalent copies to Codex and Hermes.

**Architecture:** Keep the versioned source beneath `docs/codex-skill-seeds/skills/`. Each skill is a compact router with focused direct references and a metadata record. A deterministic parity test validates the source before an explicit export to the non-resident Codex catalog and `~/.hermes/skills`; no skill is added to a preload list.

**Tech Stack:** Agent Skills (`SKILL.md`), YAML metadata, Python standard-library validation, Codex catalog, Hermes skill discovery.

---

## Chunk 1: Source contract and validation

### Task 1: Establish the versioned seed contract

**Files:**
- Modify: `docs/codex-skill-seeds/README.md`
- Modify: `docs/codex-skill-seeds/skills/README.md`
- Create: `docs/codex-skill-seeds/skills/_registry/manifest.md`
- Create: `docs/codex-skill-seeds/skills/tests/test_capability_skill_seeds.py`

- [ ] **Step 1: Write the failing validation test**

Assert the four skill directories, matching frontmatter/metadata names, required direct references, and explicit non-preload policy.

- [ ] **Step 2: Run the test to verify it fails**

Run: `python3 docs/codex-skill-seeds/skills/tests/test_capability_skill_seeds.py`

Expected: failure because the four source skills do not exist.

- [ ] **Step 3: Define the source contract**

Update the two transition README files so they describe this tree as the versioned source for global capability skills, while retaining root `skills/` as the standalone Accelerate product surface. Add the small registry with exactly the four skills and their category/placement.

- [ ] **Step 4: Re-run the test**

Expected: still fails only for missing skill packages.

## Chunk 2: Implement the four source skills

### Task 2: Create skill packages with progressive disclosure

**Files:**
- Create: `docs/codex-skill-seeds/skills/{nx-nestjs-monorepo-operations,governed-us-lead-data-acquisition,docker-compose-deployment-operations,chatwoot-conversational-channel-operations}/SKILL.md`
- Create: each package's `metadata.yaml`, `agents/openai.yaml`, `references/*.md`, and `evals/evals.json`

- [ ] **Step 1: Create the minimal skill routers**

Keep each `SKILL.md` below the local target, make triggers and exclusions explicit, route detailed material directly to references, and include a concrete verification contract.

- [ ] **Step 2: Add focused references**

Use only source-specific behavior: Nx/pnpm/Nest/Fastify; US lead provenance and opt-out with privacy as consultation; Compose preflight/deploy/rollback; Chatwoot-first webhook/channel flow.

- [ ] **Step 3: Add metadata and trigger/output eval fixtures**

Make source ownership, runtime placement, and non-resident export explicit. Do not copy foreign runtime paths, credentials, or provider-specific secrets.

- [ ] **Step 4: Run the source test and official validator**

Run: `python3 docs/codex-skill-seeds/skills/tests/test_capability_skill_seeds.py` and `python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py <each-skill>`.

Expected: every source package passes.

## Chunk 3: Promote and prove runtime parity

### Task 3: Export source-equivalent packages to Codex and Hermes

**Files:**
- Create: `~/.codex/skill-catalog-h55-20260730/<skill>/...`
- Modify: `~/.codex/skills/skill-catalog-router/references/index.tsv` (generated index)
- Create: `~/.hermes/skills/<skill>/...`

- [ ] **Step 1: Copy only validated source packages**

Export from the versioned source without changing `~/.codex/skills/` resident discovery directories or Hermes `skills.preload`.

- [ ] **Step 2: Regenerate and validate the Codex catalog index**

Run: `python3 ~/.codex/skills/skill-catalog-router/scripts/build_index.py --write` then `--check`.

- [ ] **Step 3: Verify runtime parity**

Compare file manifests and contents between source, Codex catalog and Hermes, run `quick_validate.py` on each exported skill, and run `hermes tools list --json` only to confirm the Hermes capability surface remains unaffected by a skill-file export.

- [ ] **Step 4: Review the complete change**

Run the source tests, validators, catalog index check and `git diff --check`; perform independent spec and quality reviews before merge.
