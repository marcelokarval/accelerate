"""Named A04 rows exercise production validators and production outcomes."""
import hashlib, json, tempfile, unittest
from pathlib import Path
from core.phase1.contracts import execute_a04, regenerate_output_snapshot
from test_phase1 import base, D, readiness_context, AUTH_KEY
from core.phase1.contracts import readiness_signature, a04_outcome_digest, ContractError
from core.phase1.contracts import A04_POLICY, A04_PRIVATE_REASON, A04_PRIVATE_PREDICATE, canonical_bytes, domain_digest
from test_phase1 import gate_context

M=json.loads((Path(__file__).parent/'fixtures'/'a04-denominator.json').read_text())
NORMATIVE_FIXTURE=json.loads((Path(__file__).parent/'fixtures'/'a04-normative-outcomes.json').read_text())
NORMATIVE=NORMATIVE_FIXTURE["outcomes"]
DISPOSITION_OUTCOMES=NORMATIVE_FIXTURE["operator_disposition_outcomes"]
ACCEPT={"execution-input-manifest-v1":"execution_input_manifest","review-candidate-manifest-v1":"review_candidate_manifest","root-manifest-accept":"root_review_candidate_manifest","tasks-ready-valid":"tasks_ready_receipt","builder-ready-valid":"builder_ready_receipt","reviewer-ready-valid":"reviewer_ready_receipt"}
def outcome(name, fixture_input, root=None):
    return execute_a04(name,fixture_input,root)
SNAPSHOT_CONTEXT_KEYS=("generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests")
def digest(label): return "sha256:"+hashlib.sha256(label.encode()).hexdigest()
def snapshot_context(label="baseline"):
    return {key:[digest(f"{label}:{key}")] for key in SNAPSHOT_CONTEXT_KEYS}
def mutate_context(context, *keys):
    actual={key:list(value) for key,value in context.items()}
    for key in keys: actual[key]=[digest(f"changed:{key}")]
    return actual
