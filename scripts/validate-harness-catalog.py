#!/usr/bin/env python3
"""Validate the repository-owned harness catalog without inspecting a host catalog."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import stat
import sys
from pathlib import Path, PurePosixPath
from typing import Any

import yaml


LIFECYCLE_STATES = [
    "defined",
    "registered",
    "projected",
    "loader-confirmed",
    "callable",
    "authorized",
    "retired",
]
STATE_RANK = {state: index for index, state in enumerate(LIFECYCLE_STATES)}
NON_CALLABLE_REGISTRY_STATUSES = {
    "legacy-reference",
    "export-only",
    "staged-only",
    "planned",
    "experimental",
    "available",
    "disabled",
    "supported",
}
CANONICAL_INPUT_SHA256 = {
    "catalog/catalog.yaml": "309b2e1b0905d86eb82985121d9030205a1cb3515eabe442a5d39f17a36a5ee6",
    "catalog/namespaces.yaml": "2fd3ea0942a6b29af964197f1ff1218eaafc08e51ac7a123a5eeb9eb921a239f",
    "catalog/provenance.yaml": "7f5d5c04cd9c571982e804b8f90b1c0e16b0b84ef2ebe0e4ac5ce2c6c95cedce",
    "catalog/lifecycle.yaml": "27f70fe66b9a883594d5db9d8f561622c5a4955ae7a676565230e267008bc775",
    "adapters/runtime/runtime-consumer-registry.json": "c3fd92a66307a32d164361b01c962df994ae7992572482798759f9da3b5083c0",
    "adapters/runtime/cross-runtime-bootstrap-manifest.json": "6b5382f6e4a1caca4166b5b17639a479452a1ed4ec1c39f2afb5196c95b1fb57",
}
CANONICAL_HARNESS_SHA256 = {
    "references/harnesses/codex.md": "a31cddf41491bda6cc79e3d60528fa0139efd3bf104f399bb149473c37b530f3",
    "references/harnesses/claude.md": "014b5f11750ea6bf43e8a5951c635aff1cd09e1868fcecf9b94653b6429c7156",
    "references/harnesses/hermes.md": "a65ee5cc8d50eb28f13c9abf4f19539b5e2a90d5469b3f7d006dca18d6918fce",
    "references/harnesses/paperclip.md": "c1682a1ce06d1c16f5f11f90b9d8e43d6c1cb386d3f41bd015553a174977e38f",
    "references/harnesses/deepseek-harness.md": "299559e8672a1df1e40583064b7424466c172c1fecf83af0ea78498b8a19a8a3",
    "references/harnesses/opencode.md": "664e2db9aecbd36f297aa72d05adfbd31b6098306951cd15e4c07b3df685d1af",
    "references/harnesses/openhands.md": "769d2e62ce5192bbc2f7a0581c2cc0b77aed1262b2c570b4bead503dc4120c19",
}


def fail(message: str) -> None:
    raise ValueError(message)


class UniqueKeyLoader(yaml.SafeLoader):
    """Safe YAML loader that rejects duplicate mapping keys instead of last-wins."""


def _construct_unique_mapping(loader: UniqueKeyLoader, node: yaml.MappingNode, deep: bool = False) -> dict[Any, Any]:
    mapping: dict[Any, Any] = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in mapping:
            fail(f"duplicate YAML key: {key!r}")
        mapping[key] = loader.construct_object(value_node, deep=deep)
    return mapping


UniqueKeyLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, _construct_unique_mapping)


def unique_json_object(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    output: dict[str, Any] = {}
    for key, value in pairs:
        if key in output:
            fail(f"duplicate JSON key: {key!r}")
        output[key] = value
    return output


def load_yaml(path: Path) -> dict[str, Any]:
    payload = yaml.load(path.read_text(encoding="utf-8"), Loader=UniqueKeyLoader)
    if not isinstance(payload, dict):
        fail(f"{path}: expected YAML mapping")
    return payload


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=unique_json_object)
    if not isinstance(payload, dict):
        fail(f"{path}: expected JSON mapping")
    return payload


def require_exact_keys(payload: dict[str, Any], keys: set[str], label: str) -> None:
    if set(payload) != keys:
        fail(f"{label} has unknown or missing keys")


def require_canonical_input(root: Path, relative: str) -> None:
    path = root / relative
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != CANONICAL_INPUT_SHA256[relative]:
        fail(f"canonical input drift: {relative}")


def require_canonical_harnesses(root: Path) -> None:
    """Anchor harness meaning before catalog parsing can select or crosscheck it."""
    for relative, expected in CANONICAL_HARNESS_SHA256.items():
        path = safe_source_path(root, relative)
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            fail(f"canonical harness drift: {relative}")


def safe_source_path(root: Path, value: object) -> Path:
    if not isinstance(value, str) or not value:
        fail("source_path must be a non-empty string")
    if "\\" in value:
        fail(f"source_path must be a POSIX path: {value!r}")
    path = PurePosixPath(value)
    if path.is_absolute() or any(part in (".", "..") for part in path.parts):
        fail(f"source_path must be normalized, relative, and traversal-free: {value!r}")
    if path.as_posix() != value:
        fail(f"source_path must be normalized POSIX syntax: {value!r}")

    candidate = root.joinpath(*path.parts)
    try:
        candidate.relative_to(root)
    except ValueError:
        fail(f"source_path escapes repository root: {value!r}")

    current = root
    for part in path.parts:
        current = current / part
        try:
            mode = os.lstat(current).st_mode
        except FileNotFoundError:
            fail(f"source_path target is missing: {value!r}")
        if stat.S_ISLNK(mode):
            fail(f"source_path may not traverse a symlink: {value!r}")
    if not stat.S_ISREG(os.lstat(candidate).st_mode):
        fail(f"source_path target must be a regular file: {value!r}")
    if candidate.resolve().parent != candidate.parent.resolve():
        fail(f"source_path containment resolution failed: {value!r}")
    return candidate


def expected_source_path(identifier: str) -> tuple[str, str]:
    prefix = "prop4you.accelerate.harness."
    if not isinstance(identifier, str) or not identifier.startswith(prefix):
        fail(f"{identifier!r}: harness id must use the canonical harness namespace")
    runtime = identifier.removeprefix(prefix)
    if not runtime or "/" in runtime or "\\" in runtime:
        fail(f"{identifier}: invalid harness runtime identity")
    return runtime, f"references/harnesses/{runtime}.md"


def safe_evidence_path(root: Path, value: object, label: str) -> Path:
    path = safe_source_path(root, value)
    relative = path.relative_to(root)
    if relative.parts[0] == "catalog":
        fail(f"{label} must be independent of catalog declarations")
    return path


def digest_bound_file(root: Path, path_value: object, digest: object, label: str) -> Path:
    path = safe_evidence_path(root, path_value, label)
    if not isinstance(digest, str) or digest != hashlib.sha256(path.read_bytes()).hexdigest():
        fail(f"{label} digest is stale or invalid")
    return path


def validate_evidence_binding(
    path: Path, receipt: dict[str, Any], evidence_kind: str, label: str
) -> None:
    try:
        payload = load_json(path)
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        fail(f"{label} must be a machine-readable JSON binding: {exc}")
    expected = {
        "asset_id": receipt["asset_id"],
        "source_path": receipt["source_path"],
        "source_sha256": receipt["source_sha256"],
        "to": receipt["to"],
        "receipt_type": receipt["receipt_type"],
        "evidence_kind": evidence_kind,
    }
    if set(payload) != set(expected) or any(payload.get(key) != value for key, value in expected.items()):
        fail(f"{label} is not bound to its catalog receipt")


def validate_receipts(
    root: Path, asset: dict[str, Any], state: str, source: Path, rules: dict[str, dict[str, Any]]
) -> None:
    if state == "defined":
        if "lifecycle_receipts" in asset:
            fail(f"{asset['id']}: defined asset may not carry lifecycle receipts")
        return
    expected_states = LIFECYCLE_STATES[1 : STATE_RANK[state] + 1]
    receipts = asset.get("lifecycle_receipts")
    if not isinstance(receipts, list) or len(receipts) != len(expected_states):
        fail(f"{asset['id']}: lifecycle_state above defined requires complete receipt chain")
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    for receipt, destination in zip(receipts, expected_states, strict=True):
        required_keys = {
            "to", "receipt_type", "asset_id", "source_path", "source_sha256"
            , "evidence_path", "evidence_sha256"
        }
        rule = rules[destination]
        if rule.get("requires_projection_artifact"):
            required_keys |= {
                "projection_artifact_path", "projection_artifact_sha256",
                "readback_path", "readback_sha256",
            }
        if not isinstance(receipt, dict) or set(receipt) != required_keys:
            fail(f"{asset['id']}: lifecycle receipt has invalid shape")
        if receipt["to"] != destination or receipt["receipt_type"] != rule["required_receipt"]:
            fail(f"{asset['id']}: lifecycle receipt transition is incoherent")
        if receipt["asset_id"] != asset["id"] or receipt["source_path"] != asset["source_path"]:
            fail(f"{asset['id']}: lifecycle receipt is not asset/source bound")
        if receipt["source_sha256"] != digest:
            fail(f"{asset['id']}: lifecycle receipt source digest is stale or invalid")
        evidence = digest_bound_file(root, receipt["evidence_path"], receipt["evidence_sha256"], "receipt evidence")
        if evidence == source:
            fail(f"{asset['id']}: receipt evidence must be independent of source artifact")
        validate_evidence_binding(evidence, receipt, rule["required_evidence_kind"], "receipt evidence")
        if rule.get("requires_projection_artifact"):
            artifact = digest_bound_file(
                root, receipt["projection_artifact_path"], receipt["projection_artifact_sha256"], "projection artifact"
            )
            readback = digest_bound_file(
                root, receipt["readback_path"], receipt["readback_sha256"], "projection readback"
            )
            if len({artifact, readback, evidence, source}) != 4:
                fail(f"{asset['id']}: projection evidence must use independent physical artifacts")
            validate_evidence_binding(artifact, receipt, "projection-artifact", "projection artifact")
            validate_evidence_binding(readback, receipt, "provider-or-loader-readback", "projection readback")


def registry_statuses(root: Path) -> tuple[dict[str, str], dict[str, str]]:
    consumer_path = root / "adapters/runtime/runtime-consumer-registry.json"
    bootstrap_path = root / "adapters/runtime/cross-runtime-bootstrap-manifest.json"
    consumer_payload = load_json(consumer_path)
    bootstrap_payload = load_json(bootstrap_path)
    require_exact_keys(consumer_payload, {"registry_version", "purpose", "consumers"}, "consumer registry")
    require_exact_keys(bootstrap_payload, {"contract_version", "semantic_core", "runtimes"}, "bootstrap manifest")
    if not isinstance(consumer_payload["consumers"], list) or not isinstance(bootstrap_payload["runtimes"], dict):
        fail("runtime registries have invalid collection shapes")
    for item in consumer_payload["consumers"]:
        if not isinstance(item, dict):
            fail("consumer registry entry must be a mapping")
        require_exact_keys(item, {"runtime", "status", "source_authority", "projection", "loader", "native_primitive", "adapter", "proof", "install", "rollback"}, "consumer registry entry")
        if not isinstance(item["projection"], dict):
            fail("consumer registry projection must be a mapping")
        require_exact_keys(item["projection"], {"mode", "path", "behavior_change"}, "consumer registry projection")
    for item in bootstrap_payload["runtimes"].values():
        if not isinstance(item, dict):
            fail("bootstrap runtime entry must be a mapping")
        require_exact_keys(item, {"status", "apply_eligible", "loader", "projection"}, "bootstrap runtime entry")
    consumers = {
        item["runtime"]: item["status"]
        for item in consumer_payload["consumers"]
    }
    if len(consumers) != len(consumer_payload["consumers"]):
        fail("consumer registry contains duplicate runtime IDs")
    bootstrap = {
        name: payload["status"]
        for name, payload in bootstrap_payload["runtimes"].items()
    }
    return consumers, bootstrap


def validate(root: Path) -> None:
    root = root.resolve(strict=True)
    require_canonical_harnesses(root)
    catalog = load_yaml(root / "catalog/catalog.yaml")
    lifecycle = load_yaml(root / "catalog/lifecycle.yaml")
    namespaces = load_yaml(root / "catalog/namespaces.yaml")
    provenance = load_yaml(root / "catalog/provenance.yaml")
    catalog_keys = {"schema_version", "catalog_id", "authority", "assets"}
    if "runtime_registry_aliases" in catalog:
        catalog_keys.add("runtime_registry_aliases")
    require_exact_keys(catalog, catalog_keys, "catalog")
    if not isinstance(catalog["authority"], dict):
        fail("catalog authority must be a mapping")
    require_exact_keys(catalog["authority"], {"canonical_source", "repository_root", "installed_discovery_catalog", "installed_catalog_role", "promotion", "lifecycle_receipt_binding", "statement"}, "catalog authority")
    if catalog["authority"]["canonical_source"] != "repository":
        fail("catalog authority canonical_source must be repository")
    if catalog["authority"]["promotion"] != "separate-receipt-required-not-authorized-by-catalog":
        fail("catalog authority promotion must remain separately authorized")
    if "runtime_registry_aliases" in catalog:
        aliases = catalog["runtime_registry_aliases"]
        if not isinstance(aliases, dict):
            fail("runtime_registry_aliases must be a mapping")
        for alias_name, alias in aliases.items():
            if not isinstance(alias_name, str) or not isinstance(alias, dict):
                fail("runtime alias policy must be a string-keyed mapping")
            require_exact_keys(alias, {"runtime_identity", "consumer", "bootstrap"}, "runtime alias policy")
            if alias["runtime_identity"] != alias_name or alias["consumer"] != alias_name or alias["bootstrap"] != alias_name:
                fail("runtime alias policy may not redirect canonical identity")
    require_exact_keys(lifecycle, {"schema_version", "states", "rules", "invariants"}, "lifecycle catalog")
    require_exact_keys(namespaces, {"schema_version", "canonical_namespace", "namespaces", "collision_policy"}, "namespace catalog")
    require_exact_keys(provenance, {"schema_version", "provenance"}, "provenance catalog")
    if not isinstance(namespaces["namespaces"], list) or not isinstance(namespaces["collision_policy"], dict):
        fail("namespace catalog has invalid collection shapes")
    for namespace in namespaces["namespaces"]:
        if not isinstance(namespace, dict):
            fail("namespace entry must be a mapping")
        expected = {"name", "owner", "reserved_unqualified_names"} if "reserved_unqualified_names" in namespace else {"name", "owner", "parent"}
        require_exact_keys(namespace, expected, "namespace entry")
    collision = namespaces["collision_policy"]
    require_exact_keys(collision, {"comparison", "unqualified_lookup", "reserved_name_rule", "external_distribution_exception", "resolution_on_collision"}, "collision policy")
    if not isinstance(collision["external_distribution_exception"], dict):
        fail("external distribution exception must be a mapping")
    require_exact_keys(collision["external_distribution_exception"], {"distribution", "forbidden_aliases", "required_identifier", "rationale"}, "external distribution exception")
    if namespaces["canonical_namespace"] != "prop4you.accelerate":
        fail("canonical namespace must be prop4you.accelerate")
    if collision["unqualified_lookup"] != "denied" or collision["resolution_on_collision"] != "block-and-report":
        fail("collision policy must deny unqualified lookup and block collisions")
    if not isinstance(provenance["provenance"], list):
        fail("provenance catalog must be a list")
    provenance_shapes = {
        "repository-owned": {"subject", "source_class", "canonical_location", "projection_rule"},
        "installed-projection": {"subject", "source_class", "location", "authority", "prohibited_inference"},
        "external-package": {"subject", "source_class", "authority", "relation_to_catalog"},
        "external-service": {"subject", "source_class", "authority", "relation_to_catalog", "prohibited_fallbacks"},
    }
    for entry in provenance["provenance"]:
        if not isinstance(entry, dict) or entry.get("source_class") not in provenance_shapes:
            fail("provenance entry has unknown source class")
        require_exact_keys(entry, provenance_shapes[entry["source_class"]], "provenance entry")
    if lifecycle.get("states") != LIFECYCLE_STATES:
        fail("catalog lifecycle states drift from the closed canonical vocabulary")
    rules = lifecycle.get("rules")
    if not isinstance(rules, list):
        fail("catalog lifecycle rules must be a list")
    if not all(isinstance(rule, dict) for rule in rules):
        fail("catalog lifecycle rule must be a mapping")
    receipt_types = {
        rule.get("to"): rule
        for rule in rules
        if isinstance(rule, dict)
    }
    if (
        set(receipt_types) != set(LIFECYCLE_STATES[1:])
        or not all(
            isinstance(rule.get("required_receipt"), str)
            and isinstance(rule.get("required_evidence_kind"), str)
            for rule in receipt_types.values()
        )
    ):
        fail("catalog lifecycle rules must cover each advancement with a receipt type")
    for rule in rules:
        expected = {"from", "to", "required_receipt", "required_evidence_kind"}
        if rule.get("requires_projection_artifact"):
            expected.add("requires_projection_artifact")
        require_exact_keys(rule, expected, "lifecycle rule")
    consumers, bootstrap = registry_statuses(root)
    assets = catalog.get("assets")
    if not isinstance(assets, list) or not assets:
        fail("catalog assets must be a non-empty list")
    seen: set[str] = set()
    for asset in assets:
        if not isinstance(asset, dict):
            fail("catalog asset must be a mapping")
        asset_keys = {"id", "namespace", "kind", "source_path", "lifecycle_state", "runtime_registry"}
        if "lifecycle_receipts" in asset:
            asset_keys.add("lifecycle_receipts")
        require_exact_keys(asset, asset_keys, "catalog asset")
        identifier = asset.get("id")
        if not isinstance(identifier, str) or identifier in seen:
            fail(f"catalog asset id is missing or duplicated: {identifier!r}")
        seen.add(identifier)
        runtime, expected_source = expected_source_path(identifier)
        if asset["namespace"] != "prop4you.accelerate.harness" or asset["kind"] != "harness":
            fail(f"{identifier}: namespace or kind is not allowlisted")
        source = safe_source_path(root, asset.get("source_path"))
        if asset.get("source_path") != expected_source:
            fail(f"{identifier}: source_path must bind to its canonical harness identity")
        state = asset.get("lifecycle_state")
        if state not in STATE_RANK:
            fail(f"{identifier}: invalid lifecycle_state {state!r}")
        if state != "defined":
            fail(f"{identifier}: source-only catalog cannot advance lifecycle_state above defined")
        validate_receipts(root, asset, state, source, receipt_types)
        registration = asset.get("runtime_registry")
        if registration == "none":
            if identifier.rsplit(".", 1)[-1] not in {"paperclip", "deepseek-harness"}:
                fail(f"{identifier}: only Paperclip and DeepSeek Harness may omit current registries")
            if state != "defined":
                fail(f"{identifier}: unregistered harness must remain defined-only")
            continue
        if not isinstance(registration, dict) or set(registration) != {"consumer", "bootstrap"}:
            fail(f"{identifier}: runtime_registry must be 'none' or consumer/bootstrap mapping")
        aliases = catalog.get("runtime_registry_aliases", {})
        if not isinstance(aliases, dict):
            fail("runtime_registry_aliases must be a mapping when declared")
        alias = aliases.get(runtime)
        expected_runtime = runtime
        if alias is not None:
            if not isinstance(alias, dict) or set(alias) != {
                "runtime_identity", "consumer", "bootstrap"
            }:
                fail(f"{identifier}: runtime alias policy has invalid shape")
            if alias["runtime_identity"] != runtime or alias["consumer"] != runtime or alias["bootstrap"] != runtime:
                fail(f"{identifier}: runtime alias policy may not redirect canonical identity")
        consumer_name = registration["consumer"]
        bootstrap_name = registration["bootstrap"]
        if consumer_name != expected_runtime or bootstrap_name != expected_runtime:
            fail(
                f"{identifier}: consumer/bootstrap registry identity must bind to "
                f"{expected_runtime!r}"
            )
        if consumer_name not in consumers or bootstrap_name not in bootstrap:
            fail(f"{identifier}: declared runtime registry entry is absent")
        consumer_status = consumers[consumer_name]
        bootstrap_status = bootstrap[bootstrap_name]
        if consumer_status not in NON_CALLABLE_REGISTRY_STATUSES or bootstrap_status not in NON_CALLABLE_REGISTRY_STATUSES:
            fail(f"{identifier}: unknown runtime registry status")
        if STATE_RANK[state] >= STATE_RANK["loader-confirmed"]:
            fail(
                f"{identifier}: registry statuses {consumer_status!r}/{bootstrap_status!r} "
                "do not prove loader, callability, or authorization"
            )
    # The source-only model is closed: parse/schema checks above provide precise
    # diagnostics; exact digests then reject every remaining semantic mutation.
    for relative in CANONICAL_INPUT_SHA256:
        require_canonical_input(root, relative)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    try:
        validate(args.root)
    except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError, yaml.YAMLError) as exc:
        print(f"FAIL harness catalog: {exc}", file=sys.stderr)
        return 1
    print("PASS harness catalog")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
