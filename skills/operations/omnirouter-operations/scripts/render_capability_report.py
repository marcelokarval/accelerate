#!/usr/bin/env python3
"""Render a hardened Markdown capability report from constrained evidence and matching receipt."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
import tempfile
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any

from validate_capability_battery import load_json, validate_manifest


def escape_markdown(value: Any) -> str:
    """Escape Markdown and table special characters."""
    if value is None:
        return ""
    text = str(value)
    return (
        text.replace("\\", "\\\\")
        .replace("|", "\\|")
        .replace("\r", " ")
        .replace("\n", " ")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )


def validate_receipt(receipt: dict[str, Any], digest: str, counts: dict[str, int]) -> None:
    required = {
        "schema_version",
        "status",
        "manifest_sha256",
        "validated_at",
        "planned_slot_count",
        "evidence_count",
    }
    if not isinstance(receipt, dict) or not required <= set(receipt):
        raise ValueError("invalid receipt schema: missing required fields")
    if receipt["schema_version"] not in {"1.0", "2.0"}:
        raise ValueError("unsupported receipt schema_version")
    if receipt["status"] != "valid":
        raise ValueError("receipt status must be 'valid'")
    if receipt["manifest_sha256"] != digest:
        raise ValueError("receipt manifest_sha256 does not match freshly computed manifest SHA-256")
    if receipt["planned_slot_count"] != counts["planned_slot_count"]:
        raise ValueError("receipt planned_slot_count does not match manifest")
    if receipt["evidence_count"] != counts["evidence_count"]:
        raise ValueError("receipt evidence_count does not match manifest")
    if not isinstance(receipt["validated_at"], str):
        raise ValueError("invalid receipt validated_at timestamp")
    try:
        datetime.fromisoformat(receipt["validated_at"].replace("Z", "+00:00"))
    except ValueError as exc:
        raise ValueError(f"invalid receipt timestamp: {exc}") from exc


def render_report(manifest: dict[str, Any], digest: str, receipt_name: str, counts: dict[str, int]) -> str:
    statuses = Counter(row["status"] for row in manifest["evidence"])
    by_slot: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in manifest["evidence"]:
        by_slot[row["slot_id"]].append(row)

    lines = [
        "# Capability Battery Report",
        "",
        f"- Battery: `{escape_markdown(manifest.get('battery_id'))}`",
        f"- Schema version: `{escape_markdown(manifest.get('schema_version'))}`",
        f"- Catalog snapshot: `{escape_markdown(manifest.get('catalog_snapshot_id'))}`",
    ]
    if "provider" in manifest:
        lines.append(f"- Provider: `{escape_markdown(manifest.get('provider'))}`")
    if "route" in manifest:
        lines.append(f"- Route: `{escape_markdown(manifest.get('route'))}`")
    if "harness" in manifest:
        lines.append(f"- Harness: `{escape_markdown(manifest.get('harness'))}`")

    lines.extend([
        f"- Manifest SHA-256: `{digest}`",
        f"- Validator receipt: `{escape_markdown(receipt_name)}`",
        f"- Frozen denominator: {counts['planned_slot_count']} planned slots; {counts['evidence_count']} retained attempts.",
        "",
        "## Coverage",
        "",
        "| Status | Attempts |",
        "|---|---:|",
    ])
    for status in ("pass", "semantic_fail", "transport_fail", "protocol_fail", "not_run", "inconclusive"):
        lines.append(f"| {status} | {statuses.get(status, 0)} |")

    lines.extend([
        "",
        "## Controls",
        "",
        "```json",
        json.dumps(manifest["controls"], sort_keys=True, indent=2),
        "```",
        "",
        "## Per-slot evidence",
        "",
        "| Slot | Attempt | Status | Requested Model | Effective Model | HTTP | Artifact | Reason |",
        "|---|---:|---|---|---|---:|---|---|",
    ])
    for slot in manifest["planned_slots"]:
        slot_id = slot["slot_id"]
        attempts = sorted(by_slot.get(slot_id, []), key=lambda item: item["attempt"])
        for row in attempts:
            lines.append(
                "| {slot} | {attempt} | {status} | {requested} | {effective} | {http} | {artifact} | {reason} |".format(
                    slot=escape_markdown(row["slot_id"]),
                    attempt=row["attempt"],
                    status=escape_markdown(row["status"]),
                    requested=escape_markdown(row["requested_model"]),
                    effective=escape_markdown(row.get("effective_model", "unknown")),
                    http=row.get("http_status", ""),
                    artifact=escape_markdown(row.get("artifact_locator", "")),
                    reason=escape_markdown(row.get("reason", "")),
                )
            )

    lines.extend([
        "",
        "## Interpretation limits and non-promotion notice",
        "",
        "- Este relatório renderiza e audita unicamente evidências pré-coletadas e congeladas offline.",
        "- Modelos solicitados (requested) e observados (effective) são mantidos estritamente distintos.",
        "- Não gera rankings arbitrários nem promove automaticamente providers, modelos ou Combos.",
        "- Falhas de transporte não atestam incapacidade semântica de modelos; retries adicionais não eliminam histórico de tentativas prévias.",
        "",
    ])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--validation-receipt", required=True, type=Path)
    parser.add_argument("--out-dir", required=True, type=Path)
    args = parser.parse_args()
    try:
        raw = args.manifest.read_bytes()
        manifest = load_json(args.manifest)
        counts = validate_manifest(manifest)
        digest = hashlib.sha256(raw).hexdigest()
        receipt = load_json(args.validation_receipt)
        validate_receipt(receipt, digest, counts)

        if args.out_dir.is_symlink():
            raise ValueError(f"refusing symlink out-dir: {args.out_dir}")
        out_dir = args.out_dir.resolve()
        if out_dir.exists() and (out_dir.is_symlink() or not out_dir.is_dir()):
            raise ValueError(f"refusing symlink or non-directory out-dir: {out_dir}")
        out_dir.mkdir(parents=True, exist_ok=True)

        target = out_dir / "capability-battery-report.md"
        if target.is_symlink() or (target.exists() and target.is_symlink()):
            raise ValueError(f"refusing symlink target file: {target}")

        resolved_target = target.resolve()
        try:
            if not resolved_target.is_relative_to(out_dir):
                raise ValueError(f"path traversal detected for output: {resolved_target}")
        except AttributeError:
            if os.path.commonpath([str(out_dir), str(resolved_target)]) != str(out_dir):
                raise ValueError(f"path traversal detected for output: {resolved_target}")

        if resolved_target.exists() and resolved_target.is_symlink():
            raise ValueError(f"refusing symlink target file: {resolved_target}")

        content = render_report(manifest, digest, args.validation_receipt.name, counts)
        with tempfile.NamedTemporaryFile("w", dir=out_dir, prefix=".report-", delete=False, encoding="utf-8") as tmp:
            tmp.write(content)
            temp_target = Path(tmp.name)
        try:
            if target.is_symlink():
                raise ValueError(f"refusing symlink target file: {target}")
            os.replace(temp_target, target)
        finally:
            if temp_target.exists():
                temp_target.unlink()
        print(target)
    except (ValueError, KeyError, TypeError) as exc:
        print(f"render failed: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
