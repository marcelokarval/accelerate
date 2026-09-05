import json, os, stat, tempfile, unittest, subprocess
from pathlib import Path
from core.phase1.contracts import *
from core.phase1.gauntlet import FixtureGauntletStore, ReplayConflict
from adapters.openspec.fixture_adapter import invoke, AdapterError, FROZEN, FIXTURE_CORE_ARGV, stage_verified_release, run_core_json, run_verified_fixture_flow, fixture_environment

D="sha256:"+"a"*64
AUTH_KEY=b"phase1-test-authority-key"
def readiness_context(schema, value, **bound):
 return {"evaluation_time":__import__('datetime').datetime(2026,9,2,12,tzinfo=__import__('datetime').timezone.utc),**{key:value.get(key,D) for key in REQUIRED_CONTEXT_BINDINGS[schema]},**bound}
def gate_context(schema,value):
 return {"evaluation_time":__import__('datetime').datetime(2026,9,2,12,tzinfo=__import__('datetime').timezone.utc),**{key:value[key] for key in SCHEMAS[schema][2] if key!="validator_signature"},"trust_root":"fixture-root"}
def sealed_catalog(source):
 source["source_digest"]=catalog_source_digest(source);return source
def base(s):
 v, f, fields=SCHEMAS[s]; x={"schema_version":v,"receipt_family":f} if s.endswith("receipt") or s.endswith("receipt_set") else {"schema_id":s,"schema_version":v,"owner_id":OWNER,"phase":1,"contract_family":f}
 for k in fields:
  if k.endswith("digest"): x[k]=D
  elif k in ("issued_at",): x[k]="2026-09-02T00:00:00Z"
  elif k in ("expires_at",): x[k]="2026-09-03T00:00:00Z"
  elif k in ("freshness_basis","validator_signature"): x[k]="valid"
  elif k=="node_bindings": x[k]=[{"node_id":"one","owner_id":"owner","profile_digest":D,"assignment_digest":D,"scope_digest":D,"dependency_digests":[D],"acceptance_digest":D,"proof_digest":D,"required_skill_ids":["skill"],"required_skill_digests":[D],"artifact_digest":D,"projection_digest":D,"loader_digest":D}]
  elif k=="gate_id": x[k]={"domain_gauntlet_g4_receipt_set":"domain-gauntlet:G4","domain_gauntlet_g5_receipt_set":"domain-gauntlet:G5","domain_gauntlet_g6_receipt_set":"domain-gauntlet:G6"}[s]
  elif k=="verdict": x[k]="GO"
  elif k=="allowed_state_advance": x[k]="advance"
  elif k in ("reference_digests","profile_digests","capability_digests","planning_artifact_digests","generated_artifact_digests","dependency_digests","lockfile_digests","config_digests","environment_input_digests","non_goal_digests"): x[k]=[D]
  elif k in ("prerequisite_receipt_digests","receipt_digests"): x[k]={"one":D}
  elif k in ("participant_ids","prerequisite_receipt_ids","receipt_ids"): x[k]=["one"]
  elif k in ("input_artifacts","assignment_lineage"): x[k]=[{"id":"one","digest":D}]
  elif k=="children": x[k]=[{"node_id":"one","state":"ACCEPTED","candidate_id":"candidate","candidate_digest":D,"acceptance_receipt_id":"acceptance","acceptance_receipt_digest":D,"quorum_receipt_id":"quorum","quorum_receipt_digest":D}]
  elif k in ("g4_receipt_set","g5_receipt_set","g6_receipt_set"): x[k]={"id":k,"digest":D}
  elif k in ("output_snapshot","integration_output_snapshot"): x[k]={"mode":"no_commit","root_identity":"root","allowed_paths":[],"tracked_policy":"materialized","entries":[],"generated_artifact_digests":[],"dependency_digests":[],"lockfile_digests":[],"config_digests":[],"environment_input_digests":[]}
  elif k=="proportional_depth": x[k]="fixture"
  elif k=="loop_selectors": x[k]=["one"]
  elif k in ("verifier_actor_id","verifier_actor_epoch"): x[k]="fixture-validator"
  else: x[k]="x"
 if s.endswith("receipt") or s.endswith("receipt_set"):
  x["validator_signature"]=readiness_signature(x,AUTH_KEY,schema_id=s,validator_id="fixture-validator",trust_root="fixture-root")
 return x
