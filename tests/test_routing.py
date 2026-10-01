"""Behavioral checks for routing and preservation of handoff decisions."""

import copy
import unittest

from core.routing import classify, validate_handoff


def request(**changes):
    value = dict(engineering=True, bounded=True, reversible=True,
                 uncertainty=False, multi_step=False, explicit_asds=False, risks=[])
    return value | changes


def handoff():
    return dict(objective="Update the selected project", project="/projects/example",
                scope=["Selected feature"], constraints=["Do not deploy"],
                risks=[], references=[], authorizations=[])


class RoutingTests(unittest.TestCase):
    def test_conversation_does_not_activate_asds(self):
        result = classify(request(engineering=False))
        self.assertEqual((result["route"], result["process_owner"]),
                         ("conversation", "accelerate"))

    def test_trivial_work_stays_direct(self):
        result = classify(request())
        self.assertEqual((result["classification"], result["route"]), ("trivial", "direct"))

    def test_explicit_asds_is_honored_even_for_a_small_request(self):
        for engineering in (False, True):
            with self.subTest(engineering=engineering):
                result = classify(request(explicit_asds=True, engineering=engineering))
                self.assertEqual(result["route"], "asds")
                self.assertEqual(result["process_owner"], "asds-after-acceptance")

    def test_each_complexity_observation_excludes_trivial_route(self):
        for field, value in (("bounded", False), ("reversible", False),
                             ("uncertainty", True), ("multi_step", True)):
            with self.subTest(field=field):
                self.assertEqual(classify(request(**{field: value}))["route"], "asds")

    def test_sensitive_and_unknown_risks_cannot_bypass_asds(self):
        for risk in ("auth", "billing", "permissions", "sensitive data", "migration",
                     "secrets", "irreversible effect", "runtime truth", "new risk"):
            with self.subTest(risk=risk):
                self.assertEqual(classify(request(risks=[risk]))["route"], "asds")

    def test_routing_does_not_mutate_observations_or_create_permission_fields(self):
        value = request(risks=["billing"])
        original = copy.deepcopy(value)
        result = classify(value)
        result["reasons"].append("caller edit")
        self.assertEqual(value, original)
        self.assertEqual(set(result), {"classification", "route", "process_owner", "reasons"})

    def test_controls_reject_truthy_strings_and_integers(self):
        for field in set(request()) - {"risks"}:
            for value in ("false", "true", 0, 1, None):
                with self.subTest(field=field, value=value), self.assertRaises(ValueError):
                    classify(request(**{field: value}))

    def test_malformed_risk_lists_are_rejected(self):
        for value in (None, "billing", [""], [" "], [False], {}):
            with self.subTest(value=value), self.assertRaises(ValueError):
                classify(request(risks=value))

    def test_missing_or_unknown_request_fields_are_rejected(self):
        value = request()
        del value["explicit_asds"]
        for invalid in (value, request(consent=True), None, []):
            with self.subTest(invalid=invalid), self.assertRaises(ValueError):
                classify(invalid)

    def test_complex_or_ambiguous_conversation_stays_direct(self):
        for changes in ({"risks": ["billing"]}, {"uncertainty": True},
                        {"multi_step": True}, {"uncertainty": True, "multi_step": True}):
            with self.subTest(changes=changes):
                value = request(engineering=False, **changes)
                self.assertEqual(classify(value)["route"], "conversation")
                self.assertEqual(classify(value | {"explicit_asds": True})["route"], "asds")


class HandoffTests(unittest.TestCase):
    def test_empty_authorizations_stay_empty(self):
        result = validate_handoff(handoff())
        self.assertEqual(result["authorizations"], [])
        self.assertNotIn("initialize_openspec", result)

    def test_grants_and_refusals_preserve_source_and_scope(self):
        value = handoff()
        value["authorizations"] = [
            dict(action="edit", scope="selected feature", decision="granted", source="user message 1"),
            dict(action="deploy", scope="production", decision="denied", source="user message 2"),
        ]
        result = validate_handoff(value)
        self.assertEqual(result, value)
        result["authorizations"][0]["scope"] = "changed"
        self.assertEqual(value["authorizations"][0]["scope"], "selected feature")

    def test_silence_and_pending_are_not_consent(self):
        for decision in (None, True, "pending", "silence", "assumed", ""):
            value = handoff()
            value["authorizations"] = [dict(action="initialize", scope="project",
                                           decision=decision, source="user")]
            with self.subTest(decision=decision), self.assertRaises(ValueError):
                validate_handoff(value)

    def test_missing_authorization_source_is_rejected(self):
        value = handoff()
        value["authorizations"] = [dict(action="edit", scope="feature", decision="granted")]
        with self.assertRaises(ValueError):
            validate_handoff(value)

    def test_missing_and_unknown_handoff_fields_are_rejected(self):
        for field in handoff():
            value = handoff()
            del value[field]
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_handoff(value)
        with self.assertRaises(ValueError):
            validate_handoff(handoff() | {"approved": True})

    def test_blank_project_objective_and_empty_scope_are_rejected(self):
        for field, invalid in (("project", " "), ("objective", ""), ("scope", [])):
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_handoff(handoff() | {field: invalid})

    def test_malformed_context_lists_are_rejected(self):
        for field in ("scope", "constraints", "risks", "references", "authorizations"):
            with self.subTest(field=field), self.assertRaises(ValueError):
                validate_handoff(handoff() | {field: "not a list"})


if __name__ == "__main__":
    unittest.main()
