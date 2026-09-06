#!/usr/bin/env python3
"""Fail-closed validation for semantic implication receipts."""
from __future__ import annotations

import json
import hashlib
import re
import unicodedata
import sys
from pathlib import Path
from typing import Any

import yaml
from yaml.constructor import ConstructorError
from jsonschema import Draft202012Validator


REPO = Path(__file__).resolve().parents[1]
SCHEMA_PATH = REPO / "assets/schemas/semantic-implication-receipt.schema.json"
REGISTRY_PATH = REPO / "assets/registries/domain-risk-registry.yaml"
SCHEMA_SHA256 = "2894c34f7597e78153ceddf0e2c4c9377a07f7003ed5ef89f2c6c7f7f87a2f0d"
REGISTRY_SHA256 = "db29abc6e914210519c7e4d00273c5468de9fd0b675428c51980100f5d981368"


class UniqueKeySafeLoader(yaml.SafeLoader):
    """Safe YAML loader that rejects duplicate mapping keys at every depth."""


def construct_unique_mapping(loader: UniqueKeySafeLoader, node: yaml.MappingNode, deep: bool = False) -> dict[Any, Any]:
    mapping: dict[Any, Any] = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if key in mapping:
            raise ConstructorError("while constructing a mapping", node.start_mark, f"duplicate key: {key}", key_node.start_mark)
        mapping[key] = loader.construct_object(value_node, deep=deep)
    return mapping


UniqueKeySafeLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_unique_mapping)


def fail(message: str) -> None:
    raise ValueError(message)


def verify_anchor(path: Path, expected: str) -> None:
    try:
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
    except OSError as error:
        fail(f"cannot read anchored artifact {path}: {error}")
    if actual != expected:
        fail(f"governed semantic anchor mismatch: {path.name}")


def load_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"cannot read JSON {path}: {error}")
    if not isinstance(value, dict):
        fail(f"JSON document must be an object: {path}")
    return value


def load_yaml(path: Path) -> dict[str, Any]:
    try:
        value = yaml.load(path.read_text(encoding="utf-8"), Loader=UniqueKeySafeLoader)
    except (OSError, yaml.YAMLError) as error:
        fail(f"cannot read YAML {path}: {error}")
    if not isinstance(value, dict):
        fail(f"YAML document must be an object: {path}")
    return value


def schema_values(schema: dict[str, Any], field: str) -> set[str]:
    definition = schema["properties"][field]
    reference = definition.get("$ref")
    if reference:
        definition = schema["$defs"][reference.rsplit("/", 1)[-1]]
    values = definition.get("enum")
    if values is None:
        values = definition.get("items", {}).get("enum")
    if not isinstance(values, list) or not all(isinstance(item, str) for item in values):
        fail(f"schema {field} enum is invalid")
    return set(values)


def validate_registry(registry: dict[str, Any], schema: dict[str, Any]) -> None:
    if set(registry) != {"registry_version", "risk_order", "sensitive_signals", "domain_locks", "direct_fast_path_admission", "domains"}:
        fail("registry must contain only known top-level fields")
    if registry["registry_version"] != "domain-risk-registry/v1":
        fail("registry has unsupported registry_version")
    risk_order = registry["risk_order"]
    if not isinstance(risk_order, list) or risk_order != ["low", "medium", "high", "critical"]:
        fail("registry risk_order must be low, medium, high, critical")
    domains = registry["domains"]
    if not isinstance(domains, dict) or set(domains) != schema_values(schema, "domain"):
        fail("registry domain denominator must equal schema domains")
    list_fields = {
        "required_invariants": "invariants",
        "required_seams": "seams",
        "required_effects": "effects",
        "required_external_effects": "external_effects",
        "required_risk_basis": "risk_basis",
        "required_implications": "implications",
        "required_proof": "required_proof",
    }
    expected_fields = {"minimum_risk", "required_capability", "allowed_reversibility", "required_route", "escalation_required", *list_fields}
    for domain, policy in domains.items():
        if not isinstance(policy, dict) or set(policy) != expected_fields:
            fail(f"registry policy is malformed: {domain}")
        if policy["minimum_risk"] not in risk_order:
            fail(f"registry policy has invalid minimum_risk: {domain}")
        if policy["required_capability"] not in schema_values(schema, "capability"):
            fail(f"registry policy has invalid required_capability: {domain}")
        if policy["required_route"] not in {"direct-fast-path", "scoped", "orchestrated"}:
            fail(f"registry policy has invalid required_route: {domain}")
        if not isinstance(policy["escalation_required"], bool):
            fail(f"registry policy has invalid escalation_required: {domain}")
        if not isinstance(policy["allowed_reversibility"], list) or not policy["allowed_reversibility"] or not set(policy["allowed_reversibility"]) <= {"reversible", "reversible-with-rollback", "irreversible-or-constrained"}:
            fail(f"registry policy has invalid allowed_reversibility: {domain}")
        for policy_field, receipt_field in list_fields.items():
            required = policy[policy_field]
            if not isinstance(required, list) or not required or len(required) != len(set(required)):
                fail(f"registry policy has invalid {policy_field}: {domain}")
            if not set(required) <= schema_values(schema, receipt_field):
                fail(f"registry policy contains unknown {policy_field}: {domain}")


