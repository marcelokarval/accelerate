#!/usr/bin/env python3
"""Render the repo-owned delegation fragment into a staged AGENTS target."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

START = "<!-- accelerate-delegation-policy:start -->"
END = "<!-- accelerate-delegation-policy:end -->"
TICK = chr(96)
LEGACY_FIRST = "- Non-trivial work defaults to multi-agent execution."
LEGACY_SECOND = "- At least one bounded subagent should normally be spawned for non-trivial work."
LEGACY_THIRD = (
    "- Each spawned subagent should load "
    + TICK + "accelerate" + TICK
    + " first, then leave "
    + TICK + "self-review" + TICK
    + " and "
    + TICK + "self-forensic review" + TICK
    + " output before returning."
)


class RenderError(ValueError):
    """The target cannot be transformed without ambiguity."""


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_fragment(path: Path) -> bytes:
    data = path.read_bytes()
    if data.count(START.encode()) != 1 or data.count(END.encode()) != 1:
        raise RenderError("fragment must contain exactly one complete marker pair")
    start = data.index(START.encode())
    end = data.index(END.encode())
    if start != 0 or end < start:
        raise RenderError("fragment markers must enclose the complete fragment")
    if data[end + len(END) :].strip():
        raise RenderError("fragment contains content outside its marker pair")
    return data


def find_legacy_spans(target: bytes) -> list[tuple[int, int]]:
    lines = target.splitlines(keepends=True)
    offsets: list[int] = []
    offset = 0
    for line in lines:
        offsets.append(offset)
        offset += len(line)
    spans: list[tuple[int, int]] = []
    partial = False
    for index, line in enumerate(lines):
        if line.rstrip(b"\r\n").decode("utf-8") != LEGACY_FIRST:
            continue
        if index + 2 >= len(lines):
            partial = True
            continue
        if lines[index + 1].rstrip(b"\r\n").decode("utf-8") != LEGACY_SECOND:
            partial = True
            continue
        third_lines = [lines[index + 2].rstrip(b"\r\n").decode("utf-8")]
        end_index = index + 3
        while end_index < len(lines):
            continuation = lines[end_index].rstrip(b"\r\n").decode("utf-8")
            if not continuation or not continuation[0].isspace():
                break
            third_lines.append(continuation)
            end_index += 1
        normalized = " ".join(part.strip() for part in third_lines)
        if normalized != LEGACY_THIRD:
            partial = True
            continue
        end_offset = offsets[end_index] if end_index < len(offsets) else len(target)
        spans.append((offsets[index], end_offset))
    if partial:
        raise RenderError("target contains a partial legacy delegation block")
    return spans


def render_target(target: bytes, fragment: bytes) -> bytes:
    starts = target.count(START.encode())
    ends = target.count(END.encode())
    if starts or ends:
        if starts != 1 or ends != 1:
            raise RenderError("target has broken or multiple delegation markers")
        start = target.index(START.encode())
        end = target.index(END.encode())
        if end < start:
            raise RenderError("target delegation markers are out of order")
        end += len(END)
        if end < len(target) and target[end : end + 1] == b"\n":
            end += 1
        return target[:start] + fragment + target[end:]

    try:
        matches = find_legacy_spans(target)
    except UnicodeDecodeError as exc:
        raise RenderError("target must be UTF-8 to locate the legacy delegation block") from exc
    if len(matches) != 1:
        raise RenderError(
            "first installation requires exactly one known legacy delegation block"
        )
    start, end = matches[0]
    return target[:start] + fragment + target[end:]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", required=True, type=Path)
    parser.add_argument(
        "--fragment",
        type=Path,
        default=Path(__file__).resolve().parents[1]
        / "adapters/runtime/codex/global-bootstrap-orchestration.fragment.md",
    )
    args = parser.parse_args()
    try:
        fragment = load_fragment(args.fragment)
        target = args.target.read_bytes()
        rendered = render_target(target, fragment)
    except (OSError, RenderError) as exc:
        parser.error(str(exc))
    print(json.dumps({"changed": rendered != target, "source_sha256": sha256(fragment), "target_before_sha256": sha256(target), "target_after_sha256": sha256(rendered)}, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
