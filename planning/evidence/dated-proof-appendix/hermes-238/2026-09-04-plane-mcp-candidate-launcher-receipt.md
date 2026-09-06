# Candidate Launcher Receipt

**Timestamp:** 2026-09-04T14:06:00-04:00
**Commit:** `26488c53ec9852ae8d02adfecaf86694f50e3c8c`

## Artifact Identity
- **Candidate Launcher Path:** `/home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.candidate-26488c53.sh`
- **Candidate Launcher SHA256:** `8e915500cb7b2366c5eb7035e11bff334a52ff8521befc2b1c87b4adce24651e`

## Static Guard Evidence
The candidate launcher contains updated guards designed for the `26488c53` release. It correctly omits the deprecated `v3` registry check in favor of the `v2` registry check:
- **EXPECTED_COMMIT:** `26488c53ec9852ae8d02adfecaf86694f50e3c8c`
- **EXPECTED_SERVER_SHA256:** `1341d58a9851d31df475703573df086f1881823c12551c6953da40e111e5323f`
- **EXPECTED_V2_REGISTRY_SHA256:** `c52cfd2ec5db3fe78844dc4c89f3482e665b8d4aa4b2ab82008ff0e9ef8283b2`
- **EXPECTED_OPERATION_REGISTRY_SHA256:** `264a7c9c6eed036551733d7efcb8b510e7c7f7bcf39c7b708cb13e827a7dcb04`

## Atomic-Swap Instructions
To activate this candidate seamlessly without downtime, run:
```bash
# 1. Back up the original rollback baseline
cp /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.sh /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.rollback.sh

# 2. Stage the new candidate
cp /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.candidate-26488c53.sh /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.staging.sh

# 3. Perform the atomic swap using mv
mv /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.staging.sh /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.sh
```

## Rollback Instructions
To instantly revert to the authoritative 7a4b60 baseline:
```bash
mv /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.rollback.sh /home/marcelo-karval/.codex/bin/plane-mcp-karval-launcher.sh
```

