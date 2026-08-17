#!/usr/bin/env python3
"""Run governed external model lanes for Codex without copying credentials."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path


ANSI_ESCAPE = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")
REASONING_BOX = re.compile(
    r"(?:^|\n)┌─ Reasoning .*?\n.*?\n└─+┘(?:\n|$)", re.DOTALL
)


def final_only_deepseek_output(value: str) -> str:
    """Remove Hermes presentation-only reasoning from an internal lane result."""
    plain = ANSI_ESCAPE.sub("", value)
    return REASONING_BOX.sub("\n", plain).strip()


def parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser()
    p.add_argument("--check", action="store_true")
    p.add_argument("--lane", choices=("deepseek", "gemini-flash"))
    p.add_argument("--timeout", type=int, default=900)
    return p


def check() -> dict[str, object]:
    home = Path.home()
    return {
        "deepseek": {
            "executable": bool(shutil.which("hermes")),
            "profile": (home / ".hermes/profiles/deepseek/config.yaml").is_file(),
            "model": "deepseek-v4-flash",
        },
        "gemini-flash": {
            "executable": bool(shutil.which("gemini")),
            "model": "gemini-3.7-flash",
            "auth": "owned-by-gemini-cli-not-inferred",
        },
    }


def main() -> int:
    args = parser().parse_args()
    state = check()
    if args.check:
        print(json.dumps(state, sort_keys=True))
        return 0 if all(v["executable"] for v in state.values()) else 1
    if not args.lane:
        parser().error("--lane is required unless --check is used")
    prompt = sys.stdin.read()
    if not prompt.strip():
        parser().error("read a non-empty prompt from stdin")
    if args.lane == "deepseek":
        command = [
            "hermes", "-p", "deepseek", "chat", "--query-stdin", "--quiet",
            "--source", "tool", "--reasoning", "none",
        ]
    else:
        command = [
            "gemini", "--model", "gemini-3.7-flash", "--prompt", "",
            "--approval-mode", "plan", "--output-format", "text",
        ]
    completed = subprocess.run(
        command,
        input=prompt,
        text=True,
        timeout=args.timeout,
        check=False,
        capture_output=True,
    )
    stderr = completed.stderr
    if args.lane == "deepseek":
        stderr = "\n".join(
            line for line in stderr.splitlines() if not line.startswith("session_id: ")
        ).strip()
    if stderr:
        print(stderr, file=sys.stderr)
    output = completed.stdout
    if args.lane == "deepseek":
        output = final_only_deepseek_output("\n".join(
            line for line in output.splitlines() if not line.startswith("session_id: ")
        ))
    print(output, end="" if output.endswith("\n") else "\n")
    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
