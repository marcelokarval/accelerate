"""Missing-only projection regression tests; no runtime writes."""
import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('repair', Path(__file__).resolve().parents[1] / 'scripts/repair-dsh-support.py')
assert spec is not None and spec.loader is not None
repair = importlib.util.module_from_spec(spec)
spec.loader.exec_module(repair)


class RepairTests(unittest.TestCase):
    def test_dependency_and_preservation(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            source, target = root / 'source', root / 'target'
            for base in (source, target):
                (base / 'references').mkdir(parents=True)
            (source / 'core/runtime-packets').mkdir(parents=True)
            (target / 'SKILL.md').write_text('`references/qa-proof-stack.md` `references/overlay.md`')
            (target / 'references/overlay.md').write_text('runtime-specific')
            (source / 'references/qa-proof-stack.md').write_text('`../core/runtime-packets/qa-proof-stack.md`')
            (source / 'core/runtime-packets/qa-proof-stack.md').write_text('real QA doctrine')
            copies = repair.plan(source, target)
            self.assertEqual(len(copies), 2)
            for rel, data in copies.items():
                (target / rel).parent.mkdir(parents=True, exist_ok=True)
                (target / rel).write_bytes(data)
            self.assertEqual(repair.plan(source, target), {})
            self.assertEqual((target / 'references/overlay.md').read_text(), 'runtime-specific')

    def test_missing_source_fails_before_writes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'SKILL.md').write_text('references/missing.md')
            with self.assertRaises(ValueError):
                repair.plan(root / 'source', root)
            self.assertFalse((root / 'references').exists())

    def test_target_symlink_escape(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            target = root / 'target'
            target.mkdir()
            (target / 'SKILL.md').write_text('references/escape.md')
            (target / 'references').symlink_to(root)
            with self.assertRaises(ValueError):
                repair.plan(root / 'source', target)


if __name__ == '__main__':
    unittest.main()
