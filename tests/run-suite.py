"""Run every active test registered in suites.json without changing host installations."""
from pathlib import Path
import json
import subprocess
import sys
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    entries = json.loads((ROOT / "tests/suites.json").read_text())["tests"]
    active = [entry["path"] for entry in entries if entry["status"] == "active"]
    python_tests = [path for path in active if path.endswith(".py")]
    with TemporaryDirectory(prefix="accelerate-tests-") as temporary:
        subprocess.run(
            [sys.executable, "-m", "pytest", "-q", "-p", "no:cacheprovider", "--basetemp", temporary, *python_tests],
            cwd=ROOT, check=True,
        )
    subprocess.run([sys.executable, "skills/governance/skill-catalog-router/scripts/build_index.py", "--repo-root", ".", "--check"], cwd=ROOT, check=True)
    for path in active:
        if path.endswith(".sh"):
            subprocess.run(["bash", path, *(["--receipt-self-test"] if path.endswith("codex-v2-delegation-live-canary.sh") else [])], cwd=ROOT, check=True)
        elif path.endswith(".mjs"):
            subprocess.run(["node", "--test", path], cwd=ROOT, check=True)
    print(f"v1 acceptance passed: {len(active)} registered test files; historical v0 contracts were not executed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
