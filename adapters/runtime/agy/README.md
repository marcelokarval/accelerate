# Antigravity CLI entry adapter

This adapter installs Accelerate's self-contained portable skill to the native
Antigravity user skill directory. It optionally manages a conditional entry rule.
It does not install ASDS, select models, change providers/permissions, or run a
second runtime. Source tests establish installation behavior, not model compliance.

## Native locations and evidence

Checked 2026-10-02 against Google's [skills documentation](https://antigravity.google/docs/skills?app=antigravity-ide)
and [rules documentation](https://www.antigravity.google/docs/rules-workflows?tab=ide):

- Skill: `~/.gemini/config/skills/accelerate/SKILL.md`.
- Optional global rule: `~/.gemini/GEMINI.md`.

The installed `agy` executable's embedded customization documentation also names
`~/.gemini/config/` as global discovery and `skills/<name>/SKILL.md` as the skill
layout. This is Antigravity CLI (`agy`), not the separate Gemini CLI product.
No live discovery or routing qualification is implied by file placement.

## Preview and explicit application

From the Accelerate checkout, preview without creating files or directories:

```sh
python3 -B scripts/install-agy-entry.py
python3 -B scripts/install-agy-entry.py --with-entry-rule
```

The first command plans only the skill; the second includes the conditional rule.
JSON output reports exact paths, before/after sizes and hashes, permissions and
`plan_sha256`. After the owner approves those changes, use the same options:

```sh
python3 -B scripts/install-agy-entry.py --with-entry-rule --apply \
  --expect-plan-sha256 APPROVED_PREVIEW_SHA256
```

`--home /absolute/fixture-home` supports isolated installer tests; production uses
the user's existing home. It is not a launcher or runtime redirection. A fingerprint
binds the preview, not human identity or consent; obtain authorization separately.
No installation is implied by publishing or reviewing this source.

The skill source is `global-runtime/accelerate/SKILL.md`, copied byte-for-byte.
An existing different skill is a conflict, never an implicit upgrade. The rule
comes from `entry-rule.md`; enabling it replaces an exact standalone
`No global skill or workflow bootstrap is configured.` line, if present, or appends
the managed block. All other owner bytes and existing file permissions remain.
Existing identical blocks are idempotent; modified, duplicate or malformed blocks
require explicit reconciliation. No automatic migration of other bootstraps occurs.
The whole rule file must fit the documented 24,000-byte limit.

## Behavior and limits

The conditional instruction bypasses workflows for ordinary conversation and clear
bounded low-risk edits. New structured work loads Accelerate and hands off to ASDS;
accepted ASDS work and worker assignments continue with their owner. Explicit
workflow choices and actual permissions remain authoritative. This prompt policy
requires fresh-session evaluation; fixture tests cannot prove model selection.
ASDS availability is a separate installation/discovery concern.

The installer rejects symlink components, hardlinked target files, payload conflicts
and stale previews. It writes in place using short-lived sibling temporary files,
without disk backups, copies of the repository, staging runtimes or permanent
receipts. Completed temporary writes are removed. Ordinary failures roll back this
invocation's writes using previous bytes held only in memory and remove newly
created directories. Crash recovery, hostile races, extended metadata preservation
and concurrently edited targets are not guaranteed; apply in a quiescent directory.
Rollback conflicts are reported rather than overwriting a concurrent owner edit.
Existing rule content is never printed in preview output.
