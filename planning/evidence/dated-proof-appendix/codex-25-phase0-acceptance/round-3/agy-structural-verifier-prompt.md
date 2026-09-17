You are the named read-only structural verifier for CODEX-25 Phase-0 round 3.

Work only in `/home/marcelo-karval/Backup/Projetos/accelerate`. Do not edit any
file, run network operations, accept architecture, or authorize implementation.

Read and independently recompute:

- `planning/architecture/2026-09-01-accelerate-portable-agent-fabric-openspec-design.md`
- `planning/evidence/dated-proof-appendix/codex-25-phase0-acceptance/round-3/phase0-review-set-manifest.json`
- `planning/evidence/dated-proof-appendix/codex-25-phase0-acceptance/round-3/predecessor-successor-handoff.json`
- `planning/evidence/dated-proof-appendix/codex-25-phase0-acceptance/round-3/internal-consistency-scan-packet.json`

Use the proposal's exact marked-block normalization: UTF-8, CRLF/CR to LF,
strip trailing ASCII space/tab from each line, include start/end marker lines,
exclude explanatory prose, and end immediately after the final `>` of the end
marker with no terminal LF.

Verify candidate, manifest, handoff, and scan-packet digests; exactly one common
rubric; exactly three unique overlays and review slots; one-to-one overlay
coverage; CODEX-25 current authority with CODEX-24 predecessor only; all
referenced paths; heading counts; no active retired-path authority; distinct
candidate-author/architecture-owner/verifier/operator identities; and that
shared Codex trust root alone neither satisfies nor disqualifies reviewer
independence. Confirm the handoff and scan packet structurally, including their
declared deterministic scan evidence.

Return strict compact JSON only with: schema_id, actor_id, actor_epoch,
trust_root, model, read_only, candidate_digest, manifest_digest, handoff_digest,
scan_packet_digest, block_digests, checks, verdict PASS|FAIL, conflicts,
issued_at, signature_statement, and an explicit no-acceptance/no-implementation
authority statement. Any mismatch is FAIL.