class Phase1Contracts(unittest.TestCase):
 def test_git_commit_snapshot_tracks_gitlink_and_dirty_state(self):
  with tempfile.TemporaryDirectory() as d:
   root=Path(d)/"root";sub=Path(d)/"sub";root.mkdir();sub.mkdir()
   def git(cwd,*args):subprocess.run(["git",*args],cwd=cwd,check=True,capture_output=True)
   for repo in (root,sub):git(repo,"init");git(repo,"config","user.email","fixture@example.invalid");git(repo,"config","user.name","fixture")
   (sub/"s").write_text("s");git(sub,"add","s");git(sub,"commit","-m","sub")
   (root/"a").write_text("a");(root/"link").symlink_to("a");git(root,"add","a","link");git(root,"commit","-m","root")
   git(root,"-c","protocol.file.allow=always","submodule","add",str(sub),"module");git(root,"commit","-am","module")
   snap=regenerate_output_snapshot(root,"commit");self.assertTrue(any(e["type"]=="submodule" and e["mode"]==0o160000 for e in snap["entries"]))
   (root/"extra").write_text("x")
   with self.assertRaisesRegex(ContractError,"COMMIT_SNAPSHOT_DIRTY"):regenerate_output_snapshot(root,"commit")
 def test_a04_named_main_and_supplemental_inventory_is_unique(self):
  p=Path(__file__).parent/"fixtures"/"a04-denominator.json"; matrix=json.loads(p.read_text())
  names=matrix["main"]+matrix["supplemental"]+matrix["snapshot_negatives"]
  self.assertEqual(len(names),len(set(names))); self.assertEqual(len(matrix["main"]),35)
  self.assertTrue({"root-manifest-omitted-child-reject","root-manifest-stale-child-reject","root-manifest-missing-gates-reject","root-global-proof-mismatch-reject"}.isdisjoint(names))
 def test_all_nine_accept(self):
  for s in SCHEMAS:
   value=base(s);validate(s,value,expected_context=readiness_context(s,value) if s.endswith("receipt") and not s.endswith("receipt_set") else (gate_context(s,value) if s.endswith("receipt_set") else None))
 def test_closed_and_duplicate_key(self):
  x=base("tasks_ready_receipt"); x["x"]=1
  with self.assertRaisesRegex(ContractError,"UNKNOWN_FIELD"): validate("tasks_ready_receipt",x)
  with self.assertRaisesRegex(ContractError,"DUPLICATE_KEY"): load_strict_json('{"a":1,"a":2}')
 def test_canonical_and_domains(self):
  self.assertEqual(canonical_bytes({"b":1,"a":"é"}),b'{"a":"\xc3\xa9","b":1}')
  self.assertEqual(canonical_bytes({"10":"a","2":"b"}),b'{"10":"a","2":"b"}')
  self.assertNotEqual(domain_digest("execution_input_manifest",{}),domain_digest("review_candidate_manifest",{}))
 def test_semantic_dup_and_bad_digest(self):
  x=base("domain_gauntlet_g4_receipt_set"); x["participant_ids"]=["x","x"]
  with self.assertRaises(ContractError): validate("domain_gauntlet_g4_receipt_set",x)
  x=base("tasks_ready_receipt"); x["binding_digest"]="SHA256:"+"a"*64
  with self.assertRaises(ContractError): validate("tasks_ready_receipt",x)
 def test_gate_lineage_requires_exact_ids_digests_and_parent(self):
  import hashlib
  g4=base("domain_gauntlet_g4_receipt_set"); g4["parent_loop_id"]="parent"
  g5=base("domain_gauntlet_g5_receipt_set"); g5.update({"seam_id":"seam","prerequisite_receipt_ids":["one"],"prerequisite_receipt_digests":{"one":D}})
  g6=base("domain_gauntlet_g6_receipt_set"); g6.update({"flow_id":"flow","prerequisite_receipt_ids":["one"],"prerequisite_receipt_digests":{"one":D}})
  for s,v in (("domain_gauntlet_g4_receipt_set",g4),("domain_gauntlet_g5_receipt_set",g5),("domain_gauntlet_g6_receipt_set",g6)):v["validator_signature"]=readiness_signature(v,AUTH_KEY,schema_id=s,validator_id="fixture-validator",trust_root="fixture-root")
  args={"candidate_digest":D,"parent_loop_id":"parent","seam_id":"seam","flow_id":"flow","participants":{"g4":["one"],"g5":["one"],"g6":["one"]},"expected_contexts":{"g4":gate_context("domain_gauntlet_g4_receipt_set",g4),"g5":gate_context("domain_gauntlet_g5_receipt_set",g5),"g6":gate_context("domain_gauntlet_g6_receipt_set",g6)}}
  validate_gate_lineage(g4,g5,g6,**args)
  g6["prerequisite_receipt_digests"]={"one":"sha256:"+"b"*64}
  with self.assertRaisesRegex(ContractError,"BOUND_INPUT_MISMATCH"): validate_gate_lineage(g4,g5,g6,**args)
 def test_gate_lineage_requires_complete_predecessor_maps(self):
  g4=base("domain_gauntlet_g4_receipt_set");g4.update({"parent_loop_id":"parent","participant_ids":["one","two"],"receipt_ids":["one","two"],"receipt_digests":{"one":D,"two":"sha256:"+"b"*64}})
  g5=base("domain_gauntlet_g5_receipt_set");g5.update({"seam_id":"seam","participant_ids":["one","two"],"receipt_ids":["one","two"],"receipt_digests":{"one":D,"two":"sha256:"+"b"*64},"prerequisite_receipt_ids":["one","two"],"prerequisite_receipt_digests":dict(g4["receipt_digests"])})
  g6=base("domain_gauntlet_g6_receipt_set");g6.update({"flow_id":"flow","participant_ids":["one","two"],"receipt_ids":["one","two"],"receipt_digests":{"one":D,"two":"sha256:"+"b"*64},"prerequisite_receipt_ids":["one","two"],"prerequisite_receipt_digests":dict(g5["receipt_digests"])})
  for s,v in (("domain_gauntlet_g4_receipt_set",g4),("domain_gauntlet_g5_receipt_set",g5),("domain_gauntlet_g6_receipt_set",g6)):v["validator_signature"]=readiness_signature(v,AUTH_KEY,schema_id=s,validator_id="fixture-validator",trust_root="fixture-root")
  args={"candidate_digest":D,"parent_loop_id":"parent","seam_id":"seam","flow_id":"flow","participants":{"g4":["one","two"],"g5":["one","two"],"g6":["one","two"]},"expected_contexts":{"g4":gate_context("domain_gauntlet_g4_receipt_set",g4),"g5":gate_context("domain_gauntlet_g5_receipt_set",g5),"g6":gate_context("domain_gauntlet_g6_receipt_set",g6)}}
  validate_gate_lineage(g4,g5,g6,**args);g5["prerequisite_receipt_ids"]=["one"];g5["prerequisite_receipt_digests"]={"one":D}
  with self.assertRaisesRegex(ContractError,"BOUND_INPUT_MISMATCH"):validate_gate_lineage(g4,g5,g6,**args)
 def test_root_manifest_requires_external_frozen_dag_denominator(self):
  x=base("root_review_candidate_manifest")
  validate_root_manifest_context(x,frozen_node_ids=["one"],current_child_set_digest=D,candidate_digest=D)
  with self.assertRaisesRegex(ContractError,"FROZEN_DAG_DENOMINATOR_MISMATCH"): validate_root_manifest_context(x,frozen_node_ids=["other"],current_child_set_digest=D)
 def test_readiness_context_freshness_authority_and_collection_negatives(self):
  now=__import__('datetime').datetime(2026,9,2,12,tzinfo=__import__('datetime').timezone.utc)
  cases=(("tasks_ready_receipt","execution_input_manifest_digest"),("builder_ready_receipt","builder_assignment_digest"),("reviewer_ready_receipt","review_candidate_digest"))
  for schema,key in cases:
   value=base(schema); context=readiness_context(schema,value,**{key:D}); validate(schema,value,expected_context=context)
   value[key]="sha256:"+"b"*64
   value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id=schema,validator_id="fixture-validator",trust_root="fixture-root")
   with self.assertRaisesRegex(ContractError,"BOUND_INPUT_MISMATCH"): validate(schema,value,expected_context=context)
   value=base(schema); value["expires_at"]="2026-09-02T01:00:00Z";value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id=schema,validator_id="fixture-validator",trust_root="fixture-root")
   with self.assertRaisesRegex(ContractError,"STALE_RECEIPT"): validate(schema,value,expected_context=readiness_context(schema,value))
   value=base(schema); value["validator_signature"]=""
   with self.assertRaisesRegex(ContractError,"AUTHORITY_OR_SIGNATURE"): validate(schema,value,expected_context=readiness_context(schema,value))
   with self.assertRaisesRegex(ContractError,"AUTHORITY_CONTEXT_REQUIRED"): validate(schema,base(schema))
   value=base(schema)
   wrong=readiness_context(schema,value);wrong["authority_key"]=b"wrong"
   with self.assertRaisesRegex(ContractError,"BOUND_INPUT_MISMATCH"):validate(schema,value,expected_context=wrong)
  value=base("tasks_ready_receipt"); value["capability_digests"]=[D,D]
  value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id="tasks_ready_receipt",validator_id="fixture-validator",trust_root="fixture-root")
  with self.assertRaisesRegex(ContractError,"DUPLICATE"): validate("tasks_ready_receipt",value,expected_context=readiness_context("tasks_ready_receipt",value))
 def test_attacker_constructed_verifier_cannot_replace_fixture_authority(self):
  attacker=ReadinessAuthorityVerifier({"fixture-validator":{"fixture-root":b"attacker"}})
  for schema in ("tasks_ready_receipt","builder_ready_receipt","reviewer_ready_receipt"):
   value=base(schema);value["validator_signature"]=readiness_signature(value,b"attacker",schema_id=schema,validator_id="fixture-validator",trust_root="fixture-root")
   with self.assertRaisesRegex(ContractError,"AUTHORITY_OR_SIGNATURE"): validate(schema,value,expected_context=readiness_context(schema,value))
 def test_validation_closes_over_definition_trust_not_exported_global(self):
  import core.phase1.contracts as contracts
  original=contracts.FIXTURE_READINESS_VERIFIER
  try:
   contracts.FIXTURE_READINESS_VERIFIER=ReadinessAuthorityVerifier({"fixture-validator":{"fixture-root":b"attacker"}})
   value=base("tasks_ready_receipt")
   value["validator_signature"]=readiness_signature(value,b"attacker",schema_id="tasks_ready_receipt",validator_id="fixture-validator",trust_root="fixture-root")
   with self.assertRaisesRegex(ContractError,"AUTHORITY_OR_SIGNATURE"): validate("tasks_ready_receipt",value,expected_context=readiness_context("tasks_ready_receipt",value))
  finally: contracts.FIXTURE_READINESS_VERIFIER=original
 def test_gate_authority_freshness_and_external_denominator_negatives(self):
  now=__import__('datetime').datetime(2026,9,2,12,tzinfo=__import__('datetime').timezone.utc)
  for schema in ("domain_gauntlet_g4_receipt_set","domain_gauntlet_g5_receipt_set","domain_gauntlet_g6_receipt_set"):
   value=base(schema); validate(schema,value,expected_context=gate_context(schema,value))
   value["validator_signature"]=""
   with self.assertRaisesRegex(ContractError,"AUTHORITY_OR_SIGNATURE"): validate(schema,value,expected_context=gate_context(schema,value))
   value=base(schema); value["expires_at"]="2026-09-02T01:00:00Z"; value["validator_signature"]=readiness_signature(value,AUTH_KEY,schema_id=schema,validator_id="fixture-validator",trust_root="fixture-root")
   with self.assertRaisesRegex(ContractError,"STALE_RECEIPT"): validate(schema,value,expected_context=gate_context(schema,value))
   value=base(schema); value["participant_ids"]=["one","one"]
   with self.assertRaisesRegex(ContractError,"DUPLICATE"): validate(schema,value,expected_context=gate_context(schema,value))
 def test_d12_d14_negative_matrix(self):
  ident={"kind":"skill","namespace":"phase1","name":"a","version":"v1"}; src=sealed_catalog({"source_id":"catalog","source_digest":D,"mode":"source-only","reader_denominator":["reader"],"reader_bindings":[{"reader_id":"reader","identities":[ident]}],"rollback":{"route":"remove","candidate_digest":D},"entries":[{"identity":ident,"digest":D,"owner_id":"owner","source":{"locator":"repo","revision":"v1","digest":D},"lifecycle":{"state":"active","replacement":"","reader_rationale":"","history":["active"]},"aliases":[]}]}); projection={"source_digest":src["source_digest"],"target_harness":"fixture","target_locator":"fixture","mode":"source-only","reader_id":"reader","lifecycle":"unactivated","rollback_route":"remove"}; validate_source_catalog(src,projection)
  projection["source_digest"]="sha256:"+"b"*64
  with self.assertRaises(ContractError): validate_source_catalog(src,projection)
 def test_catalog_source_digest_rejects_every_governed_stale_mutation(self):
  import copy
  ident={"kind":"skill","namespace":"phase1","name":"a","version":"v1"}
  source=sealed_catalog({"source_id":"catalog","source_digest":D,"mode":"source-only","reader_denominator":["reader"],"reader_bindings":[{"reader_id":"reader","identities":[ident]}],"rollback":{"route":"remove","candidate_digest":D},"entries":[{"identity":ident,"digest":D,"owner_id":"owner","source":{"locator":"repo","revision":"v1","digest":D},"lifecycle":{"state":"active","replacement":"","reader_rationale":"","history":["active"]},"aliases":[]}]})
  for path,value in (("locator","other"),("revision","v2"),("lifecycle","deprecated"),("reader","otherreader"),("rollback","otherroute")):
   changed=copy.deepcopy(source)
   if path in {"locator","revision"}: changed["entries"][0]["source"][path]=value
   elif path=="lifecycle": changed["entries"][0]["lifecycle"].update({"state":value,"reader_rationale":"reason","history":["active","deprecated"]})
   elif path=="reader": changed["reader_denominator"]=[value];changed["reader_bindings"][0]["reader_id"]=value
   else: changed["rollback"]["route"]=value
   with self.assertRaisesRegex(ContractError,"STALE_CATALOG_SOURCE_DIGEST"):validate_source_catalog(changed)
 def test_d12_d14_alias_target_retirement_and_reader_contracts(self):
  ident={"kind":"skill","namespace":"phase1","name":"a","version":"v1"}; other={"kind":"skill","namespace":"phase1","name":"b","version":"v1"}
  entry={"identity":ident,"digest":D,"owner_id":"owner","source":{"locator":"repo","revision":"v1","digest":D},"lifecycle":{"state":"active","replacement":"","reader_rationale":"","history":["active"]},"aliases":[{"identity":{"kind":"skill","namespace":"phase1","name":"old","version":"v1"},"target":other,"owner_id":"owner","source_digest":D,"expires":"2099-01-01","state":"active","replacement_rationale":"replacement"}]}
  src=sealed_catalog({"source_id":"catalog","source_digest":D,"mode":"source-only","reader_denominator":["reader"],"reader_bindings":[{"reader_id":"reader","identities":[ident]}],"rollback":{"route":"remove","candidate_digest":D},"entries":[entry]})
  with self.assertRaisesRegex(ContractError,"ALIAS_AMBIGUITY_OR_TARGET"): validate_source_catalog(src)
  entry["aliases"][0]["target"]=ident; entry["lifecycle"].update({"state":"retired","history":["active","deprecated","retired"]});sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"RETIRED_ALIAS_TARGET"): validate_source_catalog(src)
  entry["aliases"]=[]; entry["lifecycle"]={"state":"deprecated","replacement":"","reader_rationale":"","history":["active","deprecated"]};sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"DEPRECATION_RATIONALE"): validate_source_catalog(src)
 def test_d12_d14_cross_kind_alias_cycle_lifecycle_and_active_reader_rejections(self):
  ident={"kind":"skill","namespace":"phase1","name":"a","version":"v1"}; alias1={"kind":"skill","namespace":"phase1","name":"old","version":"v1"}; alias2={"kind":"skill","namespace":"phase1","name":"older","version":"v1"}
  def entry(identity=ident): return {"identity":identity,"digest":D,"owner_id":"owner","source":{"locator":"repo","revision":"v1","digest":D},"lifecycle":{"state":"active","replacement":"","reader_rationale":"","history":["active"]},"aliases":[]}
  src=sealed_catalog({"source_id":"catalog","source_digest":D,"mode":"source-only","reader_denominator":["reader"],"reader_bindings":[{"reader_id":"reader","identities":[ident]}],"rollback":{"route":"remove","candidate_digest":D},"entries":[entry()]})
  cross=entry({"kind":"profile","namespace":"phase1","name":"a","version":"v1"}); src["entries"].append(cross);sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"DUPLICATE_CANONICAL_IDENTIFIER"): validate_source_catalog(src)
  src["entries"]=[entry()];sealed_catalog(src)
  src["entries"][0]["aliases"]=[{"identity":alias1,"target":alias2,"owner_id":"owner","source_digest":D,"expires":"2099-01-01","state":"active","replacement_rationale":"r"},{"identity":alias2,"target":alias1,"owner_id":"owner","source_digest":D,"expires":"2099-01-01","state":"active","replacement_rationale":"r"}];sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"ALIAS_CYCLE"): validate_source_catalog(src)
  src["entries"][0]["aliases"]=[];src["entries"][0]["lifecycle"]["history"]=["deprecated","active"];sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"LIFECYCLE_ORDER"): validate_source_catalog(src)
  src["entries"][0]["lifecycle"]={"state":"retired","replacement":"replacement","reader_rationale":"","history":["active","deprecated","retired"]};sealed_catalog(src)
  with self.assertRaisesRegex(ContractError,"RETIRED_ACTIVE_READER"): validate_source_catalog(src)
