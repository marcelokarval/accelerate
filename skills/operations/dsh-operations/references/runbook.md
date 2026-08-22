# DSH Operations Runbook

## Safe Readback

```bash
systemctl --user status deepseek-harness.service --no-pager
journalctl --user -u deepseek-harness.service -n 100 --no-pager
curl --fail --silent --show-error http://127.0.0.1:3080/
git -C /home/marcelo-karval/.deepseek-harness describe --tags --always
git -C /home/marcelo-karval/.deepseek-harness rev-parse HEAD
```

Do not print `~/.dsh/env`, provider settings, request headers, or session
payloads. For catalog proof, inspect skill names, source roots, retained `skill`
tool events, and managed digests only.

## Code Orchestrated Bootstrap

```bash
python3 adapters/runtime/dsh/install-code-orchestrated-bootstrap.py \
  --preset-dir /home/marcelo-karval/.dsh/.agent-presets/code-orchestrated
```

Apply only after a clean dry-run review. Record the printed backup path. New
prompt policy applies to fresh sessions, not already-mounted sessions.

## Upgrade Invariants

Before upgrading, back up `~/.dsh` and confirm the target immutable release.
After checkout/build, reapply and prove these local patches:

- `packages/bundle/web-app/src/startup.ts`: permit `--host 0.0.0.0`.
- `apps/web/dist/index.html`: HTTP/LAN fallback for `crypto.randomUUID`.

Run `pnpm install --frozen-lockfile`, `pnpm run build`, restart the existing
service, and verify the existing URL after refresh. Do not validate a replacement
server on another port as proof of the deployed service.

## Rollback

Use the bootstrap installer's `--rollback BACKUP_PATH` for preset changes. For
release rollback, restore the previous immutable checkout and `~/.dsh` backup,
reapply the two local patches, rebuild, restart, and repeat health/session proof.