def validate_receipt(receipt: dict[str, Any], schema: dict[str, Any], registry: dict[str, Any]) -> None:
    errors = sorted(Draft202012Validator(schema).iter_errors(receipt), key=lambda error: list(error.path))
    if errors:
        fail(f"schema violation: {errors[0].message}")
    binding = receipt["prompt_binding"]
    normalized_source = unicodedata.normalize("NFKC", binding["raw_prompt"]).casefold()
    normalized = " ".join(re.findall(r"[a-z0-9]+", normalized_source))
    if binding["sha256"] != hashlib.sha256(binding["raw_prompt"].encode()).hexdigest() or binding["normalized_prompt"] != normalized:
        fail("prompt binding digest or normalization mismatch")
    known = set(schema["properties"]["prompt_binding"]["properties"]["normalized_signals"]["items"]["enum"])
    signals = sorted(set(normalized.split()) & known)
    if binding["normalized_signals"] != signals:
        fail("prompt binding normalized_signals mismatch")
    for signal, domain in registry["domain_locks"].items():
        if signal in signals and receipt["domain"] != domain:
            fail(f"prompt signal {signal} requires domain {domain}")
    if set(signals) & set(registry["sensitive_signals"]):
        if receipt["risk_tier"] != "critical" or receipt["selected_route"]["route"] != "orchestrated":
            fail("sensitive prompt signals require critical risk and orchestrated route")
    if receipt["selected_route"]["route"] == "direct-fast-path":
        admission = registry["direct_fast_path_admission"]
        if (receipt["domain"] != admission["domain"] or receipt["capability"] != admission["capability"]
                or receipt["risk_tier"] != "low" or receipt["escalation"]["required"]
                or receipt["prompt_binding"]["target_kind"] != admission["target_kind"]
                or not binding["raw_prompt"].isascii()
                or not set(admission["required_signals"]) <= set(signals)
                or (admission.get("exact_signals", False) and set(signals) != set(admission["required_signals"]))
                or normalized != admission["normalized_prompt"]):
            fail("direct-fast-path receipt is not positively admitted")
    elif receipt["risk_tier"] == "low" and not receipt["escalation"]["required"]:
        fail("non-admitted low-risk receipt requires escalation")
    policy = registry["domains"][receipt["domain"]]
    risk_order = registry["risk_order"]
    if risk_order.index(receipt["risk_tier"]) < risk_order.index(policy["minimum_risk"]):
        fail(
            f"risk_tier {receipt['risk_tier']} is below {receipt['domain']} minimum "
            f"{policy['minimum_risk']}"
        )
    if receipt["capability"] != policy["required_capability"]:
        fail(f"{receipt['domain']} requires capability {policy['required_capability']}")
    if receipt["reversibility"] not in policy["allowed_reversibility"]:
        fail(f"{receipt['domain']} has disallowed reversibility {receipt['reversibility']}")
    if receipt["selected_route"]["route"] != policy["required_route"]:
        fail(f"{receipt['domain']} requires route {policy['required_route']}")
    if receipt["escalation"]["required"] != policy["escalation_required"]:
        fail(f"{receipt['domain']} has invalid escalation requirement")
    for policy_field, receipt_field in {
        "required_invariants": "invariants",
        "required_seams": "seams",
        "required_effects": "effects",
        "required_external_effects": "external_effects",
        "required_risk_basis": "risk_basis",
        "required_implications": "implications",
        "required_proof": "required_proof",
    }.items():
        missing = sorted(set(policy[policy_field]) - set(receipt[receipt_field]))
        if missing:
            label = receipt_field.replace("_", " ")
            fail(f"{receipt['domain']} requires {label}: {', '.join(missing)}")


def main() -> int:
    paths = [Path(argument) for argument in sys.argv[1:]]
    if not paths:
        fail("usage: validate-semantic-implication.py RECEIPT.yaml [RECEIPT.yaml ...]")
    verify_anchor(SCHEMA_PATH, SCHEMA_SHA256)
    verify_anchor(REGISTRY_PATH, REGISTRY_SHA256)
    schema = load_json(SCHEMA_PATH)
    registry = load_yaml(REGISTRY_PATH)
    validate_registry(registry, schema)
    for path in paths:
        validate_receipt(load_yaml(path), schema, registry)
    print(f"PASS: semantic implication receipts validated ({len(paths)} receipt(s))")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ValueError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