class A03Store(unittest.TestCase):
 def test_crash_replay_divergent_atomic_restore(self):
  with tempfile.TemporaryDirectory() as d:
   s=FixtureGauntletStore(Path(d)/"store"); self.assertEqual(s.apply("k",b"input",b"out")[0],"ACCEPTED"); before=s.event_log_digest()
   self.assertEqual(s.apply("k",b"input",b"out")[0],"REPLAYED"); self.assertEqual(before,s.event_log_digest())
   with self.assertRaisesRegex(ReplayConflict,"CONFLICT"): s.apply("k",b"changed",b"out")
   self.assertEqual(before,s.event_log_digest()); r=s.restore_to(Path(d)/"restore"); self.assertEqual(r.event_log_digest(),before)
   with self.assertRaises(ReplayConflict): s.restore_to(Path(d)/"restore")
 def test_fault_boundaries_and_revision_fence(self):
  with tempfile.TemporaryDirectory() as d:
   for boundary in ("after_request_publish","after_result_publish","before_event","before_commit"):
    s=FixtureGauntletStore(Path(d)/boundary)
    with self.assertRaisesRegex(ReplayConflict,"INJECTED_FAILURE"): s.apply("key",b"request",b"result",fault=boundary)
    self.assertEqual(s.cx.execute("SELECT count(*) FROM operations").fetchone()[0],0)
    self.assertEqual([p for p in s.cas.iterdir() if p != s.stage],[])
   s=FixtureGauntletStore(Path(d)/"fence"); _,digest=s.apply("key",b"request",b"result",revision=2,fence="fence")
   with self.assertRaisesRegex(ReplayConflict,"CONFLICT"): s.apply("key",b"request",b"result",revision=3,fence="fence")
   (s.cas/digest.removeprefix("sha256:")).unlink()
   with self.assertRaisesRegex(ReplayConflict,"CAS_MISSING_OR_TAMPERED"): s.verify_cas(digest)
