# OpenHands Operations Runbook

## Safe Readback

```bash
systemctl --user status openhands-agent-canvas.service --no-pager
journalctl --user -u openhands-agent-canvas.service -n 100 --no-pager
systemctl --user status open-design-43210.service --no-pager
```

Inspect only model/profile names, managed ownership markers, skill names, MCP
status, HTTP status, and non-secret version output. Do not dump `~/.openhands`,
the application `.env`, request headers, or conversation state.

## Governed Changes

Run each repository installer without `--apply` first. Refuse unmanaged target
collisions. After apply, read back the generated digest and start a disposable
session. File presence alone is not runtime discovery proof.

Restart with:

```bash
systemctl --user restart openhands-agent-canvas.service
```

Then verify service health, Agent Canvas loading, the `open-design` MCP, and the
actual skill catalog. Keep child dispatch `prompt-contract-only` unless a fresh
session and provider binding demonstrate a callable supported primitive.

## Rollback

Restore only repository-managed projections from their recorded backups or
materializer receipts, restart the service, and repeat health/readback. Never
delete unmanaged profiles or skills as cleanup.