def execute(name):
    if name in ACCEPT:
        schema=ACCEPT[name]
        value=base(schema)
        if schema=="root_review_candidate_manifest": return outcome(name,{"value":value,"root_context":{"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D}})
        if schema.endswith("receipt"): return outcome(name,{"value":value,"expected_context":readiness_context(schema,value)})
        return outcome(name,{"value":value})
    if name in M["snapshot_negatives"] or name=="output-tree-mismatch-reject":
        # The closed dispatcher deliberately owns the snapshot action; a bad
        # structured candidate proves its rejection without a test callback.
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); (root/"a").write_text("one")
            supplied=regenerate_output_snapshot(root); (root/"a").write_text("changed")
            return outcome(name,{"value":supplied},root)
    if name.startswith(("g4-","g5-","g6-")):
        schema="domain_gauntlet_"+name[:2]+"_receipt_set"; value=base(schema); context=gate_context(schema,value); value["participant_ids"]=["one","two"]
        # The collection denominator is rejected before cryptographic context
        # verification, so this reaches the named multi-member predicate.
        return outcome(name,{"schema_id":schema,"value":value,"expected_participants":["one"],"candidate_digest":D,"parent":"parent" if name.startswith("g4-") else None,"expected_context":context})
    if name.startswith("root-") or name in {"included-input-mutation","proof-before-review-candidate-freeze-reject"}:
        value=base("root_review_candidate_manifest")
        if name=="root-manifest-unknown-field-reject":value["unrecognized"]=1
        elif name=="root-manifest-duplicate-semantic-child-reject":value["children"].append(dict(value["children"][0]))
        elif name=="root-manifest-non-denominator-child-reject":value["children"][0]["node_id"]="foreign"
        elif name=="root-manifest-current-child-set-mismatch-reject":value["current_child_set_digest"]="sha256:"+"b"*64
        elif name in {"root-manifest-nonaccepted-child-reject","root-manifest-unknown-active-child-reject","root-manifest-failed-child-reject","root-manifest-blocked-child-reject"}:value["children"][0]["state"]="FAILED"
        elif name=="root-manifest-invalid-omission-or-replacement-reject":
            return outcome(name,{"value":value,"root_context":{"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D},"operator_disposition":{"action":"omit","reason":""}})
        elif name=="included-input-mutation":
            import copy
            predecessor=copy.deepcopy(value); mutated=base("execution_input_manifest")
            mutated["intent_digest"]="sha256:"+"b"*64
            return outcome(name,{"predecessor":predecessor,"predecessor_candidate_digest":domain_digest("root_review_candidate_manifest",predecessor),"mutated_execution_input_manifest":mutated,"root_context":{"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D}})
        elif name=="proof-before-review-candidate-freeze-reject":
            return outcome(name,{"value":value,"root_context":{"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D},"frozen_candidate":False,"gate_evidence":False})
        return outcome(name,{"value":value,"root_context":{"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D}})
    schema="tasks_ready_receipt" if name.startswith("tasks-ready") else ("builder_ready_receipt" if name.startswith("builder-ready") else "reviewer_ready_receipt")
    value=base(schema)
    context=readiness_context(schema,value)
    if name=="tasks-ready-missing-required-skill-plan-reject": value["node_bindings"][0].pop("required_skill_ids")
    elif name=="tasks-ready-duplicate-node-reject": value["node_bindings"].append(dict(value["node_bindings"][0]))
    elif name=="tasks-ready-bare-family-reject": value["receipt_family"]="readiness"
    elif name=="tasks-ready-stale-binding-reject": value["expires_at"]="2026-09-02T01:00:00Z"; context=readiness_context(schema,value)
    elif name=="tasks-ready-bound-input-change-reject": value["binding_readback_digest"]="sha256:"+"b"*64
    elif name=="tasks-ready-unresolvable-loader-capability-reject":
        # Context is an immutable authoritative readback, not a shallow alias
        # of the candidate's mutable node-binding object.
        import copy
        context=copy.deepcopy(context); value["node_bindings"][0]["loader_digest"]="sha256:"+"b"*64
    elif name=="builder-ready-missing-worker-reject": value.pop("worker_actor_id")
    elif name=="builder-ready-wrong-worker-reject": value["worker_actor_id"]="other-worker"
    elif name=="builder-ready-missing-ack-reject": value.pop("bootstrap_ack_digest")
    elif name=="builder-ready-lease-fence-reject": value["lease_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="builder-ready-prompt-load-reject": value["prompt_load_receipt_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="builder-ready-capability-reject": value["capability_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="reviewer-ready-missing-candidate-reject": value.pop("review_candidate_digest")
    elif name=="reviewer-ready-wrong-assignment-reject": value["reviewer_assignment_digest"]="sha256:"+"b"*64
    elif name=="reviewer-ready-actor-runtime-reject": value["runtime_instance_id"]="other-runtime"
    elif name=="reviewer-ready-ack-lease-fence-reject": value["fence_token_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="reviewer-ready-prompt-load-reject": value["prompt_load_receipt_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="reviewer-ready-proof-independence-reject": value["independence_digest"]="not-a-digest"; context=readiness_context(schema,value)
    elif name=="reviewer-ready-capability-reject": value["capability_digests"]=["not-a-digest"]; context=readiness_context(schema,value)
    value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id=schema,validator_id="fixture-validator",trust_root="fixture-root")
    return outcome(name,{"value":value,"expected_context":context})

class A04NamedFixtures(unittest.TestCase): pass
for fixture_name in M["main"]+M["supplemental"]+M["snapshot_negatives"]:
    def test(self,name=fixture_name):
        result=execute(name)
        expected=NORMATIVE[name]
        self.assertEqual(set(result),{"code","result_state","revision_effect","forbidden_effect","receipt_digests"})
        self.assertEqual((result["code"],result["result_state"],result["revision_effect"],result["forbidden_effect"]),tuple(expected[:4]))
        self.assertEqual(tuple(result["receipt_digests"]),tuple(expected[4]))
        if name in A04_PRIVATE_REASON:self.assertEqual(A04_PRIVATE_PREDICATE[name],"exact:"+A04_PRIVATE_REASON[name])
    setattr(A04NamedFixtures,"test_"+fixture_name.replace("-","_"),test)

class A04ObservedReceipt(unittest.TestCase):
    def test_normative_fixture_covers_the_frozen_49_row_denominator_without_policy_derivation(self):
        names=M["main"]+M["supplemental"]+M["snapshot_negatives"]
        self.assertEqual(len(names),49)
        self.assertEqual(set(NORMATIVE),set(names))
        self.assertIsNot(NORMATIVE,A04_POLICY)
    def test_included_input_mutation_requires_eligible_predecessor_and_constructs_successor(self):
        import copy
        predecessor=base("root_review_candidate_manifest")
        predecessor_bytes=canonical_bytes(predecessor)
        predecessor_digest=domain_digest("root_review_candidate_manifest",predecessor)
        mutated=base("execution_input_manifest")
        mutated["intent_digest"]="sha256:"+"b"*64
        context={"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D}
        result=outcome("included-input-mutation",{"predecessor":predecessor,"predecessor_candidate_digest":predecessor_digest,"mutated_execution_input_manifest":mutated,"root_context":context})
        self.assertEqual(canonical_bytes(predecessor),predecessor_bytes)
        self.assertEqual(result["receipt_digests"]["predecessor"],predecessor_digest)
        self.assertNotEqual(result["receipt_digests"]["successor"],predecessor_digest)
        for invalid in (None,"not-a-candidate",{"arbitrary":"map"}):
            with self.assertRaises(ContractError):
                outcome("included-input-mutation",{"predecessor":invalid,"predecessor_candidate_digest":predecessor_digest,"mutated_execution_input_manifest":mutated,"root_context":context})
        with self.assertRaises(ContractError):
            outcome("included-input-mutation",{"predecessor":predecessor,"predecessor_candidate_digest":predecessor_digest,"successor":copy.deepcopy(predecessor),"mutated_execution_input_manifest":mutated,"root_context":context})
    def test_operator_disposition_valid_and_invalid_forms_have_distinct_normalized_public_outcomes(self):
        value=base("root_review_candidate_manifest")
        context={"frozen_node_ids":["one"],"current_child_set_digest":D,"candidate_digest":D}
        cases=(({"action":"omit","reason":"operator-approved"},DISPOSITION_OUTCOMES["valid_but_insufficient"]),({"action":"omit","reason":""},DISPOSITION_OUTCOMES["invalid"]),({"action":"replace","reason":None},DISPOSITION_OUTCOMES["invalid"]))
        observed=[]
        for disposition,expected in cases:
            result=outcome("root-manifest-invalid-omission-or-replacement-reject",{"value":value,"root_context":context,"operator_disposition":disposition})
            outcome_tuple=(result["code"],result["result_state"],result["revision_effect"],result["forbidden_effect"],tuple(result["receipt_digests"]))
            self.assertEqual(outcome_tuple,(*expected[:4],tuple(expected[4])))
            observed.append(outcome_tuple)
        self.assertNotEqual(observed[0],observed[1])
    def test_observed_error_state_changes_receipt_and_changed_noop_rejects(self):
        one=a04_outcome_digest("commit-extra-file","REJECTED","OUTPUT_SNAPSHOT_MISMATCH","unchanged","no_assignment_or_review_effect")
        two=a04_outcome_digest("commit-extra-file","REJECTED","COMMIT_SNAPSHOT_DIRTY","unchanged","no_assignment_or_review_effect")
        self.assertNotEqual(one,two)
        with self.assertRaises(ContractError): execute_a04("tasks-ready-valid",lambda: True)
    def test_closed_boundary_has_no_callback_or_adapter_api(self):
        import inspect
        self.assertEqual(tuple(inspect.signature(execute_a04).parameters),("name","fixture_input","root"))
        self.assertNotIn("A04StateAdapter",dir(__import__("core.phase1.contracts",fromlist=["*"])))
    def test_cross_name_private_reason_cannot_borrow_no_go(self):
        value=base("builder_ready_receipt"); value.pop("worker_actor_id")
        value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id="builder_ready_receipt",validator_id="fixture-validator",trust_root="fixture-root")
        with self.assertRaisesRegex(ContractError,"A04_SEMANTIC_MISMATCH"):
            execute_a04("builder-ready-capability-reject",{"value":value,"expected_context":readiness_context("builder_ready_receipt",value)})
    def test_public_policy_rebind_or_mutation_cannot_change_execution(self):
        import core.phase1.contracts as contracts
        original=contracts.A04_POLICY
        with self.assertRaises(TypeError): contracts.A04_POLICY["tasks-ready-valid"]=("REJECTED","NO_GO","unchanged","no_spawn_or_write","tasks-ready")
        try:
            contracts.A04_POLICY={"tasks-ready-valid":("REJECTED","NO_GO","unchanged","no_spawn_or_write","tasks-ready")}
            value=base("tasks_ready_receipt")
            result=execute_a04("tasks-ready-valid",{"value":value,"expected_context":readiness_context("tasks_ready_receipt",value)})
            self.assertEqual(result["result_state"],"READY")
        finally: contracts.A04_POLICY=original

class SnapshotBindingDenominator(unittest.TestCase):
    def test_dependency_lock_config_and_environment_bindings_each_reject_with_a_stable_tree(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)/"repo";root.mkdir();(root/"a").write_text("stable")
            baseline=snapshot_context(); supplied=regenerate_output_snapshot(root,context=baseline)
            for key in SNAPSHOT_CONTEXT_KEYS:
                result=outcome("dependency-lock-config-env-input",{"value":supplied,"actual_context":mutate_context(baseline,key)},root)
                self.assertEqual(result["result_state"],"OUTPUT_SNAPSHOT_MISMATCH")
            result=outcome("dependency-lock-config-env-input",{"value":supplied,"actual_context":mutate_context(baseline,*SNAPSHOT_CONTEXT_KEYS)},root)
            self.assertEqual(result["result_state"],"OUTPUT_SNAPSHOT_MISMATCH")
