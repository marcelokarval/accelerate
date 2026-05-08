# Skill Sync Topology

This topology makes Accelerate's repo-local skill authority operational. Skills
may be exported from this repository to runtime hosts, but user-home catalogs are
not governing authority for this repository.

## Source-Of-Truth Rule

The source of truth is repo-local and self-contained:

- `SKILL.md`
- `skills/README.md`
- `skills/_registry/`
- skill directories under `skills/`
- governing references from `core/`, `adapters/`, `profiles/`, `onboarding/`,
  `planning/`, and `references/`

Do not treat `~/.claude/skills`, `~/.codex/skills`, `~/.agents/skills`, or any
other user-home catalog as authority. External catalogs can be consulted only as
import candidates. Useful material must be imported, adapted, registered, and
enforced in this repository before it can govern Accelerate.

## Sync Direction

| Edge | Status | Direction | Boundary | Proof locator | Promotion condition | Demotion condition |
| --- | --- | --- | --- | --- | --- | --- |
| Repo skill source to generated runtime export | `planned` | `repo -> generated export -> host runtime` | Generated bundles are deployment artifacts; they are not source truth. | `skills/README.md`; `skills/_registry/manifest.md` when present; this topology | A generated bundle can be promoted only when it is reproducible from repo-local files, has a manifest/provenance entry, and passes drift detection. | Demote if generated files differ from repo source without a recorded generation command or provenance. |
| User-home skill catalog to repo | `blocked` | `external candidate -> import review -> repo-local source` | No direct authority transfer from user home. | `AGENTS.md`; `skills/README.md`; this topology | Promote only through an import task that adapts content, registers it locally, and adds tests/contracts if it becomes mandatory. | Demote/remove if a repo doc relies on a user-home path as governing authority. |
| Repo skill source to project overlay | `substitute` | `repo -> overlay draft` | Overlay drafts may specialize behavior but cannot rewrite core law. | `skills/overlays/`; `core/control-plane/authority-set-gate.md` | Promote when the overlay is bounded, registered, and referenced by a profile or task packet. | Demote if overlay becomes global doctrine or lacks an owning source. |
| Repo skill source to agent factory role envelope | `linked` | `repo -> skill envelope -> candidate role` | Agent roles consume skill envelopes; they do not create autonomous runtime availability. | `core/control-plane/agent-factory-promotion-pipeline.md` | Promote a role only when the envelope is complete and proof replay passes. | Demote when required skill references are missing, stale, or unregistered. |

## Sync Artifact Boundaries

Allowed durable artifacts:

- repo-local skill source files under `skills/`;
- registry/provenance docs under `skills/_registry/`;
- control-plane references to the skill topology;
- tests that verify mandatory skills and source-of-truth language.

Generated or private artifacts must not become source truth:

- host-specific exported bundles;
- user-home skill copies;
- local runtime caches;
- private provider outputs;
- temporary prompt or agent transcripts.

If an export is needed, create it as a reproducible deployment step from the repo
outward. The export may be useful operationally, but governance remains here.

## Drift Detection Command / Contract

Run the skill topology contract before claiming a skill bundle is current:

```bash
bash tests/control-plane-rc4-rc6.sh
```

A full drift check must verify:

1. `skills/README.md` preserves repo-local source-of-truth language.
2. Mandatory skill references in `SKILL.md`, `core/`, `adapters/`, `profiles/`,
   `agents/` if present, and `references/` either exist under `skills/` or are
   listed as temporary migration gaps in `skills/_registry/manifest.md`.
3. No governing doc claims user-home catalogs are authority.
4. Generated bundles, if present, identify the repo source commit or manifest.
5. Promotion status does not move beyond `planned`, `substitute`, or `linked`
   without reproducible generation proof.

## Promotion Criteria For Generated Skill Bundles

A generated skill bundle may be promoted from `planned` to `available` only when:

- the generation command is documented;
- source files all come from this repository;
- provenance records the source commit or registry version;
- drift detection passes;
- export destination is identified as generated runtime deployment, not source
  authority;
- cleanup rules remove stale host copies when repo source changes.

## Cleanup Rules

- Delete or regenerate stale exported bundles instead of editing them by hand.
- Do not commit user-home catalogs or host runtime caches.
- If a skill is retired, remove mandatory references or move the skill to
  `skills/legacy/` with a migration note.
- If drift is detected, block promotion until the repo source, registry, and
  generated export agree.
