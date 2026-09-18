#!/usr/bin/env python3
"""Dense-Dispatch Codec & Validator CLI (GAP 3).

Implements Dense-Dispatch Skeleton YAML v1 validation, automatic SHA-256 calculation
from on-disk repository files, fail-closed checking (--check), and canonical
rendering for dispatch (--render) according to
docs/architecture/dense-dispatch-and-caveman-protocol.md.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any, NoReturn

import yaml
from yaml.loader import SafeLoader

REPO = Path(__file__).resolve().parents[1]

ALLOWED_ROOT_KEYS = {
    "projection_version",
    "example_kind",
    "identity",
    "verified_base",
    "requested",
    "targets",
    "constraints",
    "forbidden_paths",
    "evidence_gates",
    "delta",
    "run_artifacts",
}

REQUIRED_ROOT_KEYS = {
    "projection_version",
    "identity",
    "verified_base",
    "requested",
    "targets",
    "constraints",
    "forbidden_paths",
    "evidence_gates",
    "delta",
}

ALLOWED_DELTA_KEYS = {
    "objective",
    "read_scopes",
    "write_scopes",
    "proof_requirement",
}

ALLOWED_EXPANSION_TARGETS = {
    "runtime-neutral-assignment-projection/v1",
}

SHA256_HEX_RE = re.compile(r"^[0-9a-f]{64}$")


class UniqueKeySafeLoader(SafeLoader):
    """YAML SafeLoader enforcing no duplicate keys and rejecting forbidden YAML features."""
    pass


def _construct_mapping(loader: SafeLoader, node: yaml.MappingNode, deep: bool = False) -> dict[Any, Any]:
    mapping: dict[Any, Any] = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in mapping:
            raise ValueError(f"duplicate YAML key detected: {key!r}")
        value = loader.construct_object(value_node, deep=deep)
        mapping[key] = value
    return mapping


UniqueKeySafeLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, _construct_mapping)


def fail(message: str) -> NoReturn:
    raise ValueError(message)


def compute_sha256(path: Path) -> str:
    """Compute 64-char lowercase hexadecimal SHA-256 for a file on disk."""
    if not path.is_file():
        fail(f"file not found for hashing: {path}")
    hasher = hashlib.sha256()
    with path.open("rb") as f:
        while chunk := f.read(65536):
            hasher.update(chunk)
    return hasher.hexdigest().lower()


def resolve_contained_repo_path(ref_str: str) -> Path:
    """Resolve a repository-relative path, ensuring it is contained within the repo."""
    if not isinstance(ref_str, str) or not ref_str.strip():
        fail("path reference must be a non-empty string")
    ref_path = Path(ref_str)
    if ref_path.is_absolute():
        fail(f"absolute path is forbidden: {ref_str}")
    if any(part == ".." for part in ref_path.parts):
        fail(f"path escaping with '..' is forbidden: {ref_str}")
    resolved = (REPO / ref_path).resolve()
    try:
        resolved.relative_to(REPO.resolve())
    except ValueError:
        fail(f"path escapes repository boundary: {ref_str}")
    return resolved


def parse_input(content: str, filename: str) -> dict[str, Any]:
    """Parse JSON or YAML with strict duplicate key checking and feature restrictions."""
    # Check for forbidden YAML features in raw content
    for line in content.splitlines():
        stripped = line.strip()
        if stripped.startswith("#"):
            continue
        if re.search(r"!\w+|&[\w-]+|\*[\w-]+", stripped):
            fail(f"disallowed YAML features (tags, anchors, aliases) detected in {filename}")

    # First try strict JSON
    def check_json_dups(pairs: list[tuple[Any, Any]]) -> dict[Any, Any]:
        res: dict[Any, Any] = {}
        for k, v in pairs:
            if k in res:
                fail(f"duplicate JSON key: {k!r}")
            res[k] = v
        return res

    try:
        parsed_json = json.loads(content, object_pairs_hook=check_json_dups)
        if isinstance(parsed_json, dict):
            return parsed_json
    except Exception:
        pass

    try:
        data = yaml.load(content, Loader=UniqueKeySafeLoader)
        if isinstance(data, dict):
            return data
        fail(f"top-level document in {filename} must be a mapping/object")
    except Exception as err:
        fail(f"failed to parse {filename}: {err}")


def rfc8785_canonical_json(obj: Any) -> bytes:
    """Serialize object to RFC 8785 JSON Canonicalization Scheme (I-JSON subset)."""
    def check_values(v: Any) -> None:
        if isinstance(v, float):
            fail("floats are disallowed in canonical serialization per RFC 8785")
        elif isinstance(v, dict):
            for k, val in v.items():
                if not isinstance(k, str):
                    fail(f"dictionary keys must be strings, got: {type(k)}")
                check_values(val)
        elif isinstance(v, (list, tuple)):
            for val in v:
                check_values(val)

    check_values(obj)
    # RFC 8785 sorts keys lexicographically, eliminates whitespace
    return json.dumps(obj, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def populate_and_verify_hashes(doc: dict[str, Any], auto_hash: bool = False) -> list[str]:
    """Populate missing/auto hashes or verify existing ones. Returns list of verified files."""
    verified_refs: list[str] = []
    vb = doc.get("verified_base")
    if not isinstance(vb, dict):
        fail("verified_base must be an object")

    # 1. authority_refs
    auth_refs = vb.get("authority_refs")
    if not isinstance(auth_refs, list):
        fail("verified_base.authority_refs must be a list")
    for item in auth_refs:
        if not isinstance(item, dict):
            fail("each item in authority_refs must be an object")
        ref = item.get("ref")
        if not isinstance(ref, str):
            fail("authority ref must be a string")
        disk_path = resolve_contained_repo_path(ref)
        if not disk_path.is_file():
            fail(f"authority ref file not found on disk: {ref}")
        actual_hash = compute_sha256(disk_path)
        existing_hash = item.get("sha256")
        if auto_hash and not existing_hash:
            item["sha256"] = actual_hash
        else:
            if not isinstance(existing_hash, str) or not SHA256_HEX_RE.match(existing_hash):
                fail(f"invalid or missing sha256 for authority ref {ref}")
            if existing_hash.lower() != actual_hash:
                fail(f"hash mismatch for authority ref {ref}: expected {existing_hash}, actual {actual_hash}")
        verified_refs.append(ref)

    # 2. named_source
    ns = vb.get("named_source")
    if not isinstance(ns, dict):
        fail("verified_base.named_source must be an object")
    ns_ref = ns.get("ref")
    if not isinstance(ns_ref, str):
        fail("named_source.ref must be a string")
    disk_path = resolve_contained_repo_path(ns_ref)
    if not disk_path.is_file():
        fail(f"named_source file not found on disk: {ns_ref}")
    actual_hash = compute_sha256(disk_path)
    existing_hash = ns.get("sha256")
    if auto_hash and not existing_hash:
        ns["sha256"] = actual_hash
    else:
        if not isinstance(existing_hash, str) or not SHA256_HEX_RE.match(existing_hash):
            fail(f"invalid or missing sha256 for named_source {ns_ref}")
        if existing_hash.lower() != actual_hash:
            fail(f"hash mismatch for named_source {ns_ref}: expected {existing_hash}, actual {actual_hash}")
    verified_refs.append(ns_ref)

    # 3. binding_policy (if present)
    bp = vb.get("binding_policy")
    if bp is not None:
        if not isinstance(bp, dict):
            fail("binding_policy must be an object")
        bp_ref = bp.get("ref")
        if not isinstance(bp_ref, str):
            fail("binding_policy.ref must be a string")
        disk_path = resolve_contained_repo_path(bp_ref)
        if not disk_path.is_file():
            fail(f"binding_policy file not found on disk: {bp_ref}")
        actual_hash = compute_sha256(disk_path)
        existing_hash = bp.get("sha256")
        if auto_hash and not existing_hash:
            bp["sha256"] = actual_hash
        else:
            if not isinstance(existing_hash, str) or not SHA256_HEX_RE.match(existing_hash):
                fail(f"invalid or missing sha256 for binding_policy {bp_ref}")
            if existing_hash.lower() != actual_hash:
                fail(f"hash mismatch for binding_policy {bp_ref}: expected {existing_hash}, actual {actual_hash}")
        verified_refs.append(bp_ref)

    # 4. run_artifacts (if present)
    ra = doc.get("run_artifacts")
    if ra is not None:
        if not isinstance(ra, (dict, list)):
            fail("run_artifacts must be a dict or list of artifact refs")
        artifacts_iter = ra.values() if isinstance(ra, dict) else ra
        for item in artifacts_iter:
            if isinstance(item, dict):
                ref = item.get("ref")
                if isinstance(ref, str):
                    disk_path = resolve_contained_repo_path(ref)
                    actual_hash = compute_sha256(disk_path)
                    existing_hash = item.get("sha256")
                    if auto_hash and not existing_hash:
                        item["sha256"] = actual_hash
                    else:
                        if not isinstance(existing_hash, str) or existing_hash.lower() != actual_hash:
                            fail(f"hash mismatch for run_artifact {ref}")
                    verified_refs.append(ref)

    return verified_refs


def validate_dense_dispatch_v1(doc: dict[str, Any]) -> dict[str, Any]:
    """Execute all fail-closed validation checks for dense-dispatch/v1.

    Returns the selected assignment dictionary from named_source.
    """
    # 1. Projection version & root keys
    pv = doc.get("projection_version")
    if pv != "dense-dispatch/v1":
        fail(f"invalid projection_version: expected 'dense-dispatch/v1', got {pv!r}")

    unknown_keys = set(doc.keys()) - ALLOWED_ROOT_KEYS
    if unknown_keys:
        fail(f"unknown root key(s) in skeleton: {sorted(unknown_keys)}")

    missing_keys = REQUIRED_ROOT_KEYS - set(doc.keys())
    if missing_keys:
        fail(f"missing required root key(s) in skeleton: {sorted(missing_keys)}")

    # 2. Identity
    identity = doc["identity"]
    if not isinstance(identity, dict):
        fail("identity must be an object")
    run_id = identity.get("run_id")
    assignment_id = identity.get("assignment_id")
    expansion_target = identity.get("named_expansion_target")
    if not isinstance(run_id, str) or not run_id.strip():
        fail("identity.run_id must be a non-empty string")
    if not isinstance(assignment_id, str) or not assignment_id.strip():
        fail("identity.assignment_id must be a non-empty string")
    if expansion_target not in ALLOWED_EXPANSION_TARGETS:
        fail(f"unknown or invalid named_expansion_target: {expansion_target!r}")

    # 3. Requested binding validation
    requested = doc["requested"]
    if not isinstance(requested, dict):
        fail("requested must be an object")
    model = requested.get("model")
    if not isinstance(model, str) or not model.strip():
        fail("requested.model must be an explicitly specified non-empty string")
    reasoning_effort = requested.get("reasoning_effort")
    variant = requested.get("variant")
    if not reasoning_effort and not variant:
        fail("requested.reasoning_effort (or variant) must be explicitly specified")
    if reasoning_effort and not isinstance(reasoning_effort, str):
        fail("requested.reasoning_effort must be a string")
    if variant and not isinstance(variant, str):
        fail("requested.variant must be a string")
    fork_turns = requested.get("fork_turns")
    if fork_turns is None:
        fail("requested.fork_turns must be explicitly specified ('none' or 1..5)")
    if fork_turns != "none" and not (isinstance(fork_turns, int) and 1 <= fork_turns <= 5):
        fail(f"requested.fork_turns must be 'none' or integer 1..5, got: {fork_turns!r}")

    # 4. Targets, constraints, forbidden_paths, evidence_gates
    targets = doc["targets"]
    if not isinstance(targets, dict) or "surfaces" not in targets or "paths" not in targets:
        fail("targets must be an object with 'surfaces' and 'paths'")
    if not isinstance(targets["surfaces"], list) or not isinstance(targets["paths"], list):
        fail("targets.surfaces and targets.paths must be lists")

    constraints = doc["constraints"]
    if not isinstance(constraints, list):
        fail("constraints must be a list")

    forbidden_paths = doc["forbidden_paths"]
    if not isinstance(forbidden_paths, list):
        fail("forbidden_paths must be a list")

    evidence_gates = doc["evidence_gates"]
    if not isinstance(evidence_gates, list):
        fail("evidence_gates must be a list")

    # 5. Delta validation
    delta = doc["delta"]
    if not isinstance(delta, dict):
        fail("delta must be an object")
    unknown_delta_keys = set(delta.keys()) - ALLOWED_DELTA_KEYS
    if unknown_delta_keys:
        fail(f"unknown delta key(s): {sorted(unknown_delta_keys)}")

    # 6. Load named_source and locate selected assignment
    vb = doc["verified_base"]
    if not isinstance(vb, dict):
        fail("verified_base must be an object")
    ns = vb.get("named_source")
    if not isinstance(ns, dict):
        fail("verified_base.named_source must be an object")
    ns_ref = ns.get("ref")
    if not isinstance(ns_ref, str):
        fail("named_source.ref must be a string")
    ns_assignment_id = ns.get("assignment_id")
    if ns_assignment_id != assignment_id:
        fail(f"named_source.assignment_id ({ns_assignment_id!r}) does not match identity.assignment_id ({assignment_id!r})")

    source_path = resolve_contained_repo_path(ns_ref)
    try:
        source_data = json.loads(source_path.read_text(encoding="utf-8"))
    except Exception as e:
        fail(f"failed to load named_source JSON from {ns_ref}: {e}")

    assignments = source_data.get("assignments")
    if not isinstance(assignments, list):
        fail(f"named_source {ns_ref} missing assignments array")

    matching = [a for a in assignments if isinstance(a, dict) and a.get("assignment_id") == assignment_id]
    if len(matching) == 0:
        fail(f"no assignment matching assignment_id={assignment_id!r} in {ns_ref}")
    if len(matching) > 1:
        fail(f"multiple assignments matching assignment_id={assignment_id!r} in {ns_ref}")

    selected_assignment = matching[0]

    # 7. Delta assertions against selected assignment
    for k, v in delta.items():
        if k not in selected_assignment:
            fail(f"delta key {k!r} not present in selected assignment in {ns_ref}")
        source_val = selected_assignment[k]
        if v != source_val:
            fail(f"delta assertion mismatch for {k!r}: expected {source_val!r} from source, got {v!r} in skeleton")

    # 8. Check binding policy if present
    bp = vb.get("binding_policy")
    if bp is not None:
        profile_name = bp.get("profile")
        bp_ref = bp.get("ref")
        if not isinstance(bp_ref, str):
            fail("binding_policy.ref must be a string")
        bp_path = resolve_contained_repo_path(bp_ref)
        try:
            bp_data = json.loads(bp_path.read_text(encoding="utf-8"))
        except Exception as e:
            fail(f"failed to load binding_policy from {bp_ref}: {e}")

        profiles = bp_data.get("profiles", {})
        if profile_name not in profiles:
            fail(f"profile {profile_name!r} not found in binding_policy {bp_ref}")
        prof = profiles[profile_name]
        expected_model = prof.get("model")
        expected_effort = prof.get("reasoning_effort")
        if expected_model and model != expected_model:
            fail(f"requested.model ({model}) does not match binding policy profile {profile_name} ({expected_model})")
        if expected_effort and reasoning_effort and reasoning_effort != expected_effort:
            fail(f"requested.reasoning_effort ({reasoning_effort}) does not match profile {profile_name} ({expected_effort})")

    return selected_assignment


def render_canonical_dispatch(doc: dict[str, Any], selected_assignment: dict[str, Any]) -> tuple[dict[str, Any], str]:
    """Render canonical expanded dispatch payload and compute RFC 8785 SHA-256."""
    expanded = {
        "envelope_version": "runtime-neutral-assignment-projection/v1",
        "identity": doc["identity"],
        "verified_base": doc["verified_base"],
        "requested": doc["requested"],
        "targets": doc["targets"],
        "constraints": doc["constraints"],
        "forbidden_paths": doc["forbidden_paths"],
        "evidence_gates": doc["evidence_gates"],
        "delta": doc["delta"],
        "resolved_assignment": selected_assignment,
    }
    if "run_artifacts" in doc:
        expanded["run_artifacts"] = doc["run_artifacts"]
    if "example_kind" in doc:
        expanded["example_kind"] = doc["example_kind"]

    canonical_bytes = rfc8785_canonical_json(expanded)
    expanded_hash = hashlib.sha256(canonical_bytes).hexdigest().lower()
    return expanded, expanded_hash


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Dense-Dispatch Codec & Validator CLI (GAP 3)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("input_file", help="Path to input YAML or JSON skeleton file")
    parser.add_argument(
        "--check",
        action="store_true",
        help="Validate input fail-closed against dense-dispatch/v1 specification",
    )
    parser.add_argument(
        "--compute-hashes",
        action="store_true",
        help="Automatically compute and print actual on-disk SHA-256 for all references",
    )
    parser.add_argument(
        "--render",
        action="store_true",
        help="Render canonical JSON payload for session.send with final RFC 8785 SHA-256",
    )

    args = parser.parse_args()

    input_path = Path(args.input_file)
    if not input_path.is_file():
        sys.stderr.write(f"Error: input file not found: {args.input_file}\n")
        return 1

    try:
        content = input_path.read_text(encoding="utf-8")
    except Exception as e:
        sys.stderr.write(f"Error reading {args.input_file}: {e}\n")
        return 1

    try:
        doc = parse_input(content, str(input_path))

        if args.compute_hashes:
            populate_and_verify_hashes(doc, auto_hash=True)
            print(yaml.dump(doc, sort_keys=False))
            return 0

        # Validate hashes against disk
        populate_and_verify_hashes(doc, auto_hash=False)

        # Full validation
        selected_assignment = validate_dense_dispatch_v1(doc)

        if args.render:
            expanded, expanded_hash = render_canonical_dispatch(doc, selected_assignment)
            output = {
                "expanded_artifact": expanded,
                "expanded_artifact_sha256": expanded_hash,
            }
            print(json.dumps(output, indent=2, ensure_ascii=False))
            return 0

        if args.check:
            print(f"OK: {args.input_file} conforms to dense-dispatch/v1 (all hashes, bindings, and assertions valid).")
            return 0

        # Default action if neither --check nor --render is specified
        print(f"Validated {args.input_file} successfully.")
        return 0

    except ValueError as ve:
        sys.stderr.write(f"Validation failure (fail-closed): {ve}\n")
        return 1
    except Exception as e:
        sys.stderr.write(f"Unexpected error: {e}\n")
        return 1


if __name__ == "__main__":
    sys.exit(main())
