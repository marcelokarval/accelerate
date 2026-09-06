# Release Update Governance

Use this contract for updates to persistent CLIs, daemons, gateways, desktop
backends, agent runtimes, and other managed applications.

## Core rule

Treat an immutable published release, version, or tag as the stable authority.
Never equate a moving branch such as `main` or `master` with the stable channel.
An option named `--latest` is not sufficient proof: inspect the installed
source first and determine what that option resolves for that installation.

## Required sequence

1. Read the official release source and freeze the exact version, tag, digest,
   or commit behind the release.
2. Inspect installed provenance: package channel, git ref, payload path,
   runtime version, service launcher, and active process.
3. Run check/dry-run and compare its target with the frozen release.
4. Fail closed if `latest` resolves to a moving branch or a different target.
   Use the official exact-version/tag migration path instead.
5. Use the supported build runtime used by the active service, not an
   incidental shell runtime.
6. Freeze health, state authority, identity/count invariants, and a fresh
   recoverable backup before cutover.
7. Install the immutable target and restart only the owned service if needed.
8. Read back CLI/service versions, payload provenance, migrations, health,
   state invariants, logs, and update availability.
9. Preserve or explicitly disposition rollback payloads and temporary roots.

## Stop rules

- Do not chase a branch that advances after the denominator was frozen.
- Do not disable backup merely to make an updater proceed.
- Allow at most one evidence-backed retry for a proven runtime mismatch.
- After rollback, prove active payload, process, health, data, and service
  state directly; installer prose is not runtime truth.
- Name a retained failed candidate as rollback history or residue. Never
  confuse it with the active release.

## Paperclip specialization

Inspect `~/.paperclip/cli/install.json` before updating Paperclip.

- With `source=npm`, `paperclipai update --latest` may follow the published
  stable channel, but its resolved version must match the official release.
- With `source=git` and `ref=main` or `ref=master`, `update --latest` follows
  that moving branch in current managed installs. It is not a stable update.
- Migrate to the immutable published release with
  `paperclipai install --version <published-version> --yes`. Use an exact git
  tag only when the package is unavailable and a git build is intentional.
- Run the installer with the supported Node runtime used by the service.
- Close only after version/health parity, `update --check` reports no stable
  update, service-manager readback, PostgreSQL state invariants, and absence of
  any unauthorized worktree flag.

## Completion receipt

```text
official_release = <immutable version/tag>
installed_source_before = <npm|git|other>
resolved_target = <exact target>
backup = <fresh recoverable artifact>
active_payload = <canonical path/version>
service_health = <status/version>
state_invariants = <preserved or explicit change>
rollback = <available/dispositioned>
residuals = <none or explicit>
verdict = supported|blocked|rolled_back
```