class OpenSpecAdapter(unittest.TestCase):
 @unittest.skipUnless(os.environ.get("PHASE1_REAL_OPENSPEC")=="1","requires explicit disposable real-package lane")
 def test_real_pinned_release_staging_and_json_status(self):
  with tempfile.TemporaryDirectory() as d:
   flow=run_verified_fixture_flow(Path(d)/"fixture")
   self.assertEqual(flow["release"]["integrity"],FROZEN["integrity"])
   self.assertTrue(flow["status"]["isComplete"])
   self.assertEqual(flow["instructions"]["artifactId"],"proposal")
   self.assertTrue(flow["validation"]["items"][0]["valid"])
   self.assertEqual(flow["archive"]["archive"]["change"],"phase1-fixture")
   self.assertEqual(flow["bootstrap_argv"],[['init','.', '--tools','none','--no-animation'],['new','change','phase1-fixture']])
   self.assertEqual(flow["invoked_argv"],FIXTURE_CORE_ARGV)
 def test_status_instructions_validation_archive_and_negative_protocol(self):
  with tempfile.TemporaryDirectory() as d:
   root=Path(d); (root/"planning"/"openspec").mkdir(parents=True); exe=root/"tool"
   exe.write_text('#!/bin/sh\nprintf \'{"ok":true,"command":"%s","result":{}}\' "$1"\n'); exe.chmod(0o700)
   for c in ("status","instructions","validate","archive"): self.assertEqual(invoke(exe,root,c)["command"],c)
   exe.write_text('#!/bin/sh\necho noise\n'); exe.chmod(0o700)
   with self.assertRaisesRegex(AdapterError,"JSON_PROTOCOL_INVALID"): invoke(exe,root,"status")
 def test_strict_duplicate_json_timeout_and_fixture_only_environment(self):
  with tempfile.TemporaryDirectory() as d:
   root=Path(d); (root/"planning"/"openspec").mkdir(parents=True); exe=root/"tool"
   exe.write_text('#!/bin/sh\nprintf \'{"ok":true,"ok":true,"command":"status","result":{}}\'\n'); exe.chmod(0o700)
   with self.assertRaisesRegex(AdapterError,"JSON_PROTOCOL_INVALID"): invoke(exe,root,"status")
   exe.write_text('#!/bin/sh\nsleep 3\n'); exe.chmod(0o700)
   with self.assertRaisesRegex(AdapterError,"TIMEOUT"): invoke(exe,root,"status",timeout=.05)
   env=fixture_environment(root,bin_dir=root/"bin")
   self.assertEqual(set(env),{"HOME","XDG_CONFIG_HOME","XDG_CACHE_HOME","NPM_CONFIG_CACHE","NPM_CONFIG_USERCONFIG","NPM_CONFIG_GLOBALCONFIG","NPM_CONFIG_PREFIX","GIT_CONFIG_NOSYSTEM","GIT_TERMINAL_PROMPT","PATH","LANG","NO_PROXY","OPENSPEC_TELEMETRY","DO_NOT_TRACK"})
   self.assertTrue(all(str(root) in value for key,value in env.items() if key.endswith(("HOME","CACHE","USERCONFIG","GLOBALCONFIG","PREFIX"))))
 def test_stage_rejects_lexical_symlink_ancestry(self):
  with tempfile.TemporaryDirectory() as d:
   target=Path(d)/"target"; target.mkdir(); link=Path(d)/"link"; link.symlink_to(target,target_is_directory=True)
   with self.assertRaisesRegex(AdapterError,"WORKSPACE_ESCAPE"): stage_verified_release(link/"fixture")
 def test_containment(self):
  with tempfile.TemporaryDirectory() as d:
   r=Path(d); (r/"planning"/"openspec").mkdir(parents=True)
   with self.assertRaisesRegex(AdapterError,"PROVENANCE_MISMATCH"): invoke("/bin/echo",r,"status")
if __name__ == '__main__': unittest.main()
