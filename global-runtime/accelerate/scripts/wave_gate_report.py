#!/usr/bin/env python3
"""Compute Wave-Gated Execution coverage and emit a closure report.

Statuses that count as covered: covered, pass, passed, done. All other
statuses are residual/failed unless explicitly waived.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

COVERED = {"covered", "pass", "passed", "done"}
WAIVED = {"waived", "waive", "waived-with-reason"}


def load_payload(path: str | None) -> dict[str, Any]:
    if path in {None, "-"}:
        return json.load(sys.stdin)
    with open(path, "r", encoding="utf-8") as fh:
        return json.load(fh)


def normalize_threshold(value: Any) -> float:
    if value is None:
        return 0.95
    threshold = float(value)
    if threshold > 1:
        threshold = threshold / 100.0
    if not 0 <= threshold <= 1:
        raise ValueError("threshold must be between 0 and 1 or 0 and 100")
    return threshold


def compute(payload: dict[str, Any]) -> dict[str, Any]:
    targets = payload.get("targets") or []
    if not isinstance(targets, list):
        raise ValueError("targets must be a list")
    denominator = len(targets)
    covered = []
    residual = []
    waived = []
    for target in targets:
        if not isinstance(target, dict):
            raise ValueError("each target must be an object")
        status = str(target.get("status", "")).strip().lower()
        if status in COVERED:
            covered.append(target)
        elif status in WAIVED:
            waived.append(target)
            residual.append(target)
        else:
            residual.append(target)
    threshold = normalize_threshold(payload.get("threshold"))
    coverage = (len(covered) / denominator) if denominator else 1.0
    passed = coverage >= threshold and not any(
        str(target.get("status", "")).strip().lower() not in COVERED | WAIVED
        for target in residual
    )
    if denominator == 0:
        passed = False
    return {
        "wave_id": payload.get("wave_id", "wave-unknown"),
        "requested_objective": payload.get("objective", ""),
        "frozen_denominator": denominator,
        "covered_targets": len(covered),
        "failed_residual_targets": len(residual),
        "coverage_percent": round(coverage * 100, 2),
        "threshold_percent": round(threshold * 100, 2),
        "validators_suites": payload.get("validators", []),
        "interface_runtime_proof": payload.get("proof", []),
        "correction_loops": payload.get("correction_loops", []),
        "residual_targets": residual,
        "waived_targets": waived,
        "decision": "block" if not denominator else ("advance" if passed else "correct"),
        "pass": passed,
        "next_wave": payload.get("next_wave", "advance when decision=advance"),
    }


def as_packet(report: dict[str, Any]) -> str:
    return "\n".join(
        [
            "Wave Closure Packet",
            f"- wave id: {report['wave_id']}",
            f"- requested objective: {report['requested_objective']}",
            f"- frozen denominator: {report['frozen_denominator']}",
            f"- covered targets: {report['covered_targets']}",
            f"- failed/residual targets: {report['failed_residual_targets']}",
            f"- coverage percent: {report['coverage_percent']}",
            f"- validators/suites: {report['validators_suites']}",
            f"- interface/runtime proof: {report['interface_runtime_proof']}",
            f"- correction loops: {report['correction_loops']}",
            f"- residual classification: {report['residual_targets']}",
            f"- decision: {report['decision']}",
            f"- next wave: {report['next_wave']}",
        ]
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compute wave-gated coverage and emit a Wave Closure Packet."
    )
    parser.add_argument("input", nargs="?", default="-", help="Input JSON file, or '-' for stdin")
    parser.add_argument("--format", choices=["json", "packet"], default="json")
    parser.add_argument("--allow-fail", action="store_true", help="Exit 0 when the gate fails.")
    args = parser.parse_args()
    try:
        report = compute(load_payload(args.input))
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    if args.format == "json":
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        print(as_packet(report))
    return 0 if report["pass"] or args.allow_fail else 1


if __name__ == "__main__":
    raise SystemExit(main())
